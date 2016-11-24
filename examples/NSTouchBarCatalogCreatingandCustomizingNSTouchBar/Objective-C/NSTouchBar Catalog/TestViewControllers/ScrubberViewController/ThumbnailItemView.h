/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSScrubberItemView used to display an image.
 */

#import <Cocoa/Cocoa.h>

@interface ThumbnailItemView : NSScrubberItemView
{
    NSImage *_thumbnail;
    NSURL *_imageURL;
}

@property NSImage *thumbnail;
@property NSURL *imageURL;

@end
