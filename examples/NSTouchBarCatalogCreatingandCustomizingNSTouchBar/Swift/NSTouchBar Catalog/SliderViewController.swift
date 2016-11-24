/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSSliderTouchBarItem.
 */

import Cocoa

class SliderViewController: NSViewController {

    // The default class for a slider item is NSCustomTouchBarItem.
    // Make sure it is changed to NSSliderTouchBarItem if more slider item configuraiton is needed
    @IBOutlet weak var sliderItem: NSSliderTouchBarItem!
    
    @IBOutlet weak var feedbackLabel: NSTextField!
    
    // MARK: View Controller Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        sliderItem.label = "Slider"

        sliderItem.target = self
        sliderItem.action = #selector(sliderValueChanged(_:))
        
        // valueAccessoryWidth should have a .default value
        sliderItem.valueAccessoryWidth = .default
        
        // Set up slider properties in the storyboard doesn't seem to work
        // Remove this after it is fixed. TODO:
        sliderItem.slider.minValue = 0.0
        sliderItem.slider.maxValue = 100.0
    }
    
    deinit {
        sliderItem.slider.unbind(NSValueBinding)
    }
    
    // MARK: Action Functions
    
    @IBAction func useSliderAccessoryAction(_ sender: AnyObject) {
        guard let checkBox = sender as? NSButton else { return }
        
        if checkBox.state == NSOnState {
            sliderItem.minimumValueAccessory = NSSliderAccessory(image: NSImage(named: AssetNames.red.rawValue)!)
            sliderItem.maximumValueAccessory = NSSliderAccessory(image: NSImage(named: AssetNames.green.rawValue)!)
        }
        else {
            sliderItem.minimumValueAccessory = nil
            sliderItem.maximumValueAccessory = nil
        }
    }
    
    func sliderValueChanged(_ sender: Any) {
        if let sliderItem = sender as? NSSliderTouchBarItem {
            feedbackLabel.stringValue = String(format: "Slider Value = %ld", sliderItem.slider.intValue)
        }
    }
    
}
