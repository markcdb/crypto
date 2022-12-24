//
//  CryptoViewmodelTest.swift
//  cryptoTests
//
//  Created by Mark Christian Buot on 22/12/22.
//

import XCTest
@testable import CryptoSDK

@MainActor final class CryptoViewmodelTest: XCTestCase {
    
    var mockNetwork = MockCryptoNetworkRequest()
    var viewModel: CryptoViewmodel?
    
    @MainActor override func setUp() {
        super.setUp()
        mockNetwork.fileName = "mock_price"
        viewModel = CryptoBuilder.assemlbleViewmodelWithRequestor(mockNetwork)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialState() {
        waitUntil(viewModel!.$state, equals: .none)
    }
    
    func testFetchCoins() {
        viewModel?.reloadCoins()
        waitUntil(viewModel!.$state, equals: .success([]))
        XCTAssertTrue(mockNetwork.fetchDataCount == 1)
    }
    
    func testFailAndCache() {
        //Do cache first
        viewModel?.reloadCoins()
        waitUntil(viewModel!.$state, equals: .success([]))
        XCTAssertTrue(mockNetwork.fetchDataCount == 1)

        //Then add error
        mockNetwork.error = MockError(description: "SUT: Error")
        
        //Reload coins
        viewModel?.reloadCoins()

        //Validate state, should be error
        waitUntil(viewModel!.$state, equals: .failed([]))
        XCTAssertTrue(mockNetwork.fetchDataCount == 2)
        
        //Validate array inside state isn't empty
        if case let .failed(coin) = viewModel?.state {
            XCTAssertTrue(!coin.isEmpty)
        } else {
            XCTFail("State should be failed")
        }
    }
    
    func testSearchCoinAndCleanup() {
        //Do cache first
        viewModel?.reloadCoins()
        waitUntil(viewModel!.$state, equals: .success([]))
        XCTAssertTrue(mockNetwork.fetchDataCount == 1)
        
        //Search keyword, let's try doge
        viewModel?.searchString = "DOGE"
        viewModel?.search()
        if let search = viewModel?.searchedCoin,
           let first = search.first {
            XCTAssertTrue(!search.isEmpty && search.count == 1)
            XCTAssertTrue(first.name == "Dogecoin")
        }
        
        //Test cleanup
        viewModel?.cleanupSearch()
        XCTAssertTrue(viewModel?.searchedCoin.isEmpty ?? false)
        XCTAssertTrue(viewModel?.searchString == "")
    }
    
    func testCoinsInit() {
        let coin = Coin(base: "Test",
                        counter: "Test",
                        buyPrice: "2.0",
                        sellPrice: "3.0",
                        icon: "https://cdn.coinhako.com/assets/wallet-ldo-e169d4a9e68cca676d55fc3f669df92ea319c2b26d7e44e51d899fe47711310c.png",
                        name: "Testing coin")
        
        XCTAssertTrue(coin.base == "Test")
    }
    
    func testFilter() {
        viewModel?.reloadCoins()
        waitUntil(viewModel!.$state, equals: .success([]))
        XCTAssertTrue(mockNetwork.fetchDataCount == 1)
        
        viewModel?.filter(.name, shouldReverse: false)
        if case let .success(coins) = viewModel?.state,
            let coin = coins.first {
            XCTAssertTrue(coin.name == "1INCH")
        } else {
            XCTFail("Failed because state is nil")
        }
        
        //Reversing sort order
        viewModel?.filter(.name)
        if case let .success(coins) = viewModel?.state,
            let coin = coins.first {
            XCTAssertTrue(coin.base == "ZIL")
        } else {
            XCTFail("Failed because state is nil")
        }
    }
}
