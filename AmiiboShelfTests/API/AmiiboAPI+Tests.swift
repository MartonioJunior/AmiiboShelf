//
//  AmiiboAPI+Tests.swift
//  AmiiboShelfTests
//
//  Created by Martônio Júnior on 05/11/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import XCTest
@testable import AmiiboShelf

final class AmiiboAPI_Tests: XCTestCase {
    var api: AmiiboAPI!
    
    // MARK: Setup
    override func setUpWithError() throws {
        api = .init()
    }

    override func tearDownWithError() throws {
        api = nil
    }

    // MARK: Test Cases
    func test_getAmiiboList() async {
        measure {
            let expectation = expectation(description: "Finished")
            
            Task {
                _ = try await api.getAmiiboList()
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 15)
        }
    }
}
