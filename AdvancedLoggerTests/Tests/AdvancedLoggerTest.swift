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
    var queue: DispatchQueue!
    
    override func setUp() {
        super.setUp()
        self.testLog = "AdvancedLogger test write"
        self.queue =  DispatchQueue(label: "com.AdvancedLogger.Test")
    }
    
    override func tearDown() {
        super.tearDown()
        self.testLog = nil
        self.queue = nil
    }
    
    func testWrite() {
        queue.sync {
            AdvancedLogger.shared.encryptData = false
            AdvancedLogger.shared.addNew(log: self.testLog, type: .execution)
            
            AdvancedLogger.shared.getStringLogs { (log) in
                XCTAssertNotNil(log, "Error with write log. Logger return nil after write!")
                XCTAssertEqual(self.testLog, log!)
            }
            
            AdvancedLogger.shared.cleanLogs()
        }
    }
    
    func testCryptoWrite() {
        queue.sync {
            AdvancedLogger.shared.encryptData = true
            AdvancedLogger.shared.addNew(log: self.testLog, type: .execution)
            
            AdvancedLogger.shared.getStringLogs { (log) in
                XCTAssertNotNil(log, "Error with write log. Logger return nil after write!")
                XCTAssertEqual(self.testLog, log!)
            }
            
            AdvancedLogger.shared.cleanLogs()
        }
    }
    
    func testUpdateCryptoKeys() {
        queue.sync {
            
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
}
