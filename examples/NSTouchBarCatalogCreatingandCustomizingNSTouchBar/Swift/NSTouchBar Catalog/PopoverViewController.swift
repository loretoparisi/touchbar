/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSPopoverTouchBarItem in an NSTouchBar instance.
 */

import Cocoa

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let popoverBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.popoverBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let popover = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.popover")
}

class PopoverViewController: NSViewController {
    
    @IBOutlet weak var useImage: NSButton!

    @IBOutlet weak var useLabel: NSButton!
    
    @IBOutlet weak var useCustomClose: NSButton!
    
    @IBOutlet weak var pressAndHold: NSButton!

    enum RadioButtonTag: Int {
        case imageLabel = 1014, custom = 1015
    }
    
    var representationType: RadioButtonTag = .imageLabel

    // MARK: NSTouchBar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .popoverBar
        touchBar.defaultItemIdentifiers = [.popover]
        touchBar.customizationAllowedItemIdentifiers = [.popover]
        touchBar.principalItemIdentifier = .popover
        
        return touchBar
    }
    
    // MARK: Action Functions
    
    @IBAction func representationTypeAction(_ sender: Any) {
        guard let radioButton = sender as? NSButton,
            let choice = RadioButtonTag(rawValue:radioButton.tag) else { return }
        
        representationType = choice
        touchBar = nil
    }
    
    @IBAction func customizeAction(_ sender: Any) {
        touchBar = nil
    }
}

// MARK: NSTouchBarDelegate

extension PopoverViewController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        guard identifier == NSTouchBarItemIdentifier.popover else { return nil }
        
        let popoverItem = NSPopoverTouchBarItem(identifier: identifier)
        popoverItem.showsCloseButton = useCustomClose.state == NSOffState
        popoverItem.customizationLabel = "Popover"

        switch representationType {
        case .imageLabel:
            if useImage.state == NSOnState {
                popoverItem.collapsedRepresentationImage = NSImage(named: AssetNames.accounts.rawValue)
            }
            
            if useLabel.state == NSOnState {
                popoverItem.collapsedRepresentationLabel = "Open Popover"
            }
            
        case .custom:
            let button = NSButton(title: "Open Popover", target: popoverItem,
                                  action: #selector(NSPopoverTouchBarItem.showPopover(_:)))
            button.bezelColor = NSColor.blue
            popoverItem.collapsedRepresentation = button
        }
        
        // We can setup a different NSTouchBar instance for popoverTouchBar and pressAndHoldTouchBar property
        // However, in that case, the chevron won't be shown. Here we just use the same NSTouchBar instance.
        if pressAndHold.state == NSOnState {
            popoverItem.pressAndHoldTouchBar = PopoverTouchBarSample(presentingItem: popoverItem, forPressAndHold: true)
            popoverItem.popoverTouchBar = popoverItem.pressAndHoldTouchBar!
            popoverItem.showsCloseButton = true
        }
        else {
            popoverItem.popoverTouchBar = PopoverTouchBarSample(presentingItem: popoverItem)
        }

        return popoverItem
    }
}
