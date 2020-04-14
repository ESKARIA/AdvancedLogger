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
        AdvancedLogger.shared.encryptData = false
        AdvancedLogger.shared.addNew(log: self.testLog, type: .execution)
        
        AdvancedLogger.shared.getStringLogs { (log) in
            XCTAssertNotNil(log, "Error with write log. Logger return nil after write!")
            XCTAssertEqual(self.testLog, log!)
        }
        AdvancedLogger.shared.cleanLogs()
    }
    
    func testCryptoWrite() {
        AdvancedLogger.shared.encryptData = true
        AdvancedLogger.shared.addNew(log: self.testLog, type: .execution)
        
        AdvancedLogger.shared.getStringLogs { (log) in
            XCTAssertNotNil(log, "Error with write log. Logger return nil after write!")
            XCTAssertEqual(self.testLog, log!)
        }
        
        AdvancedLogger.shared.cleanLogs()
    }
    
    func testUpdateCryptoKeys() {
        
        var dataWithDefaultKey: Data?
        var dataWithCustomtKey: Data?
        
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
            dataWithCustomtKey = data
        }
        
        XCTAssertEqual(dataWithDefaultKey, dataWithCustomtKey)
        
        AdvancedLogger.shared.cleanLogs()
    }
}
