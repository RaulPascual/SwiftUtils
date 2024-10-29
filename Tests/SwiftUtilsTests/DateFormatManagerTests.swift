import XCTest
@testable import SwiftUtilities

final class DateFormatManagerTests: XCTestCase {
    
    var dateFormatManager: DateFormatManager!
    
    override func setUp() {
        super.setUp()
        dateFormatManager = DateFormatManager()
    }

    override func tearDown() {
        dateFormatManager = nil
        super.tearDown()
    }

    func testDateFromString() {
        let dateString = "2023-11-01"
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 11
        dateComponents.day = 01
        // Create date from components
        let userCalendar = Calendar(identifier: .gregorian)
        let someDateTime = userCalendar.date(from: dateComponents)
        
        let expectedDate = someDateTime
        let resultDate = dateFormatManager.date(dateString: dateString,
                                                format: DateStrings.yyyyMMdd.rawValue)
        
        XCTAssertEqual(resultDate, expectedDate, "The converted date does not match the expected date.")
    }
    
    func testStringFromDate() {
        let date = Date(timeIntervalSinceReferenceDate: 738100693) // = "2024-05-22"
        let expectedDateString = "2024-05-22"
        let resultDateString = dateFormatManager.string(date: date, format: DateStrings.yyyyMMdd.rawValue)
        
        XCTAssertEqual(resultDateString, expectedDateString, "The generated date string does not match the expected string.")
    }
    
    func testCustomFormattedStringFromDate() {
        let date = Date(timeIntervalSinceReferenceDate: 738100693) // = "2024-05-22"
        let customFormatString = "MMM d, yyyy"
        let expectedCustomFormattedString = "May 22, 2024"
        let resultCustomFormattedString = dateFormatManager.customFormattedString(date: date, stringFormat: customFormatString)
        
        XCTAssertEqual(resultCustomFormattedString.lowercased(), expectedCustomFormattedString.lowercased(), "The generated date string does not match the expected string.")
    }
}
