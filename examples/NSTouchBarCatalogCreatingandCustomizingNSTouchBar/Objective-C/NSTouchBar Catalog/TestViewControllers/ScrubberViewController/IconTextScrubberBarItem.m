/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSCustomTouchBarItem used to display buttons with icon and text.
 */

#import "IconTextScrubberBarItem.h"

#pragma mark - IconTextItemView

@interface IconTextItemView : NSScrubberItemView
@end

@interface IconTextItemView ()

@property (strong) NSImageView *imageView;
@property (strong) NSTextField *textField;

@end


#pragma mark -

@implementation IconTextItemView

- (instancetype)init:(NSCoder *)coder
{
    assert("init:coder: has not been implemented");
    return nil;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self != nil)
    {
        _textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _imageView = [[NSImageView alloc] initWithFrame:NSZeroRect];
        
        self.textField.font = [NSFont systemFontOfSize: 15];
        self.textField.textColor = [NSColor alternateSelectedControlTextColor];
        
        self.textField.alignment = NSTextAlignmentCenter;
        self.textField.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self addSubview:self.imageView];
        [self addSubview:self.textField];
        
        [self updateLayout];
    }
    
    return self;
}

- (void)updateLayout
{
    if (self.imageView != nil && self.textField != nil)
    {
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSTextField *targetTextField = self.textField;
        NSImageView *targetImageView = self.imageView;
        
        NSDictionary *viewBindings = NSDictionaryOfVariableBindings(targetImageView, targetTextField);
        NSString *formatString = @"H:|-2-[targetImageView]-2-[targetTextField]-2-|";
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:formatString
                                                                     options:0
                                                                     metrics:nil
                                                                       views:viewBindings];
        
        formatString = @"V:|-0-[targetImageView]-0-|";
        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:formatString
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewBindings];
        
        NSLayoutConstraint *alignConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.textField
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1
                                                                            constant:0];
        NSMutableArray *constraints = [NSMutableArray arrayWithArray:hConstraints];
        [constraints addObjectsFromArray:vConstraints];
        [constraints addObject:alignConstraint];
                                
        [NSLayoutConstraint activateConstraints:constraints];
    }
}

@end


#pragma mark - IconTextScrubberBarItem

@interface IconTextScrubberBarItem () <NSScrubberDelegate, NSScrubberDataSource, NSScrubberFlowLayoutDelegate>

// IconTextItemView is used for measuring the image and text width.
@property (strong) IconTextItemView *itemView;

@property (strong) NSArray *testStrings;
@property (strong) NSArray *testImageNames;

@end

#pragma mark -



@implementation IconTextScrubberBarItem

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [super initWithCoder:coder];
}

- (instancetype)initWithIdentifier:(NSTouchBarItemIdentifier)identifier
{
    self = [super initWithIdentifier:identifier];
    if (self != nil)
    {
        NSScrubber *scrubber = [[NSScrubber alloc] init];
        scrubber.scrubberLayout = [[NSScrubberFlowLayout alloc] init];
        [scrubber registerClass:[IconTextItemView class] forItemIdentifier:self.identifier];
        scrubber.mode = NSScrubberModeFree;
        scrubber.selectionBackgroundStyle = [NSScrubberSelectionStyle outlineOverlayStyle];
        scrubber.delegate = self;
        scrubber.dataSource = self;
        self.view = scrubber;
        
        _testStrings = @[@"Alaska", @"Nevada", @"New York", @"Texas", @"Iowa", @"Florida"];
        _testImageNames = @[@"Accounts", @"Bookmark", @"Accounts", @"Bookmark", @"Accounts", @"Bookmark"];
    }
    return self;
}


#pragma mark - NSScrubberDataSource

- (NSInteger)numberOfItemsForScrubber:(NSScrubber *)scrubber
{
    return self.testStrings.count;
}

- (__kindof NSScrubberItemView *)scrubber:(NSScrubber *)scrubber viewForItemAtIndex:(NSInteger)index
{
    IconTextItemView *itemView = [scrubber makeItemWithIdentifier:self.identifier owner:nil];
    itemView.imageView.image = [NSImage imageNamed:self.testImageNames[index]];
    itemView.textField.stringValue = self.testStrings[index];
    [itemView.textField sizeToFit];
    
    return itemView;
}

- (NSSize)scrubber:(NSScrubber *)scrubber layout:(NSScrubberFlowLayout *)layout sizeForItemAtIndex:(NSInteger)itemIndex
{
    NSSize size = NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX);
    
    // Specify a system font size of 0 to automatically use the appropriate size.
    //
    NSString *title = self.testStrings[itemIndex];
    
    NSRect textRect = [title boundingRectWithSize:size
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:@{ NSFontAttributeName: [NSFont systemFontOfSize:0]}];
    
    //+6:  spacing.
    //+10: NSTextField horizontal padding, no good way to retrieve this though.
    //
    CGFloat width = 100.0;
    NSImage *image = self.itemView.imageView.image;
    if (image != nil)
    {
        width = textRect.size.width + image.size.width + 6 + 10;
    }
    
    return NSMakeSize(width, 30);
}


#pragma mark - NSScrubberDelegate

- (void)scrubber:(NSScrubber *)scrubber didSelectItemAtIndex:(NSInteger)selectedIndex
{
    NSLog(@"selectedIndex = %ld", selectedIndex);
}

@end
