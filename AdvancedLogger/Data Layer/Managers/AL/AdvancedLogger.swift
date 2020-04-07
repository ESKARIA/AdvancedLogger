//
//  AdvancedLogger.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - AdvancedLogger

/// Main struct for interact with your app
public struct AdvancedLogger {
    
    init() {
        self.writeManager = diresolver.getALLogWriteManager()
        self.readManager = diresolver.getALLogReadManager()
        self.queue = DispatchQueue(label: Constaints.Queue.queueAdvancedLogger.rawValue, qos: .utility)
    }
    
    //public
    /// Point for interact with singleton logger
    static public let shared: AdvancedLoggerProtocol = AdvancedLogger()
    /// Do you need encrypt data?
    public var encryptData = false
    /// log file size. Default is 4096
    public var logFileSize = 4096
    
    //private
    private var diresolver: ALDIResolverComponentsProtocol = ALDIResolver()
    private var writeManager: ALLogWriteManagerProtocol
    private var readManager: ALLogReadManagerProtocol
    private var queue: DispatchQueue!
    
}

// MARK: - AdvancedLoggerProtocol

extension AdvancedLogger: AdvancedLoggerProtocol {
    
    /// Add new log to log file
    /// - Parameters:
    ///   - log: description log
    ///   - type: log type for view format in logfile
    public func addNew(log: String, type: AdvancedLoggerEvent) {
        self.queue.async {
            self.writeManager.addNew(log: log,
                                     isEncrypted: self.encryptData,
                                     logType: type)
        }
    }
    
    /// Get logs in string format
    /// - Parameter completion: completion with string logs
    public func getStringLogs(completion: @escaping (String?) -> Void) {
        self.queue.async {
            self.readManager.getStringLogs(isEncrypted: self.encryptData) { (logs) in
                completion(logs)
            }
        }
    }
    
    /// Clean all logs
    public func cleanLogs() {
        self.queue.async {
            self.writeManager.cleanAll()
        }
    }
}
