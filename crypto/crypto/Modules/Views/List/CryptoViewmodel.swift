//
//  CryptoViewmodel.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

//We will use this to manage list of crypto with respective price base on currency
import Foundation

enum ViewModelState<T>: Equatable {
    
    case none
    case success(T)
    case failed(T)
    
    static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.success(_), .success(_)):
            return true
        case (.failed(_), .failed(_)):
            return true
        default:
            return false
        }
    }
}

@MainActor class CryptoViewmodel: ObservableObject {
    let repository: CryptoRepository
    @Published var state: ViewModelState<[Coin]> = .none
    
    init(cryptoRepository: CryptoRepository) {
        self.repository = cryptoRepository        
    }
    
    func reloadCoinsWith(_ currency: String) {
        repository.getCoinsPricesFrom(currency: currency)
    }
}

extension CryptoViewmodel: CryptoResponseDelegate {
    func didFailed(cachedCoins: [Coin]) {
        state = .failed(cachedCoins)
    }
    
    func didReceive(coins: [Coin]) {
        state = .success(coins)
    }
}