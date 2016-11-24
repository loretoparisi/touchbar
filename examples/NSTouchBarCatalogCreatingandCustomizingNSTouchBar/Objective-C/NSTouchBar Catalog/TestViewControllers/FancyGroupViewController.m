/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing grouped (NSGroupTouchBarItem) NSTouchBarItem instances with a more fancy layout.
 */

#import "FancyGroupViewController.h"

static NSTouchBarItemIdentifier FancyGroupItemIdentifier = @"com.TouchBarCatalog.fancyGroupItem";
static NSTouchBarCustomizationIdentifier FancyGroupCustomizationIdentifier = @"com.TouchBarCatalog.fancyGroupViewController";

@interface FancyGroupViewController () <NSTouchBarDelegate>

@property (strong) NSGroupTouchBarItem *touchBarItem;
@property (weak) IBOutlet NSButton *principalCheckBox;

@end


#pragma mark -

@implementation FancyGroupViewController

- (IBAction)principalAction:(id)sender
{
    // We need to set the first responder status when the checkbox was clicked.
    [self.view.window makeFirstResponder:self.view];
    
    // Set to nil so makeTouchBar can be called again to re-create our NSTouchBar instance.
    self.touchBar = nil;
    
    // Note: If you ever want to show the NSTouchBar instance within this view controller do this:
    // [self.view.window makeFirstResponder:self.view];
}

- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    
    bar.customizationIdentifier = FancyGroupCustomizationIdentifier;
    
    // Set the default ordering of items.
    bar.defaultItemIdentifiers =
        @[FancyGroupItemIdentifier, NSTouchBarItemIdentifierOtherItemsProxy];
    
    bar.customizationAllowedItemIdentifiers = @[FancyGroupItemIdentifier];
    
    if (self.principalCheckBox.state == NSOnState)
    {
        // Note: To make this grouping truly centerered in the Touch Bar, it must be a principal item.
        bar.principalItemIdentifier = FancyGroupItemIdentifier;
    }
    
    return bar;
}

- (void)buttonAction:(id)sender
{
    NSLog(@"button was pressed");
}

- (NSCustomTouchBarItem *)makeButtonWithIdentifier:(NSString *)theIdentifier title:(NSString *)title customizationLabel:(NSString *)customizationLabel
{
    NSButton *button = [NSButton buttonWithTitle:title target:self action:@selector(buttonAction:)];
    NSCustomTouchBarItem *touchBarItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:theIdentifier];
    touchBarItem.view = button;
    touchBarItem.customizationLabel = customizationLabel;

    return touchBarItem;
}

- (NSArray *)makeFirstGroupButtons
{
    return @[
             [self makeButtonWithIdentifier:@"com.TouchbarCatalog.fancyGroupItem.button1" title:@"Button 1" customizationLabel:@"Button 1"],
             [self makeButtonWithIdentifier:@"com.TouchbarCatalog.fancyGroupItem.button2" title:@"Button 2" customizationLabel:@"Button 2"],
             ];
}

- (NSArray *)makeSecondGroupButtons
{
    return @[
             [self makeButtonWithIdentifier:@"com.TouchbarCatalog.fancyGroupItem.button3" title:@"Button 3" customizationLabel:@"Button 3"],
             [self makeButtonWithIdentifier:@"com.TouchbarCatalog.fancyGroupItem.button4" title:@"Button 4" customizationLabel:@"Button 4"],
             ];
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:FancyGroupItemIdentifier])
    {
        // Left side is a group of 2 buttons.
        NSArray *firstSegItems = [self makeFirstGroupButtons];
        
        // Center is a popover.
        NSPopoverTouchBarItem *popoverTouchBarItem =
            [[NSPopoverTouchBarItem alloc] initWithIdentifier:@"com.TouchBarCatalog.centerPopover"];
        popoverTouchBarItem.collapsedRepresentationLabel = @"Open Popover";
        
        // The popover item's content is just a slider item and its label.
        NSTouchBar *secondaryTouchBar = [[NSTouchBar alloc] init];
        secondaryTouchBar.delegate = self;
        secondaryTouchBar.defaultItemIdentifiers = @[@"com.TouchBarCatalog.simpleSlider"];
        popoverTouchBarItem.popoverTouchBar = secondaryTouchBar;

        // Right side is a group of 2 buttons.
        NSArray *secondSegItems = [self makeSecondGroupButtons];
        
        // Combine all the elements in a single group.
        NSMutableArray *allItems = [[NSArray arrayWithArray:firstSegItems] mutableCopy];
        [allItems addObject:popoverTouchBarItem];
        [allItems addObjectsFromArray:secondSegItems];
        _touchBarItem = [NSGroupTouchBarItem groupItemWithIdentifier:FancyGroupItemIdentifier items:allItems];

        self.touchBarItem.customizationLabel = @"Fancy Group";

        return self.touchBarItem;
    }
    else if ([identifier isEqualToString:@"com.TouchBarCatalog.simpleSlider"])
    {
        NSSliderTouchBarItem *slider =
            [[NSSliderTouchBarItem alloc] initWithIdentifier:@"com.TouchBarCatalog.simpleSlider"];
        slider.slider.minValue = 0.0f;
        slider.slider.maxValue = 10.0f;
        slider.slider.doubleValue = 2.0f;
        slider.target = self;
        slider.action = @selector(sliderChanged:);
        slider.label = @"Slider:";
        slider.customizationLabel = @"Slider";
        
        return slider;
    }
    
    return nil;
}

- (void)sliderChanged:(NSSliderTouchBarItem *)sender
{
    NSLog(@"slider changed");
}

@end
