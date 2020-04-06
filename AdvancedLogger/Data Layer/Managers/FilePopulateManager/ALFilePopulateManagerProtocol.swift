//
//  ALFilePopulateManagerProtocol.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - ALFilePopulateManagerProtocol

/// Protocol for create data file that will be writed on disk
protocol ALFilePopulateManagerProtocol {
    
    /// Add new log to file
    /// - Parameter log: string with event's description
    /// - Parameter existData: exist data in log file
    /// - Parameter isUsedEncryption: do you use encryption for logs
    /// - Parameter logType: log type for format in file
    /// - Parameter completion: completion with result optional data and optional error
    func populate(log: String,
                  existData: Data?,
                  isUsedEncryption: Bool,
                  logType: AdvancedLoggerEvent,
                  completion: @escaping (Data?, ALFilePopulateManagerErrors?) -> Void)
}
