/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Main window controller for this sample.
 */

import Cocoa

enum AssetNames: String {
    case accounts = "Accounts", bookmark = "Bookmark", cat = "DorianGrayCat",
         red = "Red", green = "Green"
}

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let windowBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.windowTouchBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let label = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.label")
}

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.setFrameAutosaveName("WindowAutosave")
    }
    
    // MARK: NSTouchBar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .windowBar
        touchBar.defaultItemIdentifiers = [.label, .fixedSpaceLarge, .otherItemsProxy]
        touchBar.customizationAllowedItemIdentifiers = [.label]
        
        return touchBar
    }
    
}

// MARK: NSTouchBarDelegate

extension WindowController: NSTouchBarDelegate {
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        
        switch identifier {
        case NSTouchBarItemIdentifier.label:
            let custom = NSCustomTouchBarItem(identifier: identifier)
            custom.customizationLabel = "TouchBar Catalog Label"
            
            let label = NSTextField.init(labelWithString: "Catalog")
            custom.view = label
            
            return custom
            
        default:
            return nil
        }
    }
}
