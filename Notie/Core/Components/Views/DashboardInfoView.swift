//
//  DashboardInfoView.swift
//  Notie
//
//  Created by Neftali Samarey on 2/4/26.
//

import SwiftUI

struct DashboardInfoView: View {

    private let eventName: String
    private let dueDate: String

    public init(eventName: String, dueDate: String) {
        self.eventName = eventName
        self.dueDate = dueDate
    }

    var body: some View {
        content
    }
}

fileprivate extension DashboardInfoView {
    var content: some View {
        RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
            .fill(Color.white)
            .frame(height: Constants.dashboardInfoViewHeight)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(eventName)
                    Text(dueDate)
                }
                .padding()
            }
    }
}

#Preview {
    DashboardInfoView(eventName: "AMEX Credit Card", dueDate: "Feb 18, 2026")
}
