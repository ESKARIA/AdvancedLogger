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
}

/// DIResolver for components
struct ALDIResolver {
    
    private var alFileManager: ALFileDiskManagerProtocol?
    private var alPopulateManager: ALFilePopulateManagerProtocol?
}

extension ALDIResolver: ALDIResolverComponentsProtocol {
    
    /// File manager for read and write data on disk
    /// - Returns: return struct ALFileManagerProtocol
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
    /// - Returns: manager
    mutating func getALPopulateManager() -> ALFilePopulateManagerProtocol {
        if let _alFilePopulateManager = self.alPopulateManager {
            return _alFilePopulateManager
        }
        self.alPopulateManager = ALFilePopulateManager(diskManager: self.getALFileManager())
        return self.alPopulateManager!
    }
}
