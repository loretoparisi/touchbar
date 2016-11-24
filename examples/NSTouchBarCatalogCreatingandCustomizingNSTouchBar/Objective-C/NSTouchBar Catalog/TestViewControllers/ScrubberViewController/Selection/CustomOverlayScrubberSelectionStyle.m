/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSScrubberSelectionStyle to override the selection overlay.
 */

#import "CustomOverlayScrubberSelectionStyle.h"
#import "SelectionOverlayView.h"

@implementation CustomOverlayScrubberSelectionStyle

- (nullable __kindof NSScrubberSelectionView *)makeSelectionView
{
    SelectionOverlayView *selectionView = [[SelectionOverlayView alloc] init];
    return selectionView;
}

@end



