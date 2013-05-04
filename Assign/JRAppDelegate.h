//
//  JRAppDelegate.h
//  Assign
//
//  Created by Jan-Yves on 21/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JRStatusItem;
@class JRPreferencesController;
@class JRAssignWindowController;
@class JRFolderCollection;


@interface JRAppDelegate : NSObject <NSApplicationDelegate>{
    JRAssignWindowController *assign;
    JRPreferencesController *preferences;
    NSUserDefaults *defaults;
}

@property JRStatusItem *statusItem;
@property NSMutableArray *folderCollections;
@property BOOL themeIsLight;

#pragma mark Defaults-related activities
-(void)saveFolderCollectionsToDefaults;
//Theme virtual setter/getter
-(NSString *)theme;
-(void)setTheme:(NSString *)theme;

#pragma mark Window manipulation
-(void)openAssignWindowForFolderCollection:(JRFolderCollection *)collection;
-(IBAction)displayAssignWindow:(id)sender;
-(IBAction)disappearAssignWindow:(id)sender;
-(IBAction)displayPreferences:(id)sender;

#pragma mark -
-(NSArray *)retrieveFinderSelection;

#pragma mark Login items
-(BOOL)startsAtLogin;
-(void)setStartAtLogin:(BOOL)startAtLogin;

#pragma mark folder collections
-(void)addFolderCollection:(JRFolderCollection *)fc;
-(BOOL)removeFolderCollection:(JRFolderCollection *)fc;
@end
