//
//  OverviewBills.swift
//  Notie
//
//  Created by Neftali Samarey on 3/25/26.
//

import Foundation

public struct OverviewBills: Identifiable {
    public var id = UUID()
    let title: String
    let icon: String
    let count: String
}
