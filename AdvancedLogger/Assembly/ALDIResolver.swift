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
}

/// DIResolver for components
struct ALDIResolver {
    
    private var alFileManager: ALFileDiskManagerProtocol?
}

extension ALDIResolver: ALDIResolverComponentsProtocol {
    
    /// File manager for read and write data on disk
    /// - Returns: return struct ALFileManagerProtocol
    mutating func getALFileManager() -> ALFileDiskManagerProtocol {
        if let _alFileManager = self.alFileManager {
            return _alFileManager
        }
        self.alFileManager = ALFileDiskManager(queueLabel: Constaints.queueDiskOperationName.rawValue,
                                               qos: .background,
                                               directoryPath: Constaints.documentDirectoryPath.rawValue)
        return self.alFileManager!
    }
}
