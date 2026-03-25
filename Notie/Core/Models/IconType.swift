//
//  IconType.swift
//  Notie
//
//  Created by Neftali Samarey on 3/25/26.
//

import Foundation

public enum IconType: String {
    case calendar
    case alert
    case creditCard

    var iconStringValue: String {
        switch self {
        case .calendar:
            return "calendar"
        case .alert:
            return "exclamationmark.triangle.fill"
        case .creditCard:
            return "creditcard.fill"
        }
    }
}
