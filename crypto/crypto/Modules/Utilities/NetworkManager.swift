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
                                 cacheKey: String,
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
                      cacheKey: String = "",
                      completion: @escaping (T?, Error?) -> Void) where T : Decodable {
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        dataTask = urlSession.dataTask(with: urlRequest) {[weak self] data, _, error in
            guard let self = self else {
                return
            }
            
            let response: APIResponse<T>? = try? self.decoder.decode(data: data)
            completion(response?.data, error)
            
            /**
             There are multiple ways to cache data:
             1. Using cachesDirectory
             2. Coredata
             3. UserDefaults
             For now we're choosing user default, though it's not as lightweight as using cache directory, for the simpleness of this cache requirement we'll choose using this for now
             */
            UserDefaults.standard.set(data, forKey: cacheKey)
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
