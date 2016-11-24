/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing different color picker items.
 */

import Cocoa

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let colorPickerBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.colorPickerBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let color = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.color")
    static let text = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.text")
    static let stroke = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.stroke")
}

fileprivate enum PickerTypeButtonTag: Int {
    case color = 1002, text = 1003, stroke = 1004
}

class ColorPickerViewController: NSViewController {
    
    @IBOutlet weak var customColors: NSButton!
    
    var selectedItemIdentifier: NSTouchBarItemIdentifier = .color
    
    // MARK: TouchBar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .colorPickerBar
        touchBar.defaultItemIdentifiers = [selectedItemIdentifier]
        touchBar.customizationAllowedItemIdentifiers = [selectedItemIdentifier]
        touchBar.principalItemIdentifier = selectedItemIdentifier
        
        return touchBar
    }

    // MARK: Action Functions
    
    @IBAction func choiceAction(_ sender: AnyObject) {
        guard let button = sender as? NSButton,
            let choice = PickerTypeButtonTag(rawValue:button.tag) else { return }
        
        switch choice {
        case .color:
            selectedItemIdentifier = .color
            
        case .text:
            selectedItemIdentifier = .text
            
        case .stroke:
            selectedItemIdentifier = .stroke
        }
        
        touchBar = nil
    }
    
    @IBAction func customColorsAction(_ sender: AnyObject) {
        touchBar = nil
    }

    func colorDidPick(_ colorPicker: NSColorPickerTouchBarItem) {
        print("Picked color: \(colorPicker.color)")
    }
}

// MARK: NSTouchBarDelegate

extension ColorPickerViewController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        
        let colorPicker: NSColorPickerTouchBarItem
        
        switch identifier {
        case NSTouchBarItemIdentifier.color:
            colorPicker = NSColorPickerTouchBarItem.colorPicker(withIdentifier: identifier)
            
        case NSTouchBarItemIdentifier.text:
            colorPicker = NSColorPickerTouchBarItem.textColorPicker(withIdentifier: identifier)
            
        case NSTouchBarItemIdentifier.stroke:
            colorPicker = NSColorPickerTouchBarItem.strokeColorPicker(withIdentifier: identifier)
            
        default:
            return nil
        }
        
        colorPicker.customizationLabel = "Color Picker"
        colorPicker.target = self
        colorPicker.action = #selector(colorDidPick(_:))
        
        if self.customColors.state == NSOnState {
            let colorList = ["Red": NSColor.red, "Green": NSColor.green, "Blue": NSColor.blue]
            colorPicker.colorList = NSColorList()
            
            for (key, color) in colorList {
                colorPicker.colorList.setColor(color, forKey: key)
            }
        }
        
        return colorPicker
    }
}
