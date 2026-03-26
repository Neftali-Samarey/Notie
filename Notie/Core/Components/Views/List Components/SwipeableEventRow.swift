//
//  SwipeableEventRow.swift
//  Notie
//
//  Created by Neftali Samarey on 3/25/26.
//

import SwiftUI

struct SwipeableEventRow: View {
    let item: EventItem
    let style: GridItemStyle
    let onDelete: () -> Void

    @State private var offset: CGFloat = 0
    @State private var isOpen = false

    private let maxSwipe: CGFloat = -80

    var body: some View {
        ZStack {
            // background (Delete button)
            HStack {
                Spacer()

                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .frame(width: 80, height: 74)
                }
                .background(Color.red)
                .cornerRadius(12)
            }

            // foreground (card view)
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
                            .overlay {
                                Image(systemName: "creditcard.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                            }

                        Text(item.title)

                        Spacer()

                        Text(item.date.formatted(date: .numeric, time: .omitted))
                    }
                    .padding()
                }
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translation = value.translation.width

                            if translation < 0 { // swipe left only
                                offset = max(translation, maxSwipe)
                            } else if isOpen {
                                offset = min(maxSwipe + translation, 0)
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if offset < maxSwipe / 2 {
                                    offset = maxSwipe
                                    isOpen = true
                                } else {
                                    offset = 0
                                    isOpen = false
                                }
                            }
                        }
                )
        }
    }
}
