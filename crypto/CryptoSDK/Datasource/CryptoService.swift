//
//  NetworkRequestor.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

import Foundation

public class CryptoService {
    
    let baseUrl: String = "https://www.coinhako.com/api/v3/price/all_prices_for_mobile?counter_currency="
    
    let requestor: Requestor
    let decoder = JSONKeySnakeCaseDecoder()
    let cacheKey = "com.crypto.coinCache"

    init(requestor: Requestor) {
        self.requestor = requestor
    }
    
    func getPricesFrom(_ currency: String,
                       cacheKey: String = "",
                       success: @escaping ((APIResponse<[Coin]>) -> Void),
                       failed: @escaping ((APIResponse<[Coin]>?) -> Void)) {
        let url = baseUrl + currency
        
        requestor.fetchData(from: url,
                            method: .get,
                            cacheKey: cacheKey) {[weak self] data, error in
            
            guard let data = data, error == nil else {
                //For now we don't need to specify the error type, so we can keep it generic
                //whether data is nil or error is not nil we fall back to same failed state
                failed(self?.loadCache(cacheKey: cacheKey))
                return
            }
            
            if let response: APIResponse<[Coin]> = try? self?.decoder.decode(data: data) {
                success(response)
            } else {
                //Decode fails, fallback to failed state
                failed(self?.loadCache(cacheKey: cacheKey))
            }
        }
    }
    
    func loadCache(cacheKey: String) -> APIResponse<[Coin]>? {
        //Fetch cached response from defaults
        let data = UserDefaults.standard.data(forKey: cacheKey)
        let response: APIResponse<[Coin]>? = try? self.decoder.decode(data: data)
        return response
    }
}

