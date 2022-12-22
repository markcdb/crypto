//
//  cryptoApp.swift
//  crypto
//
//  Created by Mark Christian Buot on 20/12/22.
//

import SwiftUI

@main
struct cryptoApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        Countries.shared.createCountries()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
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
