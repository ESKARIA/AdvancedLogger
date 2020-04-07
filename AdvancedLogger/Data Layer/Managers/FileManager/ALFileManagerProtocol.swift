//
//  ALFileManagerProtocol.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - ALFileManagerProtocol

/// Protocol for Manager for write and read file from bundle
protocol ALFileDiskManagerProtocol {
    
    /// write data to disk
    /// - Parameters:
    ///   - data: data that need to be writed
    ///   - completion: completion block with optional Error
    func write(data: Data, completion: (Error?) -> Void)
    /// Read data from disk
    /// - Parameter completion: completion block with optional data from storage
    func read(completion: (Data?) -> Void)
    /// Remove log file from disk
    /// - Parameter completion: completion block with optional Error
    func clean(completion: (Error?) -> Void)
}
