/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom NSView responsible for showing low level touch events.
 */

#import "CustomView.h"

@interface CustomView ()

@property NSInteger selection;
@property NSInteger oldSelection;
@property id trackingTouchIdentity;

@end


#pragma mark - CustomView

@implementation CustomView

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)touchesBeganWithEvent:(NSEvent *)event
{
    // We are already tracking a touch, so this must be a new touch.
    // What should we do? Cancel or ignore.
    //
    if (self.trackingTouchIdentity == nil)
    {
        NSSet<NSTouch *> *touches = [event touchesMatchingPhase:NSTouchPhaseBegan inView:self];
        // Note: Touches may contain 0, 1 or more touches.
        // What to do if there are more than one touch?
        // In this example, randomly pick a touch to track and ignore the other one.
        
        NSTouch *touch = touches.anyObject;
        if (touch != nil)
        {
            if (touch.type == NSTouchTypeDirect)
            {
                _trackingTouchIdentity = touch.identity;
                
                // Remember the selection value at start of tracking in case we need to cancel.
                _oldSelection = self.selection;
                
                NSPoint location = [touch locationInView:self];
                self.trackingLocationString = [NSString stringWithFormat:@"Began at: {x = %3.2f}", location.x];
            }
        }
    }
    
    [super touchesBeganWithEvent:event];
}

- (void)touchesMovedWithEvent:(NSEvent *)event
{
    if (self.trackingTouchIdentity)
    {
        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseMoved inView:self])
        {
            if (touch.type == NSTouchTypeDirect && [_trackingTouchIdentity isEqual:touch.identity])
            {
                NSPoint location = [touch locationInView:self];
                self.trackingLocationString = [NSString stringWithFormat:@"Moved at: {x = %3.2f}", location.x];
                
                break;
            }
        }
    }
    
    [super touchesMovedWithEvent:event];
}

- (void)touchesEndedWithEvent:(NSEvent *)event
{
    if (self.trackingTouchIdentity)
    {
        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseEnded inView:self])
        {
            if (touch.type == NSTouchTypeDirect && [_trackingTouchIdentity isEqual:touch.identity])
            {
                // Finshed tracking successfully.
                _trackingTouchIdentity = nil;
                
                NSPoint location = [touch locationInView:self];
                self.trackingLocationString = [NSString stringWithFormat:@"Ended at: {x = %3.2f}", location.x];
                break;
            }
        }
    }

    [super touchesEndedWithEvent:event];
}

- (void)touchesCancelledWithEvent:(NSEvent *)event
{    
    if (self.trackingTouchIdentity)
    {
        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseMoved inView:self])
        {
            if (touch.type == NSTouchTypeDirect && [self.trackingTouchIdentity isEqual:touch.identity])
            {
                // CANCEL
                // This can happen for a number of reasons.
                // # A gesture recognizer started recognizing a touch.
                // # The underlying touch context changed (User Cmd-Tabbed while interacting with this view).
                // # The hardware itself decided to cancel the touch.
                // Whatever the reason, but things back the way they were, in this example, reset the selection.
                //
                _trackingTouchIdentity = nil;
                
                self.selection = self.oldSelection;
                
                NSPoint location = [touch locationInView:self];
                self.trackingLocationString = [NSString stringWithFormat:@"Canceled at: {x = %3.2f}", location.x];
            }
        }
    }
    
    [super touchesCancelledWithEvent:event];
}

@end
