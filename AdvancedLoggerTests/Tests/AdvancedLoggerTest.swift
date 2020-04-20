//
//  AdvancedLoggerTest.swift
//  AdvancedLoggerTests
//
//  Created by Дмитрий Торопкин on 14.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import XCTest
@testable import AdvancedLogger

class AdvancedLoggerTest: XCTestCase {
    
    var testLog: String!
    
    override func setUp() {
        super.setUp()
        self.testLog = "AdvancedLogger test write"
    }
    
    override func tearDown() {
        super.tearDown()
        self.testLog = nil
    }
    
    func testWrite() {
        let expectation = XCTestExpectation(description: "AdvancedLogget class: testWrite")
        
        AdvancedLogger.shared.encryptData = false
        AdvancedLogger.shared.addNew(log: self.testLog, type: .execution)
        
        AdvancedLogger.shared.getStringLogs { (log) in
            XCTAssertNotNil(log, "Error with write log. Logger return nil after write!")
            XCTAssertEqual(self.testLog, log!)
            expectation.fulfill()
        }
        AdvancedLogger.shared.cleanLogs()
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testCryptoWrite() {
        let expectation = XCTestExpectation(description: "AdvancedLogget class: testCryptoWrite")
        
        AdvancedLogger.shared.encryptData = true
        AdvancedLogger.shared.addNew(log: self.testLog, type: .execution)
        
        AdvancedLogger.shared.getStringLogs { (log) in
            XCTAssertNotNil(log, "Error with write log. Logger return nil after write!")
            XCTAssertEqual(self.testLog, log!)
            expectation.fulfill()
        }
        
        AdvancedLogger.shared.cleanLogs()
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testUpdateCryptoKeys() {
        
        let expectation = XCTestExpectation(description: "AdvancedLogget class: testUpdateCryptoKeys")
        
        var dataWithDefaultKey: Data?
        
        AdvancedLogger.shared.encryptData = true
        AdvancedLogger.shared.addNew(log: self.testLog, type: .execution)
        
        AdvancedLogger.shared.getDataLogs { (data) in
            XCTAssertNotNil(data, "Error with write log. Logger return nil after write!")
            dataWithDefaultKey = data
        }
        
        AdvancedLogger.shared.cleanLogs()
        
        AdvancedLogger.shared.aesCryptoKeys = ALAESCryptoInitModel(cryptoKey: "98765432101234567890123456789012", initialVector: "zxcdefghijklmnop")
        AdvancedLogger.shared.addNew(log: self.testLog, type: .execution)
        
        AdvancedLogger.shared.getDataLogs { (data) in
            XCTAssertNotNil(data, "Error with write log. Logger return nil after write!")
            XCTAssertEqual(dataWithDefaultKey, data)
            expectation.fulfill()
        }
        
        AdvancedLogger.shared.cleanLogs()
        wait(for: [expectation], timeout: 3.0)
    }
}
