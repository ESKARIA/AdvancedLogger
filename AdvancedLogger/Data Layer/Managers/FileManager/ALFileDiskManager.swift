//
//  ALFileManager.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation
import ESFileManager

// MARK: - ALFileManager

/// Manager for write and read file from bundle
struct ALFileDiskManager {
    
    private var fileNameModel: ESFileNameModel
    private var fileManager: ESFileManagerProtocol
    
    init(directoryPath: String, fileName: String) {
        self.fileNameModel = ESFileNameModel(name: fileName, fileExtension: .txt)
        self.fileManager = ESFileManager(defaultDirectory: .applicationSupport(customPath: directoryPath, useBackups: false))
    }
    
}

// MARK: ALFileManagerProtocol Impletation

extension ALFileDiskManager: ALFileDiskManagerProtocol {
    
    /// write data to disk
    /// - Parameters:
    ///   - data: data that need to be writed
    ///   - completion: completion block with optional Error
    func write(data: Data, completion: @escaping (Error?) -> Void) {
        let file = ESFileModel(data: data, name: self.fileNameModel)
        self.fileManager.write(file: file, at: nil) { (error) in
            completion(error)
            return
        }
        
    }
    
    /// Read data from disk
    /// - Parameter completion: completion block with optional data from storage
    func read(completion: @escaping (Data?, Error?) -> Void) {
        self.fileManager.read(fileStorage: self.fileNameModel, at: nil) { (fileModel, error) in
            completion(fileModel?.data, error)
        }
    }
    
    /// Remove log file from disk
    /// - Parameter completion: completion block with optional Error
    func clean(completion: @escaping (Error?) -> Void) {
        self.fileManager.remove(file: self.fileNameModel, at: nil) { (error) in
            completion(error)
        }
        
    }
}
