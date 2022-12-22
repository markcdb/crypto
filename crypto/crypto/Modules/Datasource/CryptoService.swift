//
//  NetworkRequestor.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

import Foundation

class CryptoService {
    
    let baseUrl: String = "https://www.coinhako.com/api/v3/price/all_prices_for_mobile?counter_currency="
    
    let requestor: Requestor
    
    init(requestor: Requestor) {
        self.requestor = requestor
    }
    
    func getPricesFrom(_ currency: String,
                       cacheKey: String = "",
                       success: @escaping (([Coin]) -> Void),
                       failed: @escaping () -> Void) {
        let url = baseUrl + currency
        
        requestor.fetchData(from: url,
                            method: .get,
                            cacheKey: cacheKey) { (coins: [Coin]?, error) in
            guard let coins = coins else {
                failed()
                return
            }
            
            success(coins)
        }
    }
}

