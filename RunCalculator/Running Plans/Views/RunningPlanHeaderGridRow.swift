//
//  RunningPlanHeaderView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/26/23.
//

import SwiftUI

struct RunningPlanHeaderGridRow: View {
    var body: some View {
        GridRow {
            Text("Wk")
            ForEach(0..<7) { idx in
                Text(RunningPlan.dayDescription(dayIndex: idx) ?? "xx")
            }
            Text("Tot")
        }
    }
}
