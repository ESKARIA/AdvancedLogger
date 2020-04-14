import XCTest
import AdvancedLoggerTests

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AdvancedLoggerTests.allTests),
    ]
}
#endif
