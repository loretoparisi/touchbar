/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSCustomTouchBarItem class for images.
 */

import Cocoa

class ImageScrubberBarItemSample: NSCustomTouchBarItem, NSScrubberDelegate, NSScrubberDataSource, NSScrubberFlowLayoutDelegate {
    
    private static let itemViewIdentifier = "ImageItemViewIdentifier"
    
    var scrubberItemWidth: Int = 50
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(identifier: NSTouchBarItemIdentifier) {
        super.init(identifier: identifier)
        
        let scrubber = NSScrubber()
        scrubber.register(ThumbnailItemView.self, forItemIdentifier: ImageScrubberBarItemSample.itemViewIdentifier)
        scrubber.mode = .free
        scrubber.selectionBackgroundStyle = .roundedBackground
        scrubber.delegate = self
        scrubber.dataSource = self
        
        self.view = scrubber
    }
    
    private var pictures = [URL]()
    
    private func fetchPictureResources() {
        let library = FileManager.default.urls(for: .libraryDirectory, in: .localDomainMask)[0]
        let desktopPicturesURL = library.appendingPathComponent("Desktop Pictures", isDirectory: true)
        
        let enumerator = FileManager.default.enumerator(at: desktopPicturesURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles, errorHandler: nil)!
        
        for url in enumerator {
            guard let url = url as? URL else { continue }
            pictures.append(url)
        }
    }
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        if pictures.isEmpty {
            fetchPictureResources()
        }
        
        return pictures.count
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        let itemView = scrubber.makeItem(withIdentifier: ImageScrubberBarItemSample.itemViewIdentifier, owner: nil) as! ThumbnailItemView
        if index < pictures.count {
            itemView.imageURL = pictures[index]
        }
        
        return itemView
    }
    
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        return NSSize(width: scrubberItemWidth, height: 30)
    }
    
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
        print("\(#function) at index \(index)")
    }
}
