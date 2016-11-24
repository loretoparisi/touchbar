/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSCustomTouchBarItem with an NSScrubber.
 */

#import "ScrubberViewController.h"
#import "IconTextScrubberBarItem.h"
#import "ThumbnailItemView.h"
#import "ScrubberBackgroundView.h"

// selection appearance override:

// selection background:
#import "CustomBackgroundScrubberSelectionStyle.h"
#import "SelectionBackgroundView.h"

// selection overlay:
#import "CustomOverlayScrubberSelectionStyle.h"
#import "SelectionOverlayView.h"


#pragma mark Scrubber control variants

typedef NS_ENUM(NSInteger, ScrubberType)
{
    ScrubberTypeImage = 2000,
    ScrubberTypeText = 2001,
    ScrubberTypeBoth = 2014
};

typedef NS_ENUM(NSInteger, ScrubberMode)
{
    ScrubberModeFree = 2002,
    ScrubberModeFixed = 2003
};

typedef NS_ENUM(NSInteger, SelectionBackgroundStyle)
{
    ScrubberSelectionBackgroundNone = 2004,
    ScrubberSelectionBackgroundBoldOutline = 2005,
    ScrubberSelectionBackgroundSolidBackground = 2006,
    ScrubberSelectionBackgroundCustom = 2007
};

typedef NS_ENUM(NSInteger, SelectionOverlayStyle)
{
    ScrubberSelectionOverlayNone = 2008,
    ScrubberSelectionOverlayBoldOutline = 2009,
    ScrubberSelectionOverlaySolidBackground = 2010,
    ScrubberSelectionOverlayCustom = 2011
};

typedef NS_ENUM(NSInteger, FlowType)
{
    ScrubberFlow = 2012,
    ScrubberProportianal = 2013
};


#pragma mark - View Controller

static NSTouchBarCustomizationIdentifier ScrubberCustomizationIdentifier = @"com.TouchBarCatalog.scrubberViewController";
static NSTouchBarItemIdentifier ScrubbedItemIdentifier = @"com.TouchBarCatalog.scrubber";

@interface ScrubberViewController () <NSTouchBarDelegate, NSScrubberDelegate, NSScrubberDataSource, NSScrubberFlowLayoutDelegate>

@property NSInteger scrubberType;
@property NSInteger scrubberMode;
@property NSInteger scrubberSelectionBackgroundStyle;
@property NSInteger scrubberSelectionOverlayStyle;
@property NSInteger scrubberLayout;

@property (weak) IBOutlet NSSlider *spacingSlider;
@property (weak) IBOutlet NSButton *showsArrows;
@property (weak) IBOutlet NSButton *useBackgroundColor;
@property (weak) IBOutlet NSButton *useBackgroundView;
@property (weak) IBOutlet NSColorWell *backgroundColorWell;

@property (strong) NSMutableArray *pictures;

@end


#pragma mark -

@implementation ScrubberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the pictures for our scrubber content.
    _pictures = [[NSMutableArray alloc] init];
    [self fetchPictureResources];
    
    _scrubberType = ScrubberTypeImage;
    _scrubberMode = ScrubberModeFree;
    _scrubberSelectionBackgroundStyle = ScrubberSelectionBackgroundNone;
    _scrubberSelectionOverlayStyle = ScrubberSelectionOverlayNone;
    _scrubberLayout = ScrubberFlow;
}

// Loads all the Desktop Pictures on this system, to be used in the image-based NSScrubber.
- (void)fetchPictureResources
{
    NSURL *picturesURL =
        [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSLocalDomainMask] lastObject];
    picturesURL = [picturesURL URLByAppendingPathComponent:@"Desktop Pictures"];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:picturesURL
                                                             includingPropertiesForKeys:nil
                                                                                options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           errorHandler:nil];
    for (NSURL *file in enumerator)
    {
        [self.pictures addObject:file];
    }
}


#pragma mark - Actions

// called when any checkbox in the UI is clicked (this just invalidates the NSTouchBar instance)
- (IBAction)customizeAction:(id)sender
{
    [self invalidateTouchBar];
}

- (IBAction)useBackgroundColorAction:(id)sender
{
    NSButton *useBackgroundColorCheckbox = (NSButton *)sender;
    self.backgroundColorWell.enabled = (useBackgroundColorCheckbox.state == NSOnState);
    [self invalidateTouchBar];
}

- (IBAction)kindAction:(id)sender
{
    _scrubberType = ((NSButton *)sender).tag;
    [self invalidateTouchBar];
}

- (IBAction)modeAction:(id)sender
{
    _scrubberMode = ((NSButton *)sender).tag;
    [self invalidateTouchBar];
}

- (IBAction)selectionAction:(id)sender
{
    _scrubberSelectionBackgroundStyle = ((NSButton *)sender).tag;
    [self invalidateTouchBar];
}

