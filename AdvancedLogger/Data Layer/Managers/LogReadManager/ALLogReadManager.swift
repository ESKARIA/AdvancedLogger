//
//  ALLogReadManager.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - ALLogReadManager

/// manager that get log from disk, decrypt it if needed and return
struct ALLogReadManager {
    
    private var diskManager: ALFileDiskManagerProtocol
    private var cryptoManager: ALCryptoManagerProtocol
    private var queue: DispatchQueue
    
    init(diskManager: ALFileDiskManagerProtocol,
         cryptoManager: ALCryptoManagerProtocol,
         queueLabel: String,
         qos: DispatchQoS) {
        self.diskManager = diskManager
        self.cryptoManager = cryptoManager
        self.queue = DispatchQueue(label: queueLabel, qos: qos)
    }
}

// MARK: - ALLogReadManagerProtocol

extension ALLogReadManager: ALLogReadManagerProtocol {
    func getStringLogs(isEncrypted: Bool, completion: @escaping (String?) -> Void) {
        self.queue.sync {
            self.diskManager.read { (data) in
                if let data = data {
                    if isEncrypted {
                        self.cryptoManager.decrypt(data: data) { (log, error) in
                            completion(log)
                        }
                    } else {
                        let log = String(data: data, encoding: .utf8)
                        completion(log)
                    }
                }
            }
        }
    }
}
