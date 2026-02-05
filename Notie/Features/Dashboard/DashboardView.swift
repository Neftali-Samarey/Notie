//
//  DashboardView.swift
//  Notie
//
//  Created by Neftali Samarey on 2/4/26.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        mainContent()
    }

    private func addItem() {
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
    }
}

fileprivate extension DashboardView {

    func mainContent() -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    DashboardInfoView(eventName: "Credit Card", dueDate: "Feb 20, 2026")
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
                .padding(.horizontal, 15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollContentBackground(.hidden)
            .background(
                Color.mainBackground.ignoresSafeArea()
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { }) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: Item.self, inMemory: true)
}
