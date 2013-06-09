//
//  JRAppDelegate.h
//  Assign
//
//  Created by Jan-Yves on 21/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JRStatusItem, JRPreferencesController, JRAssignWindowController, JRAboutController, JRFolderCollection, SUUpdater;

@interface JRAppDelegate : NSObject <NSApplicationDelegate>{
    JRAssignWindowController *assign;
    JRPreferencesController *preferences;
    JRAboutController *about;
    NSUserDefaults *defaults;
    int scansInProgress;
    SUUpdater *updater;
}

@property JRStatusItem *statusItem;
@property NSMutableArray *folderCollections;

#pragma mark Scan-related activities
-(void)increaseScansInProgress;
-(void)decreaseScansInProgress;

#pragma mark Defaults-related activities
-(void)saveFolderCollections;

//Theme virtual setter/getter
-(NSString *)theme;
-(void)setTheme:(NSString *)theme;

#pragma mark Window manipulation
-(void)openAssignWindowForFolderCollection:(JRFolderCollection *)collection;
-(IBAction)displayAssignWindow:(id)sender;
-(IBAction)disappearAssignWindow:(id)sender;
-(IBAction)displayPreferences:(id)sender;
-(IBAction)displayAbout:(id)sender;

#pragma mark -
-(NSArray *)retrieveFinderSelection;

#pragma mark Login items
-(BOOL)startsAtLogin;
-(void)setStartAtLogin:(BOOL)startAtLogin;

#pragma mark folder collections
-(void)addFolderCollection:(JRFolderCollection *)fc;
-(BOOL)removeFolderCollection:(JRFolderCollection *)fc;

#pragma mark Update stuff
-(void)checkForUpdates:(id)sender;
@end
