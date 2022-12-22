//
//  Coin.swift
//  crypto
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation

struct Coin: Decodable {
    let base: String
    let counter: String
    let buyPrice: String
    let sellPrice: String
    let icon: String
    let name: String
}
