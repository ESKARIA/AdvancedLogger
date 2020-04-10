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
    
    init?(initKey: String, initIV: String) {
        
        var keyData: Data
        var ivData: Data
        
        if initKey.count == kCCKeySizeAES128 || initKey.count == kCCKeySizeAES256, let _keyData = initKey.data(using: .utf8) {
            keyData = _keyData
        } else {
            NSLog("AdvancedLogger error: witn crypto init: invalid crypto key. Install default key.")
            keyData = Constaints.Crypto.cryptoKey.rawValue.data(using: .utf8)!
        }
        
        if initIV.count == kCCBlockSizeAES128, let _ivData = initIV.data(using: .utf8) {
            ivData = _ivData
        } else {
            NSLog("AdvancedLogger error: witn crypto init: invalid initial vector key. Install default key.")
            ivData = Constaints.Crypto.cryptoKey.rawValue.data(using: .utf8)!
        }
        
        self.key = keyData
        self.iv = ivData
    }
    
    private func crypt(data: Data?, option: CCOperation, completion: (Data?, ALCryptoManagerErrors?) -> Void) {
        
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
    func encrypt(string: String, completion: (Data?, ALCryptoManagerErrors?) -> Void) {
        self.crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt), completion: {data, error in
            completion(data, error)
        })
    }
    
    /// decrypt data with default key
    /// - Parameter data: data to decrypt
    /// - Parameter completion: completion with decrypted optional string and optional error
    func decrypt(data: Data?, completion: (Data?, ALCryptoManagerErrors?) -> Void) {
        self.crypt(data: data, option: CCOperation(kCCDecrypt), completion: { decryptData, error in
            completion(decryptData, error)
        })
        
    }
}
