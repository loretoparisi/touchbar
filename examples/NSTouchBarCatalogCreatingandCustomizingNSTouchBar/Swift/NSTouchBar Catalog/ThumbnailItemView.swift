/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSScrubberItemView class for thumbnail images.
 */

import Cocoa

class ThumbnailItemView: NSScrubberItemView {
    
    static let thumbnailCache = NSCache<NSURL, NSImage>()
    
    private let imageView: NSImageView
    
    private let spinner: NSProgressIndicator
    
    private var thumbnail: NSImage {
        didSet {
            spinner.isHidden = true
            spinner.stopAnimation(nil)
            imageView.isHidden = false
            imageView.image = thumbnail
        }
    }
    
    var imageURL: URL? {
        didSet {
            guard oldValue != imageURL else { return }
            guard let imageURL = imageURL else {
                imageView.image = nil
                return
            }
            
            if let cachedThumbnail = ThumbnailItemView.thumbnailCache.object(forKey: imageURL as NSURL) {
                thumbnail = cachedThumbnail
                return
            }
            
            spinner.isHidden = false
            spinner.startAnimation(nil)
            imageView.isHidden = true
            
            let currentURL = imageURL
            DispatchQueue.global(qos: .background).async {
                guard let fullImage = NSImage(contentsOf: currentURL) else {
                    DispatchQueue.main.async {
                        if currentURL == self.imageURL {
                            self.thumbnail = NSImage(size: .zero)
                        }
                    }
                    
                    return
                }
                
                let imageSize = fullImage.size
                let thumbnailHeight: CGFloat = 30
                let thumbnailSize = NSSize(width: ceil(thumbnailHeight * imageSize.width / imageSize.height), height: thumbnailHeight)
                
                let thumbnail = NSImage(size: thumbnailSize)
                thumbnail.lockFocus()
                fullImage.draw(in: NSRect(origin: .zero, size: thumbnailSize), from: NSRect(origin: .zero, size: imageSize), operation: .sourceOver, fraction: 1.0)
                thumbnail.unlockFocus()
                
                ThumbnailItemView.thumbnailCache.setObject(thumbnail, forKey: currentURL as NSURL)
                
                DispatchQueue.main.async {
                    if currentURL == self.imageURL {
                        self.thumbnail = thumbnail
                    }
                }
            }
        }
    }
    
    required override init(frame frameRect: NSRect) {
        imageURL = nil
        thumbnail = NSImage(size: frameRect.size)
        imageView = NSImageView(image: thumbnail)
        imageView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        spinner = NSProgressIndicator()
        
        super.init(frame: frameRect)
        
        spinner.isIndeterminate = true
        spinner.style = .spinningStyle
        spinner.sizeToFit()
        spinner.frame = bounds.insetBy(dx: (bounds.width - spinner.frame.width)/2, dy: (bounds.height - spinner.frame.height)/2)
        spinner.isHidden = true
        spinner.controlSize = .small
        spinner.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        spinner.autoresizingMask = [.viewMinXMargin, .viewMaxXMargin, .viewMinYMargin, .viewMaxXMargin]
        
        subviews = [imageView, spinner]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayer() {
        layer?.backgroundColor = NSColor.controlColor.cgColor
    }
    
    override func layout() {
        super.layout()
        
        imageView.frame = bounds
        spinner.sizeToFit()
        spinner.frame = bounds.insetBy(dx: (bounds.width - spinner.frame.width)/2, dy: (bounds.height - spinner.frame.height)/2)
    }
}
