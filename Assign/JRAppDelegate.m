//
//  JRAppDelegate.m
//  Assign
//
//  Created by Jan-Yves on 21/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRAppDelegate.h"

#import "Finder.h"

#import "JRMenu.h"
#import "JRStatusItem.h"

#import "JRFolderCollection.h"
#import "JRKeyCombo.h"

#import "JRPreferencesController.h"
#import "JRAssignWindowController.h"


@implementation JRAppDelegate

#pragma mark Inherited methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    defaults = [NSUserDefaults standardUserDefaults];
    self.statusItem = [[JRStatusItem alloc] init];
    [self loadFolderCollectionsFromDefaults];
}

//Runs when it loses focus
-(void)applicationDidResignActive:(NSNotification *)notification {
    [self disappearAssignWindow:notification];
    DLog(@"Lost focus");
}

#pragma mark Scan-related activities
-(void)increaseScansInProgress {
    scansInProgress++;
    if (scansInProgress == 1) [self.statusItem startScanning];
}

-(void)decreaseScansInProgress {
    scansInProgress--;
    if (scansInProgress == 0) [self.statusItem stopScanning];
}

#pragma mark -
#pragma mark Defaults-related

-(void)saveFolderCollectionsToDefaults {
    DLog(@"Defaults save called.");
    NSMutableArray *dicts = [NSMutableArray array];
    for (JRFolderCollection *fc in [self folderCollections])
        [dicts addObject:[fc toDictionary]];
    
    [defaults setObject:dicts forKey:@"folderCollections"];
}

//Load folderCollections
-(void)loadFolderCollectionsFromDefaults {
    self.folderCollections = [NSMutableArray array];
    
    NSArray *allCollections = [defaults arrayForKey:@"folderCollections"];
    if (allCollections) { // We've saved some data to disk - so let's use it
        for (NSDictionary *d in allCollections) {
            JRFolderCollection *fc = [JRFolderCollection folderCollectionWithDictionary:d];
            [self.folderCollections addObject:fc];
        }
    }
    else // Make defaults
        [self.folderCollections addObject: [JRFolderCollection defaultFolderCollection]];
}

// Virtual getter/setter for defaults
-(NSString *)theme {
    NSString *theme = [defaults stringForKey:@"theme"];
    if (!theme) theme = @"Light";
    DLog(@"Returning theme: %@", theme);
    return theme;
}

-(void)setTheme:(NSString *)theme {
    [defaults setObject:theme forKey:@"theme"];
    if (assign) [assign setTheme:theme];
}

#pragma mark Window manipulation

-(void)openAssignWindowForFolderCollection:(JRFolderCollection *)collection {
    NSArray *finderSelection = [self retrieveFinderSelection];
    if ([finderSelection count] == 0)
        NSBeep();
    else {
        [self disappearAssignWindow:self];
        assign = [JRAssignWindowController windowWithFolderCollection:collection targetFiles:finderSelection theme:self.theme];
        [assign show];
    }
}

-(IBAction)displayAssignWindow:(id)sender {
    [self openAssignWindowForFolderCollection:[self folderCollections][0]];
}

-(IBAction)disappearAssignWindow:(id)sender {
    if (assign) {
        [assign close];
        assign = nil;
    }
}


-(IBAction)displayPreferences:(id)sender {
    if (preferences == nil) preferences = [[JRPreferencesController alloc]init];
    [self disappearAssignWindow:sender];
    [preferences toggleVisible];
}

#pragma mark -
-(NSArray *)retrieveFinderSelection{
    FinderApplication *finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.finder"];
    NSArray *sbFinderSelection = (NSArray *)[[finder selection] get];
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for(FinderItem *item in sbFinderSelection)
        [returnArray addObject:[NSURL URLWithString:[item URL]]];
    
    return returnArray;
}

#pragma mark Login items
-(BOOL)startsAtLogin {
    if ([self loginItem])
        return YES;
    else
        return NO;
}

-(void)setStartAtLogin:(BOOL)startAtLogin {
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (loginItems) {
        if (startAtLogin) {
            NSString *appPath = [[NSBundle mainBundle] bundlePath];
            CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
            
            LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
            if (item)
                CFRelease(item);
        }
        else {
            LSSharedFileListItemRef toRemove = [self loginItem];
            LSSharedFileListItemRemove(loginItems, toRemove);
        }
    }
}

//These are private
-(LSSharedFileListItemRef)loginItem {
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
    
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (loginItems) {
        NSArray *loginArray = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItems, nil);
        for (id idItem in loginArray) {
            LSSharedFileListItemRef item = (__bridge LSSharedFileListItemRef) idItem;
            if (LSSharedFileListItemResolve(item, 0, &url, NULL) == noErr) {
                NSString *urlPath = [(__bridge NSURL *)url path];
                if ([urlPath hasPrefix: appPath])
                    return item;
            }
        }
    }
    
    return nil;
}

#pragma mark folder collections
/* Adds a folderCollection to the global list
 */
-(void)addFolderCollection:(JRFolderCollection *)fc {
    [self.folderCollections addObject:fc];
}

/* Removes a folderCollection from the global list.
 * Returns YES if folderCollection was removed, and
 * NO if it can't be found.
 */
-(BOOL)removeFolderCollection:(JRFolderCollection *)fc {
    if ([self.folderCollections containsObject:fc]) {
        [self.folderCollections removeObject:fc];
        return YES;
    }
    else return NO;
}
@end
