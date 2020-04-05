//
//  ALFileManager.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - ALFileManager

/// Manager for write and read file from bundle
struct ALFileDiskManager {
    
    private var queue: DispatchQueue!
    private var directoryPath: String
    
    init(queueLabel: String, qos: DispatchQoS, directoryPath: String) {
        self.queue = DispatchQueue(label: queueLabel, qos: qos)
        self.directoryPath = directoryPath
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(self.directoryPath)
    }
}

// MARK: ALFileManagerProtocol Impletation

extension ALFileDiskManager: ALFileDiskManagerProtocol {
    
    /// write data to disk
    /// - Parameters:
    ///   - data: data that need to be writed
    ///   - completion: completion block with optional Error
    func write(data: Data, completion: @escaping (Error?) -> Void) {
        queue.async {
            do {
                try data.write(to: self.getDocumentsDirectory())
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    /// Read data from disk
    /// - Parameter completion: completion block with optional data from storage
    func read(completion: @escaping (Data?) -> Void) {
        queue.async {
            completion(FileManager.default.contents(atPath: self.getDocumentsDirectory().path))
        }
    }
    
    /// Remove log file from disk
    /// - Parameter completion: completion block with optional Error
    func clean(completion: @escaping (Error?) -> Void) {
        queue.async {
            do {
                try FileManager().removeItem(at: self.getDocumentsDirectory())
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
