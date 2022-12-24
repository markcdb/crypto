//
//  NetworkManager.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
}

public protocol Requestor: AnyObject {
    func fetchData(from urlString: String,
                   method: HTTPMethod,
                   cacheKey: String,
                   completion: @escaping (Data?, Error?) -> Void)
    
    func cancelFetch()
    func resumeFetch()
}

public class NetworkManager: ObservableObject, Requestor {
    private var urlSession: URLSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    public init() {}
    
    public func fetchData(from urlString: String,
                   method: HTTPMethod,
                   cacheKey: String = "",
                   completion: @escaping (Data?, Error?) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        dataTask = urlSession.dataTask(with: urlRequest) {data, _, error in
            completion(data, error)
            
            if !cacheKey.isEmpty {
                /**
                 There are multiple ways to cache data:
                 1. Using cachesDirectory
                 2. Coredata
                 3. UserDefaults
                 For now we're choosing user default, though it's not as lightweight as using cache directory, for the simpleness of this cache requirement we'll choose using this for now
                 */
                UserDefaults.standard.set(data, forKey: cacheKey)
            }
        }
        
        dataTask?.resume()
    }
    
    public func cancelFetch() {
        dataTask?.cancel()
    }
    
    public func resumeFetch() {
        dataTask?.resume()
    }
}
