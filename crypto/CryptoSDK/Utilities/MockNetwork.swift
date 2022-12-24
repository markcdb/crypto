//
//  MockNetwork.swift
//  cryptoTests
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation

struct MockError: Error {
    let description: String
}

/**
 Ideally mocking should be on test' module but due to new swift ui content preview which requires mock data, we're temporary placing
 Mocknetwork and mocked object to project's bundle resource to avoid having to duplicate or create separate mock for the preview
 */
public class MockCryptoNetworkRequest: Requestor {
    let decoder = JSONKeySnakeCaseDecoder()
    var fileName: String = "mock_price"
    
    var error: Error?
    
    public init() {}
    
    var fetchDataCount = 0
    public func fetchData(from urlString: String,
                   method: HTTPMethod,
                   cacheKey: String = "",
                   completion: @escaping (Data?, Error?) -> Void) {
        fetchDataCount += 1
        if let error = self.error {
            completion(nil, error)
        } else if let fileUrl = Bundle(for: type(of: self))
            .url(forResource: fileName, withExtension: "json"),
                  let data = try? Data(contentsOf: fileUrl) {
            completion(data, nil)
            UserDefaults.standard.set(data, forKey: cacheKey)
        }
    }
    
    var cancelFetchCount = 0
    public func cancelFetch() {
        cancelFetchCount += 1
    }
    
    var resumeFetchCount = 0
    public func resumeFetch() {
        resumeFetchCount += 1
    }
}
