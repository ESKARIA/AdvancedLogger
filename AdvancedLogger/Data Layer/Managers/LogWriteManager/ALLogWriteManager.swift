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
    
    /// Return saved file size. Need to replace old data and keep user storage clean
    /// - Returns: file size
    private func getSizeFile() -> Int {
        var result = 0
        self.diskManager.read { data in
            if let data = data {
                result = data.count
            }
        }
        return result
    }
    
    private func writeOnDisk(data: Data?) {
        guard let _data = data else {
            return
        }
        self.diskManager.write(data: _data) { (error) in
            // fetch disk error
        }
    }
}

// MARK: - ALLogWriteManagerProtocol

extension ALLogWriteManager: ALLogWriteManagerProtocol {
    func addNew(log: String,
                isEncrypted: Bool,
                logType: AdvancedLoggerEvent) {
        self.queue.sync {
            self.diskManager.read { (data) in
                    self.populateManager.populate(log: log,
                                                  existData: data,
                                                  isUsedEncryption: isEncrypted,
                                                  logType: logType) { (data, error) in
                                                    if error == nil, data != nil {
                                                        self.writeOnDisk(data: data)
                                                    } else {
                                                        // fetch populate error
                                                    }
                    }
                }
        }
    }
    
    func cleanAll() {
        self.queue.sync {
            self.diskManager.clean { (error) in
                   
            }
        }
    }
}
