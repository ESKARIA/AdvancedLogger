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
    /// - Parameter isEncrypted: do you use crypto in log file
    /// - Parameter maxSize: max size of log file
    /// - Parameter logType: log type for format in file
    func addNew(log: String,
                isEncrypted: Bool,
                maxSize: Int,
                logType: AdvancedLoggerEvent)
    /// Clean all logs
    func cleanAll()
}
