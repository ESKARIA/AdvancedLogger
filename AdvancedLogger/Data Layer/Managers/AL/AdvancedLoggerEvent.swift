//
//  AdvancedLoggerEvent.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Log type for write. Containt different event like warning\crash\etc
public enum AdvancedLoggerEvent {
    
    /// If you get warning use this event
    case warning
    /// if you get error (non fatal) use this case
    case error
    /// if your app crash use this
    case crash
    /// if you collect logs of any func and func successed use this one
    case success
    /// just event for logs any execution (in run state) logs from app
    case execution
}

extension AdvancedLoggerEvent: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    ///  !Dont use this! Public init for encode\decode.
    /// - Parameter decoder: decoder
    /// - Throws: error throw
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
    
    ///  !Dont use this! Encode to encoder
    /// - Parameter encoder: encoder
    /// - Throws: throw
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
