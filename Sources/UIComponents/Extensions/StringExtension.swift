//
//  StringExtension.swift
//
//
//  Created by Raul on 27/5/24.
//

import Foundation
import SwiftUI

extension String {
    static func localizedString(for key: String, locale: Locale = .current) -> String {
        return Bundle.main.localizedString(forKey: key, value: "", table: nil)
    }
    
    /// Used to validate a regex string. Can apply to custom Textfield
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }
}

extension LocalizedStringKey {
    var stringKey: String {
        let description = "\(self)"
        
        let components = description.components(separatedBy: "key: \"")
            .map { $0.components(separatedBy: "\",") }
        
        return components[1][0]
    }
    
    func stringValue(locale: Locale = .current) -> String {
        return .localizedString(for: self.stringKey, locale: locale)
    }
}
