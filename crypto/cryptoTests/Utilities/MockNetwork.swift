//
//  MockNetwork.swift
//  cryptoTests
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation
@testable import crypto

struct MockError: Error {
    let description: String
}

class MockCryptoNetworkRequest: Requestor {
    let decoder = JSONKeySnakeCaseDecoder()
    var fileName: String = ""
    
    var error: Error?
    
    var fetchDataCount = 0
    func fetchData<T>(from urlString: String,
                      method: crypto.HTTPMethod,
                      cacheKey: String = "",
                      completion: @escaping (T?, Error?) -> Void) where T : Decodable {
        fetchDataCount += 1
        if let error = self.error {
            completion(nil, error)
        } else if let fileUrl = Bundle(for: type(of: self))
            .url(forResource: fileName, withExtension: "json"),
                  let data = try? Data(contentsOf: fileUrl),
                  let response: APIResponse<T> = try? self.decoder.decode(data: data) {
            completion(response.data, nil)
            UserDefaults.standard.set(data, forKey: cacheKey)
        }
        
    }
    
    var cancelFetchCount = 0
    func cancelFetch() {
        cancelFetchCount += 1
    }
    
    var resumeFetchCount = 0
    func resumeFetch() {
        resumeFetchCount += 1
    }
}
