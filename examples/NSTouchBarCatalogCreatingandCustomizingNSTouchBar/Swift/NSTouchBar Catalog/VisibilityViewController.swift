/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing visibility priority feature of NSTouchBarItem.
 */

import Cocoa

class VisibilityViewController: NSViewController {

    enum TextFieldTag: Int {
        case textField1 = 1, textField2 = 2, textField3 = 3, textField4 = 4
        case textField5 = 5, textField6 = 6, textField7 = 7
    }
    
    dynamic var priority1: Float = 0
    dynamic var priority2: Float = 0
    dynamic var priority3: Float = 0
    dynamic var priority4: Float = 0
    dynamic var priority5: Float = 0
    dynamic var priority6: Float = 0
    dynamic var priority7: Float = 0

    @IBOutlet weak var button1: NSTouchBarItem!
    @IBOutlet weak var button2: NSTouchBarItem!
    @IBOutlet weak var button3: NSTouchBarItem!
    @IBOutlet weak var button4: NSTouchBarItem!
    @IBOutlet weak var button5: NSTouchBarItem!
    @IBOutlet weak var button6: NSTouchBarItem!
    @IBOutlet weak var button7: NSTouchBarItem!
    
    @IBOutlet weak var lastButtonItem: NSTouchBarItem!
    @IBOutlet weak var lastButtonWidthSlider: NSSlider!

    var lastButtonSizeConstraint: NSLayoutConstraint!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        for tag in TextFieldTag.textField1.rawValue...TextFieldTag.textField7.rawValue {
            
            if let textField = self.view.viewWithTag(tag) as? NSTextField {
                textField.isAutomaticTextCompletionEnabled = false
            }
        }
        (self.lastButtonItem.view as! NSButton).bezelColor = NSColor.red
        (self.button3.view as! NSButton).bezelColor = NSColor.darkGray
        (self.button4.view as! NSButton).bezelColor = NSColor.darkGray
        (self.button5.view as! NSButton).bezelColor = NSColor.darkGray
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        
        let lastButton = self.lastButtonItem.view as! NSButton
        self.lastButtonSizeConstraint = lastButton.widthAnchor.constraint(equalToConstant: CGFloat(self.lastButtonWidthSlider.floatValue))
        self.lastButtonSizeConstraint.isActive = true
    }
    
    func updateVisibility(sender: NSTextField) {
        
        guard let currentTextField = TextFieldTag(rawValue: sender.tag) else { return }
        let itemToChange: NSTouchBarItem
        
        switch currentTextField {
            case .textField1: itemToChange = self.button1
            case .textField2: itemToChange = self.button2
            case .textField3: itemToChange = self.button3
            case .textField4: itemToChange = self.button4
            case .textField5: itemToChange = self.button5
            case .textField6: itemToChange = self.button6
            case .textField7: itemToChange = self.button7
        }
        itemToChange.visibilityPriority = NSTouchBarItemPriority(rawValue: sender.floatValue)
    }
    
    override func controlTextDidChange(_ notification: Notification) {
        
        guard let textField = notification.object as? NSTextField else { return }
        self.updateVisibility(sender: textField)
    }
    
    // MARK: - Action Functions
    
    @IBAction func editFieldAction(_ sender: AnyObject) {
        
        guard let textField = sender as? NSTextField else { return }
        self.updateVisibility(sender: textField)
    }

    @IBAction func sliderAction(_ sender: AnyObject) {
        
        self.lastButtonSizeConstraint.constant = CGFloat(self.lastButtonWidthSlider.floatValue)
    }
}

class PriorityValueFormatter: NumberFormatter {
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                 for string: String,
                                 errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        if string == "" {
            obj?.pointee = "0" as AnyObject
            return true
        }
        if string == self.minusSign {
            obj?.pointee = string as AnyObject
            return true
        }
        return super.getObjectValue(obj, for: string, errorDescription: error)
    }
    
    override func string(for obj: Any?) -> String? {
        
        if let letter = obj as? String, letter == self.minusSign {
            return letter
        }
        return super.string(for: obj)
    }

    override func editingString(for obj: Any) -> String? {
        
        if let letter = obj as? String, letter == self.minusSign {
            return letter
        }
        return super.editingString(for: obj)
    }
}
