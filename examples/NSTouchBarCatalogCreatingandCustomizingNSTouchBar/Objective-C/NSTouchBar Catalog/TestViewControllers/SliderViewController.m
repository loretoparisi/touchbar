/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSSliderTouchBarItem.
 */

#import "SliderViewController.h"

static NSTouchBarCustomizationIdentifier SliderCustomizationIdentifier = @"com.TouchBarCatalog.sliderViewController";
static NSTouchBarItemIdentifier SliderItemIdentifier = @"com.TouchBarCatalog.slider";

@interface SliderViewController () <NSTouchBarDelegate>

@property (strong) NSSliderTouchBarItem *sliderTouchBarItem;
@property (weak) IBOutlet NSTextField *feedbackLabel;

@end


#pragma mark -

@implementation SliderViewController

- (IBAction)useSliderAccessoryAction:(id)sender
{
    NSImage *minSliderImage = nil;
    NSImage *maxSliderImage = nil;

    if (((NSButton *)sender).state == NSOnState)
    {
        minSliderImage = [NSImage imageNamed:@"Red"];
        maxSliderImage = [NSImage imageNamed:@"Green"];
    }
    
    NSSliderAccessory *minSliderAccessory = [NSSliderAccessory accessoryWithImage:minSliderImage];
    self.sliderTouchBarItem.minimumValueAccessory = minSliderAccessory;
    
    NSSliderAccessory *maxSliderAccessory = [NSSliderAccessory accessoryWithImage:maxSliderImage];
    self.sliderTouchBarItem.maximumValueAccessory = maxSliderAccessory;
}

- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    
    bar.customizationIdentifier = SliderCustomizationIdentifier;
    
    // Set the default ordering of items.
    bar.defaultItemIdentifiers =
        @[SliderItemIdentifier, NSTouchBarItemIdentifierOtherItemsProxy];
    
    bar.customizationAllowedItemIdentifiers = @[SliderItemIdentifier];
    
    return bar;
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:SliderItemIdentifier])
    {
        _sliderTouchBarItem = [[NSSliderTouchBarItem alloc] initWithIdentifier:SliderItemIdentifier];
        
        self.sliderTouchBarItem.slider.minValue = 0.0f;
        self.sliderTouchBarItem.slider.maxValue = 100.0f;
        self.sliderTouchBarItem.slider.doubleValue = 50.0f;
        self.sliderTouchBarItem.slider.continuous = YES;
        self.sliderTouchBarItem.target = self;
        self.sliderTouchBarItem.action = @selector(sliderChanged:);
        self.sliderTouchBarItem.label = @"Slider";
        self.sliderTouchBarItem.customizationLabel = @"Slider";
        
        // Keep track of the slider value for next time, also helps us sync the slider item
        // with the slider in this view controller.
        //
        [self.sliderTouchBarItem.slider bind:NSValueBinding
                                    toObject:[NSUserDefaultsController sharedUserDefaultsController]
                                 withKeyPath:@"values.slider"
                                     options:nil];

        return self.sliderTouchBarItem;
    }
    
    return nil;
}

- (void)sliderChanged:(NSSliderTouchBarItem *)sender
{
    // Slider value has changed.
    self.feedbackLabel.stringValue = [NSString stringWithFormat:@"Slider Value = %ld", (long)sender.slider.integerValue];
}

@end
