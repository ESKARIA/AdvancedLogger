//
//  AppDelegate.swift
//  AdvancedLoggerExample
//
//  Created by Дмитрий Торопкин on 07.04.2020.
//  Copyright © 2020 Dmitriy Toropkin. All rights reserved.
//

import UIKit
import AdvancedLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.testLogs()
        
        return true
    }


    private func testLogs() {
        AdvancedLogger.shared.cleanLogs()
        AdvancedLogger.shared.addNew(log: "Test log 1", type: .warning)
        AdvancedLogger.shared.addNew(log: "Test log 2", type: .warning)
        AdvancedLogger.shared.addNew(log: "Test log 3", type: .warning)
        AdvancedLogger.shared.getStringLogs { (logs) in
            print("\n logs is")
            print(logs!)
        }
    }

}

