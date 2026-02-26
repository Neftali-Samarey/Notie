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
    //@Attribute(.unique) private(set) var id: UUID
    var title: String
    var date: Date

    init(title: String, date: Date) {
        //self.id = UUID()
        self.title = title
        self.date = date
    }
}
