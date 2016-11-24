/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSApplicationDelegate used to respond to NSApplication events.
 */

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Insert code here to initialize your application
        
        // You can get the “Customize Touch Bar…” menu to display on the View menu by:
        // 1: setting the “automaticCustomizeTouchBarMenuItemEnabled” property to YES
        // or
        // 2: create your own menu item and connect it to the "toggleTouchBarCustomizationPalette:" selector
        
        // Here we just opt-in for allowing our NSTouchBar instance to be customized throughout the app.
        //
        if NSClassFromString("NSTouchBar") != nil {
            NSApplication.shared().isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    }
}
