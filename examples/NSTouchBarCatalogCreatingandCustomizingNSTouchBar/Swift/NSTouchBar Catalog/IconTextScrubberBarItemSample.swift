/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSCustomTouchBarItem for icon and text as content.
 */

import Cocoa

class IconTextScrubberBarItemSample: NSCustomTouchBarItem, NSScrubberDelegate, NSScrubberDataSource, NSScrubberFlowLayoutDelegate {
    
    private static let itemViewIdentifier = "TextIconItemViewIdentifier"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(identifier: NSTouchBarItemIdentifier) {
        super.init(identifier: identifier)
        
        let scrubber = NSScrubber()
        scrubber.scrubberLayout = NSScrubberFlowLayout()
        scrubber.register(IconTextItemView.self, forItemIdentifier: IconTextScrubberBarItemSample.itemViewIdentifier)
        scrubber.mode = .free
        scrubber.selectionBackgroundStyle = .outlineOverlay
        scrubber.delegate = self
        scrubber.dataSource = self
        
        view = scrubber
    }

    let testStrings = ["Alaska", "California", "New York", "Texas", "Washington DC", "Alaska"]
    let testImageNames = [AssetNames.accounts.rawValue, AssetNames.bookmark.rawValue,
                          AssetNames.accounts.rawValue, AssetNames.bookmark.rawValue,
                          AssetNames.accounts.rawValue, AssetNames.bookmark.rawValue]

    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return testStrings.count
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        let itemView = scrubber.makeItem(withIdentifier: type(of: self).itemViewIdentifier, owner: nil) as! IconTextItemView
        
        itemView.imageView.image = NSImage(named: testImageNames[index])
        itemView.textField.stringValue = testStrings[index]
        itemView.textField.sizeToFit()

        return itemView
    }
    
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        let size = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        // Specify a system font size of 0 to automatically use the appropriate size. 
        let title = testStrings[itemIndex]
        let textRect = title.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin],
                                          attributes: [NSFontAttributeName: NSFont.systemFont(ofSize: 0)])
        //+6:  spacing.
        //+10: NSTextField horizontal padding, no good way to retrieve this though.
        var width: CGFloat = 100.0
        if let image = NSImage(named: testImageNames[itemIndex]) {
            width = textRect.size.width + image.size.width + 6 + 10
        }
        
        return NSSize(width: width, height: 30)
    }
    
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
        print("\(#function) at index \(index)")
    }
}
