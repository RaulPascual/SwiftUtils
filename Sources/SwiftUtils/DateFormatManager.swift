//
//  DateFormat.swift
//
//
//  Created by Raul on 21/5/24.
//

import Foundation
import SwiftUI

// MARK: - Dates management

public enum DateStrings: String {
    // MARK: - Date Formats
    case ddMMyyyy = "dd-MM-yyyy" // 01-11-2023
    case yyyyMMdd = "yyyy-MM-dd" // 2023-11-01
    case MMddyyyy = "MM-dd-yyyy" // 11-01-2023
    case ddMMMMyyyy = "dd MMMM yyyy" // 01 noviembre 2023
    case EEEEddMMMMyyyy = "EEEE, dd MMMM yyyy" // miércoles, 01 noviembre 2023
    case MMMdyyyy = "MMM d, yyyy" // nov 1, 2023
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss" // 2023-11-01 12:30:45
    case HHmmss = "HH:mm:ss" // 12:30:45
    case hmma = "h:mm a" // 1:30 PM
    case yyyyMMddTHHmmss = "yyyy-MM-dd'T'HH:mm:ss" // 2023-11-10T15:30:45
    case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ" // 2023-11-10T15:30:45+0000
}


/**
 A manager class for handling date formatting and parsing.
 
 - Parameters:
 - locale: The locale to be used for date formatting. Defaults to the current locale.
 
 This class provides various static date format strings and methods to convert between `Date` and `String` using specified formats.
 */
public class DateFormatManager {
    /// Lazy-loaded `DateFormatter` instance for formatting dates.
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        return formatter
    }()
    
    /// The locale to be used for date formatting.
    var locale: Locale?
    
    /**
     Initializes a new `DateFormatManager` with the specified locale.
     
     - Parameter locale: The locale to be used for date formatting. Defaults to the current locale.
     */
    public init(locale: Locale? = Locale.current) {
        self.locale = locale
    }
    
    // MARK: - Date Formatting and Parsing
    /**
     Converts a date string to a `Date` object using the specified format.
     
     - Parameters:
     - dateString: The date string to be converted.
     - format: The date format to be used for conversion.
     
     - Returns: A `Date` object if the conversion is successful, otherwise `nil`.
     */
    public func date(dateString: String, format: String) -> Date? {
        configureDateFormatter(with: format)
        return dateFormatter.date(from: dateString)
    }
    
    /**
     Converts a `Date` object to a string using the specified format.
     
     - Parameters:
     - date: The `Date` object to be converted.
     - format: The date format to be used for conversion.
     
     - Returns: A formatted date string.
     */
    public func string(date: Date, format: String) -> String {
        configureDateFormatter(with: format)
        return dateFormatter.string(from: date)
    }
    
    /**
     Converts a `Date` object to a string using a custom format string.
     
     - Parameters:
     - date: The `Date` object to be converted.
     - stringFormat: The custom date format string.
     
     - Returns: A formatted date string.
     */
    public func customFormattedString(date: Date, stringFormat: String) -> String {
        configureDateFormatter(with: stringFormat)
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Private Helper
    
    /**
     Configures the date formatter with the specified format.
     
     - Parameter format: The date format to be set.
     */
    private func configureDateFormatter(with format: String) {
        dateFormatter.dateFormat = format
    }
}
