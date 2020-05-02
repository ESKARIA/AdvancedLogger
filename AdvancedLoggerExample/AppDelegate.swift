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
        
        //CLean logs
        AdvancedLogger.shared.cleanLogs()
        
        //Enable crypto in logs
        AdvancedLogger.shared.encryptData = true
        
        //Write logs
        AdvancedLogger.shared.addNew(log: "Test log 1", type: .warning)
        AdvancedLogger.shared.addNew(log: "Test log 2", type: .warning)
        AdvancedLogger.shared.addNew(log: "Test log 3", type: .warning)
        
        //Read logs
        AdvancedLogger.shared.getLogs { (logs) in
            
            guard let _logs = logs else { return }
            for log in _logs {
                print("_________")
                print("\n logs is \(log.log) with time \(log.time)")
            }
        }
    }

}

