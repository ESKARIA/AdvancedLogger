//
//  AdvancedLoggerModel.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 27.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

public struct AdvancedLoggerModel: Codable {
    let time: String
    let log: String
    let type: AdvancedLoggerEvent
}
