//
//  RunningPlanView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/16/23.
//

import SwiftUI

struct RunningPlanView: View {
    @EnvironmentObject var controller: RunningPlanViewController
    
    var body: some View {
        VStack {
            ScrollView {
                Grid(horizontalSpacing: 0) {
                    RunningPlanHeaderGridRow()
                        .frame(width: 40)
                    
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    
                    ForEach(controller.plan.goals) { week in
                        RunningPlanWeekGridRow(week: week)
                    }
                    
                    GridRow {
                        Button("Add a week") {
                            withAnimation {
                                controller.plan.addWeek()
                            }
                        }
                        .gridCellColumns(10)
                    }
                }
                .font(.title2)
            }
            .onTapGesture {
                controller.selection = nil
            }
            
            RunningPlanKeyboard()
                .frame(height: 300)
                .padding()
        }
        
        
    }
}

struct RunningPlanView_Previews: PreviewProvider {
    static var previews: some View {
        RunningPlanView()
            .environmentObject(RunningPlanViewController())
    }
}
