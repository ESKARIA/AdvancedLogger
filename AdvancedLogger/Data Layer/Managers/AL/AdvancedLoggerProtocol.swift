//
//  AdvancedLoggerProtocol.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Main protocol requeriment for interact with your app
public protocol AdvancedLoggerProtocol {
    
    /// Do you need encrypt data?
    var encryptData: Bool { get set }
    /// set log's file size in byte. Default is 4096
    var logFileSize: Int { get set}
    /// Add new log to log file
    /// - Parameters:
    ///   - log: description log
    ///   - type: log type for view format in logfile
    func addNew(log: String, type: AdvancedLoggerEvent)
    /// Get logs in string format
    /// - Parameter completion: completion with string logs
    func getStringLogs(completion: @escaping (String?) -> Void)
    /// Clean all logs
    func cleanLogs()
}
