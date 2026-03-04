//
//  Item.swift
//  Notie
//
//  Created by Neftali Samarey on 2/4/26.
//

import Foundation
import SwiftData

@Model
final class EventItem {
    var title: String
    var date: Date
    var amount: Double?

    init(title: String, date: Date, amount: Double? = nil) {
        self.title = title
        self.date = date
        self.amount = amount
    }
}
