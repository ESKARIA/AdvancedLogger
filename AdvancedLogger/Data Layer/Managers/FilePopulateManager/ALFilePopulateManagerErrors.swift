//
//  ALFilePopulateManagerErrors.swift
//  AdvancedLogger
//
//  Created by Дмитрий Торопкин on 06.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import Foundation

/// Description error while populate model for file
enum ALFilePopulateManagerErrors {
    case encryptError(error: ALCryptoManagerErrors)
}
