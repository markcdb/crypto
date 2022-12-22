//
//  CountriesFactory.swift
//  crypto
//
//  Created by Mark Christian Buot on 21/12/22.
//

import Foundation

class Countries {
    
    struct Country {
        let name: String
        let currencyCode: String
        let flag: String
    }
    
    public static let shared = Countries()
    var countries: [Country] = []
    
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
    func createCountries() {
        let countrySGD = Country(name: "Singapore", currencyCode: "SGD", flag: "🇸🇬")
        let countryUSD = Country(name: "United States", currencyCode: "USD", flag: "🇺🇸")
        
        countries.append(countrySGD)
        countries.append(countryUSD)
    }
}
