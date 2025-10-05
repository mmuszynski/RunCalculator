//
//  MyModelObject.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 9/29/25 from the following:
//  https://developer.apple.com/documentation/swiftui/navigationpath

import SwiftUI

extension String {
    static let navigationPathKey = "com.mmuszynski.runCalculator.navigationPathKey"
}

class NavigationPathObject: ObservableObject {
    @Published var path: NavigationPath

    static func readSerializedData() -> Data? {
        // Read data representing the path from app's persistent storage.
        UserDefaults.standard.data(forKey: .navigationPathKey)
    }


    static func writeSerializedData(_ data: Data) {
        // Write data representing the path to app's persistent storage.
        UserDefaults.standard.set(data, forKey: .navigationPathKey)
    }

    init() {
        if let data = Self.readSerializedData() {
            do {
                let representation = try JSONDecoder().decode(
                    NavigationPath.CodableRepresentation.self,
                    from: data)
                self.path = NavigationPath(representation)
            } catch {
                self.path = NavigationPath()
            }
        } else {
            self.path = NavigationPath()
        }
    }


    func save() {
        guard let representation = path.codable else { return }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(representation)
            Self.writeSerializedData(data)
        } catch {
            // Handle error.
        }
    }
}
