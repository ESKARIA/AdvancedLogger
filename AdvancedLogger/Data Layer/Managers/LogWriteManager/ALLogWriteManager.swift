//
//  ALLogWriteManager.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - ALLogWriteManager

/// manager that get log from user, encrypt this if needed and write on disk
struct ALLogWriteManager {
    
    private var diskManager: ALFileDiskManagerProtocol
    private var populateManager: ALFilePopulateManagerProtocol
    private var queue: DispatchQueue
    
    init(diskManager: ALFileDiskManagerProtocol,
         populateManager: ALFilePopulateManagerProtocol,
         queueLabel: String,
         qos: DispatchQoS) {
        self.diskManager = diskManager
        self.populateManager = populateManager
        self.queue = DispatchQueue(label: queueLabel, qos: qos)
    }
    
    /// Запись файла на диск
    /// - Parameter data: data для записи
    private func writeOnDisk(data: Data?) {
        guard let _data = data else {
            return
        }
        self.diskManager.write(data: _data) { (error) in
            if let error = error {
                NSLog("AdvancedLogger error while while write: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - ALLogWriteManagerProtocol

extension ALLogWriteManager: ALLogWriteManagerProtocol {
    
    /// Add new log to file
    /// - Parameter log: string with event's description
    /// - Parameter isEncrypted: do you use crypto in log file
    /// - Parameter maxSize: max size of log file
    /// - Parameter logType: log type for format in file
    func addNew(log: String,
                isEncrypted: Bool,
                maxSize: Int,
                logType: AdvancedLoggerEvent) {
        self.queue.sync {
            self.diskManager.read { (data, error) in
                self.populateManager.populate(log: log,
                                              existData: data,
                                              isUsedEncryption: isEncrypted,
                                              logType: logType,
                                              maxSizeData: maxSize) { (data, error) in
                                                if error == nil, data != nil {
                                                    self.writeOnDisk(data: data)
                                                } else {
                                                    NSLog("AdvancedLogger error while populate: \(error.debugDescription)")
                                                }
                }
            }
        }
    }
    
    /// Очистить файлов логов
    func cleanAll() {
        self.queue.sync {
            self.diskManager.clean { (error) in
                NSLog("AdvancedLogger error while clean: \(error.debugDescription)")
            }
        }
    }
    
    /// update crypto keys for cryptomanager
    /// - Parameter keys: new keys
    mutating func update(cryptoKeys keys: ALAESCryptoInitModel) throws {
        try self.populateManager.update(cryptoKeys: keys)
    }
}
