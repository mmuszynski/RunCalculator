//
//  RunningPlanKeyboard.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/27/23.
//

import SwiftUI

extension ButtonStyle where Self == KeyboardButtonStyle {
    static var keyboard: Self { Self() }
}

struct KeyboardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { g in
            configuration.label
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(.gray)
                .cornerRadius(g.size.width / 25)
                .padding(g.size.width / 50)
                //.opacity(configuration.isPressed ? 0.5 : 1)
                .font(.largeTitle)
                .scaleEffect(configuration.isPressed ? 0.99 : 1)
                .animation(.none, value: UUID())

        }
    }
}

struct RunningPlanKeyboard: View {
    var body: some View {
        GridLayout(horizontalSpacing: 0, verticalSpacing: 0) {
            Group {
                GridRow {
                    Button(action: {}) { Text("1") }
                    Button(action: {}) { Text("2") }
                    Button(action: {}) { Text("3") }
                }
                GridRow {
                    Button(action: {}) { Text("4") }
                    Button(action: {}) { Text("5") }
                    Button(action: {}) { Text("6") }
                }
                GridRow {
                    Button(action: {}) { Text("7") }
                    Button(action: {}) { Text("8") }
                    Button(action: {}) { Text("9") }
                }
                GridRow {
                    Button(action: {}) { Text("⌫") }
                    Button(action: {}) { Text("0") }
                    Button(action: {}) { Text(".") }
                }
            }
            .buttonStyle(.keyboard)
        }
    }
}

struct RunningPlanKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        RunningPlanKeyboard()
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
