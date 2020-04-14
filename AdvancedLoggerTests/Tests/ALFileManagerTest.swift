//
//  ALFileManagerTest.swift
//  AdvancedLoggerTests
//
//  Created by Дмитрий Торопкин on 12.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import XCTest
@testable import AdvancedLogger

class ALFileManagerTest: XCTestCase {
    
    var diskManager: ALFileDiskManagerProtocol!
    
    override func setUp() {
        super.setUp()
        self.diskManager = ALFileDiskManager(directoryPath: Constaints.documentDirectoryPath.rawValue)
    }
    
    override func tearDown() {
        super.tearDown()
        self.diskManager = nil
    }
    
    func testWrite() {
        let data = "AdvancedLoggerFileManagerTest".data(using: .utf8) ?? Data()
        self.diskManager.write(data: data) { (error) in
            XCTAssertNil(error, error?.localizedDescription ?? "")
        }
        self.diskManager.read { (_data) in
            XCTAssertEqual(data, _data)
        }
    }

    func testClean() {
        self.diskManager.clean { (error) in
            XCTAssertNil(error, error?.localizedDescription ?? "")
        }
        
        self.diskManager.read { (data) in
            XCTAssertNil(data)
        }
    }
}
