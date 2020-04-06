//
//  ALEncryptionManagerProtocol.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Protocol for encrypting and decrypting data
protocol ALEncryptionManagerProtocol {
    
    /// Encrypt string with default key
    /// - Parameter string: encrypted data
    /// - Parameter completion: completion with optional data and optional error
    mutating func encrypt(string: String, completion: @escaping (Data?, ALEncryptionManagerErrors?) -> Void)
    /// decrypt data with default key
    /// - Parameter data: optional string
    /// - Parameter completion: completion with decrypted optional string and optional error
    mutating func decrypt(data: Data?, completion: @escaping (String?, ALEncryptionManagerErrors?) -> Void)
}
