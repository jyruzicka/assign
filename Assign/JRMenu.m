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

static const JRMenu* _menuWithAssignOptions;
static const JRMenu* _menuWithoutAssignOptions;

@implementation JRMenu

+(id)menuWithAssignOptions {
    if (_menuWithAssignOptions)
        return _menuWithAssignOptions;
    else
        return [self createMenuWithAssignOptions];
}

+(id)menuWithoutAssignOptions {
    if (_menuWithoutAssignOptions)
        return _menuWithoutAssignOptions;
    else
        return [self createMenuWithoutAssignOptions];
}

#pragma mark -
#pragma mark Private methods

+(id)createMenuWithoutAssignOptions {
    JRMenu *m = [[JRMenu alloc] init];
    [m addItem:[self preferencesItem]];
    [m addItem:[self quitItem]];
    return m;
}

+(id)createMenuWithAssignOptions {
    JRMenu *m = [[JRMenu alloc] init];
    
    JRAppDelegate *del = (JRAppDelegate *)[NSApp delegate];
    for (JRFolderCollection *fc in [del folderCollections]) {
        NSMenuItem *i = [[NSMenuItem alloc] initWithTitle:[[fc rootFolder] lastPathComponent] action:@selector(displayAssignWindow:) keyEquivalent:@""];
        [i setTag:[[del folderCollections] indexOfObject:fc]];
        [m addItem:i];
    }
    
    [m addItem:[NSMenuItem separatorItem]];
    
    [m addItem:[self preferencesItem]];
    [m addItem:[self quitItem]];
    return m;
}

#pragma mark Menu items
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

@end
