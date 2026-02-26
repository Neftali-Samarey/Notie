//
//  Color+Extension.swift
//  Notie
//
//  Created by Neftali Samarey on 2/4/26.
//

import SwiftUI

extension Color {
    // Note: gradientCleanRed is now a LinearGradient, not a Color.
    static let mainBackground = Color(red: 246/255.0, green: 246/255.0, blue: 246/255.0)
    static let contentWhite = Color(red: 254/255.0, green: 254/255.0, blue: 254/255.0)
    static let gradientCleanRed = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 219/255.0, green: 88/255.0, blue: 105/255.0),
            Color(red: 255/255.0, green: 160/255.0, blue: 130/255.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let darkModeGray = Color(red: 44/255.0, green: 44/255.0, blue: 44/255.0)

    // Gradients
    static let gradientPomegranate = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 244/255.0, green: 7/255.0, blue: 82/255.0),
            Color(red: 249/255.0, green: 171/255.0, blue: 143/255.0)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
