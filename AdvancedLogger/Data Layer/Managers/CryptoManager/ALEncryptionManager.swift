//
//  ALEncryptionManager.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation
import CommonCrypto

// MARK: - ALCryptoManager

/// Manager for encrypting and decrypting data
struct ALCryptoManager {
    
    private var key: Data!
    private var iv: Data!
    
    init(initKey: String, initIV: String) {
        
        let keyData = initKey.data(using: .utf8)
        let ivData = initIV.data(using: .utf8)
        
        self.key = keyData
        self.iv = ivData
    }
    
    private func crypt(data: Data?, option: CCOperation, completion: (Data?, ALCryptoManagerError?) -> Void) {
        
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

// MARK: - ALCryptoManagerProtocol

extension ALCryptoManager: ALCryptoManagerProtocol {
    
    /// encrypt data with key
    /// - Parameter string: string to crypt
    /// - Parameter completion: completion with optional data and optional error
    func encrypt(data: Data, completion: (Data?, ALCryptoManagerError?) -> Void) {
        self.crypt(data: data, option: CCOperation(kCCEncrypt), completion: {data, error in
            completion(data, error)
        })
    }
    
    /// decrypt data with default key
    /// - Parameter data: data to decrypt
    /// - Parameter completion: completion with decrypted optional string and optional error
    func decrypt(data: Data?, completion: (Data?, ALCryptoManagerError?) -> Void) {
        self.crypt(data: data, option: CCOperation(kCCDecrypt), completion: { decryptData, error in
            completion(decryptData, error)
        })
        
    }
    
    /// update crypto keys for cryptomanager
    /// - Parameter keys: new keys
    mutating func update(cryptoKeys keys: ALAESCryptoInitModel) throws {
        var keyData: Data
        var ivData: Data
        
        let initKey = keys.cryptoKey
        let initIV = keys.initialVector
        
        if initKey.count == kCCKeySizeAES128 || initKey.count == kCCKeySizeAES256, let _keyData = initKey.data(using: .utf8) {
            keyData = _keyData
        } else {
            throw ALCryptoManagerError.wrongKey
        }
        
        if initIV.count == kCCBlockSizeAES128, let _ivData = initIV.data(using: .utf8) {
            ivData = _ivData
        } else {
            throw ALCryptoManagerError.wrongInitalVector
        }
        
        self.key = keyData
        self.iv = ivData
    }
}
