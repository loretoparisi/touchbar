/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing custom view touch items.
 */

import Cocoa

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let customViewBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.customViewBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let touchEvent = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.touchEvent")
    static let panGR = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.panGR")
}

fileprivate enum InteractionTypeButtonTag: Int {
    case touchEvent = 1000, panGR = 1001
}

class CustomViewViewController: NSViewController {
    
    @IBOutlet weak var feedbackLabel: NSTextField!
    
    var selectedItemIdentifier: NSTouchBarItemIdentifier = .touchEvent
    
    // MARK: NSTouchBar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .customViewBar
        touchBar.defaultItemIdentifiers = [selectedItemIdentifier]
        touchBar.customizationAllowedItemIdentifiers = [selectedItemIdentifier]

        return touchBar
    }

    // MARK: Action Functions
    
    @IBAction func choiceAction(_ sender: AnyObject) {
        guard let button = sender as? NSButton,
            let choice = InteractionTypeButtonTag(rawValue:button.tag) else { return }
        
        switch choice {
        case .touchEvent:
            selectedItemIdentifier = .touchEvent
            
        case .panGR:
            selectedItemIdentifier = .panGR
        }
        
        touchBar = nil
    }
    
    // MARK: Gesture Recognizer
    
    func panGestureHandler(_ sender: NSGestureRecognizer?) {
        guard let currentItem = self.touchBar?.item(forIdentifier: selectedItemIdentifier),
            let itemView = currentItem.view, let panGR = sender else { return }
        
        var feedbackStr = "Pan Gesture: "
        let state = sender!.state
        
        switch state {
        case .began:
            feedbackStr += "Began"

        case .changed:
            feedbackStr += "Changed"

        case .ended:
            feedbackStr += "Ended"

        default:
            break
        }
        
        let location = panGR.location(in: itemView)
        feedbackStr += String(format: " {x = %3.2f}", location.x)
        
        feedbackLabel.stringValue = feedbackStr;
    }
    
    deinit {
        feedbackLabel.unbind(NSValueBinding)
    }
}

// MARK: NSTouchBarDelegate

extension CustomViewViewController: NSTouchBarDelegate {
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        
        switch identifier {
        case NSTouchBarItemIdentifier.touchEvent:
            let canvasView = CanvasView()
            canvasView.wantsLayer = true
            canvasView.layer?.backgroundColor = NSColor.blue.cgColor
            canvasView.allowedTouchTypes = .direct
            
            feedbackLabel.unbind(NSValueBinding)
            feedbackLabel.bind(NSValueBinding, to: canvasView, withKeyPath: #keyPath(CanvasView.trackingLocationString))
            
            let custom = NSCustomTouchBarItem(identifier: identifier)
            custom.view = canvasView
            
            return custom
            
        case NSTouchBarItemIdentifier.panGR:
            let view = NSView()
            view.wantsLayer = true
            view.layer?.backgroundColor = NSColor.gray.cgColor
            
            let panGestureRecognizer = NSPanGestureRecognizer()
            panGestureRecognizer.target = self
            panGestureRecognizer.action = #selector(panGestureHandler(_:))
            panGestureRecognizer.allowedTouchTypes = .direct
            view.addGestureRecognizer(panGestureRecognizer)
            
            let custom = NSCustomTouchBarItem(identifier: identifier)
            custom.view = view
            return custom
            
        default:
            return nil
        }
    }
}

