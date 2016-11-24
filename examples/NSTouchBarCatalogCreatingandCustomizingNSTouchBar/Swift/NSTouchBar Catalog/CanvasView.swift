/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSView responsible for showing low level touch events.
 */

import Cocoa

class CanvasView: NSView {
    
    // This is to keep the current tracking touch (figure). 
    // The Touch Bar supports multiple touches but since it has only 30-point height,
    // it is reasonable to only track one touch.
    var trackingTouchIdentity: AnyObject?
    
    // Marked as dynamic for this property to support KVO.
    dynamic var trackingLocationString = ""
    
    // NSView by default doesn't accept first responder, so override this to allow it.
    override var acceptsFirstResponder: Bool { return true }
    
    override func touchesBegan(with event: NSEvent) {
        // trackingTouchIdentity != nil:
        // We are already tracking a touch, so ignore this new touch.
        if trackingTouchIdentity == nil {
            if let touch = event.touches(matching: .began, in: self).first, touch.type == .direct {
                trackingTouchIdentity = touch.identity
                let location = touch.location(in: self)
                trackingLocationString = String(format: "Began at: {x = %3.2f}", location.x)
            }
        }
        
        super.touchesBegan(with: event)
    }
    
    override func touchesMoved(with event: NSEvent) {
        if let trackingTouchIdentity = self.trackingTouchIdentity {
            if let trackingTouch = event.touches(matching: .moved, in: self).filter({
                $0.type == .direct && $0.identity.isEqual(trackingTouchIdentity)}).first {
                
                let location = trackingTouch.location(in: self)
                trackingLocationString = String(format: "Moved at: {x = %3.2f}", location.x)
            }
        }
        
        super.touchesMoved(with: event)
    }
    
    override func touchesEnded(with event: NSEvent) {
        if let trackingTouchIdentity = self.trackingTouchIdentity {
            if let trackingTouch = event.touches(matching: .ended, in: self).filter({
                $0.type == .direct && $0.identity.isEqual(trackingTouchIdentity)}).first {
                
                self.trackingTouchIdentity = nil
                let location = trackingTouch.location(in: self)
                trackingLocationString = String(format: "Ended at: {x = %3.2f}", location.x)
            }
        }
        
        super.touchesEnded(with: event)
    }
    
    override func touchesCancelled(with event: NSEvent) {

        if let trackingTouchIdentity = self.trackingTouchIdentity {
            if let trackingTouch = event.touches(matching: .cancelled, in: self).filter({
                $0.type == .direct && $0.identity.isEqual(trackingTouchIdentity)}).first {
                
                self.trackingTouchIdentity = nil
                let location = trackingTouch.location(in: self)
                trackingLocationString = String(format: "Canceled at: {x = %3.2f}", location.x)
                
                // The touch will be cancelled, so roll back to the status before touchBegan
                //...
            }
        }

        super.touchesCancelled(with: event)
    }
}
