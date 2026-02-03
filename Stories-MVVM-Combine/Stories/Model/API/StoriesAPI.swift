//
//  StoriesAPI.swift
//  Stories
//
//
//

import Foundation
import Network
import Alamofire

class StoriesAPI: APIContract {
    let baseUrl = "https://www.wattpad.com/api/v3/"
    let imageManager: ImageManagerContract = StoriesAPIImageManager()
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func isConnectedToInternet() -> Bool {
        NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func get<R>(request: R, result: ((Result<R.Response, APIError>) -> Void)?) where R : APIRequestContract {
        func completion(_ finalResult: Result<R.Response, APIError>) {
            DispatchQueue.main.async {
                result?(finalResult)
            }
        }
        
        // 1. URL Construction
        guard var components = URLComponents(string: baseUrl + request.path) else {
            assertionFailure("url for api request was not formatted correctly")
            completion(.failure(.serverError))
            return
        }
        
        components.queryItems = request.parameters?.map { key, value in
            URLQueryItem(name: key, value: value)
        }.sorted { $0.name < $1.name }
        
        guard let url = components.url else {
            assertionFailure("url for api request was not formatted correctly")
            completion(.failure(.serverError))
            return
        }
        
        // 2. Request Configuration
        let urlRequest = URLRequest(url: url, timeoutInterval: request.timeoutInterval)
        
        // 3. Network Execution
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error as? URLError {
                if error.code == .notConnectedToInternet || error.code == .timedOut {
                    completion(.failure(.lostConnection))
                } else {
                    completion(.failure(.serverError))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.serverError))
                return
            }
            
            // 4. Status Code Handling
            switch httpResponse.statusCode {
            case 200...299:
                // Success range, proceed to decoding
                break
            case 400:
                completion(.failure(.serverError))
                return
            case 401:
                completion(.failure(.serverError))
                return
            default:
                completion(.failure(.serverError))
                return
            }
            
            // 5. Data Unwrapping
            guard let data = data else {
                completion(.failure(.serverError))
                return
            }
            
            // 6. Decoding
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(R.Response.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.serverError))
            }
        }
        task.resume()
    }
}
