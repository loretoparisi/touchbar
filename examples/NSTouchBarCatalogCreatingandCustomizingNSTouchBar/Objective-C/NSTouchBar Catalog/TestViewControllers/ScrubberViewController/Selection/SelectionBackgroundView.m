/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSView for the NSScrubber's background selection.
 */

#import "SelectionBackgroundView.h"

@implementation SelectionBackgroundView

- (void)drawRect:(NSRect)rect
{
    // Draw as a background: with a rounded rect, light blue.
    [[NSColor colorWithRed:10.0f/255.0f green:128.0f/255.0f blue:215.0f/255.0f alpha:1.0] set];
    NSBezierPath *ovalPath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:6 yRadius:6];
    [ovalPath fill];
}

@end



