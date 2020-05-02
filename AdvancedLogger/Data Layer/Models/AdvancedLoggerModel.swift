//
//  AdvancedLoggerModel.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 27.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Main Model for log. Containt time stamp, log and type
public struct AdvancedLoggerModel: Codable {
    /// Time stamp of logs. Format - "MM-dd-yyyy HH:mm:ss"
    public let time: String
    /// Log in string,
    public let log: String
    /// Type of this log (warning\crash\error etc)
    public let type: AdvancedLoggerEvent
}
