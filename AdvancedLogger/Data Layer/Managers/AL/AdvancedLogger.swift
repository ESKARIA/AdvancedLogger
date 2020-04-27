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
    static public var shared: AdvancedLoggerProtocol = AdvancedLogger()
    /// Do you need encrypt data?
    public var encryptData = false
    /// log file size. Default is 4096
    public var logFileSize = 4096
    /// AES 128 Crypto key for encrypt\decrypt your logs
    public var aesCryptoKeys = ALAESCryptoInitModel(cryptoKey: Constaints.Crypto.cryptoKey.rawValue,
                                                    initialVector: Constaints.Crypto.cryptoInitialVector.rawValue) {
        didSet {
            self.updateCryptoKeys()
        }
    }
    
    //private
    private var diresolver: ALDIResolverComponentsProtocol = ALDIResolver()
    private var writeManager: ALLogWriteManagerProtocol
    private var readManager: ALLogReadManagerProtocol
    private var queue: DispatchQueue!
    
    private mutating func updateCryptoKeys() {
        do {
            try self.writeManager.update(cryptoKeys: self.aesCryptoKeys)
            try self.readManager.update(cryptoKeys: self.aesCryptoKeys)
        } catch {
            let _error = error as? ALCryptoManagerError
            NSLog("Advanced Logger update crypto keys error: \(String(describing: _error?.errorDescription))")
        }
    }
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
                                     maxSize: self.logFileSize,
                                     logType: type)
        }
    }
    
    /// Get logs in string format
    /// - Parameter completion: completion with string logs
    public func getLogs(completion: @escaping ([AdvancedLoggerModel]?) -> Void) {
        self.queue.async {
            self.readManager.getLogs(isEncrypted: self.encryptData, completion: completion)
        }
    }
    
    /// Get logs in data format
    /// - Parameter completion: completion with data logs
    public func getJSONDataLogs(completion: @escaping (Data?) -> Void) {
        self.queue.async {
            self.readManager.getJSONLogs(isEncrypted: self.encryptData, completion: completion)
        }
    }
    
    /// Clean all logs
    public func cleanLogs() {
        self.queue.async {
            self.writeManager.cleanAll()
        }
    }
}
