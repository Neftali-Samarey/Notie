//
//  DashboardInfoView.swift
//  Notie
//
//  Created by Neftali Samarey on 2/4/26.
//

import SwiftUI
import SwiftData

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

public struct OverviewBills: Identifiable {
    public var id = UUID()
    let title: String
    let icon: String
    let count: String
}

public enum DashboardViewType {
    case overview
    case listItem
    case grid
    case none
}

struct DashboardInfoView: View {

    @Environment(\.colorScheme) private var colorScheme
    @Query(sort: \EventItem.date, order: .forward) private var events: [EventItem]

    private let viewType: DashboardViewType
    private let eventName: String?
    private let dueDate: String?

    public init(viewType: DashboardViewType = .none, eventName: String? = nil, dueDate: String? = nil) {
        self.viewType = viewType
        self.eventName = eventName
        self.dueDate = dueDate
    }

    let entry: EntryItem = EntryItem(icon: .creditCard, title: "Con Ed Bill", event: [Event(icon: .calendar, text: "March 8, 2026"), Event(icon: .alert, text: "Due in 7 days")])

    var body: some View {
        content
    }
}

fileprivate extension DashboardInfoView {

    var colorMode: Color {
        colorScheme == .dark ? Color.darkModeGray : Color.white
    }

    var content: some View {
        Group {
            switch viewType {
            case .overview:
                VStack(alignment: .leading) {
                    Group {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Next Due")
                                    .foregroundStyle(Color.gray.opacity(0.8))
                                    .font(.system(size: 12, weight: .medium))
                                Text(parseEvent(with: events.first).title)
                                    .font(.system(size: 20, weight: .medium))
                                Text("Due: \(parseEvent(with: events.first).date.formatted(date: .long, time: .omitted))")
                                    .font(.system(size: 14, weight: .regular))
                            }

                            Spacer()

                            VStack(alignment: .center) {
                                Circle()
                                    .frame(width: 65, height: 65)
                                    .foregroundStyle(Color.white)
                                    .overlay(alignment: .center) {
                                        VStack {
                                            Text("1")
                                                .foregroundStyle(Color.black)
                                                .font(.system(size: 20, weight: .medium))
                                            Text("day")
                                                .foregroundStyle(Color.gray)
                                                .font(.system(size: 13, weight: .regular))
                                        }
                                    }
                                    .padding(.trailing, 8)
                                    .padding(.top, 8)
                                Spacer()
                            }
                        }

                        VStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height: 0.5)

                            Spacer()

                            HStack {
                                Text("Amount")
                                    .foregroundStyle(Color.gray.opacity(0.8))
                                    .font(.system(size: 14, weight: .medium))
                                Spacer()
                                Text("$100.00")
                                    .font(.system(size: 18).bold())
                            }
                        }
                        .padding(.bottom, 8)
                    }
                    .foregroundStyle(Color.white)
                    /*HStack {
                        Image(systemName: entry.icon.iconStringValue)
                            .font(.system(size: 18.5, weight: .regular, design: .default))
                            .foregroundStyle(Color.gradientPomegranate)
                        Text(parseEvent(with: events.first).title)
                            .font(.system(size: 18.5, weight: .semibold, design: .default))
                            .lineLimit(1)
                    }
                    .padding(.vertical, 5)

                    Divider()

                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(entry.event) { item in
                            eventItem(with: item.icon.iconStringValue, and: item.text)
                        }
                    }
                    .padding(.vertical, 8)*/
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 169)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                        .fill(Color.black) // colorMode
                )
            case .grid:
                VStack(alignment: .leading) {
                    Text("Overview")
                        .font(.system(size: 18)).fontWeight(.medium)

                    gridItem(numberOfItems: overviewBills)
                }
            case .listItem:
                eventItemList(list: events)
                    .safeAreaPadding(.bottom, 85)
            default:
                EmptyView()
            }
        }
    }

    func gridItem(numberOfItems: [OverviewBills] ) -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(numberOfItems) { item in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 90)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.lightGray).opacity(0.5), lineWidth: 1)
                    )
                    .overlay {
                        VStack(spacing: 10) {
                            HStack {
                                Text(item.title)
                                    .font(.system(size: 13))
                                    .foregroundStyle(Color.gray)
                                Spacer()
                                Image(systemName: item.icon)
                                    .font(.system(size: 13, weight: .regular, design: .default))
                                    .foregroundStyle(Color.gray)
                            }
                            HStack {
                                Text(item.count)
                                    .font(.system(size: 24)).bold()
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                    }
            }
        }
        .padding(.bottom, 10)
    }

    func eventItem(with iconName: String, and description: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .regular, design: .default))
            Text(description)
                .font(.system(size: 16, weight: .regular, design: .default))
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private func eventItemList(list: [EventItem]) -> some View {
        if list.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading) {
                Text("Upcoming")
                    .font(.system(size: 18)).fontWeight(.medium)
                    .padding(.bottom, 5)

                ForEach(events) { item in
                    HStack {
                        Text(item.title)
                        Spacer()
                        Text(item.date.formatted(date: .numeric, time: .omitted))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.cardListItemRadius)
                            .fill(colorMode)
                    )
                }
            }
        }
    }
}

fileprivate extension DashboardInfoView {

    func parseEvent(with event: EventItem?) -> (title: String, date: Date) {
        guard let event = event else { return ("", Date()) }
        return (event.title, event.date)
    }

    var overviewBills: [OverviewBills] {
        let billsCount = 0
        let billsDueSoon = 0
        var overview: [OverviewBills] = []
        overview.append(OverviewBills(title: "Total Bills", icon: "receipt.fill", count: "\(billsCount)"))
        overview.append(OverviewBills(title: "Due Soon", icon: "clock.badge.fill", count: "\(billsDueSoon)"))
        return overview
    }
}

#Preview {
    DashboardInfoView(viewType: .overview, eventName: "AMEX Credit Card", dueDate: "Feb 18, 2026")
    DashboardInfoView(viewType: .listItem)
}