- (IBAction)overlayAction:(id)sender
{
    _scrubberSelectionOverlayStyle = ((NSButton *)sender).tag;
    [self invalidateTouchBar];
}

- (IBAction)flowAction:(id)sender
{
    _scrubberLayout = ((NSButton *)sender).tag;
    [self invalidateTouchBar];
}

- (IBAction)spacingSliderAction:(id)sender
{
    [self invalidateTouchBar];
}


#pragma mark - NSTouchBar

// Used to invalidate the current NSTouchBar.
- (void)invalidateTouchBar
{
    // We need to set the first responder status when one of our radio knobs was clicked.
    [self.view.window makeFirstResponder:self.view];
    
    // Set to nil so makeTouchBar can be called again to re-create our NSTouchBarItem instances.
    self.touchBar = nil;
}

- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    
    bar.customizationIdentifier = ScrubberCustomizationIdentifier;
    
    // Set the default ordering of items.
    bar.defaultItemIdentifiers =
        @[ScrubbedItemIdentifier, NSTouchBarItemIdentifierOtherItemsProxy];
    
    bar.customizationAllowedItemIdentifiers = @[ScrubbedItemIdentifier];
    
    bar.principalItemIdentifier = ScrubbedItemIdentifier;
    
    return bar;
}


#pragma mark - NSScrubberDataSource

NSString *thumbnailScrubberItemIdentifier = @"thumbnailItem";
NSString *textScrubberItemIdentifier = @"textItem";

- (NSInteger)numberOfItemsForScrubber:(NSScrubber *)scrubber
{
    if (self.scrubberType == ScrubberTypeImage)
    {
        return self.pictures.count;
    }
    else
    {
        return 10;
    }
}

- (NSScrubberItemView *)scrubber:(NSScrubber *)scrubber viewForItemAtIndex:(NSInteger)index
{
    if (self.scrubberType == ScrubberTypeImage)
    {
        // Use image for this scrubber item.
        ThumbnailItemView *itemView = [scrubber makeItemWithIdentifier:thumbnailScrubberItemIdentifier owner:nil];
        if (index < self.pictures.count)
        {
            itemView.imageURL = [self.pictures objectAtIndex:index];
        }
        return itemView;
    }
    else
    {
        // Use text for this scrubber item.
        NSScrubberTextItemView *itemView = [scrubber makeItemWithIdentifier:textScrubberItemIdentifier owner:nil];
        if (index < 10)
        {
            itemView.textField.stringValue = [@(index) stringValue];
        }
        return itemView;
    }
}

#pragma mark - NSScrubberFlowLayoutDelegate

- (NSSize)scrubber:(NSScrubber *)scrubber layout:(NSScrubberFlowLayout *)layout sizeForItemAtIndex:(NSInteger)itemIndex
{
    NSInteger val = self.spacingSlider.integerValue;
    
    return NSMakeSize(val, 30);
}


#pragma mark - NSScrubberDelegate

