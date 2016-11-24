/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing segmented controls in an NSTouchBar instance.
 */

#import "SegmentedViewController.h"

@implementation SegmentedViewController

// Note: This particular view controller does not allow customizing its NSTouchBar instance.

- (IBAction)segmentAction:(id)sender
{
    NSSegmentedControl *segControl = (NSSegmentedControl *)sender;
    NSLog(@"segment selection = %ld", segControl.selectedSegment);
}

@end
