/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing different color picker items.
 */

#import "ColorPickerViewController.h"
#import "SplitViewController.h"
#import "MasterViewController.h"

static NSTouchBarItemIdentifier ColorPickerItemIdentifier = @"com.TouchBarCatalog.colorPicker";
static NSTouchBarCustomizationIdentifier ColorPickerCustomizationIdentifier = @"com.TouchBarCatalog.colorPickerViewController";

typedef NS_ENUM(NSInteger, ColorPickerType) {
    ColorPickerTypeColor = 1002,
    ColorPickerTypeText = 1003,
    ColorPickerTypeStroke = 1004
};

@interface ColorPickerViewController () <NSTouchBarDelegate>

@property (strong) NSColorPickerTouchBarItem *colorPickerItem;
@property (strong) IBOutlet NSButton *customColors;

@property ColorPickerType pickerType;

@end


#pragma mark -

@implementation ColorPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pickerType = ColorPickerTypeColor;
    
    // Note: If you ever want to show the NSTouchBar instance within this view controller do this:
    // [self.view.window makeFirstResponder:self.view];
}

- (void)invalidateTouchBar
{
    // We need to set the first responder status when one of our radio knobs was clicked.
    [self.view.window makeFirstResponder:self.view];
    
    // Set to nil so makeTouchBar can be called again to re-create our NSTouchBarItem instances.
    self.touchBar = nil;
}

- (IBAction)customColorsAction:(id)sender
{
    [self invalidateTouchBar];
}

- (IBAction)choiceAction:(id)sender
{    
    _pickerType = ((NSButton *)sender).tag;
    
    [self invalidateTouchBar];
}

- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    
    bar.customizationIdentifier = ColorPickerCustomizationIdentifier;
    
    // Set the default ordering of items.
    bar.defaultItemIdentifiers = @[ColorPickerItemIdentifier, NSTouchBarItemIdentifierOtherItemsProxy];
    
    bar.customizationAllowedItemIdentifiers = @[ColorPickerItemIdentifier];
    
    bar.principalItemIdentifier = ColorPickerItemIdentifier;
    
    return bar;
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:ColorPickerItemIdentifier])
    {
        if (self.pickerType == ColorPickerTypeColor)
        {
            // Create a bar item containing a button with the standard color picker icon that invokes the color picker.
            _colorPickerItem = [NSColorPickerTouchBarItem colorPickerWithIdentifier:ColorPickerItemIdentifier];
            self.colorPickerItem.target = self;
            self.colorPickerItem.action = @selector(colorAction:);
        }
        else if (self.pickerType == ColorPickerTypeText)
        {
            // Create a bar item containing a button with the standard text color picker icon that invokes the color picker. Should be used when the item is used for picking text colors.
            _colorPickerItem = [NSColorPickerTouchBarItem textColorPickerWithIdentifier:ColorPickerItemIdentifier];
            self.colorPickerItem.target = self;
            self.colorPickerItem.action = @selector(textColorAction:);
        }
        else if (self.pickerType == ColorPickerTypeStroke)
        {
            // Creates a bar item containing a button with the standard stroke color picker icon that invokes the color picker. Should be used when the item is used for picking stroke colors.
            _colorPickerItem = [NSColorPickerTouchBarItem strokeColorPickerWithIdentifier:ColorPickerItemIdentifier];
            self.colorPickerItem.target = self;
            self.colorPickerItem.action = @selector(strokeColorAction:);
        }

        if (self.customColors.state == NSOnState)
        {
            // Use a custom color list for the picker.
            self.colorPickerItem.colorList = [[NSColorList alloc] init];
            [self.colorPickerItem.colorList setColor:[NSColor redColor] forKey:@"Red"];
            [self.colorPickerItem.colorList setColor:[NSColor greenColor] forKey:@"Green"];
            [self.colorPickerItem.colorList setColor:[NSColor blueColor] forKey:@"Blue"];
        }
        
        return self.colorPickerItem;
    }
    
    return nil;
}

- (void)colorAction:(id)sender
{
    NSLog(@"Color Chosen = %@\n", ((NSColorPickerTouchBarItem *)sender).color);
}

- (void)textColorAction:(id)sender
{
    NSLog(@"Text Color Chosen = %@\n", ((NSColorPickerTouchBarItem *)sender).color);
}

- (void)strokeColorAction:(id)sender
{
    NSLog(@"Stroke Color Chosen = %@\n", ((NSColorPickerTouchBarItem *)sender).color);
}

@end
