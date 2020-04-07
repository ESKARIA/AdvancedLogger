//
//  AdvancedLoggerEvent.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Log type for write.
public enum AdvancedLoggerEvent {
    case warning
    case error
    case crash
    case success
    case execution
}
