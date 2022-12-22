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
    
    let cacheKey = "com.crypto.coinCache"
    
    let decoder = JSONKeySnakeCaseDecoder()
    let cryptoService: CryptoService
    weak var delegate: CryptoResponseDelegate?
    
    init(cryptoService: CryptoService) {
        self.cryptoService = cryptoService
    }
    
    func getCoinsPricesFrom(currency: String) {
        cryptoService.getPricesFrom(currency, cacheKey: cacheKey) {[weak self] coins in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.delegate?.didReceive(coins: coins)
            }
        } failed: {[weak self] in
            guard let self = self else { return }
            //Check for cache first
            
            var coins: [Coin] = []
            
            if let data = UserDefaults.standard.data(forKey: self.cacheKey),
               let response: APIResponse<[Coin]>? = try? self.decoder.decode(data: data){
                coins = response?.data ?? []
            }
            
            DispatchQueue.main.async {
                self.delegate?.didFailed(cachedCoins: coins)
            }
        }
    }
}
