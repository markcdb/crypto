//
//  CryptoViewmodelTest.swift
//  cryptoTests
//
//  Created by Mark Christian Buot on 22/12/22.
//

import XCTest
@testable import crypto

@MainActor final class CryptoViewmodelTest: XCTestCase {
    
    var mockNetwork = MockCryptoNetworkRequest()
    var viewModel: CryptoViewmodel?
    
    @MainActor override func setUp() {
        super.setUp()
        viewModel = CryptoBuilder.assemlbleViewmodelWithRequestor(mockNetwork)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchCoins() {
        mockNetwork.fileName = "mock_price"
        viewModel?.reloadCoinsWith("SGD")
        waitUntil(viewModel!.$state, equals: .success([]))
    }
}
