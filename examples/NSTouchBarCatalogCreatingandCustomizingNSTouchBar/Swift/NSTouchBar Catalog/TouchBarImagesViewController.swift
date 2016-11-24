/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing images you can use in a Touch Bar.
 */

import Cocoa

class TouchBarImagesViewController: NSViewController {

    @IBOutlet weak var theCollectionView: NSCollectionView!

    @IBOutlet weak var touchBarLabel: NSTextField!
    @IBOutlet weak var touchBarButton: NSButton!

    let imageNames = [
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
    ]
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.touchBarLabel.isHidden = true
        self.touchBarButton.isHidden = true

        self.theCollectionView.dataSource = self
        self.theCollectionView.delegate = self
        
        self.theCollectionView.register(CollectionViewItem.self, forItemWithIdentifier: "imageItem")
    }
}

// MARK: - NSCollectionView

extension TouchBarImagesViewController:  NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageNames.count
    }
    
    func collectionView(_ collectionView: NSCollectionView,
                        itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: "imageItem", for: indexPath) as! CollectionViewItem
        item.theImageView.image = NSImage(named: self.imageNames[indexPath.item])
        return item
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        let indexPathArray = Array(indexPaths)
        let selectedItem = indexPathArray[0]
        
        // Change the button and label in the Touch Bar as feedback.
        self.touchBarLabel.stringValue = self.imageNames[selectedItem.item]
        self.touchBarLabel.isHidden = false
        
        
        self.touchBarButton.image = NSImage(named: self.imageNames[selectedItem.item])
        self.touchBarButton.isHidden = false
        
        // Draw the selected collection view item.
        let item = collectionView.item(at: selectedItem) as! CollectionViewItem
        item.view.layer?.backgroundColor = NSColor.controlHighlightColor.cgColor
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        
        // Draw the unselected collection view item.
        let indexPathArray = Array(indexPaths)
        let selectedItem = indexPathArray[0]

        let item = collectionView.item(at: selectedItem) as! CollectionViewItem
        item.view.layer?.backgroundColor = NSColor.clear.cgColor
        
        self.touchBarButton.image = nil
        self.touchBarButton.isHidden = true
        self.touchBarLabel.stringValue = ""
        self.touchBarLabel.isHidden = true
    }

}
