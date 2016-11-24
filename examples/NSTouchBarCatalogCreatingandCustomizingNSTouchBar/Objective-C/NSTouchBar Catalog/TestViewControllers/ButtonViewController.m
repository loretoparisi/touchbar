/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSButtons in an NSTouchBar instance.
 */

#import "ButtonViewController.h"

@interface ButtonViewController ()

@property (strong) NSCustomTouchBarItem *touchBarItem;

@property (weak) IBOutlet NSButton *sizeConstraint;
@property (weak) IBOutlet NSButton *useCustomColor;

@property (weak) IBOutlet NSButton *button3;

@property (strong) NSArray *buttonConstraints;

@end


#pragma mark -

@implementation ButtonViewController

// Note: This particular view controller does not allow customizing its NSTouchBar instance.

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSButton *buttonToChange = self.button3;
    NSDictionary *items = NSDictionaryOfVariableBindings(buttonToChange);
    _buttonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[buttonToChange(200)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:items];
}

- (IBAction)customize:(id)sender
{
    // Change each button to the right background color.
    for (NSTouchBarItemIdentifier itemIdentifier in self.touchBar.itemIdentifiers)
    {
        NSCustomTouchBarItem *touchBarItem = [self.touchBar itemForIdentifier:itemIdentifier];
        
        NSButton *button = touchBarItem.view;
        button.bezelColor = (self.useCustomColor.state == NSOnState) ? [NSColor yellowColor] : nil;
        
        // Since we are setting the color to yellow, it makes sense to make the button titles black color.
        NSColor *titleColor = (self.useCustomColor.state == NSOnState) ? NSColor.blackColor : NSColor.whiteColor;

        NSDictionary *attributesDictionary =
            [NSDictionary dictionaryWithObjectsAndKeys:
                titleColor, NSForegroundColorAttributeName,
                button.font, NSFontAttributeName,
             nil];
        NSMutableAttributedString *attributedString =
            [[NSMutableAttributedString alloc] initWithString:button.title attributes:attributesDictionary];
        [attributedString setAlignment:NSTextAlignmentCenter range:NSMakeRange(0, attributedString.length)];
        button.attributedTitle = attributedString;
    }
    
    // Change the 3rd button's width constraint.
    if (self.sizeConstraint.state == NSOnState)
    {
        // If size constraint checkbox is on,
        // we want to set the button's width larger with the image hugging the title.
        //
        // Set the layout constraints on this custom view so that it's 200 pixels wide.
        //
        [NSLayoutConstraint activateConstraints:self.buttonConstraints];
    }
    else
    {
        [NSLayoutConstraint deactivateConstraints:self.buttonConstraints];
    }
}

- (IBAction)buttonAction:(id)sender
{
    NSLog(@"%@ was pressed", ((NSButton *)sender).title);
}

@end
