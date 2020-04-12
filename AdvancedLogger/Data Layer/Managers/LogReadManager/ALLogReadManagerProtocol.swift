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
    
    /// Получить лог файл в String формате
    /// - Parameters:
    ///   - isEncrypted: используется ли шифрование
    ///   - completion: completion блок 
    func getStringLogs(isEncrypted: Bool, completion: @escaping (String?) -> Void)
    /// Получить лог файл в Data формате
    /// - Parameters:
    ///   - isEncrypted: используется ли шифрование
    ///   - completion: completion блок
    func getDataLogs(isEncrypted: Bool, completion: @escaping (Data?) -> Void)
    /// update crypto keys for cryptomanager
    /// - Parameter keys: new keys
    mutating func update(cryptoKeys keys: ALAESCryptoInitModel) throws
}
