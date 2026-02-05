//
//  DashboardInfoView.swift
//  Notie
//
//  Created by Neftali Samarey on 2/4/26.
//

import SwiftUI

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

public struct Event: Identifiable {
    public var id = UUID()
    let icon: IconType
    let text: String
}

public struct EntryItem {
    let icon: IconType
    let title: String
    let event: [Event]
}

struct DashboardInfoView: View {

    private let eventName: String
    private let dueDate: String

    public init(eventName: String, dueDate: String) {
        self.eventName = eventName
        self.dueDate = dueDate
    }

    let test: [Event] = [Event(icon: .calendar, text: "Feb 20, 2026"),
                         Event(icon: .alert, text: "Due in 10 days")
                        ]

    let entry: EntryItem = EntryItem(icon: .creditCard, title: "Citi Credit Card", event: [Event(icon: .calendar, text: "March 20, 2026"), Event(icon: .alert, text: "Due in 10 days")])

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
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: entry.icon.iconStringValue)
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundStyle(Color.gradientCleanRed)
                        Text(entry.title)
                            .font(.system(size: 20, weight: .semibold, design: .default))
                            .lineLimit(1)
                    }
                    .padding(.vertical, 5)

                    Divider()


                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(entry.event) { item in
                            eventItem(with: item.icon.iconStringValue, and: item.text)
                        }
                    }
                    .padding(.vertical, 8)

                    Spacer()
                }
                .padding()
            }
            //.border(Color.red)
    }

    func eventItem(with iconName: String, and description: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 18, weight: .regular, design: .default))
            Text(description)
                .font(.system(size: 18, weight: .regular, design: .default))
                .lineLimit(1)
        }
    }
}

#Preview {
    DashboardInfoView(eventName: "AMEX Credit Card", dueDate: "Feb 18, 2026")
}
