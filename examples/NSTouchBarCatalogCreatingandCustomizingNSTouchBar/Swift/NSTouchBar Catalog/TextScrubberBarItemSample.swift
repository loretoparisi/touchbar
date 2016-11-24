/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSCustomTouchBarItem class for text content.
 */

import Cocoa

class TextScrubberBarItemSample: NSCustomTouchBarItem, NSScrubberDelegate, NSScrubberDataSource, NSScrubberFlowLayoutDelegate {
    
    private static let itemViewIdentifier = "TextItemViewIdentifier"
    
    var scrubberItemWidth: Int = 80

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(identifier: NSTouchBarItemIdentifier) {
        super.init(identifier: identifier)
        
        let scrubber = NSScrubber()
        scrubber.scrubberLayout = NSScrubberFlowLayout()
        scrubber.register(NSScrubberTextItemView.self, forItemIdentifier: TextScrubberBarItemSample.itemViewIdentifier)
        scrubber.mode = .fixed
        scrubber.selectionBackgroundStyle = .roundedBackground
        scrubber.delegate = self
        scrubber.dataSource = self
        
        self.view = scrubber
    }
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return 20
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        let itemView = scrubber.makeItem(withIdentifier: type(of: self).itemViewIdentifier,
                                         owner: nil) as! NSScrubberTextItemView
        itemView.textField.stringValue = String(index)        
        itemView.textField.backgroundColor = NSColor.blue
        
        return itemView
    }
    
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        return NSSize(width: scrubberItemWidth, height: 30)
    }

    func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
        print("\(#function) at index \(index)")
    }
}
