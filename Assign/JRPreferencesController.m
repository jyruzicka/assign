//
//  JRPreferencesWindowController.m
//  Assign
//
//  Created by Jan-Yves on 3/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRPreferencesController.h"
#import "JRShortcutControl.h"
#import "JRFolderCollection.h"
#import "JRShortcutControl.h"
#import "JRAppDelegate.h"
#import "JRKeyCombo.h"

@implementation JRPreferencesController
const NSString *kShortcutControlLabel = @"<ESC to cancel>";

#pragma mark Initializers and Factories

-(id)init {
    self = [super init];
    if (self) {
        DLog(@"Initialising prefs controller");
        delegate = (JRAppDelegate *)[NSApp delegate];
        self.targetCollection = nil;
        
        [NSBundle loadNibNamed:@"Preferences" owner:self];
        [self populateFieldsBasedOnTableSelection];
        [themePopUp selectItemWithTitle:[delegate theme]];
        
        if ([delegate startsAtLogin])
            [startOnLogin setState:NSOnState];
        else
            [startOnLogin setState:NSOffState];
        
        [window setNextResponder:self];
    }
    return self;
}

#pragma mark -
#pragma mark IBActions

-(IBAction)shortcutButtonClicked:(id)sender {
    if (!selectingShortcut){
        selectingShortcut = YES;
        [shortcutControl setTitle:(NSString *)kShortcutControlLabel];
    }
}

-(IBAction)browseForCatalogueRoot:(id)sender {
    NSOpenPanel *panel = [self openPanel];
    if ([panel runModal] == NSOKButton) {
        self.targetCollection.rootFolder = [panel URLs][0];
        [catalogueField setStringValue:[[self.targetCollection rootFolder] path]];

        [self saveAndRefreshPreferences];
    }
}

-(IBAction)startOnLoginClicked:(id)sender {
    if ([(NSButton *)sender state] == NSOnState)
        [delegate setStartAtLogin:YES];
    else
        [delegate setStartAtLogin:NO];

    [self saveAndRefreshPreferences];
}

-(IBAction)addCollectionButtonClicked:(id)sender {
    NSOpenPanel *panel = [self openPanel];
    if ([panel runModal] == NSOKButton) {
        JRFolderCollection *fc = [JRFolderCollection folderCollectionWithURL:[panel URLs][0]];
        [delegate addFolderCollection:fc];
        
        [self saveAndRefreshPreferences];
    }
}

-(IBAction)removeCollectionButtonClicked:(id)sender {
    [delegate removeFolderCollection:self.targetCollection];
    self.targetCollection = nil;
    
    [self saveAndRefreshPreferences];
}

-(IBAction)themePopUpClicked:(id)sender {
    [delegate setTheme:[(NSPopUpButton *)sender titleOfSelectedItem]];
}

-(IBAction)rescanPopUpClicked:(id)sender {
    [self.targetCollection setRescanInterval:(int)[(NSPopUpButton *) sender selectedTag]];
}

-(IBAction)rescanButtonClicked:(id)sender {
    [self.targetCollection backgroundScanForFolders];
}

#pragma mark -
#pragma mark User interaction

/* Called when we make a change to the preferences
 * and need to save + refresh the window.
 */
-(void)saveAndRefreshPreferences {
    [collectionTableView reloadData];
}

-(void)cancelOperation:(id)sender {
    DLog(@"Cancel Operation received");
    if (selectingShortcut) {
        selectingShortcut = NO;
        [shortcutControl setTitle:[[self.targetCollection keyCombo] asString]];
    }
    else
        [window close];
}

-(void)keyDown:(NSEvent *)theEvent
{
    if (selectingShortcut && [theEvent modifierFlags] != 0 && [theEvent modifierFlags] != NSShiftKeyMask) {
        [self.targetCollection registerHotkey:[JRKeyCombo keyComboWithEvent:theEvent]];
        [shortcutControl setTitle:[[self.targetCollection keyCombo] asString]];
        selectingShortcut = NO;
        
        [self saveAndRefreshPreferences];
    }
    else
        [super keyDown:theEvent];
}

