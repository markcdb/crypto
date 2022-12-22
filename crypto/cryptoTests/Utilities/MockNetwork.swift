//
//  MockNetwork.swift
//  cryptoTests
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation
@testable import crypto

class MockCryptoNetworkRequest: Requestor {
    let decoder = JSONKeySnakeCaseDecoder()
    var fileName: String = ""
    
    func fetchData<T>(from urlString: String,
                      method: crypto.HTTPMethod,
                      completion: @escaping (T?, Error?) -> Void) where T : Decodable {
        guard let fileUrl = Bundle(for: type(of: self))
                            .url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: fileUrl),
              let response: APIResponse<T> = try? self.decoder.decode(data: data) else {
            return
        }
        
        completion(response.data, nil)
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
