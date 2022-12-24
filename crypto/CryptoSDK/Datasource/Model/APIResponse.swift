//
//  APIResponse.swift
//  crypto
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation

public struct APIResponse<T>: Decodable where T: Decodable {
    public var data: T
}
