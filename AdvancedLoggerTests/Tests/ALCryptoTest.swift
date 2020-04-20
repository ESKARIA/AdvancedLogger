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
    
    var cryptoManager: ALCryptoManagerProtocol!
    var testStringToCrypt: String!
    
    override func setUp() {
        super.setUp()
        self.cryptoManager = ALCryptoManager(initKey: Constaints.Crypto.cryptoKey.rawValue, initIV: Constaints.Crypto.cryptoInitialVector.rawValue)
        self.testStringToCrypt = "AdvancedLogger Crypto Test"
    }
    
    override func tearDown() {
        super.tearDown()
        self.cryptoManager = nil
        self.testStringToCrypt = nil
    }
    
    func testCrypt() {
        let expectation = XCTestExpectation(description: "AdvancedLogget class: testCrypt")
        var data: Data?
        self.cryptoManager.encrypt(string: self.testStringToCrypt) { (_data, error) in
            XCTAssertNil(error, error?.errorDescription ?? "")
            data = _data
        }
        self.cryptoManager.decrypt(data: data) { (_data, error) in
            XCTAssertNil(error, error?.errorDescription ?? "")
            let resultString = String(decoding: _data ?? Data(), as: UTF8.self)
            XCTAssertEqual(resultString, self.testStringToCrypt)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testInvalidUpdateKeys() {
        let expectation = XCTestExpectation(description: "AdvancedLogget class: testInvalidUpdateKeys")
        let keys = ALAESCryptoInitModel(cryptoKey: "Invalid key", initialVector: "Invalid IV")
        XCTAssertThrowsError(try self.cryptoManager.update(cryptoKeys: keys), "Invalid keys") { (error) in
            expectation.fulfill()
            if let _error = error as? ALCryptoManagerError {
                XCTAssertTrue(_error == .wrongKey || _error == .wrongInitalVector)
                return
            } else {
                XCTAssert(false)
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSuccessUpdateKeys() {
        let keys = ALAESCryptoInitModel(cryptoKey: Constaints.Crypto.cryptoKey.rawValue, initialVector: Constaints.Crypto.cryptoInitialVector.rawValue)
        XCTAssertNoThrow(try self.cryptoManager.update(cryptoKeys: keys))
    }
}
