//
//  TodaysRunView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 8/1/23.
//

import Foundation
import SwiftUI

extension DateInterval {
    static var today: DateInterval {
        Calendar.current.dateInterval(of: .day, for: .current)!
    }
    
    static var todayPlusTwoHours: DateInterval {
        let date = Calendar.current.date(byAdding: .hour, value: 2, to: .current) ?? .current
        return Calendar.current.dateInterval(of: .day, for: date)!
    }
}

struct TodaysRunView: View {
    @EnvironmentObject var healthController: HealthDataController
    var goal: RunningPlanDailyGoal?
    var isShowing: Bool = true
    
    var isGoalToday: Bool {
        return DateInterval.today == .todayPlusTwoHours
    }
    
    var isGoalAchieved: Bool {
        guard let goal else { return false }
        return healthController.summary(for: .todayPlusTwoHours).runningDistance > goal.mileageMeasurement
    }
    
    var image: some View {
        var imageName = "zzz"
        var color: Color = .secondary
        if let goal {
            if !isGoalToday {
                imageName = "figure.run.circle.fill"
                color = .blue
            } else if isGoalAchieved {
                imageName = "checkmark.circle.fill"
                color = .green
            } else if goal.miles > 0 {
                imageName = "circle.dashed"
            }
        }
            
        return Image(systemName: imageName)
            .foregroundStyle(color)
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }()
    
    var date: Date = .current
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .rotationEffect(.degrees(isShowing ? 180 : 0))
            VStack(alignment: .leading) {
                Text(isGoalToday ? "Today's Goal" : "Tomorrow's Goal")
                    .font(.title)
                
                if let goal = goal, goal.miles > 0 {
                    Text("\(goal.mileageMeasurement, formatter: .mileageFormatter)")
                        .bold()
                } else {
                    Text("Rest Day")
                }
            }
            Spacer()
            image
        }
        .font(.largeTitle)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundStyle(.background)
                .shadow(color: .secondary, radius: 1)
        )
    }
}

struct TodayPreview: PreviewProvider {
    static var previews: some View {
        TodaysRunView(goal: .init(miles: 5, day: 3, week: 1))
            .environmentObject(HealthDataController())
            .padding()
    }
}
