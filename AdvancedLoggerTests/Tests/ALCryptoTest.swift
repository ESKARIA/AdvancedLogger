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
    var testModel: Data!
    private var encoder: JSONEncoder!
    private var decoder: JSONDecoder!
    
    override func setUp() {
        super.setUp()
        self.cryptoManager = ALCryptoManager(initKey: Constaints.Crypto.cryptoKey.rawValue, initIV: Constaints.Crypto.cryptoInitialVector.rawValue)
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        
        self.testModel = try? self.encoder.encode(AdvancedLoggerModel(time: "", log: "AdvancedLogger Crypto Test", type: .execution))
    }
    
    override func tearDown() {
        super.tearDown()
        self.cryptoManager = nil
        self.testModel = nil
        self.decoder = nil
        self.encoder = nil
    }
    
    func testCrypt() {
        let expectation = XCTestExpectation(description: "AdvancedLogget class: testCrypt")
        var data: Data?
        self.cryptoManager.encrypt(data: self.testModel) { (_data, error) in
            XCTAssertNil(error, error?.errorDescription ?? "")
            data = _data
        }
        self.cryptoManager.decrypt(data: data) { (_data, error) in
            XCTAssertNil(error, error?.errorDescription ?? "")
            XCTAssertEqual(_data, self.testModel)
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
