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
    
    private var cryptoManager: ALCryptoManagerProtocol
    
    init(cryptoManager: ALCryptoManagerProtocol) {
        self.cryptoManager = cryptoManager
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
    private func addDebugData(to log: String, logType: AdvancedLoggerEvent) -> String {
        var emoji = "🖥"
        switch logType {
        case .warning:
            emoji = "⚠️"
        case .error:
            emoji = "🛑"
        case .crash:
            emoji = "⛔️"
        case .success:
            emoji = "✅"
        case .execution:
            emoji = "➡️"
        }
        return "\(emoji) Time: \(self.getCurrentDate()) Description: \(log) \n"
    }
}

// MARK: - FilePopulateManagerProtocol

extension ALFilePopulateManager: ALFilePopulateManagerProtocol {
    
    /// Add new log to file
    /// - Parameter log: string with event's description
    /// - Parameter existData: exist data in log file
    /// - Parameter isUsedEncryption: do you use encryption for logs
    /// - Parameter logType: log type for format in file
    /// - Parameter maxSizeData: max size of log file
    /// - Parameter completion: completion with result optional data and optional error
    func populate(log: String,
                  existData: Data?,
                  isUsedEncryption: Bool,
                  logType: AdvancedLoggerEvent,
                  maxSizeData: Int,
                  completion: (Data?, ALFilePopulateManagerErrors?) -> Void) {
        
        let _log = self.addDebugData(to: log, logType: logType)
        var data = Data()
        
        if let _data = existData {
            if _data.count > maxSizeData {
                var string = ""
                switch isUsedEncryption {
                case true:
                    self.cryptoManager.decrypt(data: data) { (decryptData, error) in
                        string = decryptData ?? ""
                    }
                case false:
                    string = String(data: _data, encoding: .utf8) ?? ""
                }
                var token = string.components(separatedBy: "\n")
                // TODO: remake to data size instead string size
                while string.data(using: .utf8)?.count ?? 0 > maxSizeData {
                    token.removeFirst()
                    string = token.joined()
                }
                var needSizeData: Data? = Data()
                switch isUsedEncryption {
                case true:
                    self.cryptoManager.encrypt(string: string) { (data, error) in
                        needSizeData = data
                    }
                case false:
                    needSizeData = string.data(using: .utf8)
                }
                if let __data = needSizeData {
                    data += __data
                }
            } else {
                data += _data
            }
        }
        if isUsedEncryption {
            self.cryptoManager.encrypt(string: _log) { (encryptedData, error) in
                if let encryptedData = encryptedData {
                    data += encryptedData
                } else if let error = error {
                    completion(nil, .encryptError(error: error))
                    return
                }
            }
        } else if let newLog = _log.data(using: .utf8) {
            data += newLog
        }
        completion(data, nil)
    }
}

