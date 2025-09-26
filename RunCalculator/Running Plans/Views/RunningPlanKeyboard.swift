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
                .background(configuration.isPressed ? Color.buttonActive : .button)
                .overlay {
                    RoundedRectangle(cornerRadius: g.size.width/25)
                        .stroke(Color.gray)
                        .foregroundColor(.clear)
                }
                .cornerRadius(g.size.width / 25)
                .padding(g.size.width / 50)
                //.opacity(configuration.isPressed ? 0.5 : 1)
                .font(.largeTitle)
                .scaleEffect(configuration.isPressed ? 0.99 : 1)
                .animation(.none, value: UUID())
                .padding(g.size.width/50)
                .shadow(color: .gray.opacity(0.5), radius: 1, x: 1, y: 1)
        }
    }
}

struct RunningPlanKeyboard: View {
    @EnvironmentObject var controller: RunningPlanController
    var keys = "123456789.0⌫".map { $0 }
    
    var body: some View {
        GridLayout(horizontalSpacing: 0, verticalSpacing: 0) {
            Group {
                ForEach(0..<4) { row in
                    GridRow {
                        ForEach(keys[3*row..<3*row+3], id: \.self) { char in
                            KeyboardKey(character: char)
                        }
                    }
                }
            }
            .buttonStyle(.keyboard)
        }
        .background(.quaternary)
    }
}

struct KeyboardKey: View {
    @EnvironmentObject var controller: RunningPlanController
    var character: Character
    
    var body: some View {
        Button(action: { controller.keypress(character) },
               label: { Text(String(character)) })
        .buttonStyle(.keyboard)
    }
}

struct RunningPlanKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RunningPlanKeyboard()
            RunningPlanKeyboard()
        }
        .environmentObject(RunningPlanController())
        .previewLayout(.fixed(width: 400, height: 300))
    }
}
