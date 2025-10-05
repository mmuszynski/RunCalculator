//
//  NewMileageGoalView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 7/26/24.
//

import SwiftUI

struct NewMileageGoalView: View {
    @State private var newGoal = MileageGoal()
    @Environment(MileageGoalController.self) var goalController
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            GoalEditView(goal: $newGoal)
            Spacer()
            Text("Quick select")
            HStack {
                Text("Mileage:")
                ForEach([100, 365, 500, 1000], id: \.self) { num in
                    Button {
                        newGoal.target = num
                    } label: {
                        Text(num, format: .number)
                    }
                }
                .buttonStyle(.bordered)
            }
            HStack {
                Text("Duration:")
                Button {
                    if let month = Calendar.current.dateInterval(of: .month, for: .current) {
                        newGoal.interval = month
                    }
                } label: {
                    Text("This Month")
                }
                Button {
                    if let year = Calendar.current.dateInterval(of: .year, for: .current) {
                        newGoal.interval = year
                    }
                } label: {
                    Text("This Year")
                }
            }
            .buttonStyle(.bordered)
            
            Spacer()
            Button {
                goalController.append(newGoal)
                dismiss()
            } label: {
                Text("Add Goal")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.borderedProminent)
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}


#Preview {
    NewMileageGoalView()
        .environment(MileageGoalController())
}
