//
//  Extensions.swift
//  cryptoTests
//
//  Created by Mark Christian Buot on 22/12/22.
//

import Foundation
import Combine
import XCTest

struct Constants {
    
    static let fileName = "mock_price"
}

extension XCTestCase {
    
    /**
     Waits our published object to have some changes,
     we will then check the update data if it's equal to the expected value
     
     Timeout: 10s
     */
    func waitUntil<T: Equatable>(
        _ propertyPublisher: Published<T>.Publisher,
        equals expectedValue: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(
            description: "Awaiting value \(expectedValue)"
        )
        
        var cancellable: AnyCancellable?

        cancellable = propertyPublisher
                    .first(where: { $0 == expectedValue })
                    .sink { value in
                        XCTAssertEqual(value, expectedValue, file: file, line: line)
                        cancellable?.cancel()
                        expectation.fulfill()
                    }

        waitForExpectations(timeout: timeout, handler: nil)
    }
}
