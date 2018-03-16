//
//  AppDelegate.swift
//  MarginCalculator
//
//  Created by Max Sanna on 28/02/2018.
//  Copyright © 2018 Max Sanna. All rights reserved.
//

import Cocoa
import Fabric
import Crashlytics

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        Fabric.with([Crashlytics.self])
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

