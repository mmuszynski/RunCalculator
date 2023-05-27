/// This project is my attempt to wrap persistence information into a useable format
/// Basically, after the millionth time creating ApplicationSupport directories, I want something that is faster
///

import Foundation

extension URL {
    fileprivate func appending(_ path: String) -> URL {
        if #available(macOS 13.0, iOS 16.0, *) {
            return self.appending(path: path)
        } else {
            return self.appendingPathComponent(path)
        }
    }
}

public struct Persistence {
    public enum EncodingMethod {
        case json
        case plist
        case custom(_ method: (any Encodable) throws -> Data)
        
        func data(from object: any Encodable) throws -> Data {
            switch self {
            case .json:
                return try JSONEncoder().encode(object)
            case .plist:
                return try PropertyListEncoder().encode(object)
            case .custom(let method):
                return try method(object)
            }
        }
        
        func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
            switch self {
            case .json:
                return try JSONDecoder().decode(T.self, from: data)
            default:
                fatalError("Unimplemented")
            }
        }
    }
    
    public static func write(_ object: any Encodable, to location: Persistence.Location, withFilename filename: String = "", using method: EncodingMethod = .json) throws {
        let objectData = try method.data(from: object)
        let url = location.url.appending(filename)
        try objectData.write(to: url)
    }
    
    public static func read<T: Decodable>(_ type: T.Type, from location: Persistence.Location, withFilename filename: String = "", using method: EncodingMethod = .json) throws -> T {
        let objectData = try Data(contentsOf: location.url.appending(filename))
        let object = try method.decode(T.self, from: objectData)
        return object
    }
    
    public struct Location {
        public enum LocationError: Error {
            case noLocationNoCreate
            case unknownBundleIdentifier
        }
        
        public var url: URL
        
        public static var userApplicationSupport: Self {
            get throws {
                let url = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                return Self(url: url)
            }
        }
        
        public static func userApplicationSupport(appending path: String, createIfNeeded: Bool = true) throws -> Self {
            let fullURL: URL = try Self.userApplicationSupport.url.appending(path)
            try checkDirectory(at: fullURL, createIfNeeded: createIfNeeded)
            return Self(url: fullURL)
        }
        
        public static func bundleSpecificUserApplicationSupport(createIfNeeded: Bool = true) throws -> Self {
            guard let name = Bundle.main.bundleIdentifier else {
                throw LocationError.unknownBundleIdentifier
            }
            return try Self.userApplicationSupport(appending: name, createIfNeeded: createIfNeeded)
        }
        
        public func appending(pathComponent path: String, createIfNecessary: Bool = true) throws -> Self {
            let url = self.url.appendingPathComponent(path)
            try Self.checkDirectory(at: url, createIfNeeded: createIfNecessary)
            return Self(url: url)
        }
        
        private static func checkDirectory(at url: URL, createIfNeeded: Bool = true) throws {
            if !FileManager.default.fileExists(atPath: url.absoluteString) {
                if createIfNeeded == false {
                    throw LocationError.noLocationNoCreate
                }
                
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }
        }
        
    }
}

public extension Decodable {
    static func load(from location: Persistence.Location) throws -> Self {
        try Persistence.read(Self.self, from: location, withFilename: "")
    }
}
