//
//  GoalEditView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/8/24.
//

import SwiftUI

struct PickerButtonStyle: ButtonStyle {
    var selected: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(selected ? .secondary : .quaternary, in: Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

extension ButtonStyle where Self == PickerButtonStyle {
    static var selectedPicker: PickerButtonStyle {
        PickerButtonStyle(selected: true)
    }
    static var unselectedPicker: PickerButtonStyle {
        PickerButtonStyle(selected: false)
    }
}

struct GoalEditView: View {
    @Binding var goal: MileageGoal
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                TextField("Distance", value: $goal.target, format: .number.grouping(.never))
                    .keyboardType(.decimalPad)
                    .font(.system(size: 80))
                    .multilineTextAlignment(.trailing)
                    .focused($isFocused)
                
                Button("Mi") {
                    goal.unit = .miles
                }
                .buttonStyle(goal.unit == .miles ? .selectedPicker : .unselectedPicker)
                
                Button("km") {
                    goal.unit = .kilometers
                }
                .buttonStyle(goal.unit == .kilometers ? .selectedPicker : .unselectedPicker)
                .padding([.trailing])
            }
            
            Group {
                DatePicker(selection: $goal.interval.start,
                           displayedComponents: .date) {
                    Text("Start")
                }
                DatePicker(selection: $goal.interval.end,
                           displayedComponents: .date) {
                    Text("End")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isFocused = false
                }
            }
        }
    }
}

#Preview {
    GoalEditView(goal: .constant(.init()))
}
