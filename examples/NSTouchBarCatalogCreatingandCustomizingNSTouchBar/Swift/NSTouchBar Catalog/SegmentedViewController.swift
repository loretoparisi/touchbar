/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing segmented controls in an NSTouchBar instance.
 */

import Cocoa

class SegmentedViewController: NSViewController {
    // MARK: Action Functions
    
    @IBAction func segmentAction(_ sender: Any?) {
        if let segmented = sender as? NSSegmentedControl {
            print("\(#function) is called. Segment \(segmented.selectedSegment)!")
        }
    }
}
