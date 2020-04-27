//
//  ALLogGetManagerProtocol.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Protocol for manager that get log from disk, decrypt it if needed and return
protocol ALLogReadManagerProtocol {
    
    /// Get logs in model AdvancedLoggerModel
    /// - Parameters:
    ///   - isEncrypted: do you use crypto?
    ///   - completion: completion block
    func getLogs(isEncrypted: Bool, completion: @escaping ([AdvancedLoggerModel]?) -> Void)
    /// Get log in JSON format
    /// - Parameters:
    ///   - isEncrypted: do you use crypto?
    ///   - completion: completion block
    func getJSONLogs(isEncrypted: Bool, completion: @escaping (Data?) -> Void)
    /// update crypto keys for cryptomanager
    /// - Parameter keys: new keys
    mutating func update(cryptoKeys keys: ALAESCryptoInitModel) throws
}
