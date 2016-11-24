/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSScrubber with an NSPopoverTouchBarItem.
 */

#import "PopoverScrubberViewController.h"

static NSTouchBarItemIdentifier PopoverItemIdentifier = @"com.TouchBarCatalog.popoverScrubber";
static NSTouchBarItemIdentifier SliderItemIdentifier = @"com.TouchBarCatalog.simpleSlider";
static NSTouchBarItemIdentifier SimpleLabelItemIdentifier = @"com.TouchBarCatalog.simpleLabel";

@interface PopoverScrubberViewController () <NSTouchBarDelegate, NSScrubberDelegate, NSScrubberDataSource>

@property (strong) NSPopoverTouchBarItem *popoverTouchBarItem;

@property (strong) NSTextField *popoverLabel;

@end


#pragma mark -

@implementation PopoverScrubberViewController

- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    
    [bar setCustomizationIdentifier:@"com.TouchBarCatalog.popoverScrubberViewController"];
    
    // Set the default ordering of items
    bar.defaultItemIdentifiers = @[PopoverItemIdentifier, NSTouchBarItemIdentifierOtherItemsProxy];
    
    bar.customizationAllowedItemIdentifiers = @[PopoverItemIdentifier];
    
    bar.principalItemIdentifier = PopoverItemIdentifier;
    
    return bar;
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:PopoverItemIdentifier])
    {
        _popoverTouchBarItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:PopoverItemIdentifier];
        
        NSScrubber *scrubber = [[NSScrubber alloc] initWithFrame:NSMakeRect(0, 0, 320, 30)];
        scrubber.delegate = self;   // So we can respond to selection.
        scrubber.dataSource = self;
        
        [scrubber registerClass:[NSScrubberTextItemView class] forItemIdentifier:textScrubberInPopoverItemIdentifier];

        // Use the flow layout.
        NSScrubberLayout *scrubberLayout = [[NSScrubberFlowLayout alloc] init];
        scrubber.scrubberLayout = scrubberLayout;
        
        scrubber.mode = NSScrubberModeFree;
        
        NSScrubberSelectionStyle *outlineStyle = [NSScrubberSelectionStyle outlineOverlayStyle];
        scrubber.selectionBackgroundStyle = outlineStyle;
        
        self.popoverTouchBarItem.collapsedRepresentation = scrubber;
        
        // Now add its secondary NSTouchBar instance.
        NSTouchBar *secondaryTouchBar = [[NSTouchBar alloc] init];
        secondaryTouchBar.delegate = self;
        secondaryTouchBar.defaultItemIdentifiers =
            @[SimpleLabelItemIdentifier, NSTouchBarItemIdentifierFixedSpaceSmall, SliderItemIdentifier];
        
        self.popoverTouchBarItem.popoverTouchBar = secondaryTouchBar;
        
        self.popoverTouchBarItem.customizationLabel = @"Popover Scrubber";
        
        return self.popoverTouchBarItem;
    }
    else if ([identifier isEqualToString:SliderItemIdentifier])
    {
        NSSliderTouchBarItem *sliderTouchBarItem =
            [[NSSliderTouchBarItem alloc] initWithIdentifier:SliderItemIdentifier];
        
        sliderTouchBarItem.slider.minValue = 0.0f;
        sliderTouchBarItem.slider.maxValue = 10.0f;
        sliderTouchBarItem.slider.doubleValue = 2.0f;
        sliderTouchBarItem.target = self;
        sliderTouchBarItem.action = @selector(sliderChanged:);
        sliderTouchBarItem.label = @"Slider:";
        sliderTouchBarItem.customizationLabel = @"Slider";
        
        return sliderTouchBarItem;
    }
    else if ([identifier isEqualToString:SimpleLabelItemIdentifier])
    {
        _popoverLabel = [NSTextField labelWithString:@""];  // The label will be defined when the popover is presented.
        NSCustomTouchBarItem *customItemForLabel =
            [[NSCustomTouchBarItem alloc] initWithIdentifier:SimpleLabelItemIdentifier];
        customItemForLabel.view = self.popoverLabel;
        
        return customItemForLabel;
    }
    
    return nil;
}

- (void)sliderChanged:(NSSliderTouchBarItem *)sender
{
    NSLog(@"slider changed");
}


#pragma mark - NSScrubberDataSource

NSString *textScrubberInPopoverItemIdentifier = @"textItem";

- (NSInteger)numberOfItemsForScrubber:(NSScrubber *)scrubber
{
    return 10;
}

- (NSScrubberItemView *)scrubber:(NSScrubber *)scrubber viewForItemAtIndex:(NSInteger)index
{
    NSScrubberTextItemView *itemView = [scrubber makeItemWithIdentifier:textScrubberInPopoverItemIdentifier owner:nil];
    if (index < 10)
    {
        itemView.textField.stringValue = [@(index)stringValue];
    }
    return itemView;
}

#pragma mark - NSScrubberDelegate

- (void)scrubber:(NSScrubber *)scrubber didSelectItemAtIndex:(NSInteger)selectedIndex
{
    [self.popoverTouchBarItem showPopover:self];
    
    // Customize the popover a little based on which segment was selected.
    self.popoverLabel.stringValue = [NSString stringWithFormat:@"Item %ld", selectedIndex];
}

@end
