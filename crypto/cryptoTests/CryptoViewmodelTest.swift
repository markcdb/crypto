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
        mockNetwork.fileName = "mock_price"
        viewModel = CryptoBuilder.assemlbleViewmodelWithRequestor(mockNetwork)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchCoins() {
        viewModel?.reloadCoinsWith("SGD")
        waitUntil(viewModel!.$state, equals: .success([]))
        XCTAssertTrue(mockNetwork.fetchDataCount == 1)
    }
    
    func testFailAndCache() {
        //Do cache first
        viewModel?.reloadCoinsWith("SGD")
        waitUntil(viewModel!.$state, equals: .success([]))
        XCTAssertTrue(mockNetwork.fetchDataCount == 1)

        //Then add error
        mockNetwork.error = MockError(description: "SUT: Error")
        
        //Reload coins
        viewModel?.reloadCoinsWith("SGD")
        
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
        viewModel?.reloadCoinsWith("SGD")
        waitUntil(viewModel!.$state, equals: .success([]))
        XCTAssertTrue(mockNetwork.fetchDataCount == 1)
        
        //Search keyword, let's try doge
        viewModel?.searchWith("DOGE")
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
}
