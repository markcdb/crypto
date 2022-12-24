//
//  CountriesFactory.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

import Foundation

public class Countries {
    
    public struct Country {
        public let name: String
        public let currencyCode: String
        public let flag: String
    }
    
    public static let shared = Countries()
    public var countries: [Country] = []
    
    private init() {}
    
    /**
     Ideal code to loop all available ids and get currency value and name
     but for some reason it's broken in a sense that some countries maps to incorrect currencies
     
    ```
    for code in codes {
        let regionLocale = Locale(identifier: code)
        
        if let name = englishLocale.localizedString(forRegionCode: code) {
            var currency: String
            if #available(iOS 16, *) {
                currency = regionLocale.currency?.identifier ?? ""
            } else {
                currency = regionLocale.currencyCode ?? ""
            }
            let country = Country(name: name,
                                  currencyCode: currency,
                                  flag: "")
            countries.append(country)
        }
    }
     ```
     Alternative is to have list of all countries and currency in one json file and convert that into object since it's a static data. Due to API limitation we'll default to **SGD and USD** for now
    */
    public func createCountries() {
        let countryUSD = Country(name: "United States", currencyCode: "USD", flag: "🇺🇸")
        let countrySGD = Country(name: "Singapore", currencyCode: "SGD", flag: "🇸🇬")
        
        countries.append(countryUSD)
        countries.append(countrySGD)
    }
}
