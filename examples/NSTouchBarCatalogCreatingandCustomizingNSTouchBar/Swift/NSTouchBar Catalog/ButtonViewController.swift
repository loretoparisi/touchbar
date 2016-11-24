/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSButtons in an NSTouchBar instance.
 */

import Cocoa

class ButtonViewController: NSViewController {

    @IBOutlet weak var sizeConstraint: NSButton!
    
    @IBOutlet weak var useCustomColor: NSButton!

    @IBOutlet weak var button3: NSButton!
    
    lazy var button3Constraints: [NSLayoutConstraint] = {
        return NSLayoutConstraint.constraints(withVisualFormat: "H:[button3(200)]",
                                              options: [],
                                              metrics: nil,
                                              views: ["button3": self.button3!])
    }()
    
    // MARK: - Action Functions
    
    @IBAction func customize(_ sender: AnyObject) {
        guard let touchBar = self.touchBar else { return }
        
        for itemIdentifier in touchBar.itemIdentifiers {
            
            guard let item = touchBar.item(forIdentifier: itemIdentifier) as? NSCustomTouchBarItem,
                let button = item.view as? NSButton else {continue}
            
            let textRange = NSRange(location: 0, length: button.title.characters.count)
            let titleColor = useCustomColor.state == NSOnState ? NSColor.black : NSColor.white
            
            let newTitle = NSMutableAttributedString(string: button.title)
            newTitle.addAttribute(NSForegroundColorAttributeName, value: titleColor, range: textRange)
            newTitle.addAttribute(NSFontAttributeName, value: button.font!, range: textRange)
            newTitle.setAlignment(.center, range: textRange)
            
            button.attributedTitle = newTitle
            button.bezelColor = useCustomColor.state == NSOnState ? NSColor.yellow : nil
        }
        
        if sizeConstraint.state == NSOnState {
            NSLayoutConstraint.activate(button3Constraints)
        }
        else {
            NSLayoutConstraint.deactivate(button3Constraints)
        }
    }
    
    @IBAction func buttonAction(_ sender: AnyObject) {
        print("\(#function): button with title \"\((sender as! NSButton).title)\" is tapped!")
    }
}
