/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSSharingServicePickerTouchBarItem in an NTouchBar instance.
 */

import Cocoa

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let servicesBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.servicesBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let services = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.services")
}


class ServicesViewController: NSViewController {
    var catImage = NSImage(named: AssetNames.cat.rawValue)!
 
    // MARK: NSTouchBar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .servicesBar
        touchBar.defaultItemIdentifiers = [.services]
        touchBar.customizationAllowedItemIdentifiers = [.services]
        touchBar.principalItemIdentifier = .services
        
        return touchBar
    }
}


// MARK: NSTouchBarDelegate

extension ServicesViewController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        guard identifier == .services else { return nil }
        
        let services = NSSharingServicePickerTouchBarItem(identifier: identifier)
        services.delegate = self
        
        return services
    }
}

// MARK: NSSharingServicePickerTouchBarItemDelegate

extension ServicesViewController: NSSharingServicePickerTouchBarItemDelegate {
    func items(for pickerTouchBarItem: NSSharingServicePickerTouchBarItem) -> [Any] {
        return [catImage]
    }
}

extension ServicesViewController: NSSharingServiceDelegate {

    // MARK: NSSharingServicePickerDelegate

    func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, delegateFor sharingService: NSSharingService) -> NSSharingServiceDelegate? {
        return self
    }
    
    // MARK: NSSharingServiceDelegate

    func sharingService(_ sharingService: NSSharingService, sourceFrameOnScreenForShareItem item: Any) -> NSRect {
        return NSMakeRect(0, 0, catImage.size.width, catImage.size.height)
    }
    
    func sharingService(_ sharingService: NSSharingService, transitionImageForShareItem item: Any, contentRect: UnsafeMutablePointer<NSRect>) -> NSImage? {
        return catImage
    }
    
    func sharingService(_ sharingService: NSSharingService, sourceWindowForShareItems items: [Any], sharingContentScope: UnsafeMutablePointer<NSSharingContentScope>) -> NSWindow? {
        return self.view.window
    }
}


