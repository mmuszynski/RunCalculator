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
            Color.clear
                .frame(width: 10, height: 10)
            ForEach(0..<7) { idx in
                Text(RunningPlan.dayDescription(dayIndex: idx) ?? "xx")
            }
            Text("Tot")
                .fontWeight(.ultraLight)
        }
    }
}
