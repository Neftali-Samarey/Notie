//
//  DashboardView.swift
//  Notie
//
//  Created by Neftali Samarey on 2/4/26.
//

import SwiftUI
import SwiftData
import UserNotifications
import Observation

struct DashboardView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    @State private var isModalSheetPresented: Bool = false
    @State private var textValue: String = ""
    @State private var datePickerDate = Date()

    @Query private var events: [EventItem]

    private let notificationCenter = UNUserNotificationCenter.current()
    private var backgroundColorScheme: Color { colorScheme == .dark ? Color.gray : Color.mainBackground }

    var body: some View {
        mainContent()
            .overlay(alignment: .bottom) {
                actionButton
            }
            .task {
                do {
                    try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
                } catch {
                    print("Request authorization error")
                }
            }
            .sheet(isPresented: $isModalSheetPresented) {
                modalContent
                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                print("Event count: \(events.count)")
                for event in events {
                    updateDueDateIfPast(for: event, context: modelContext)
                    print("- Event: \(event.title) on \(event.date.formatted(date: .long, time: .omitted))")
                }
            }
    }

    /*private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }*/
}

fileprivate extension DashboardView {

    func mainContent() -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    DashboardInfoView(viewType: .grid)
                        .frame(maxWidth: .infinity)
    
                    DashboardInfoView(viewType: .overview)
                        .frame(maxWidth: .infinity)

                    Spacer()

                    DashboardInfoView(viewType: .listItem)
                }
                .padding(.horizontal, 15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollContentBackground(.hidden)
            .background(
                backgroundColorScheme.ignoresSafeArea()
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
        }
    }

    private var modalContent: some View {
        VStack(alignment: .center) {
            Text("Add Item")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 10)

            TextField("Item Name", text: $textValue)
                .padding(.horizontal, 12)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                )

            // Date picker
            DatePicker(
                "Select a Date",
                selection: $datePickerDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 18, weight: .medium))
            .padding(.vertical, 14)

            Spacer()

            Button {
                let entry = EventItem(title: textValue, date: datePickerDate)
                modelContext.insert(entry)

                do {
                    try modelContext.save()
                } catch {
                    print(error)
                }

                textValue = ""
                datePickerDate = Date()

                isModalSheetPresented = false
                /*Task {
                    //guard !textValue.isEmpty && datePickerDate != Date() else { return }
                    let entry = EventItem(title: textValue, date: datePickerDate)
                    /*guard !textValue.isEmpty && datePickerDate != Date() else { return }
                    let newItem = EventItem(title: textValue, date: datePickerDate)
                    modelContext.insert(newItem)*/
                    await saveItem(entry)
                }*/
            } label: {
                Text("Add")
                    .font(.system(size: 20, weight: .medium))
                    .frame(height: 55)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red)
                    )
                    .foregroundStyle(.white)
            }
            .disabled(textValue.isEmpty ? true : false)
            .opacity(textValue.isEmpty ? 0.5 : 1.0)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
    }

    private var actionButton: some View {
        Button(action: { isModalSheetPresented.toggle() }) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .bold))
                .frame(width: 56, height: 56)
                .background(Circle().fill(Color.black))
                //.background(Circle().fill(Color.gradientPomegranate))
                .shadow(radius: 2)
        }
    }
}

fileprivate extension DashboardView {

    @MainActor
    func saveItem(_ item: EventItem) async {
        modelContext.insert(item)
    }

    func updateDueDateIfPast(for item: EventItem, context: ModelContext) {
        let calendar = Calendar.current
        let now = Date()

        guard item.date < now else { return }

        let components = calendar.dateComponents([.month], from: item.date, to: now)
        let monthsToAdd = (components.month ?? 0) + 1

        if let newDate = calendar.date(byAdding: .month, value: monthsToAdd, to: item.date) {
            item.date = newDate
            try? context.save()
        }
    }
    /*func updateDueDateIfPast(for item: EventItem, context: ModelContext) {
        let calendar = Calendar.current
        let now = Date()

        guard item.date < now else { return }

        var updatedDate = item.date

        while updatedDate < now {
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: updatedDate) {
                updatedDate = nextMonth
            } else {
                break
            }
        }

        item.date = updatedDate

        do {
            try context.save()
        } catch {
            print("Failed to save updated date:", error)
        }
    }*/
}

#Preview {
    DashboardView()
        .modelContainer(for: EventItem.self, inMemory: true)
}

//@Observable
//final class DashboardViewModel {
//
//    let database: EventStore
//
//    init() {
//        // If EventStore() can throw, keep try! for now to match existing intent. Consider proper error handling later.
//        self.database = try! EventStore()
//    }
//}

