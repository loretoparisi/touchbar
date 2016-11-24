/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Main window controller for this sample.
 */

#import "WindowController.h"

static NSTouchBarItemIdentifier WindowControllerLabelIdentifier = @"com.TouchBarCatalog.windowController.label";

@interface WindowController () <NSTouchBarDelegate>

@end


#pragma mark -

@implementation WindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.window.frameAutosaveName = @"WindowAutosave";
}

// This window controller will have only one NSTouchBarItem instance, which is a simple label,
// so to show that view controller bar can reside along side its window controller.
//
- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
        
    // Set the default ordering of items.
    bar.defaultItemIdentifiers =
        @[WindowControllerLabelIdentifier, NSTouchBarItemIdentifierOtherItemsProxy];
    
    return bar;
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:WindowControllerLabelIdentifier])
    {
        NSTextField *theLabel = [NSTextField labelWithString:@"Catalog"];
        
        NSCustomTouchBarItem *customItemForLabel =
            [[NSCustomTouchBarItem alloc] initWithIdentifier:WindowControllerLabelIdentifier];
        customItemForLabel.view = theLabel;
        
        // We want this label to always be visible no matter how many items are in the NSTouchBar instance.
        customItemForLabel.visibilityPriority = NSTouchBarItemPriorityHigh;
        
        return customItemForLabel;
    }
    
    return nil;
}

@end
