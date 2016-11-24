/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing images you can use in an NSTouchBar instance.
 */

#import "TouchBarImagesViewController.h"
#import "CollectionViewItem.h"

@interface TouchBarImagesViewController () <NSCollectionViewDataSource, NSCollectionViewDelegate>

@property (weak) IBOutlet NSCollectionView *theCollectionView;
@property (strong) NSArray *imageNames;

@property (strong) IBOutlet NSTextField *touchBarLabel;
@property (strong) IBOutlet NSButton *touchBarButton;

@end


#pragma mark -

@implementation TouchBarImagesViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

    // No selection yet, so hide our NSTouchBar content.
    self.touchBarButton.hidden = YES;
    self.touchBarLabel.hidden = YES;
    
	self.theCollectionView.dataSource = self;
	self.theCollectionView.delegate = self;
	
	[self.theCollectionView registerClass:[CollectionViewItem class] forItemWithIdentifier:@"imageItem"];
	
	self.imageNames = @[
						NSImageNameTouchBarAddDetailTemplate,
						NSImageNameTouchBarAddTemplate,
						NSImageNameTouchBarAlarmTemplate,
						NSImageNameTouchBarAudioInputMuteTemplate,
						NSImageNameTouchBarAudioInputTemplate,
						NSImageNameTouchBarAudioOutputMuteTemplate,
						NSImageNameTouchBarAudioOutputVolumeHighTemplate,
						NSImageNameTouchBarAudioOutputVolumeLowTemplate,
						NSImageNameTouchBarAudioOutputVolumeMediumTemplate,
						NSImageNameTouchBarAudioOutputVolumeOffTemplate,
						NSImageNameTouchBarBookmarksTemplate,
						NSImageNameTouchBarColorPickerFill,
						NSImageNameTouchBarColorPickerFont,
						NSImageNameTouchBarColorPickerStroke,
						NSImageNameTouchBarCommunicationAudioTemplate,
						NSImageNameTouchBarCommunicationVideoTemplate,
						NSImageNameTouchBarComposeTemplate,
						NSImageNameTouchBarDeleteTemplate,
						NSImageNameTouchBarDownloadTemplate,
						NSImageNameTouchBarEnterFullScreenTemplate,
						NSImageNameTouchBarExitFullScreenTemplate,
						NSImageNameTouchBarFastForwardTemplate,
						NSImageNameTouchBarFolderCopyToTemplate,
						NSImageNameTouchBarFolderMoveToTemplate,
						NSImageNameTouchBarFolderTemplate,
						NSImageNameTouchBarGetInfoTemplate,
						NSImageNameTouchBarGoBackTemplate,
						NSImageNameTouchBarGoDownTemplate,
						NSImageNameTouchBarGoForwardTemplate,
						NSImageNameTouchBarGoUpTemplate,
						NSImageNameTouchBarHistoryTemplate,
						NSImageNameTouchBarIconViewTemplate,
						NSImageNameTouchBarListViewTemplate,
						NSImageNameTouchBarMailTemplate,
						NSImageNameTouchBarNewFolderTemplate,
						NSImageNameTouchBarNewMessageTemplate,
						NSImageNameTouchBarOpenInBrowserTemplate,
						NSImageNameTouchBarPauseTemplate,
						NSImageNameTouchBarPlayheadTemplate,
						NSImageNameTouchBarPlayPauseTemplate,
						NSImageNameTouchBarPlayTemplate,
						NSImageNameTouchBarQuickLookTemplate,
						NSImageNameTouchBarRecordStartTemplate,
						NSImageNameTouchBarRecordStopTemplate,
						NSImageNameTouchBarRefreshTemplate,
						NSImageNameTouchBarRewindTemplate,
						NSImageNameTouchBarRotateLeftTemplate,
						NSImageNameTouchBarRotateRightTemplate,
						NSImageNameTouchBarSearchTemplate,
						NSImageNameTouchBarShareTemplate,
						NSImageNameTouchBarSidebarTemplate,
						NSImageNameTouchBarSkipAhead15SecondsTemplate,
						NSImageNameTouchBarSkipAhead30SecondsTemplate,
						NSImageNameTouchBarSkipAheadTemplate,
						NSImageNameTouchBarSkipBack15SecondsTemplate,
						NSImageNameTouchBarSkipBack30SecondsTemplate,
						NSImageNameTouchBarSkipBackTemplate,
						NSImageNameTouchBarSkipToEndTemplate,
						NSImageNameTouchBarSkipToStartTemplate,
						NSImageNameTouchBarSlideshowTemplate,
						NSImageNameTouchBarTagIconTemplate,
						NSImageNameTouchBarTextBoldTemplate,
						NSImageNameTouchBarTextBoxTemplate,
						NSImageNameTouchBarTextCenterAlignTemplate,
						NSImageNameTouchBarTextItalicTemplate,
						NSImageNameTouchBarTextJustifiedAlignTemplate,
						NSImageNameTouchBarTextLeftAlignTemplate,
						NSImageNameTouchBarTextListTemplate,
						NSImageNameTouchBarTextRightAlignTemplate,
						NSImageNameTouchBarTextStrikethroughTemplate,
						NSImageNameTouchBarTextUnderlineTemplate,
						NSImageNameTouchBarUserAddTemplate,
						NSImageNameTouchBarUserGroupTemplate,
						NSImageNameTouchBarUserTemplate
																					  ];
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths
{
    NSIndexPath *selectedItem = [indexPaths allObjects][0];
    
    // Change the button and label in the NSTouchBar instance as feedback.
    self.touchBarLabel.stringValue = self.imageNames[selectedItem.item];
    self.touchBarLabel.hidden = NO;
    
    NSImage	*itemImage = [NSImage imageNamed:self.imageNames[selectedItem.item]];
    self.touchBarButton.image = itemImage;
    self.touchBarButton.hidden = NO;
    
    // Draw the selected collection view item.
    CollectionViewItem *item = (CollectionViewItem *)[collectionView itemAtIndexPath:selectedItem];
    item.view.layer.backgroundColor = [[NSColor controlHighlightColor] CGColor];
}

- (void)collectionView:(NSCollectionView *)collectionView didDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths
{
    // Draw the unselected collection view item.
    NSIndexPath *selectedItem = [indexPaths allObjects][0];
    CollectionViewItem *item = (CollectionViewItem *)[collectionView itemAtIndexPath:selectedItem];
    item.view.layer.backgroundColor = [[NSColor clearColor] CGColor];
    
    self.touchBarButton.image = nil;
    self.touchBarButton.hidden = YES;
    self.touchBarLabel.stringValue = @"";
    self.touchBarLabel.hidden = YES;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.imageNames.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
	CollectionViewItem *item = [collectionView makeItemWithIdentifier:@"imageItem" forIndexPath:indexPath];
	NSImage	*itemImage = [NSImage imageNamed:self.imageNames[indexPath.item]];
	item.theImageView.image = itemImage;

	return item;
}

@end
