//
//  ALCryptoInitModel.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 10.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Model containt crypto key and inital vector for crypto encrypt\decrypt
public struct ALAESCryptoInitModel {
    /// crypto key for aes encrypt\decrypt
    public var cryptoKey: String
    /// crupto initial vector for aes encrypt\decrypt
    public var initialVector: String
}
