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
    mutating func getALPopulateManager() -> ALFilePopulateManagerProtocol
    /// Logger crypto manager for encrypt and decrypt dsata
    mutating func getALCryptoManager() -> ALCryptoManagerProtocol
}

/// DIResolver for components
struct ALDIResolver {
    
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
        self.alFileManager = ALFileDiskManager(queueLabel: Constaints.Queue.queueDiskOperationName.rawValue,
                                               qos: .background,
                                               directoryPath: Constaints.documentDirectoryPath.rawValue)
        return self.alFileManager!
    }
    
    /// Logger create and populate file with log
    /// - Returns: populatte manager
    mutating func getALPopulateManager() -> ALFilePopulateManagerProtocol {
        if let _alFilePopulateManager = self.alPopulateManager {
            return _alFilePopulateManager
        }
        self.alPopulateManager = ALFilePopulateManager(diskManager: self.getALFileManager(),
                                                       cryptoManager: self.getALCryptoManager())
        return self.alPopulateManager!
    }
    
    /// Logger crypto manager for encrypt and decrypt dsata
    /// - Returns: crypto manager
    mutating func getALCryptoManager() -> ALCryptoManagerProtocol {
        if let _alCryptoManager = self.alCryptoManager {
            return _alCryptoManager
        }
        self.alCryptoManager = ALCryptoManager(key: Constaints.Crypto.cryptoKey.rawValue,
                                               iv: Constaints.Crypto.cryptoInitialVector.rawValue,
                                               queueLabel: Constaints.Queue.queueCryptoOperationName.rawValue,
                                               qos: .background)
        return self.alCryptoManager!
    }
}
