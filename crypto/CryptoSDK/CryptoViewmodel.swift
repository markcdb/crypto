//
//  CryptoViewmodel.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

//We will use this to manage list of crypto with respective price base on currency
import Foundation
import Combine

public enum ViewModelState<T>: Equatable {
    
    case none
    case success(T)
    case failed(T)
    
    public static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
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
    
    mutating func replace(with data: T) {
        switch self {
        case .success(_):
            self = .success(data)
        case .failed(_):
            self = .failed(data)
        case .none: return
        }
    }
}

public enum CryptoPredicate {
    case name
    case buy
    case sell
}

@MainActor public class CryptoViewmodel: ObservableObject {
    let repository: CryptoRepository
    
    /**
    We'll use Publisher to bind viewmodel to it's client
    This will serve as our state
    */
    @Published public var state: ViewModelState<[Coin]> = .none
    @Published public var searchString: String = ""
    @Published public var currency: String = "USD"
    private var sortingPredicate: (predicate: CryptoPredicate, order: SortOrder)?
    
    public var searchedCoin: [Coin] = []
    
    init(cryptoRepository: CryptoRepository) {
        self.repository = cryptoRepository
    }
    
    public func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {[weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                if self.searchString.isEmpty {
                    self.reloadCoins()
                }
            }
        }.fire()
    }
    
    public func reloadCoins() {
        repository.getCoinsPricesFrom(currency: currency)
    }
    
    public func search() {
        //Get the state first
        var coins: [Coin] = []
        
        switch state {
        case .failed(let cns), .success(let cns):
            coins = cns
        default: break
        }
        
        searchedCoin = coins.filter({ $0.name.lowercased().contains(searchString.lowercased()) || $0.base.lowercased().contains(searchString.lowercased())})
    }
    
    /**
     Uses KeyPathComparator to create sorting perdicate base on name, buy or sell value
     We will then cache the keypath and sortorder so when user taps the same filter we will reverse the sortorder
     */
    public func filter(_ predicate: CryptoPredicate, shouldReverse: Bool = true) {
        switch state {
        case .failed(var coins), .success(var coins):
            /**
             Check whether sortingPredicate exists
             If it does we will then check if keypath is the same, if true we'll reverse the sortingorder
             */
            if shouldReverse,
               let sortPrediacate = sortingPredicate,
               sortPrediacate.predicate == predicate {
                let order: SortOrder = sortPrediacate.order == .reverse ? .forward : .reverse
                sortingPredicate = (predicate, order)
            } else {
                sortingPredicate = (predicate, .forward)
            }
            
            let sortPredicate = sortingPredicate?.predicate ?? .name
            if sortingPredicate?.order == .reverse {
                switch sortPredicate {
                case .name:
                    //sort by name
                    coins = coins.sorted(using: KeyPathComparator(\.name, order: .reverse))
                case .buy:
                    coins = coins.sorted(by: { (Double($0.buyPrice) ?? 0.0) > (Double($1.buyPrice) ?? 0.0) })
                case .sell:
                    coins = coins.sorted(by: { (Double($0.sellPrice) ?? 0.0) > (Double($1.sellPrice) ?? 0.0) })
                }
            } else {
                switch sortPredicate {
                case .name:
                    //sort by name
                    coins = coins.sorted(using: KeyPathComparator(\.name, order: .forward))
                case .buy:
                    coins = coins.sorted(by: { (Double($0.buyPrice) ?? 0.0) < (Double($1.buyPrice) ?? 0.0) })
                case .sell:
                    coins = coins.sorted(by: { (Double($0.sellPrice) ?? 0.0) < (Double($1.sellPrice) ?? 0.0) })
                }
            }
            
            state.replace(with: coins)
        default: break
        }
    }
    
    func cleanupSearch() {
        searchString = ""
        searchedCoin = []
    }
}

extension CryptoViewmodel: CryptoResponseDelegate {
    public func didFailed(cachedCoins: [Coin]) {
        state = .failed(cachedCoins)
        filter(sortingPredicate?.predicate ?? .name, shouldReverse: false)
    }
    
    public func didReceive(coins: [Coin]) {
        state = .success(coins)
        filter(sortingPredicate?.predicate ?? .name, shouldReverse: false)
    }
}
