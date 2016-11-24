/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSView for the NSScrubber's overlay selection.
 */

#import "SelectionOverlayView.h"

@implementation SelectionOverlayView

- (void)drawRect:(NSRect)rect
{
    // Draw as an overlay: with a rounded rect, blue .5 alpha.
    [[NSColor colorWithSRGBRed:0.0 green:0.0 blue:1.0 alpha:.5] set];
    NSRect fillRect = NSInsetRect(rect, 4, 4);
    NSBezierPath *roundedRect = [NSBezierPath bezierPathWithRoundedRect:fillRect xRadius:6 yRadius:6];
    [roundedRect fill];
}

@end



