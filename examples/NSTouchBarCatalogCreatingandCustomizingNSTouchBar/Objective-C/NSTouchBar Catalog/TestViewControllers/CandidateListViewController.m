/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller responsible for showing NSCandidateListTouchBarItem in an NSTouchBar instance, used for picking contacts as a use case.
 */

#import "CandidateListViewController.h"
@import Contacts;

static NSTouchBarItemIdentifier CandidateItemIdentifier = @"com.TouchBarCatalog.candidateList";
static NSTouchBarCustomizationIdentifier CandidateCustomizationIdentifier = @"com.TouchBarCatalog.candidateListViewController";

@interface CandidateListViewController () <NSTouchBarDelegate, NSCandidateListTouchBarItemDelegate, NSTextViewDelegate, NSTextFieldDelegate>

@property (strong) NSCandidateListTouchBarItem<CNContact *> *candidateListItem;
@property (weak) IBOutlet NSTextField *textField;

@end


#pragma mark -

@implementation CandidateListViewController

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    // We want to use our candidate item, instead of NSTextField's.
    self.textField.automaticTextCompletionEnabled = NO;
    
    // Note: If you ever want to show the NSTouchBar instance within this view controller do this:
    // [self.view.window makeFirstResponder:self.view];
}

- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    
    bar.customizationIdentifier = CandidateCustomizationIdentifier;
    
    // Set the default ordering of items.
    bar.defaultItemIdentifiers = @[CandidateItemIdentifier, NSTouchBarItemIdentifierOtherItemsProxy];
    
    bar.customizationAllowedItemIdentifiers = @[CandidateItemIdentifier];
    
    bar.principalItemIdentifier = CandidateItemIdentifier;

    return bar;
}

- (NSString *)nameFromContact:(CNContact *)contact
{
    NSMutableString *nameStr = [NSMutableString string];
    if (contact.givenName != nil && contact.givenName.length > 0)
    {
        nameStr = [NSMutableString stringWithFormat:@"%@ ", contact.givenName];
    }
    if (contact.familyName != nil && contact.familyName.length > 0)
    {
        [nameStr appendString:contact.familyName];
    }
    return nameStr;
}

- (NSString *)emailFromContact:(CNContact *)contact
{
    NSString *emailStr = @"none";
    if (contact.emailAddresses != nil && contact.emailAddresses.count > 0)
    {
        CNLabeledValue *emailValue = contact.emailAddresses[0];
        emailStr = emailValue.value;
    }
    return emailStr;
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if ([identifier isEqualToString:CandidateItemIdentifier])
    {
        _candidateListItem = [[NSCandidateListTouchBarItem alloc] initWithIdentifier:CandidateItemIdentifier];
        self.candidateListItem.delegate = self;
        
        self.candidateListItem.customizationLabel = @"Candidate List";
        
        // Determine the appropriate descriptive string for this candidate.
        NSAttributedString *(^contactsCandidateStr)(CNContact *candidateContact, NSInteger index) = ^(CNContact *candidateContact, NSInteger index) {
            if (candidateContact != nil)
            {
                NSString *nameStr = [self nameFromContact:candidateContact];
                NSString *emailStr = [self emailFromContact:candidateContact];
                
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\r%@", nameStr, emailStr]];
            }
            else
            {
                return [[NSAttributedString alloc] initWithString:@""];
            }
            
        };
        self.candidateListItem.attributedStringForCandidate = contactsCandidateStr;
        
        return self.candidateListItem;
    }
    return nil;
}


#pragma mark - NSControlSubclassNotifications

- (void)searchForCandidatesWithString:(NSString *)string
{
    NSError *error = nil;
    CNContactStore *addressBook = [[CNContactStore alloc] init];
    NSPredicate *searchPredicate = [CNContact predicateForContactsMatchingName:string];
    
    NSArray<CNContact *> *foundContacts = [addressBook unifiedContactsMatchingPredicate:searchPredicate keysToFetch:@[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey] error:&error];
    
    NSText *text = [self.view.window fieldEditor:NO forObject:self.textField];
    NSRange range = text.selectedRange;
    [self.candidateListItem setCandidates:foundContacts forSelectedRange:range inString:nil];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    NSTextField *textField = (NSTextField *)notification.object;

    if (textField.stringValue.length > 0)
    {
        CNEntityType entityType = CNEntityTypeContacts;
        if ([CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
        {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted)
                {
                    [self searchForCandidatesWithString:textField.stringValue];
                }
            }];
        }
        else if ([CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusAuthorized)
        {
            [self searchForCandidatesWithString:textField.stringValue];
        }
    }
    else
    {
        [self.candidateListItem setCandidates:@[] forSelectedRange:NSMakeRange(0, 0) inString:nil];
    }
}


#pragma mark - NSCandidateListTouchBarItemDelegate

// Invoked when -candidateListVisible changed the visibility state.
- (void)candidateListTouchBarItem:(NSCandidateListTouchBarItem *)anItem changedCandidateListVisibility:(BOOL)isVisible
{
    //..
}

- (void)candidateListTouchBarItem:(NSCandidateListTouchBarItem *)anItem beginSelectingCandidateAtIndex:(NSInteger)index
{
    //..
}

// Invoked when user moves from touching one candidate in the bar to another.
- (void)candidateListTouchBarItem:(NSCandidateListTouchBarItem *)anItem changeSelectionFromCandidateAtIndex:(NSInteger)previousIndex toIndex:(NSInteger)index
{
    //..
}

// Invoked when user stops touching candidates in the bar. If index==NSNotFound, user didn't select any candidate.
- (void)candidateListTouchBarItem:(NSCandidateListTouchBarItem *)anItem endSelectingCandidateAtIndex:(NSInteger)index
{
    if (anItem == self.candidateListItem)
    {
        CNContact *candidateContact = self.candidateListItem.candidates[index];
        NSString *nameStr = [self nameFromContact:candidateContact];
        NSString *emailStr = [self emailFromContact:candidateContact];
        self.textField.stringValue = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@ <%@>", nameStr, emailStr]];
    }
}

@end
