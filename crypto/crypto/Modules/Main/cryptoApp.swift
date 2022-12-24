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
    
    @Environment(\.scenePhase) private var scenePhase
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
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                //Stop timer
                break
            case .active:
                //Start timer
                break
            case .inactive:
                //Stop timer
                break
            default: break
            }
        }
    }
}
