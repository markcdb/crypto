//
//  JSONDecoder.swift
//  crypto
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation

struct JSONKeySnakeCaseDecoder {

    var jsonKeyDecodeStrategy: JSONDecoder.KeyDecodingStrategy {
        .convertFromSnakeCase
    }

    func decode<T: Decodable>(data: Data?) throws -> T? {
        guard let data = data else { return nil }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = jsonKeyDecodeStrategy
        return try jsonDecoder.decode(T.self, from: data)
    }
}
