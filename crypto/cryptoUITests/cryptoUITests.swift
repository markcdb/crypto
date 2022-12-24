//
//  cryptoUITests.swift
//  cryptoUITests
//
//  Created by Mark Christian Buot on 20/12/22.
//

import XCTest

struct Identifiers {
    
    static let picker = "picker-currency"
    static let list = "list-coin"
    static let cell = "coin-bsae"
}

final class cryptoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        // UI tests must launch the application that they test.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadCryptos() {
        let app = XCUIApplication()
        app.launchArguments = ["uiMock"]
        app.launch()
        
        //Find the list view
        let list = app.collectionViews[Identifiers.list]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        //Check if list view has rows
        let cell = app.cells.staticTexts[Identifiers.cell]
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.firstMatch.label == "1INCH")

    }
    
    func testPicker() {
        let app = XCUIApplication()
        app.launchArguments = ["uiMock"]
        app.launch()
        
        //Find the list view
        let list = app.collectionViews[Identifiers.list]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        ///Check if list view has rows
        let cell = app.cells.staticTexts[Identifiers.cell]
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.firstMatch.label == "1INCH")

        //Check if picker exists
        let picker = app.segmentedControls[Identifiers.picker]
        XCTAssertTrue(picker.waitForExistence(timeout: 5))
        let button = app.buttons.matching(identifier: "SGD").firstMatch
        XCTAssertFalse(button.isSelected)
        button.tap()
        XCTAssertTrue(button.isSelected)
    }
    
    func testFilterSell() {
        let app = XCUIApplication()
        app.launchArguments = ["uiMock"]
        app.launch()
        
        //Find the list view
        let list = app.collectionViews[Identifiers.list]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        //Check if list view has rows
        let cell = app.cells.staticTexts[Identifiers.cell]
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.firstMatch.label == "1INCH")

        //Check if filter for sell exists
        let filterSell = app.staticTexts["Sell"]
        XCTAssertTrue(filterSell.waitForExistence(timeout: 5))
        filterSell.tap()
        
        //First cell element should be bittorent
        XCTAssertTrue(cell.firstMatch.label == "BTTC")
    }
    
    func testFilterBuy() {
        let app = XCUIApplication()
        app.launchArguments = ["uiMock"]
        app.launch()
        
        //Find the list view
        let list = app.collectionViews[Identifiers.list]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        //Check if list view has rows
        let cell = app.cells.staticTexts[Identifiers.cell]
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.firstMatch.label == "1INCH")

        //Check if filter for sell exists
        let filterSell = app.staticTexts["Buy"]
        XCTAssertTrue(filterSell.waitForExistence(timeout: 5))
        filterSell.tap()
        
        //First cell element should be bittorent
        XCTAssertTrue(cell.firstMatch.label == "BTTC")
    }
    
    func testFilterCoin() {
        let app = XCUIApplication()
        app.launchArguments = ["uiMock"]
        app.launch()
        
        //Find the list view
        let list = app.collectionViews[Identifiers.list]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        //Check if list view has rows
        let cell = app.cells.staticTexts[Identifiers.cell]
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.firstMatch.label == "1INCH")

        //Check if filter for sell exists
        let filterSell = app.staticTexts["Sell"]
        XCTAssertTrue(filterSell.waitForExistence(timeout: 5))
        filterSell.tap()
        
        //First cell element should be bittorent
        XCTAssertTrue(cell.firstMatch.label == "BTTC")
        
        //Check if filter for coins exists
        let filterCoin = app.staticTexts["Coin"]
        XCTAssertTrue(filterCoin.waitForExistence(timeout: 5))
        filterCoin.tap()
        
        //First cell element should be 1INCH again
        XCTAssertTrue(cell.firstMatch.label == "1INCH")
    }
    
    func testSearch() {
        let app = XCUIApplication()
        app.launchArguments = ["uiMock"]
        app.launch()
        
        //Find the list view
        let list = app.collectionViews[Identifiers.list]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        //Check if list view has rows
        let cell = app.cells.staticTexts[Identifiers.cell]
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.firstMatch.label == "1INCH")

        let search = app.searchFields.firstMatch
        search.tap()
        app.typeText("D")
        app.typeText("O")
        app.typeText("G")
        
        //Validate first cell, should be dogecoin
        XCTAssertTrue(cell.firstMatch.label == "DOGE")
    }
}
