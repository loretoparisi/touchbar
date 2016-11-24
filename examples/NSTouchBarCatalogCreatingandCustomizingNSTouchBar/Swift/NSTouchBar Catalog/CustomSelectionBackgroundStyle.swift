/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom selection background view for NSScrubber.
 */

import Cocoa

fileprivate class CustomSelectionBackgroundView: NSScrubberSelectionView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor(red:10.0/255.0, green:128.0/255.0, blue:215.0/255.0, alpha:1.0).set()
        NSBezierPath(roundedRect: dirtyRect, xRadius:6, yRadius:6).fill()
    }
}

class CustomSelectionBackgroundStyle: NSScrubberSelectionStyle {
    override func makeSelectionView () -> NSScrubberSelectionView? {
        return CustomSelectionBackgroundView()
    }
}
