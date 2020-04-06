//
//  ALFilePopulateManager.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - FilePopulateManager

/// Manager for create data file that will be writed on disk
struct ALFilePopulateManager {
    
    private var diskManager: ALFileDiskManagerProtocol
    
    init(diskManager: ALFileDiskManagerProtocol) {
        self.diskManager = diskManager
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
    
    /// get current date with needed format
    /// - Returns: date
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constaints.logDateFormat.rawValue
        return dateFormatter.string(from: Date())
    }
    
    /// Add debug data
    /// - Parameter log: string with your log
    /// - Returns: return result log
    private func addDebugData(to log: String) -> String {
        "\(self.getCurrentDate()) \(log)"
    }
}

// MARK: - FilePopulateManagerProtocol

extension ALFilePopulateManager: ALFilePopulateManagerProtocol {
    
    /// Add new log to file
    /// - Parameter log: string with event's description
    func addNew(log: String) {
        
        let _log = self.addDebugData(to: log)
        var data = Data()
        self.diskManager.read { (returnData) in
            if let _data = returnData {
                data = _data
            }
        }
        if let newLog = _log.data(using: .utf8) {
            data += newLog
        }
        
        self.diskManager.write(data: data) { (error) in
            
        }
    }
}
