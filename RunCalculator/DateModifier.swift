//
//  DebugMenu.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 8/5/23.
//

import Foundation
import SwiftUI
import OSLog

fileprivate var logger = Logger(category: "DateDebug")

struct DateModification: CustomStringConvertible {
    var component: DateComponents
    var amount: Int
    
    var description: String {
        [String(describing: amount), String(describing: component)].joined(separator: " ")
    }
}

class DateModificationController: ObservableObject {
    var dateModificiation: DateComponents = DateComponents()
    
    func updateDateGenerator() {
        DateGenerator.currentDateGenerator = {
            if let date = Calendar.current.date(byAdding: self.dateModificiation, to: .now) {
                return date
            } else {
                logger.debug("Couldn't get date using modification: \(self.dateModificiation)")
            }
            return .now
        }
    }
    
    func increase(_ component: Calendar.Component, by amount: Int) {
        switch component {
        case .day:
            dateModificiation.day = dateModificiation.day ?? 0 + amount
        case .hour:
            dateModificiation.hour = (dateModificiation.hour ?? 0) + amount
        case .minute:
            dateModificiation.minute = (dateModificiation.minute ?? 0) + amount
        case .second:
            dateModificiation.second = (dateModificiation.second ?? 0) + amount
        default:
            break
        }
        
        updateDateGenerator()
        objectWillChange.send()
    }
}

let formatter = DateComponentsFormatter()


struct DateDebugView: View {
    @ObservedObject var controller = DateModificationController()
    
    var body: some View {
        VStack {
            DateDebugControl(component: .hour)
            DateDebugControl(component: .minute)
            DateDebugControl(component: .second)

            Text("System Date")
            Text(Date(), format: .dateTime)
            Text("Adjusted Date")
            Text(Date.current, format: .dateTime)
            Text("Difference")
            Text(Date() <= .current ? Date()..<Date.current : Date.current..<Date(), format: .timeDuration)
            Text(String(describing: controller.dateModificiation))
        }
        .environmentObject(controller)
    }
}

struct DateDebugControl: View {
    @EnvironmentObject var controller: DateModificationController
    
    var component: Calendar.Component
    var amount: Int = 1
    
    var body: some View {
        HStack {
            Button(action: { controller.increase(component, by: -amount) }) {
                Image(systemName: "minus.circle.fill")
            }
            Text(
                String(describing: component).capitalized
            )
            Button(action: { controller.increase(component, by: amount) }) {
                Image(systemName: "plus.circle.fill")
            }
        }
    }
}

struct DateDebugViewPreview: PreviewProvider {
    static var previews: some View {
        DateDebugView()
            .environmentObject(DateModificationController())
    }
}
