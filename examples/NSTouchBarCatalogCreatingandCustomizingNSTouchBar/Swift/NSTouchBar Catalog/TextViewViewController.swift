/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for NSTouchBarItem instances used with an NSTextView.
 */

import Cocoa

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let textViewBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.textViewBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let toggleBold = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.toggleBold")
}

enum ButtonTitle: String {
    case normal = "Normal", bold = "Bold"
}

class TextViewViewController: NSViewController {
    @IBOutlet weak var textView: NSTextView!
    
    @IBOutlet weak var customTouchBarCheckbox: NSButton!
    
    var isBold = false

    // MARK: - NSTouchBar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .textViewBar
        touchBar.defaultItemIdentifiers = [.toggleBold, .otherItemsProxy]
        touchBar.customizationAllowedItemIdentifiers = [.toggleBold]
        touchBar.principalItemIdentifier = .toggleBold
        
        return touchBar
    }

    // MARK: Action Functions
    
    func toggleBoldButtonAction(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        
        isBold = !isBold
        button.title = isBold ? ButtonTitle.bold.rawValue : ButtonTitle.normal.rawValue
        
        if let textStorage = textView.textStorage {
            let face = isBold ? NSFontTraitMask.boldFontMask : NSFontTraitMask.unboldFontMask
            textStorage.applyFontTraits(face, range: NSMakeRange(0, textStorage.length))
        }
    }
    
    @IBAction func customTouchBarAction(_ sender: AnyObject) {
        textView.isAutomaticTextCompletionEnabled = customTouchBarCheckbox.state != NSOnState
        touchBar = nil
    }
}

// MARK: NSTouchBarDelegate

extension TextViewViewController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        guard identifier == NSTouchBarItemIdentifier.toggleBold else {return nil}
        
        let custom = NSCustomTouchBarItem(identifier: identifier)
        custom.customizationLabel = "Button"
        let title = isBold ? ButtonTitle.bold.rawValue : ButtonTitle.normal.rawValue
        custom.view = NSButton(title: title, target: self, action: #selector(toggleBoldButtonAction(_:)))
        
        return custom
    }
}

// MARK: NSTextViewDelegate

extension TextViewViewController: NSTextViewDelegate {
    func textView(_ textView: NSTextView, shouldUpdateTouchBarItemIdentifiers identifiers: [NSTouchBarItemIdentifier]) -> [NSTouchBarItemIdentifier] {
        return customTouchBarCheckbox.state == NSOnState ? [] : identifiers
    }
}
