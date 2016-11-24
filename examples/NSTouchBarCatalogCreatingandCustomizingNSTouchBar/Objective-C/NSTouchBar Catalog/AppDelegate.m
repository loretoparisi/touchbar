/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSApplicationDelegate used to respond to NSApplication events.
 */

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    // You can get apply Customize menu item to display on the View menu by:
    // 1: setting the “automaticCustomizeTouchBarMenuItemEnabled” property to YES
    // or
    // 2: create your own menu item and connect it to the "toggleTouchBarCustomizationPalette:" selector
    
    // Here we just opt-in for allowing our bar to be customized throughout the app.
    if ([[NSApplication sharedApplication] respondsToSelector:@selector(isAutomaticCustomizeTouchBarMenuItemEnabled)])
    {
        [NSApplication sharedApplication].automaticCustomizeTouchBarMenuItemEnabled = YES;
    }
}

@end
