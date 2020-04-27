//
//  ALLogReadManager.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - ALLogReadManager

/// manager that get log from disk, decrypt it if needed and return
struct ALLogReadManager {
    
    private var diskManager: ALFileDiskManagerProtocol
    private var cryptoManager: ALCryptoManagerProtocol
    private var queue: DispatchQueue
    private let decoder: JSONDecoder
    
    init(diskManager: ALFileDiskManagerProtocol,
         cryptoManager: ALCryptoManagerProtocol,
         queueLabel: String,
         qos: DispatchQoS) {
        self.diskManager = diskManager
        self.cryptoManager = cryptoManager
        self.queue = DispatchQueue(label: queueLabel, qos: qos)
        self.decoder = JSONDecoder()
    }
}

// MARK: - ALLogReadManagerProtocol

extension ALLogReadManager: ALLogReadManagerProtocol {
    
    /// Получить лог файл в String формате
    /// - Parameters:
    ///   - isEncrypted: используется ли шифрование
    ///   - completion: completion блок
    func getLogs(isEncrypted: Bool, completion: @escaping ([AdvancedLoggerModel]?) -> Void) {
        self.queue.sync {
            self.diskManager.read { (data) in
                if let data = data {
                    
                    var resultData = Data()
                    
                    switch isEncrypted {
                    case true:
                        self.cryptoManager.decrypt(data: data) { (log, error) in
                            if let error = error {
                                NSLog("AdvancedLogger error while get string log: \(error.errorDescription)")
                                return
                            }
                            resultData = log ?? Data()
                        }
                    case false:
                        resultData = data
                    }
                    do {
                        let resultLogs = try decoder.decode([AdvancedLoggerModel].self, from: resultData)
                        completion(resultLogs)
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    /// Получить лог файл в Data формате
    /// - Parameters:
    ///   - isEncrypted: используется ли шифрование
    ///   - completion: completion блок
    func getJSONLogs(isEncrypted: Bool, completion: @escaping (Data?) -> Void) {
        self.queue.sync {
            self.diskManager.read { (data) in
                if let data = data {
                    var resultData: Data?
                    switch isEncrypted {
                    case true:
                        self.cryptoManager.decrypt(data: data) { (log, error) in
                            if let error = error {
                                NSLog("AdvancedLogger error while get string log: \(error.errorDescription)")
                                return
                            }
                            resultData = log
                        }
                    case false:
                        resultData = data
                    }
                    completion(resultData)
                }
            }
        }
    }
    
    /// update crypto keys for cryptomanager
    /// - Parameter keys: new keys
    mutating func update(cryptoKeys keys: ALAESCryptoInitModel) throws {
        try self.cryptoManager.update(cryptoKeys: keys)
    }
}
