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
    
}

// MARK: - AdvancedLoggerProtocol

extension AdvancedLogger: AdvancedLoggerProtocol {
    
    /// Add new log to log file
    /// - Parameters:
    ///   - log: description log
    ///   - type: log type for view format in logfile
    public func addNew(log: String, type: AdvancedLoggerEvent) {
        self.writeManager.addNew(log: log,
                                 isUsedEncryption: self.encryptData,
                                 logType: type)
    }
}
