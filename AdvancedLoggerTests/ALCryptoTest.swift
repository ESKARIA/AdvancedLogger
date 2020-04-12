//
//  ALCryptoTest.swift
//  AdvancedLoggerTests
//
//  Created by Дмитрий Торопкин on 12.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import XCTest
@testable import AdvancedLogger

class ALCryptoTest: XCTestCase {
    
    /// Default crypto keys for encrypt logs
    enum Crypto: String {
        case cryptoKey = "12345678901234567890123456789012"
        case cryptoInitialVector = "abcdefghijklmnop"
    }
    
    var cryptoManager: ALCryptoManagerProtocol!
    var testStringToCrypt: String!
    
    override func setUp() {
        super.setUp()
        self.cryptoManager = ALCryptoManager(initKey: Crypto.cryptoKey.rawValue, initIV: Crypto.cryptoInitialVector.rawValue)
        self.testStringToCrypt = "AdvancedLogger Crypto Test"
    }
    
    override func tearDown() {
        super.tearDown()
        self.cryptoManager = nil
        self.testStringToCrypt = nil
    }
    
    func testCrypt() {
        var data: Data?
        self.cryptoManager.encrypt(string: self.testStringToCrypt) { (_data, error) in
            if let error = error {
                XCTAssertFalse(true, error.errorDescription)
                return
            }
            data = _data
        }
        self.cryptoManager.decrypt(data: data) { (_data, error) in
            if let error = error {
                XCTAssertFalse(true, error.errorDescription)
                return
            }
            let resultString = String(decoding: _data ?? Data(), as: UTF8.self)
            XCTAssertTrue(resultString == self.testStringToCrypt)
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
