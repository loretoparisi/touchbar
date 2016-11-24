/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSScrubberSelectionStyle to override the selection background.
 */

#import "CustomBackgroundScrubberSelectionStyle.h"
#import "SelectionBackgroundView.h"

@implementation CustomBackgroundScrubberSelectionStyle

- (nullable __kindof NSScrubberSelectionView *)makeSelectionView
{
    SelectionBackgroundView *selectionView = [[SelectionBackgroundView alloc] init];
    return selectionView;
}

@end



