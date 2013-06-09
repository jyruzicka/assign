//
//  JRMenu.m
//  Assign
//
//  Created by Jan-Yves on 21/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRMenu.h"
#import "JRAssignWindow.h"
#import "JRAppDelegate.h"
#import "JRFolderCollection.h"

static const JRMenu* kMenuWithAssignOptions;
static const JRMenu* kMenuWithoutAssignOptions;

@implementation JRMenu

+(id)menuWithAssignOptions {
    if (!kMenuWithAssignOptions)
        kMenuWithAssignOptions = [self createMenuWithAssignOptions];

    return kMenuWithAssignOptions;
}

+(id)menuWithoutAssignOptions {
    if (!kMenuWithoutAssignOptions)
        kMenuWithoutAssignOptions = [self createMenuWithoutAssignOptions];
    
    return kMenuWithoutAssignOptions;
}

+(void)updateMenuItems {
    JRMenu *menu = [self menuWithAssignOptions];
    [menu removeAllItems];
    
    [menu addAssignMenuItems];
    [menu addSeparator];
    [menu addGenericMenuItems];
}

#pragma mark -
#pragma mark Private methods

+(id)createMenuWithoutAssignOptions {
    JRMenu *m = [[JRMenu alloc] init];
    [m addGenericMenuItems];
    return m;
}

+(id)createMenuWithAssignOptions {
    JRMenu *m = [[JRMenu alloc] init];
    [m addAssignMenuItems];
    [m addSeparator];
    [m addGenericMenuItems];
    return m;
}

#pragma mark Menu items
-(void)addAssignMenuItems {
    JRAppDelegate *delegate = (JRAppDelegate *)[NSApp delegate];
    for (JRFolderCollection *fc in [delegate folderCollections]) {
        NSMenuItem *i = [[NSMenuItem alloc] initWithTitle:[[fc rootFolder] lastPathComponent] action:@selector(displayAssignWindow:) keyEquivalent:@""];
        [i setTag:[[delegate folderCollections] indexOfObject:fc]];
        [self addItem:i];
    }
}

-(void)addSeparator {
    [self addItem:[NSMenuItem separatorItem]];
}

-(void)addGenericMenuItems {
    [self addItem:[JRMenu aboutItem]];
    [self addItem: [JRMenu updateItem]];
    [self addItem:[JRMenu preferencesItem]];
    [self addItem:[JRMenu quitItem]];
}

+(NSMenuItem *) quitItem {
    NSMenuItem *i = [[NSMenuItem alloc] initWithTitle:@"Quit Assign"
                                               action:@selector(terminate:)
                                        keyEquivalent:@"q"];
    [i setTarget:NSApp];
    return i;
}

+(NSMenuItem *) preferencesItem {
    NSMenuItem *i = [[NSMenuItem alloc] initWithTitle:@"Preferences…"
                                                   action:@selector(displayPreferences:)
                                            keyEquivalent:@","];
    [i setTarget:[NSApp delegate]];
    return i;
}

+(NSMenuItem *)aboutItem {
    NSMenuItem *i = [[NSMenuItem alloc] initWithTitle:@"About"
                                               action:@selector(displayAbout:)
                                        keyEquivalent:@""];
    [i setTarget:[NSApp delegate]];
    return i;
}

+(NSMenuItem *)updateItem {
    NSMenuItem *i = [[NSMenuItem alloc] initWithTitle:@"Check for updates…"
                                               action:@selector(checkForUpdates:)
                                        keyEquivalent:@""];
    [i setTarget:[NSApp delegate]];
    return i;
}

@end