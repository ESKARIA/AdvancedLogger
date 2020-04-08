//
//  ALEncryptionManagerProtocol.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Protocol for encrypting and decrypting data
protocol ALCryptoManagerProtocol {
    
    /// Encrypt string with default key
    /// - Parameter string: encrypted data
    /// - Parameter completion: completion with optional data and optional error
    func encrypt(string: String, completion: (Data?, ALCryptoManagerErrors?) -> Void)
    /// decrypt data with default key
    /// - Parameter data: optional string
    /// - Parameter completion: completion with decrypted optional string and optional error
    func decrypt(data: Data?, completion: (Data?, ALCryptoManagerErrors?) -> Void)
}
