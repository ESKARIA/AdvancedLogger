import XCTest

import ALCryptoTest
import ALFileManagerTest

var tests = [XCTestCase]()
tests += ALCryptoTest.allTests()
tests += ALFileManagerTest.allTests()
XCTMain(tests)
