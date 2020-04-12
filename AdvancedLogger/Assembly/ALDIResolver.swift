//
//  ALDIResolver.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

protocol ALDIResolverComponentsProtocol {
    
    /// File manager for read and write data on disk
    /// - Returns: return struct ALFileManagerProtocol
    mutating func getALFileManager() -> ALFileDiskManagerProtocol
    /// Logger create and populate file with log
    /// - Parameter keys: crypto key and initial vector
    mutating func getALPopulateManager() -> ALFilePopulateManagerProtocol
    /// Logger crypto manager for encrypt and decrypt data
    /// - Parameters:
    ///   - keys: crypto key and initial vector
    mutating func getALCryptoManager() -> ALCryptoManagerProtocol
    /// Logger write manager for write logs
    /// - Parameter cryptoKeys: crypto key and initial vector for encrypt and decrypt logs
    mutating func getALLogWriteManager() -> ALLogWriteManagerProtocol
    /// Logger read manager for get logs file (or logs)
    /// - Parameter cryptoKeys: crypto key and initial vector for encrypt and decrypt logs
    mutating func getALLogReadManager() -> ALLogReadManagerProtocol
}

/// DIResolver for components
struct ALDIResolver {
    
    private var alLogWriteManager: ALLogWriteManagerProtocol?
    private var alLogReadManager: ALLogReadManagerProtocol?
    private var alFileManager: ALFileDiskManagerProtocol?
    private var alPopulateManager: ALFilePopulateManagerProtocol?
    private var alCryptoManager: ALCryptoManagerProtocol?
}

extension ALDIResolver: ALDIResolverComponentsProtocol {
    
    /// File manager for read and write data on disk
    /// - Returns: disk manager
    mutating func getALFileManager() -> ALFileDiskManagerProtocol {
        if let _alFileManager = self.alFileManager {
            return _alFileManager
        }
        self.alFileManager = ALFileDiskManager(directoryPath: Constaints.documentDirectoryPath.rawValue)
        return self.alFileManager!
    }
    
    /// Logger create and populate file with log
    /// - Returns: populatte manager
    mutating func getALPopulateManager() -> ALFilePopulateManagerProtocol {
        if let _alFilePopulateManager = self.alPopulateManager {
            return _alFilePopulateManager
        }
        self.alPopulateManager = ALFilePopulateManager(cryptoManager: self.getALCryptoManager())
        return self.alPopulateManager!
    }
    
    /// Logger crypto manager for encrypt and decrypt dsata
    /// - Returns: crypto manager
    mutating func getALCryptoManager() -> ALCryptoManagerProtocol {
        if let _alCryptoManager = self.alCryptoManager {
            return _alCryptoManager
        }
        self.alCryptoManager = ALCryptoManager(initKey: Constaints.Crypto.cryptoKey.rawValue,
                                               initIV: Constaints.Crypto.cryptoInitialVector.rawValue)
        return self.alCryptoManager!
    }
    
    /// get manager for write log on disk
    /// - Returns: write manager
    mutating func getALLogWriteManager() -> ALLogWriteManagerProtocol {
        if let _alLogWriteManager = self.alLogWriteManager {
            return _alLogWriteManager
        }
        self.alLogWriteManager = ALLogWriteManager(diskManager: self.getALFileManager(),
                                                   populateManager: self.getALPopulateManager(),
                                                   queueLabel: Constaints.Queue.queueDiskOperationName.rawValue,
                                                   qos: .utility)
        return self.alLogWriteManager!
    }
    
    /// get manager for read log from disk
    /// - Returns: read manager
    mutating func getALLogReadManager() -> ALLogReadManagerProtocol {
        if let _alLogReadManager = self.alLogReadManager {
            return _alLogReadManager
        }
        self.alLogReadManager = ALLogReadManager(diskManager: self.getALFileManager(),
                                                 cryptoManager: self.getALCryptoManager(),
                                                 queueLabel: Constaints.Queue.queueDiskOperationName.rawValue,
                                                 qos: .utility)
        return self.alLogReadManager!
    }
}
