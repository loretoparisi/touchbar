/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSCustomTouchBarItem with an NSScrubber.
 */

import Cocoa

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let scrubberBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.scrubberBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let imageScrubber = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.imageScrubber")
    static let textScrubber = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.textScrubber")
    static let iconTextScrubber = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.customScrubber")
}

// Button Tag enums. The values have to be the same as the button tags in the storyboard.
fileprivate enum KindButtonTag: Int {
    case imageScrubber = 2000, textScrubber = 2001, iconTextScrubber = 2014
}

fileprivate enum ModeButtonTag: Int {
    case free = 2002, fixed = 2003
}

fileprivate enum SelectionBackgroundStyleButtonTag: Int {
    case none = 2004, boldOutline = 2005, solidBackground = 2006, custom = 2007
}

enum SelectionOverlayStyleButtonTag: Int {
    case none = 2008, boldOutline = 2009, solidBackground = 2010, custom = 2011
}

enum LayoutTypeButtonTag: Int {
    case flow = 2012, proportianal = 2013
}

class ScrubberViewController: NSViewController {
    
    var selectedItemIdentifier: NSTouchBarItemIdentifier = .imageScrubber
    
    var selectedMode: NSScrubberMode = .free
    
    var selectedSelectionBackgroundStyle: NSScrubberSelectionStyle? = .outlineOverlay
    
    var selectedSelectionOverlayStyle: NSScrubberSelectionStyle? = .outlineOverlay
    
    var selectedLayout: NSScrubberLayout = NSScrubberFlowLayout()

    @IBOutlet weak var spacingSlider: NSSlider!
    
    @IBOutlet weak var showsArrows: NSButton!
    
    @IBOutlet weak var useBackgroundColor: NSButton!
    
    @IBOutlet weak var useBackgroundView: NSButton!
    
    @IBOutlet weak var backgroundColorWell: NSColorWell!
    
    // MARK: Action Functions
    
    @IBAction func customizeAction(_ sender: AnyObject) {
        touchBar = nil
    }

    @IBAction func useBackgroundColorAction(_ sender: AnyObject) {
        backgroundColorWell.isEnabled = (sender.state == NSOnState)
        touchBar = nil
    }

    @IBAction func kindAction(_ sender: AnyObject) {
        guard let button = sender as? NSButton, let choice = KindButtonTag(rawValue:button.tag) else { return }
        
        switch choice {
        case .imageScrubber:
            selectedItemIdentifier = .imageScrubber
            
        case .textScrubber:
            selectedItemIdentifier = .textScrubber
        
        case .iconTextScrubber:
            selectedItemIdentifier = .iconTextScrubber
        }

        touchBar = nil
    }

    @IBAction func modeAction(_ sender: AnyObject) {
        guard let button = sender as? NSButton, let choice = ModeButtonTag(rawValue:button.tag) else { return }

        switch choice {
        case .free:
            selectedMode = .free
            
        case .fixed:
            selectedMode = .fixed
        }

        touchBar = nil
    }

    @IBAction func selectionAction(_ sender: AnyObject) {
        guard let button = sender as? NSButton, let choice = SelectionBackgroundStyleButtonTag(rawValue:button.tag) else { return }
        
        switch choice {
        case .none:
            selectedSelectionBackgroundStyle = nil
            
        case .boldOutline:
            selectedSelectionBackgroundStyle = .outlineOverlay

        case .solidBackground:
            selectedSelectionBackgroundStyle = .roundedBackground

        case .custom:
            selectedSelectionBackgroundStyle = CustomSelectionBackgroundStyle()
        }

        touchBar = nil
    }

    @IBAction func overlayAction(_ sender: AnyObject) {
        guard let button = sender as? NSButton, let choice = SelectionOverlayStyleButtonTag(rawValue:button.tag) else { return }
        
        switch choice {
        case .none:
            selectedSelectionOverlayStyle = nil
            
        case .boldOutline:
            selectedSelectionOverlayStyle = .outlineOverlay
            
        case .solidBackground:
            selectedSelectionOverlayStyle = .roundedBackground
            
        case .custom:
            selectedSelectionOverlayStyle = CustomSelectionOverlayStyle()
        }

        touchBar = nil
    }

    @IBAction func flowAction(_ sender: AnyObject) {
        guard let button = sender as? NSButton, let choice = LayoutTypeButtonTag(rawValue:button.tag) else { return }
        
        switch choice {
        case .flow:
            selectedLayout = NSScrubberFlowLayout()
            
        case .proportianal:
            selectedLayout = NSScrubberProportionalLayout()
        }

        touchBar = nil
    }

    @IBAction func spacingSliderAction(_ sender: AnyObject) {
        touchBar = nil
    }

    // MARK: NSTouchBar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .scrubberBar
        touchBar.defaultItemIdentifiers = [selectedItemIdentifier]
        touchBar.customizationAllowedItemIdentifiers = [selectedItemIdentifier]
        
        return touchBar
    }
}

// MARK: NSTouchBarDelegate

extension ScrubberViewController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        let scrubberItem: NSCustomTouchBarItem

        switch identifier {
        case NSTouchBarItemIdentifier.textScrubber:
            scrubberItem = TextScrubberBarItemSample(identifier: identifier)
            scrubberItem.customizationLabel = "Text Scrubber"
            (scrubberItem as! TextScrubberBarItemSample).scrubberItemWidth = self.spacingSlider.integerValue
            
        case NSTouchBarItemIdentifier.imageScrubber:
            scrubberItem = ImageScrubberBarItemSample(identifier: identifier)
            scrubberItem.customizationLabel = "Image Scrubber"
            (scrubberItem as! ImageScrubberBarItemSample).scrubberItemWidth = self.spacingSlider.integerValue
 
        case NSTouchBarItemIdentifier.iconTextScrubber:
            scrubberItem = IconTextScrubberBarItemSample(identifier: identifier)
            scrubberItem.customizationLabel = "IconText Scrubber"
            
        default:
            return nil
        }
        
        guard let scrubber = scrubberItem.view as? NSScrubber else { return nil }
    
        scrubber.mode = selectedMode
        scrubber.showsArrowButtons = showsArrows.state == NSOnState
        scrubber.selectionBackgroundStyle = selectedSelectionBackgroundStyle
        scrubber.selectionOverlayStyle = selectedSelectionOverlayStyle
        scrubber.scrubberLayout = selectedLayout
        
        if useBackgroundColor.state == NSOnState {
            scrubber.backgroundColor = backgroundColorWell.color
        }

        if self.useBackgroundView.state == NSOnState {
            scrubber.backgroundView = CustomBackgroundView()
        }

        let viewBindings: [String: NSView] = ["scrubber": scrubber]
        let hconstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[scrubber(400)]",
                                                          options: [],
                                                          metrics: nil,
                                                          views: viewBindings)
        NSLayoutConstraint.activate(hconstraints)

        return scrubberItem
    }
}
