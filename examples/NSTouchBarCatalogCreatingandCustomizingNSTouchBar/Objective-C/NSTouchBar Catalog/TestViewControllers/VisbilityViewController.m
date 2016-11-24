/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 */

#import "VisibilityViewController.h"

enum visibilityTextFieldItemTags {
    button1Tag = 1,
    button2Tag,
    button3Tag,
    button4Tag,
    button5Tag,
    button6Tag,
    button7Tag
};

@interface VisibilityViewController ()

// left separate side NSTouchBarItems
@property (weak) IBOutlet NSTouchBarItem *button1;
@property (weak) IBOutlet NSTouchBarItem *button2;

// middle grouping of NSTouchBarItems (inside an NSGroupTouchBarItem)
@property (weak) IBOutlet NSTouchBarItem *button3;
@property (weak) IBOutlet NSTouchBarItem *button4;
@property (weak) IBOutlet NSTouchBarItem *button5;

// right separate side NSTouchBarItems
@property (weak) IBOutlet NSTouchBarItem *button6;
@property (weak) IBOutlet NSTouchBarItem *button7;

// for binding the text field and stepper values together
@property NSNumber *priority1;
@property NSNumber *priority2;
@property NSNumber *priority3;
@property NSNumber *priority4;
@property NSNumber *priority5;
@property NSNumber *priority6;
@property NSNumber *priority7;

@property (weak) IBOutlet NSTouchBarItem *lastButtonItem;

@property (weak) IBOutlet NSSlider *lastButtonWidthSlider;

@property (strong) NSLayoutConstraint *lastButtonSizeConstraint;

@end


#pragma mark -

@interface PriorityValueFormatter : NSNumberFormatter
@end

@implementation PriorityValueFormatter

- (BOOL)getObjectValue:(out id _Nullable * _Nullable)obj forString:(NSString *)string range:(inout nullable NSRange *)rangep error:(out NSError **)error {
    if ([string isEqualToString:@""])
    {
        *obj = @"0";
        return YES;
    }
    if ([string isEqualToString:self.minusSign])
    {
        *obj = string;
        return YES;
    }
    return [super getObjectValue:obj forString:string range:rangep error:error];
}

- (NSString *)stringForObjectValue:(id)anObject
{
    if ([anObject isKindOfClass:[NSString class]])
    {
        if([(NSString *)anObject isEqualToString:self.minusSign])
            return anObject;
    }
    return [super stringForObjectValue:anObject];
}

- (nullable NSString *)editingStringForObjectValue:(id)anObject
{
    if ([anObject isKindOfClass:[NSString class]])
    {
        if([(NSString *)anObject isEqualToString:self.minusSign])
            return anObject;
    }
    return [super editingStringForObjectValue:anObject];
}

@end


#pragma mark -

@implementation VisibilityViewController

// Note: this particular view controller does not allow customizing its NSTouchBar instance.

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.priority1 =
    self.priority2 =
    self.priority3 =
    self.priority4 =
    self.priority5 =
    self.priority6 =
    self.priority7 = [NSNumber numberWithInteger:NSTouchBarItemPriorityNormal];
    
    // Make the last button distict by coloring it red.
    NSButton *lastButton = (NSButton *)self.lastButtonItem.view;
    lastButton.bezelColor = [NSColor redColor];
    
    for (NSInteger tag = button1Tag; tag <= button7Tag; tag++)
    {
        NSTextField *textField = [self.view viewWithTag:tag];
        textField.automaticTextCompletionEnabled = NO;
    }
    
    // Change the colors within the grouping to make them more distinct.
    NSButton *buttonInGroup = (NSButton *)self.button3.view;
    buttonInGroup.bezelColor = [NSColor darkGrayColor];
    buttonInGroup = (NSButton *)self.button4.view;
    buttonInGroup.bezelColor = [NSColor darkGrayColor];
    buttonInGroup = (NSButton *)self.button5.view;
    buttonInGroup.bezelColor = [NSColor darkGrayColor];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    // Remember the width constraint of the last button.
    NSButton *lastButton = (NSButton *)self.lastButtonItem.view;
    _lastButtonSizeConstraint = [lastButton.widthAnchor constraintEqualToConstant:self.lastButtonWidthSlider.floatValue];
    _lastButtonSizeConstraint.active = YES;
}

- (void)updateVisibility:(id)sender
{
    // Use tag to know which button's visibility priority to affect.
    NSTextField *textField = (NSTextField *)sender;
    NSTouchBarItem *itemToChange;
    switch (textField.tag)
    {
        case button1Tag:
            itemToChange = self.button1;
            break;
        case button2Tag:
            itemToChange = self.button2;
            break;
        case button3Tag:
            itemToChange = self.button3;
            break;
        case button4Tag:
            itemToChange = self.button4;
            break;
        case button5Tag:
            itemToChange = self.button5;
            break;
        case button6Tag:
            itemToChange = self.button6;
            break;
        case button7Tag:
            itemToChange = self.button7;
            break;
    }
    itemToChange.visibilityPriority = textField.integerValue;
}

// Called then text changes in each edit field.
- (void)controlTextDidChange:(NSNotification *)notification
{
    [self updateVisibility:notification.object];
}

// Action method for both edit fields and each of their associated steppers.
- (IBAction)editFieldAction:(id)sender
{
    [self updateVisibility:sender];
}

- (IBAction)sliderAction:(id)sender
{
    // Change size of the last red button.
    self.lastButtonSizeConstraint.constant = self.lastButtonWidthSlider.floatValue;
}

@end
