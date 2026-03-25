//
//  DashboardInfoView.swift
//  Notie
//
//  Created by Neftali Samarey on 2/4/26.
//

import SwiftUI
import SwiftData

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
                overviewContentView()
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 169)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                        .fill(Color.white) // colorMode
                        .shadow(color: Color.black.opacity(0.1), radius: 2.5, x: 0, y: 1)
                )
            case .grid:
                VStack(alignment: .leading) {
                    Text("Overview")
                        .font(.system(size: 18)).fontWeight(.medium)

                    gridItem(numberOfItems: overviewBills, style: .shadow)
                }
            case .listItem:
                eventItemList(list: events, style: .shadow)
                    .safeAreaPadding(.bottom, 85)
            default:
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private func overviewContentView() -> some View {
        if !events.isEmpty {
            VStack(alignment: .leading) {
                Group {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Next Due")
                                .foregroundStyle(Color.gray.opacity(0.8))
                                .font(.system(size: 12, weight: .medium))
                                .textCase(.uppercase)
                            Text(parseEvent(with: events.first).title)
                                .foregroundStyle(Color.black)
                                .font(.system(size: 20, weight: .medium))
                            Text("Due: \(parseEvent(with: events.first).date.formatted(date: .long, time: .omitted))")
                                .foregroundStyle(Color.black)
                                .font(.system(size: 14, weight: .regular))
                        }

                        Spacer()

                        VStack(alignment: .center) {
                            Circle()
                                .frame(width: 65, height: 65)
                                .foregroundStyle(Color.black.opacity(0.8))
                                .overlay(alignment: .center) {
                                    daysLeft()
                                }
                                .padding(.trailing, 8)
                                .padding(.top, 8)
                            Spacer()
                        }
                    }

                    if events.first?.amount != nil {
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
                }
                .foregroundStyle(Color.white)
            }
        } else {
            VStack(alignment: .center) {
                Text("No upcoming bills")
                    .foregroundStyle(Color.gray.opacity(0.8))
                    .font(.system(size: 18, weight: .medium))
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    func gridItem(numberOfItems: [OverviewBills], style: GridItemStyle) -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(numberOfItems) { item in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 90)
                    .overlay {
                        if style == .lined {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.lightGray).opacity(0.5), lineWidth: 1)
                        }
                    }
                    .shadow(
                        color: style == .shadow ? Color.black.opacity(0.1) : .clear,
                        radius: style == .shadow ? 2.5 : 0,
                        x: 0,
                        y: style == .shadow ? 1 : 0
                    )
                    .overlay {
                        VStack(spacing: 10) {
                            HStack {
                                Text(item.title)
                                    .font(.system(size: 13))
                                    .foregroundStyle(Color.gray)
                                Spacer()
                                Image(systemName: item.icon)
                                    .font(.system(size: 13, weight: .regular))
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
                    /*.overlay(alignment: .topTrailing) {
                        Circle()
                            .foregroundStyle(Color.red)
                            .frame(width: 20, height: 20)
                            .offset(x: 8, y: -8)
                    }*/
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
    private func eventItemList(list: [EventItem], style: GridItemStyle) -> some View {
        if list.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading) {
                Text("Upcoming")
                   .font(.system(size: 18)).fontWeight(.medium)
                   .padding(.bottom, 5)

                ForEach(events) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(height: 74)
                        .overlay {
                            if style == .lined {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.lightGray).opacity(0.5), lineWidth: 1)
                            }
                        }
                        .shadow(
                            color: style == .shadow ? Color.black.opacity(0.1) : .clear,
                            radius: style == .shadow ? 2.5 : 0,
                            x: 0,
                            y: style == .shadow ? 1 : 0
                        )
                        .overlay {
                            HStack {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color.gray.opacity(0.1))
                                    .overlay(alignment: .center) {
                                        Image(systemName: "creditcard.fill")
                                            .font(.system(size: 18, weight: .regular))
                                            .foregroundStyle(.black)
                                    }
                                Text(item.title)
                                Spacer()
                                Text(item.date.formatted(date: .numeric, time: .omitted))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                }
            }
        }
    }

    @ViewBuilder
    func daysLeft() -> some View {
        let days = absoluteDaysFromNow(since: events.first?.date ?? Date())
        VStack {
            Text("\(days)")
                .foregroundStyle(Color.white)
                .font(.system(size: 20, weight: .medium))
            Text(days > 1 ? "days" : "day")
                .foregroundStyle(Color.white)
                .font(.system(size: 13, weight: .regular))
        }
    }

    func daysFromNow(since date: Date) -> Int {
        let calendar = Calendar.current
        let startOfInput = calendar.startOfDay(for: date)
        let startOfToday = calendar.startOfDay(for: Date())

        let components = calendar.dateComponents([.day], from: startOfInput, to: startOfToday)
        return components.day ?? 0
    }

    func absoluteDaysFromNow(since date: Date) -> Int {
        abs(daysFromNow(since: date))
    }
}

fileprivate extension DashboardInfoView {

    func parseEvent(with event: EventItem?) -> (title: String, date: Date) {
        guard let event = event else { return ("", Date()) }
        return (event.title, event.date)
    }

    var eventCount: Int {
        events.count
    }

    var eventDueSoon: Int {
        events.count
    }

    var overviewBills: [OverviewBills] {
        let billsCount = eventCount
        let billsDueSoon = eventDueSoon
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
