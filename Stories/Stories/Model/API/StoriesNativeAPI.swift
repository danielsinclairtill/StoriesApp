//
//  StoriesNativeAPI.swift
//  Stories
//
//
//

import Foundation
import Network

class StoriesNativeAPI: APIContract {
    let baseUrl = "https://www.wattpad.com/api/v3/"
    var imageManager: ImageManagerContract = StoriesImageManager()
    private var isConnected: Bool = true
    let backgroudQueue = DispatchQueue.global(qos: .background)
    private let monitor = NWPathMonitor()
    
    init() {
        // update internet connection status on any change
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isConnected = true
            } else {
                self?.isConnected = false
            }
        }
        monitor.start(queue: backgroudQueue)
    }
    
    func isConnectedToInternet() -> Bool {
        return isConnected
    }
    
    func get<R>(request: R, result: ((Result<R.Response, APIError>) -> Void)?) where R : APIRequestContract {
        guard var url = URLComponents(string: baseUrl + request.path) else {
            assertionFailure("url for api request was not formatted correctly")
            DispatchQueue.main.async {
                result?(.failure(.serverError))
            }
            return
        }
        
        url.queryItems = request.parameters?.map({ key, value in
            URLQueryItem(name: key, value: value)
        })
        
        guard let url = url.url else {
            assertionFailure("url for api request was not formatted correctly")
            DispatchQueue.main.async {
                result?(.failure(.serverError))
            }
            return
        }
        let urlRequest = URLRequest(url: url, timeoutInterval: request.timeoutInterval)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error as? URLError {
                if error.code == .notConnectedToInternet || error.code == .timedOut {
                    DispatchQueue.main.async {
                        result?(.failure(.lostConnection))
                    }
                } else {
                    DispatchQueue.main.async {
                        result?(.failure(.serverError))
                    }
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                DispatchQueue.main.async {
                    result?(.failure(.serverError))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    result?(.failure(.serverError))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(R.Response.self, from: data)
                DispatchQueue.main.async {
                    result?(.success(data))
                }
            }
            catch {
                assertionFailure("url for api request was not formatted correctly")
                DispatchQueue.main.async {
                    result?(.failure(.serverError))
                }
            }
        }
        task.resume()
    }
}
