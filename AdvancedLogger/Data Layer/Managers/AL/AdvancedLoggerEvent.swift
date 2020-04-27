//
//  AdvancedLoggerEvent.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Log type for write.
public enum AdvancedLoggerEvent {
    
    case warning
    case error
    case crash
    case success
    case execution
}

extension AdvancedLoggerEvent: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .warning
        case 1:
            self = .error
        case 2:
            self = .crash
        case 3:
            self = .success
        case 4:
            self = .execution
        default:
            throw CodingError.unknownValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .warning:
            try container.encode(0, forKey: .rawValue)
        case .error:
            try container.encode(1, forKey: .rawValue)
        case .crash:
            try container.encode(2, forKey: .rawValue)
        case .success:
            try container.encode(3, forKey: .rawValue)
        case .execution:
            try container.encode(4, forKey: .rawValue)
        }
    }
    
    
}
