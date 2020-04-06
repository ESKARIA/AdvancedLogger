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
    
}
