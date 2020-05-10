//
//  ALFilePopulateManager.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation
import ESCrypto

// MARK: - FilePopulateManager

/// Manager for create data file that will be writed on disk
struct ALFilePopulateManager {
    
    private var cryptoManager: ESCryptoProtocol
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(cryptoManager: ESCryptoProtocol) {
        self.cryptoManager = cryptoManager
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
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
    private func addDebugData(to log: String, logType: AdvancedLoggerEvent) -> AdvancedLoggerModel {
        
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
        return AdvancedLoggerModel(time: self.getCurrentDate(), log: "\(emoji) Log: \(log)", type: logType)
    }
    
    /// check data size
    /// - Parameters:
    ///   - data: exist data in storage
    ///   - size: max size
    /// - Returns: result data
    private func prepareSize(data: Data, size: Int) -> [AdvancedLoggerModel] {
        var resultModel = [AdvancedLoggerModel]()
        if data.count <= size {
            do {
                return try self.decoder.decode([AdvancedLoggerModel].self, from: data)
            } catch {
                return resultModel
            }
        } else {
            var resultData = data
            while resultData.count > size {
                do {
                    var logs = try self.decoder.decode([AdvancedLoggerModel].self, from: resultData)
                    logs.removeFirst()
                    resultModel = logs
                    resultData = try self.encoder.encode(resultModel)
                } catch {
                    return resultModel
                }
            }
            return resultModel
        }
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
        
        var resultModel = [AdvancedLoggerModel]()
        
        //if there are exist data get this
        if let _data = existData {
            var _existData: Data?
            switch isUsedEncryption {
            case true:
                self.cryptoManager.decrypt(data: _data, cryptoType: .aes) { (__data, error) in
                    _existData = __data
                }
            case false:
                _existData = _data
            }
            
            if let __existData = _existData {
                resultModel.append(contentsOf: self.prepareSize(data: __existData, size: maxSizeData))
            }
        }
        
        do {
            resultModel.append(_log)
            var resultData = try self.encoder.encode(resultModel)
            if isUsedEncryption {
                self.cryptoManager.encrypt(data: resultData, cryptoType: .aes) { (data, error) in
                    if let error = error {
                        completion(nil, .encryptError(error: error))
                        return
                    }
                    guard let _data = data else {
                        completion(nil, .encryptError(error: .emptyData))
                        return
                    }
                    resultData = _data
                }
            }
            completion(resultData, nil)
            return
        } catch {
            completion(nil, .errorWithEncode)
        }
    }
    
    /// update crypto keys for cryptomanager
    /// - Parameter keys: new keys
    mutating func update(cryptoKeys keys: ALAESCryptoInitModel) throws {
        self.cryptoManager.cryptoKeys = .init(aesCryptoKeys: ESAESCryptoKeysModel(aesCryptoKey: keys.cryptoKey,
                                                                                  aesInitialVector: keys.initialVector))
    }
}

