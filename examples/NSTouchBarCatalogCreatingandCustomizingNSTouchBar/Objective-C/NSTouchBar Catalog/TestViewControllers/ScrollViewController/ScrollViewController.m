/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSScrollView-based touch item.
 */

#import "ScrollViewController.h"

#pragma mark -

static NSTouchBarCustomizationIdentifier ScrollViewCustomizationIdentifier = @"com.TouchBarCatalog.scrollViewController";
static NSTouchBarItemIdentifier ScrollViewIdentifier = @"com.TouchBarCatalog.customScrollView";

@interface ScrollViewController () <NSTouchBarDelegate>

@property (strong) NSCustomTouchBarItem *customTouchBarItem;
@property (strong) IBOutlet NSScrollView *scrollView;

@end


#pragma mark -

@implementation ScrollViewController

- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    
    bar.customizationIdentifier = ScrollViewCustomizationIdentifier;
    
    // Set the default ordering of items.
    bar.defaultItemIdentifiers = @[ScrollViewIdentifier,
                                                NSTouchBarItemIdentifierOtherItemsProxy];
    
    bar.customizationAllowedItemIdentifiers = @[ScrollViewIdentifier];
    
    bar.principalItemIdentifier = ScrollViewIdentifier;
    
    return bar;
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:ScrollViewIdentifier])
    {
        _customTouchBarItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:ScrollViewIdentifier];
        self.customTouchBarItem.view = self.scrollView;
        self.customTouchBarItem.customizationLabel = @"Scroll View";

        return self.customTouchBarItem;
    }
    
    return nil;
}

@end
