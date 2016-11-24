/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom selection overlay view for NSScrubber.
 */

import Cocoa

fileprivate class CustomSelectionOverlayView: NSScrubberSelectionView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor(red:0, green:0, blue:1, alpha:0.5).set()
        NSBezierPath(roundedRect: NSInsetRect(dirtyRect, 4, 4), xRadius:6, yRadius:6).fill()
    }
}

class CustomSelectionOverlayStyle: NSScrubberSelectionStyle {
    override func makeSelectionView () -> NSScrubberSelectionView? {
        return CustomSelectionOverlayView()
    }
}
