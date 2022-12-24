//
//  CryptoRepository.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

import Foundation

public protocol CryptoResponseDelegate: AnyObject {
    
    func didReceive(coins: [Coin])
    func didFailed(cachedCoins: [Coin])
}

public class CryptoRepository {
    
    let cacheKey = "com.crypto.coinCache"
    
    let cryptoService: CryptoService
    weak var delegate: CryptoResponseDelegate?
    
    init(cryptoService: CryptoService) {
        self.cryptoService = cryptoService
    }
    
    func getCoinsPricesFrom(currency: String) {
        cryptoService.getPricesFrom(currency, cacheKey: cacheKey) {[weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.delegate?.didReceive(coins: response.data)
            }
        } failed: {[weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.delegate?.didFailed(cachedCoins: response?.data ?? [])
            }
        }
    }
}
