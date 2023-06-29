//
//  CalendarView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/23/23.
//

import SwiftUI

struct CalendarDay {
    init(dayIndex: Int, year: Int) {
        
    }
}

struct CalendarView: View {
    @EnvironmentObject var hdc: HealthDataController
    @State var index: Int = 0
    
    var min: Int = 0
    var max: Int = 1000
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(min..<max, id: \.self) { int in
                        Text("\(int)")
                            .id(int)
                    }
                }
                .scrollTargetLayout()
                .onAppear {
                    proxy.scrollTo(50, anchor: .top)
                }
            }
        }
    }
}

#Preview {
    CalendarView()
        .environmentObject(HealthDataController())
}
