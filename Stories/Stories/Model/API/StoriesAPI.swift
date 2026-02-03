//
//  StoriesAPI.swift
//  Stories
//
//
//
//

import Foundation
import Alamofire

class StoriesAPI: APIContract {
    let baseUrl = "https://www.wattpad.com/api/v3/"
    var imageManager: ImageManagerContract = StoriesImageManager()

    func isConnectedToInternet() -> Bool {
        NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func get<R: APIRequestContract>(request: R,
                                    result: ((Result<R.Response, APIError>) -> Void)?) {
        let url = baseUrl + request.path
        AF.request(url,
                   parameters: request.parameters,
                   requestModifier: { $0.timeoutInterval = request.timeoutInterval }
        ).responseDecodable(of: R.Response.self) { response in
            func completion(_ finalResult: Result<R.Response, APIError>) {
                DispatchQueue.main.async {
                    result?(finalResult)
                }
            }
            
            switch response.result {
            case .success:
                if let data = response.value {
                    completion(.success(data))
                } else {
                    completion(.failure(APIError.serverError))
                }
            case .failure(let error):
                if let underlyingError = error.underlyingError,
                    let urlError = underlyingError as? URLError {
                    switch urlError.code {
                    case .timedOut, .notConnectedToInternet:
                        completion(.failure(APIError.lostConnection))
                    default:
                        completion(.failure(APIError.serverError))
                    }
                } else {
                    completion(.failure(APIError.serverError))
                }
            }
        }
    }
}
