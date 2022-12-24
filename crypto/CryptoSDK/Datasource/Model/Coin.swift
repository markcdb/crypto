//
//  Coin.swift
//  crypto
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation

public struct Coin: Decodable {
    public let base: String
    public let counter: String
    public let buyPrice: String
    public let sellPrice: String
    public let icon: String
    public let name: String
    
    public init(base: String, counter: String, buyPrice: String, sellPrice: String, icon: String, name: String) {
        self.base = base
        self.counter = counter
        self.buyPrice = buyPrice
        self.sellPrice = sellPrice
        self.icon = icon
        self.name = name
    }
}
