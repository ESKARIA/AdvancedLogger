//
//  ALEncryptionManager.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation
import CommonCrypto

// MARK: - ALEncryptionManager

/// Manager for encrypting and decrypting data
struct ALEncryptionManager {
    
    private let initKey: String
    private let initIV: String
    private var key: Data!
    private var iv: Data!
    private var queue: DispatchQueue!
    
    init?(key: String, iv: String, queueLabel: String, qos: DispatchQoS) {
        self.initKey = key
        self.initIV  = iv
        self.queue = DispatchQueue(label: queueLabel, qos: qos)
    }
    
    private mutating func checkCryptoKeys(completion: @escaping (ALEncryptionManagerErrors?) -> Void) {
        guard initKey.count == kCCKeySizeAES128 || initKey.count == kCCKeySizeAES256, let keyData = initKey.data(using: .utf8) else {
            completion(.wrongKey)
            return
        }
        
        guard initIV.count == kCCBlockSizeAES128, let ivData = initIV.data(using: .utf8) else {
            completion(.wrongInitalVector)
            return
        }
        self.key = keyData
        self.iv = ivData
    }
    
    private mutating func crypt(data: Data?, option: CCOperation, completion: @escaping (Data?, ALEncryptionManagerErrors?) -> Void) {
        
        self.checkCryptoKeys { (error) in
            completion(nil, error)
            return
        }
        
        self.queue.async { [self] in
            
            guard let data = data else {
                completion(nil, .emptyData)
                return
            }
            
            let cryptLength = data.count + kCCBlockSizeAES128
            var cryptData   = Data(count: cryptLength)
            
            let keyLength = self.key.count
            let options   = CCOptions(kCCOptionPKCS7Padding)
            
            var bytesLength = Int(0)
            
            let status = cryptData.withUnsafeMutableBytes { cryptBytes in
                data.withUnsafeBytes { dataBytes in
                    self.iv.withUnsafeBytes { ivBytes in
                        self.key.withUnsafeBytes { keyBytes in
                            CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                        }
                    }
                }
            }
            
            guard UInt32(status) == UInt32(kCCSuccess) else {
                completion(nil, .failedCryptData(status: status.description))
                return
            }
            
            cryptData.removeSubrange(bytesLength..<cryptData.count)
            completion(cryptData, nil)
        }
    }
}

// MARK: - ALEncryptionManagerProtocol

extension ALEncryptionManager: ALEncryptionManagerProtocol {
    
    /// encrypt data with key
    /// - Parameter string: string to crypt
    /// - Parameter completion: completion with optional data and optional error
    mutating func encrypt(string: String, completion: @escaping (Data?, ALEncryptionManagerErrors?) -> Void) {
        self.crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt), completion: {data, error in
            completion(data, error)
        })
    }
    
    /// decrypt data with default key
    /// - Parameter data: data to decrypt
    /// - Parameter completion: completion with decrypted optional string and optional error
    mutating func decrypt(data: Data?, completion: @escaping (String?, ALEncryptionManagerErrors?) -> Void) {
        self.crypt(data: data, option: CCOperation(kCCDecrypt), completion: { decryptData, error in
            if let _resultData = decryptData {
                let resultData = String(bytes: _resultData, encoding: .utf8)
                completion(resultData, error)
                return
            }
            completion(nil, error)
        })
        
    }
}
