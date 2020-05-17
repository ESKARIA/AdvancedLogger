//
//  Constaints+FileStorage.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 17.05.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

extension Constaints {
    
    /// Default crypto keys for encrypt logs
    enum FileStorage: String {
        case documentDirectoryPath = "AdvancedLoggerLogs"
        case fileName = "AdvancedLogger"
    }
}
