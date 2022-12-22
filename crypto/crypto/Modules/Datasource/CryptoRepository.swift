//
//  CryptoRepository.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

import Foundation

protocol CryptoResponseDelegate: AnyObject {
    
    func didReceive(coins: [Coin])
    func didFailed(cachedCoins: [Coin])
}

class CryptoRepository {
    
    let cryptoService: CryptoNetworkRequest
    weak var delegate: CryptoResponseDelegate?
    
    init(cryptoService: CryptoNetworkRequest) {
        self.cryptoService = cryptoService
    }
    
    func getCoinsPricesFrom(currency: String) {
        cryptoService.getPricesFrom(currency) {[weak self] coins in
            guard let self = self else { return }
            self.delegate?.didReceive(coins: coins)
            //Handle cache
        } failed: {[weak self] in
            guard let self = self else { return }
            //Check for cache first
            self.delegate?.didFailed(cachedCoins: [])
        }
    }
}
