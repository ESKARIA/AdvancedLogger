//
//  ALFilePopulateManagerProtocol.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 05.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

// MARK: - ALFilePopulateManagerProtocol

/// Protocol for create data file that will be writed on disk
protocol ALFilePopulateManagerProtocol {
    
    /// Add new log to file
    /// - Parameter log: string with event's description
    func addNew(log: String)
}
