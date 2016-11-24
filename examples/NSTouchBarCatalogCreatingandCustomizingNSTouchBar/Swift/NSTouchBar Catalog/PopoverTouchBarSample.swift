/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Special NSTouchBar for the PopoverViewController.
 */

import Cocoa

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let popoverBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.popoverBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let button = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.button")
    static let dismissButton = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.dismissButton")
    static let slider = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.slider")
}

class PopoverTouchBarSample: NSTouchBar {
    
    var presentingItem: NSPopoverTouchBarItem?
    
    func dismiss(_ sender: Any?) {
        guard let popover = presentingItem else { return }
        popover.dismissPopover(sender)
    }
    
    override init() {
        super.init()
        
        delegate = self
        defaultItemIdentifiers = [.button, .slider]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(presentingItem: NSPopoverTouchBarItem? = nil, forPressAndHold: Bool = false) {
        self.init()
        self.presentingItem = presentingItem
        
        // Sliders only work well with press & hold behavior when they are the only item in the popover 
        // and you use the slider popover item
        if forPressAndHold {
            self.defaultItemIdentifiers = [.slider]
            return
        }
        
        if let showsCloseButton = presentingItem?.showsCloseButton, showsCloseButton == false {
            self.defaultItemIdentifiers = [.dismissButton, .button, .slider]
        }
    }
    
    func actionHandler(_ sender: Any?) {
        print("\(#function) is called!")
    }
    
    func sliderValueChanged(_ sender: Any) {
        if let sliderItem = sender as? NSSliderTouchBarItem {
            print("Slider value: \(sliderItem.slider.intValue)!")
        }
    }
}

// MARK: NSTouchBarDelegate

extension PopoverTouchBarSample: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        
        switch identifier {
        case NSTouchBarItemIdentifier.button:
            let custom = NSCustomTouchBarItem(identifier: identifier)
            custom.customizationLabel = "Button"
            custom.view = NSButton(title: "Button", target: self, action: #selector(actionHandler(_:)))
            return custom
            
        case NSTouchBarItemIdentifier.dismissButton:
            let custom = NSCustomTouchBarItem(identifier: identifier)
            custom.customizationLabel = "Close Button"
            custom.view = NSButton(title: "Close", target: self, action: #selector(PopoverTouchBarSample.dismiss(_:)))
            return custom
            
        case NSTouchBarItemIdentifier.slider:
            let sliderItem = NSSliderTouchBarItem(identifier: identifier)
            let slider = sliderItem.slider
            slider.minValue = 0.0
            slider.maxValue = 100.0
            sliderItem.label = "Slider"
            
            sliderItem.customizationLabel = "Slider"
            sliderItem.target = self
            sliderItem.action = #selector(sliderValueChanged(_:))
            
            sliderItem.minimumValueAccessory = NSSliderAccessory(image: NSImage(named: AssetNames.accounts.rawValue)!)
            sliderItem.maximumValueAccessory = NSSliderAccessory(image: NSImage(named: AssetNames.bookmark.rawValue)!)
            
            let viewBindings : [String: NSView] = ["slider": slider]
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: "[slider(300)]",
                                                             options: [],
                                                             metrics: nil,
                                                             views: viewBindings)
            NSLayoutConstraint.activate(constraints)
            return sliderItem

        default:
            return nil
        }
    }
}
