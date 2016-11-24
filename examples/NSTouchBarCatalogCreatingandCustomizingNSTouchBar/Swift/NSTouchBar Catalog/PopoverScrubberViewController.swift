/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSScrubber with a NSPopoverTouchBarItem.
 */

import Cocoa

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let popoverBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.popoverBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let scrubberPopover = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.scrubberPopover")
}

class PopoverScrubber: NSScrubber {
    var presentingItem: NSPopoverTouchBarItem?
}

class PopoverScrubberViewController: NSViewController {
    // MARK: NSTouchBar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .popoverBar
        touchBar.defaultItemIdentifiers = [.scrubberPopover]
        touchBar.customizationAllowedItemIdentifiers = [.scrubberPopover]
        
        return touchBar
    }
}

// MARK: NSTouchBarDelegate

extension PopoverScrubberViewController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        guard identifier == NSTouchBarItemIdentifier.scrubberPopover else { return nil }
        
        let popoverItem = NSPopoverTouchBarItem(identifier: identifier)
        popoverItem.collapsedRepresentationLabel = "Scrubber Popover"
        popoverItem.customizationLabel = "Scrubber Popover"
        
        let scrubber = PopoverScrubber()
        scrubber.register(NSScrubberTextItemView.self, forItemIdentifier: "TextScrubberItemIdentifier")
        scrubber.mode = .free
        scrubber.selectionBackgroundStyle = .roundedBackground
        scrubber.delegate = self
        scrubber.dataSource = self
        scrubber.presentingItem = popoverItem
        
        popoverItem.collapsedRepresentation = scrubber
        
        popoverItem.popoverTouchBar = PopoverTouchBarSample(presentingItem: popoverItem)
        
        return popoverItem
    }
}

// MARK: NSScrubber Data Source and delegate

extension PopoverScrubberViewController: NSScrubberDataSource, NSScrubberDelegate {
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return 10
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        let itemView = scrubber.makeItem(withIdentifier: "TextScrubberItemIdentifier", owner: nil) as! NSScrubberTextItemView
        itemView.textField.stringValue = String(index)
        return itemView
    }
    
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
        print("\(#function) at index \(index)")
        
        if let popoverScrubber = scrubber as? PopoverScrubber,
            let popoverItem = popoverScrubber.presentingItem {
            popoverItem.showPopover(nil)
        }
    }
}
