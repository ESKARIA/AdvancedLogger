import XCTest

import ALCryptoTest
import ALFileManagerTest
import AdvancedLoggerTest

var tests = [XCTestCase]()
tests += ALCryptoTest.allTests()
tests += ALFileManagerTest.allTests()
tests += AdvancedLoggerTest.allTests()
XCTMain(tests)
