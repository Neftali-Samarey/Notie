//
//  SettingsView.swift
//  Notie
//
//  Created by Neftali Samarey on 2/28/26.
//

import SwiftUI
import Combine

struct SettingsView: View {

    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            List {
                Stepper(
                    "Due Soon Days: \(viewModel.threshold)",
                    value: $viewModel.threshold,
                    in: 1...10
                )
                .onChange(of: viewModel.threshold) { oldValue, newValue in
                    UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.thresholdKey)
                    HapticFeedbackService.vibrate(.medium)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") {
                        dismiss()
                        HapticFeedbackService.vibrate(.selection)
                    }
                }
            }
            .onAppear {
                let saved = UserDefaults.standard.integer(forKey: UserDefaults.Keys.thresholdKey)
                if saved != 0 { // integer(forKey:) returns 0 if the key doesn't exist
                    viewModel.threshold = saved
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
