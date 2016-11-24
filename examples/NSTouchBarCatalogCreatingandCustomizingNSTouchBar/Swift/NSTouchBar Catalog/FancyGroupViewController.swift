/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing grouped (NSGroupTouchBarItem) NSTouchBarItem instances with a more fancy layout.
 */

import Cocoa

fileprivate extension NSTouchBarItemIdentifier {
    static let fancyGroup = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.fancyGroup")
}

class FancyGroupViewController: NSViewController {
    // MARK: Action Functions
    
    @IBAction func buttonAction(_ sender: AnyObject) {
        let button = sender as! NSButton
        print("\(#function): button with title \"\(button.title)\" is tapped!")
    }

    @IBAction func sliderChanged(_ sender: AnyObject) {
        let slider = sender as! NSSlider
        print("\(#function): \"\(slider.intValue)\" !")
    }
    
    @IBAction func principalAction(_ sender: AnyObject) {
        guard let checkBox = sender as? NSButton else { return }
        
        let identifier = checkBox.state == NSOnState ? NSTouchBarItemIdentifier.fancyGroup : nil
        touchBar?.principalItemIdentifier = identifier
    }
}
