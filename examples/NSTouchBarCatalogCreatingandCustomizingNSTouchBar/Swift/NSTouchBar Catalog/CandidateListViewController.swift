/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSCandidateListTouchBarItem in an NSTouchBar instance, used for picking contacts as a use case.
 */

import Cocoa
import Contacts

fileprivate extension NSTouchBarCustomizationIdentifier {
    static let candidateListBar = NSTouchBarCustomizationIdentifier("com.TouchBarCatalog.candidateListBar")
}

fileprivate extension NSTouchBarItemIdentifier {
    static let candidateList = NSTouchBarItemIdentifier("com.TouchBarCatalog.TouchBarItem.candidateList")
}

class CandidateListViewController: NSViewController {
    
    var candidateListItem: NSCandidateListTouchBarItem<CNContact>!
    
    @IBOutlet weak var textField: NSTextField!
    
    // MARK: View Controller Life Cycle
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // We want to use our candidate item, instead of NSTextField's.
        textField.isAutomaticTextCompletionEnabled = false
    }
    
    // MARK: NSTouchBar
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .candidateListBar
        touchBar.defaultItemIdentifiers = [.candidateList]
        touchBar.customizationAllowedItemIdentifiers = [.candidateList]

        return touchBar
    }
    
    func candidateName(from contact: CNContact) -> String {
        if contact.givenName.characters.count > 0 {
            if contact.familyName.characters.count > 0 {
                return contact.givenName + " " + contact.familyName
            }
            else {
                return contact.givenName
            }
        }
        else {
            return contact.familyName
        }
    }

    func candidateEmail(from contact: CNContact) -> String {
        if contact.emailAddresses.count > 0 {
            return contact.emailAddresses[0].value as String
        }
        else {
            return "None"
        }
    }
    
    func candidates(matching name: String) -> [CNContact] {
        let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                           CNContactFamilyNameKey as CNKeyDescriptor,
                           CNContactEmailAddressesKey as CNKeyDescriptor]

        do {
            let contacts = try CNContactStore().unifiedContacts(matching: CNContact.predicateForContacts(matchingName: name), keysToFetch: keysToFetch)
            return contacts
        }
        catch {
            print("Caught an error but not handle it at \(#function): \(error)!")
        }
        
        return []
    }
    
    override func controlTextDidChange(_ notification: Notification) {
        guard let textField = notification.object as? NSTextField else { return }
        
        var candidates: [CNContact] = []
        
        let range: NSRange
        if let text = view.window?.fieldEditor(false, for: textField) {
            range = text.selectedRange
        }
        else {
            range = NSMakeRange(0, 0)
        }

        if !textField.stringValue.isEmpty {
            let authorizeStatus = CNContactStore.authorizationStatus(for: .contacts)
            
            if authorizeStatus == .notDetermined {
                CNContactStore().requestAccess(for: .contacts) { granted, error in
                    if granted {
                        candidates = self.candidates(matching: textField.stringValue)
                    }
                }
            }
            else if authorizeStatus == .authorized {
                candidates = self.candidates(matching: textField.stringValue)
            }
        }
        
        self.candidateListItem.setCandidates(candidates, forSelectedRange: range, in: nil)
    }
}

// MARK: NSTouchBarDelegate

extension CandidateListViewController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        guard identifier == .candidateList else { return nil }
        
        candidateListItem = NSCandidateListTouchBarItem<CNContact>(identifier: identifier)
        candidateListItem.delegate = self
        candidateListItem.customizationLabel = "Candidate List"
        
        candidateListItem.attributedStringForCandidate = { [unowned self] (candidate, index) -> NSAttributedString in
            return NSAttributedString(string: self.candidateName(from: candidate) + "\r" + self.candidateEmail(from: candidate))
        }

        return candidateListItem
    }
}

// MARK: NSCandidateListTouchBarItemDelegate

extension CandidateListViewController: NSCandidateListTouchBarItemDelegate {
    func candidateListTouchBarItem(_ anItem: NSCandidateListTouchBarItem<AnyObject>, endSelectingCandidateAt index: Int) {
        guard anItem == candidateListItem && anItem.candidates.count > index else { return }

        let contact = candidateListItem.candidates[index]
        textField.stringValue = candidateName(from: contact) + " <" + candidateEmail(from: contact) + ">"
    }
}
