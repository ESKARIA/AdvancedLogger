//
//  ALLogWriteManagerProtocol.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Protocol for manager that get log from user, encrypt this if needed and write on disk
protocol ALLogWriteManagerProtocol {
    
    /// Add new log to file
    /// - Parameter log: string with event's description
    /// - Parameter existData: exist data in log file
    /// - Parameter isUsedEncryption: do you use encryption for logs
    /// - Parameter logType: log type for format in file
    /// - Parameter completion: completion with result optional data and optional error
    func addNew(log: String,
                isEncrypted: Bool,
                logType: AdvancedLoggerEvent)
    /// Clean all logs
    func cleanAll()
}
