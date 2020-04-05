//
//  AdvancedLogger.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - AdvancedLogger

/// Main struct for interact with your app
public struct AdvancedLogger {
    
    /// Point for interact with singleton logger
    static public let shared: AdvancedLoggerProtocol = AdvancedLogger()
}

// MARK: - AdvancedLoggerProtocol

extension AdvancedLogger: AdvancedLoggerProtocol {
    
}
