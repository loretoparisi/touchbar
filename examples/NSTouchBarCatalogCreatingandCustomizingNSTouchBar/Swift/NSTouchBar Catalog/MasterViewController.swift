/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The master view controller giving access to all test cases in this sample.
 */

import Cocoa

class MasterViewController: NSViewController, NSTableViewDelegate {
    struct TestCaseKey {
        static let root = "tests"
        static let name = "testName"
        static let kind = "testKind"
    }
    
    @IBOutlet weak var contentArray: NSArrayController!
    
    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if NSClassFromString("NSTouchBar") != nil {
            guard let fileURL = Bundle.main.url(forResource: "Tests", withExtension: "plist"),
                let plistContent = NSDictionary(contentsOf: fileURL),
                let testData = plistContent[TestCaseKey.root] as? Array<Dictionary<String, String>> else { return }
            
            tableView.delegate = self
            contentArray.add(contentsOf: testData)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MasterViewController.selectionDidChange(_:)),
                                               name: .NSTableViewSelectionDidChange,
                                               object: tableView)
    
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    
        // Start by showing the first button example.
        contentArray.setSelectionIndex(0)
    }
    
    func selectionDidChange(_ notification: Notification) {
        guard 0...self.tableView.numberOfRows ~= self.tableView.selectedRow else { return }
        
        guard let arrangedObjects = contentArray.arrangedObjects as? Array<AnyObject>,
            let testCase = arrangedObjects[tableView.selectedRow] as? Dictionary<String, String>,
            let storyboardName = testCase[TestCaseKey.kind]
            else { return }
        
        guard let viewController = NSStoryboard(name: storyboardName, bundle: nil).instantiateInitialController() as? NSViewController else { return }
        
        let splitViewController = view.window!.contentViewController as! NSSplitViewController
        let splitViewItem = NSSplitViewItem(viewController: viewController)
        splitViewController.splitViewItems[1] =  splitViewItem

        // Bind the NSTouchBar instance of master view controller to the one of the detal view controller
        // so that the bar always shows up whoever the first responder is.
        //
        unbind(#keyPath(touchBar)) // unbind first
        bind(#keyPath(touchBar), to: viewController, withKeyPath: #keyPath(touchBar), options: nil)
    }
    
    deinit {
        self.unbind(#keyPath(touchBar))
    }
}
