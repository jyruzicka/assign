//
//  JRPreferencesWindowController.h
//  Assign
//
//  Created by Jan-Yves on 3/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JRFolderCollection, JRAppDelegate, JRKeyCombo, JRShortcutControl;

@interface JRPreferencesController : NSResponder <NSTableViewDataSource,NSTableViewDelegate>{
    // IBOutlets and related nibstuff
    IBOutlet NSWindow *window;
    IBOutlet JRShortcutControl *shortcutControl;
    IBOutlet NSButton *selectFolderButton;
    IBOutlet NSTextField *catalogueField;
    IBOutlet NSButton *startOnLogin;
    IBOutlet NSButton *removeCollectionButton;
    IBOutlet NSTableView *collectionTableView;
    IBOutlet NSTableColumn *collectionPathColumn;
    IBOutlet NSTableColumn *collectionAbbreviationColumn;
    IBOutlet NSPopUpButton *themePopUp;
    IBOutlet NSPopUpButton *rescanPopUp;
    IBOutlet NSButton *rescanButton;
    IBOutlet NSProgressIndicator *rescanIndicator;
    
    // Handy to have around
    JRAppDelegate *delegate;
    BOOL selectingShortcut;
}
@property JRFolderCollection *targetCollection;

-(id)init;
-(void)toggleVisible;
-(void)populateFieldsBasedOnTableSelection;
-(void)saveAndRefreshPreferences;

-(IBAction)shortcutButtonClicked:(id)sender;
-(IBAction)browseForCatalogueRoot:(id)sender;
-(IBAction)startOnLoginClicked:(id)sender;
-(IBAction)addCollectionButtonClicked:(id)sender;
-(IBAction)removeCollectionButtonClicked:(id)sender;
-(IBAction)themePopUpClicked:(id)sender;
-(IBAction)rescanPopUpClicked:(id)sender;
-(IBAction)rescanButtonClicked:(id)sender;

//NSTableViewDataSource stuff
-(NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

#pragma mark Scanning
-(void)startScanning;
-(void)stopScanning;
@end
