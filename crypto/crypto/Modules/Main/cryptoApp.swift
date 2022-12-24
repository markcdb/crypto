//
//  cryptoApp.swift
//  crypto
//
//  Created by Mark Christian Buot on 20/12/22.
//

import SwiftUI
import CryptoSDK

@main
struct cryptoApp: App {
    
    @ObservedObject var viewModel: CryptoViewmodel
    
    init() {
        Countries.shared.createCountries()

        if ProcessInfo.processInfo.arguments.contains("uiMock") {
            viewModel = CryptoBuilder.assemlbleViewmodelWithRequestor(MockCryptoNetworkRequest())
        } else {
            viewModel = CryptoBuilder.assemlbleViewmodelWithRequestor()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            CryptoListView(viewModel: self.viewModel)
        }
    }
}
