//
//  AppDelegate.swift
//  Network-AG
//
//  Created by islamshazly on 09/27/2018.
//  Copyright (c) 2018 islamshazly. All rights reserved.
//

import UIKit
import XCGLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupLogger()
        
        return true
    }

    func setupLogger() {
        
        let log = XCGLogger.default
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .debug)
        log.logAppDetails()
        
    }
    
}

