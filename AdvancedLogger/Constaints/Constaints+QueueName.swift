//
//  Constaints+QueueName.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

extension Constaints {
    
    /// Name of queue for DispatchQueue init with custom label
    enum Queue: String {
        case queueAdvancedLogger = "com.AdvancedLogger.main"
        case queueDiskOperationName = "com.AdvancedLogger.diskOperation"
        case queueCryptoOperationName = "com.AdvancedLogger.cryptoOperation"
    }
}