- (void)scrubber:(NSScrubber *)scrubber didSelectItemAtIndex:(NSInteger)selectedIndex
{
    NSLog(@"selectedIndex = %ld", selectedIndex);
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:ScrubbedItemIdentifier])
    {
        NSCustomTouchBarItem *scrubberItem;
        NSScrubber *scrubber;
        
        if (self.scrubberType == ScrubberTypeBoth)
        {
            // Create a scrubber whose items are icon and text.
            scrubberItem = [[IconTextScrubberBarItem alloc] initWithIdentifier:ScrubbedItemIdentifier];
            scrubber = scrubberItem.view;
        }
        else
        {
            // Create the scrubber that uses images.
            scrubberItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:ScrubbedItemIdentifier];
            
            scrubber = [[NSScrubber alloc] initWithFrame:NSMakeRect(0, 0, 310, 30)];
            scrubber.delegate = self;   // This is so we can respond to selection.
            scrubber.dataSource = self; // This is so we can determine the content.
            
            // Determine the scrubber content
            if (self.scrubberType == ScrubberTypeImage)
            {
                // Scrubber will use just images.
                [scrubber registerClass:[ThumbnailItemView class] forItemIdentifier:thumbnailScrubberItemIdentifier];
                
                // For the image scrubber, we want the control to draw a fade effect to indicate that there is additional unscrolled content.
                scrubber.showsAdditionalContentIndicators = YES;
            }
            else
            {
                // Scrubber will use just text.
                [scrubber registerClass:[NSScrubberTextItemView class] forItemIdentifier:textScrubberItemIdentifier];
            }
            
            scrubber.selectedIndex = 0; // Always select the first item in the scrubber.
        }
        
        scrubberItem.customizationLabel = @"Scrubber";
        
        NSScrubberLayout *scrubberLayout;
        if (self.scrubberLayout == ScrubberFlow)
        {
            // This layout arranges items end-to-end in a linear strip.
            // It supports a fixed inter-item spacing and both fixed- and variable-sized items.
            scrubberLayout = [[NSScrubberFlowLayout alloc] init];
        }
        else
        {
            // This layout sizes each item to some fraction of the scrubber's visible size.
            scrubberLayout = [[NSScrubberProportionalLayout alloc] init];
        }
        scrubber.scrubberLayout = scrubberLayout;
        
        // Note: You can make the text-based scrubber's background transparent by using:
        // scrubber.backgroundColor = [NSColor clearColor];
        
        switch (self.scrubberMode)
        {
            case ScrubberModeFree:
            {
                scrubber.mode = NSScrubberModeFree;
                break;
            }
            
            case ScrubberModeFixed:
            {
                scrubber.mode = NSScrubberModeFixed;
                break;
            }
        }
        
        // Provides leading and trailing arrow buttons.
        // Tapping an arrow button moves the selection index by one element; pressing and holding repeatedly moves the selection.
        //
        scrubber.showsArrowButtons = self.showsArrows.state;
        
        // Specify the style of decoration to place behind items that are selected and/or highlighted.
        switch (self.scrubberSelectionBackgroundStyle)
        {
            case ScrubberSelectionBackgroundNone:
            {
                scrubber.selectionBackgroundStyle = nil;
                break;
            }
                
            case ScrubberSelectionBackgroundBoldOutline:
            {
                NSScrubberSelectionStyle *outlineStyle = [NSScrubberSelectionStyle outlineOverlayStyle];
                scrubber.selectionBackgroundStyle = outlineStyle;
                break;
            }
                
            case ScrubberSelectionBackgroundSolidBackground:
            {
                NSScrubberSelectionStyle *solidBackgroundStyle = [NSScrubberSelectionStyle roundedBackgroundStyle];
                scrubber.selectionBackgroundStyle = solidBackgroundStyle;
                break;
            }
                
            case ScrubberSelectionBackgroundCustom:
            {
                CustomBackgroundScrubberSelectionStyle *customBackgroundStyle = [[CustomBackgroundScrubberSelectionStyle alloc] init];
                scrubber.selectionBackgroundStyle = customBackgroundStyle;
            }
        }
        
        // Specify the style of decoration to place above items that are selected and/or highlighted.
        switch (self.scrubberSelectionOverlayStyle)
        {
            case ScrubberSelectionOverlayNone:
            {
                scrubber.selectionOverlayStyle = nil;
                break;
            }
                
            case ScrubberSelectionOverlayBoldOutline:
            {
                NSScrubberSelectionStyle *outlineStyle = [NSScrubberSelectionStyle outlineOverlayStyle];
                scrubber.selectionOverlayStyle = outlineStyle;
                break;
            }
                
            case ScrubberSelectionOverlaySolidBackground:
            {
                NSScrubberSelectionStyle *solidBackgroundStyle = [NSScrubberSelectionStyle roundedBackgroundStyle];
                scrubber.selectionOverlayStyle = solidBackgroundStyle;
                break;
            }
             
            case ScrubberSelectionOverlayCustom:
            {
                CustomOverlayScrubberSelectionStyle *customOverlayStyle = [[CustomOverlayScrubberSelectionStyle alloc] init];
                scrubber.selectionOverlayStyle = customOverlayStyle;
                break;
            }
        }
    
        // BackgroundColor is displayed behind the scrubber content.
        // The background color is suppressed if the scrubber is assigned a non-nil backgroundView.
        //
        // Note: This is only visible when using the text scrubber
        //
        if (self.useBackgroundColor.state == NSOnState)
        {
            scrubber.backgroundColor = self.backgroundColorWell.color;
        }
        
        // BackgroundView is displayed below the scrubber content.
        // The view's layout is managed by NSScrubber to match the content area.
        // If this property is non-nil, the backgroundColor property has no effect.
        //
        // Note: This is only visible when using the text scrubber.
        if (self.useBackgroundView.state == NSOnState)
        {
            scrubber.backgroundView = [[ScrubberBackgroundView alloc] initWithFrame:NSZeroRect];    // Use a custom view that draws a purple background.
        }
        
        // Set the layout constraints on this scrubber so that it's 400 pixels wide.
        NSDictionary *items = NSDictionaryOfVariableBindings(scrubber);
        NSArray *theConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[scrubber(400)]" options:0 metrics:nil views:items];
        [NSLayoutConstraint activateConstraints:theConstraints];
        
        // or you can do this:
        //[scrubber.widthAnchor constraintLessThanOrEqualToConstant:400].active = YES;
        
        scrubberItem.view = scrubber;
        
        return scrubberItem;
    }
    
    return nil;
}

@end