-(void)flagsChanged:(NSEvent *)theEvent {
    if (selectingShortcut){
        NSString *modifiers = [self modifierKeysForEvent:theEvent includeShift:YES];
        if ([modifiers length] == 0) //No modifiers
            modifiers = (NSString *)kShortcutControlLabel;
        
        [shortcutControl setTitle:modifiers];
    }
}

-(void)toggleVisible {
    DLog(@"toggleVisible called! Window is: %@", window);
    if ([window isKeyWindow])
        [window orderOut:self];
    else {
        [NSApp activateIgnoringOtherApps:YES];
        [window makeKeyAndOrderFront:self];
    }

}

-(void)populateFieldsBasedOnTableSelection {
    if (self.targetCollection) {
        [shortcutControl setTitle:[[self.targetCollection keyCombo] asString]];
        [catalogueField setStringValue:[[self.targetCollection rootFolder] path]];
        [rescanPopUp selectItemWithTag:[self.targetCollection rescanInterval]];
        [shortcutControl setEnabled:YES];
        [selectFolderButton setEnabled:YES];
        [removeCollectionButton setEnabled:YES];
        [rescanPopUp setEnabled:YES];
        [rescanButton setEnabled: YES];
    }
    else
    {
        [shortcutControl setTitle:@""];
        [catalogueField setStringValue:@""];
        [rescanPopUp selectItem:nil];
        
        [shortcutControl setEnabled:NO];
        [selectFolderButton setEnabled:NO];
        [removeCollectionButton setEnabled:NO];
        [rescanPopUp setEnabled:NO];
        [rescanButton setEnabled: NO];
    }
}

#pragma mark -
#pragma mark NSTableDataSource and NSTableViewDelegate methods
-(NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [[delegate folderCollections] count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    JRFolderCollection *fc = [delegate folderCollections][row];
    if (tableColumn == collectionPathColumn)
        return [[fc rootFolder] lastPathComponent];
    else
        return [[fc keyCombo] asString];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selectedRow = [collectionTableView selectedRow];
    if (selectedRow == -1)
        self.targetCollection = nil;
    else
        self.targetCollection = [delegate folderCollections][selectedRow];
    
    [self populateFieldsBasedOnTableSelection];
}

#pragma mark Scanning
-(void)startScanning {
    [rescanIndicator startAnimation:self];
}

-(void)stopScanning {
    [rescanIndicator stopAnimation:self];
}

#pragma mark -
#pragma mark Private methods

-(NSMutableString *)modifierKeysForEvent:(NSEvent *)theEvent includeShift:(BOOL)shift{
    unsigned long flags = [theEvent modifierFlags];
    NSMutableString *modifiers = [NSMutableString string];
    if ((flags & NSCommandKeyMask) == NSCommandKeyMask)
        [modifiers appendString:@"⌘"];
    if ((flags & NSAlternateKeyMask) == NSAlternateKeyMask)
        [modifiers appendString:@"⌥"];
    if ((flags & NSControlKeyMask) == NSControlKeyMask)
        [modifiers appendString:@"^"];
    if ((flags & NSShiftKeyMask) == NSShiftKeyMask && shift)
        [modifiers appendString:@"⇧"];
    
    return modifiers;
}

-(BOOL) shiftDown:(NSEvent *)theEvent {
    return ([theEvent modifierFlags] & NSShiftKeyMask) == NSShiftKeyMask;
}

-(NSOpenPanel *)openPanel {
    NSOpenPanel *open = [NSOpenPanel openPanel];
    [open setCanChooseDirectories:YES];
    [open setCanChooseFiles:NO];
    [open setAllowsMultipleSelection:NO];
    [open setDirectoryURL:[self.targetCollection rootFolder]];
    [open setMessage:@"Select a folder to use as your catalogue."];
    return open;
}
@end
