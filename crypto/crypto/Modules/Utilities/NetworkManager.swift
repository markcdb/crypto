//
//  NetworkManager.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol Requestor: AnyObject {
    func fetchData<T: Decodable>(from urlString: String,
                   method: HTTPMethod,
                   completion: @escaping (T?, Error?) -> Void)
    
    func cancelFetch()
    func resumeFetch()
}

class NetworkManager: ObservableObject, Requestor {
    private var urlSession: URLSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    let decoder = JSONKeySnakeCaseDecoder()
    
    func fetchData<T>(from urlString: String,
                      method: HTTPMethod,
                      completion: @escaping (T?, Error?) -> Void) where T : Decodable {
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        dataTask = urlSession.dataTask(with: urlRequest) {[weak self] data, _, error in
            guard let self = self else {
                completion(nil, nil)
                return
            }
            
            let response: APIResponse<T>? = try? self.decoder.decode(data: data)
            completion(response?.data, error)
        }
        
        dataTask?.resume()
    }
    
    func cancelFetch() {
        dataTask?.cancel()
    }
    
    func resumeFetch() {
        dataTask?.resume()
    }
}
