//
//  MileagePieChartView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 10/5/25.
//

import SwiftUI

struct FullWidthProminentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.selection, in: Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

extension ButtonStyle where Self == FullWidthProminentButtonStyle {
    static var fullWidthPRominent: Self { Self() }
}

#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(FullWidthProminentButtonStyle())
}

struct MileagePieChartView: View {
    var goal: MileageGoal
    @EnvironmentObject var hdc: HealthDataController
    
    var body: some View {
        VStack {
            MileagePieChart()
                .aspectRatio(contentMode: .fit)
                .padding()
            Button {
                
            } label: {
                Text("Change Goal")
            }
            .buttonStyle(.fullWidthPRominent)
            .padding()
            Spacer()
            
        }
        .environment(MileageGoalViewController(hdc: self.hdc, goal: goal))
        .navigationTitle(Text("Goal: \(goal.measurement, formatter: .mileageFormatter)"))
        .navigationSubtitle(Text(goal.interval, formatter: DateIntervalFormatter(timeStyle: .none, dateStyle: .short)))
    }
}

#Preview {
    NavigationStack {
        MileagePieChartView(goal: .example)
            .environmentObject(HealthDataController())
    }
}
