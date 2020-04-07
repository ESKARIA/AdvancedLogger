//
//  Constaints+Crypto.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

extension Constaints {
    
    /// Default crypto keys for encrypt logs
    enum Crypto: String {
        case cryptoKey = "12345678901234567890123456789012"
        case cryptoInitialVector = "abcdefghijklmnop"
    }
}
