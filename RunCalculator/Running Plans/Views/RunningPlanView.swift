//
//  RunningPlanView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/16/23.
//

import SwiftUI

struct RunningPlanView: View {
    @EnvironmentObject var controller: RunningPlanViewController
    @FocusState var isEditing: Bool
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                TextField("", text: $controller.editString)
                    .focused($isEditing, equals: true)
                    .keyboardType(.decimalPad)
                    .opacity(0)
                
                VStack {
                    ScrollView {
                        Grid(horizontalSpacing: 0,
                             verticalSpacing: 0) {
                            RunningPlanHeaderGridRow()
                            
                            ForEach(controller.plan.goals) { week in
                                
                                HStack {
                                    Text("wk \(week.week + 1)")
                                        .font(.caption)
                                        .fontWeight(.ultraLight)
                                        .frame(height: 0)
                                    VStack {
                                        Divider()
                                    }
                                }
                                
                                RunningPlanWeekGridRow(week: week)
                            }
                            
                            Divider()
                            
                            GridRow {
                                Button("Add a week") {
                                    withAnimation {
                                        controller.plan.addWeek()
                                    }
                                }
                                .gridCellColumns(9)
                                .frame(height: 30)
                            }
                        }
                        .monospacedDigit()
                    }
                    .onTapGesture {
                        controller.selection = nil
                    }
                    .onChange(of: controller.selection) {
                        newValue, oldValue in
                        self.isEditing = newValue != nil
                    }
                }
            }
        }
    }
}

struct RunningPlanView_Previews: PreviewProvider {
    static var previews: some View {
        RunningPlanView()
            .environmentObject(RunningPlanViewController())
    }
}
