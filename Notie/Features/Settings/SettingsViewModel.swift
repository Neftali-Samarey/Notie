//
//  SettingsViewModel.swift
//  Notie
//
//  Created by Neftali Samarey on 3/25/26.
//

import Combine
import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var threshold: Int = 5
}
