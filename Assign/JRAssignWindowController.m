//
//  JRAssignWindowController.m
//  Assign
//
//  Created by Jan-Yves on 17/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRAssignWindowController.h"
#import "JRFolderCollection.h"
#import "JRAssignWindow.h"

@implementation JRAssignWindowController

#pragma mark Initializers and Factories
-(id)initWithFolderCollection:(JRFolderCollection *)collection targetFiles:(NSArray *)files theme:(NSString *)theme {
    if (self = [super init])
    {
        self.collection = collection;
        self.files = files;
        self.window = [JRAssignWindow windowWithController:self];
        [self setTheme:theme];

        searchString = [NSMutableString string];
        [self.window setIcons:files];
        [self populateViews]; //provide initial selection
    }
    return self;
}

+(id)windowWithFolderCollection:(JRFolderCollection *)collection targetFiles:(NSArray *)files  theme:(NSString *)theme{
    return [[self alloc] initWithFolderCollection:collection targetFiles:files theme:theme];
}

#pragma mark -
#pragma mark Window control methods

-(void)show {
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:self];
}

-(void)close {
    [self.window orderOut:self];
}

-(void)populateViews {
    [self.window populateWithURLs:[self.collection urlsFilteredByString:searchString]];
    [self.window setSearchText:searchString];
}

#pragma mark -
#pragma mark Controller triggered methods
-(void)moveTargettedFilesToSelectedLocation {
    NSURL *destinationFolder = [self.window selectedURL];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    
    for (NSURL *target in self.files) {
        NSURL *destination = [destinationFolder URLByAppendingPathComponent:[target lastPathComponent]];
        [fm moveItemAtURL:target toURL:destination error:&err];
        if (err)
            [[NSAlert alertWithError:err] runModal];
    }
    
}

#pragma mark -
#pragma mark NSResponder methods
-(void)keyDown:(NSEvent *)theEvent
{
    int firstCharacterCode = (int)[[theEvent characters] characterAtIndex:0];
    BOOL requiresViewPopulation = NO;

    switch (firstCharacterCode) {
        case NSDownArrowFunctionKey:
            [self.window increaseIndex];
            break;
        case NSUpArrowFunctionKey:
            [self.window decreaseIndex];
            break;
        case NSBackspaceCharacter:
        case NSDeleteCharacter:
            searchString = [NSMutableString string];
            requiresViewPopulation = YES;
            break;
        case NSEnterCharacter:
            [self moveTargettedFilesToSelectedLocation];
            [self close];
            break;
        default:
            if ([[theEvent characters] length] > 0) { //printing characters
                [searchString appendString:[theEvent characters]];
                requiresViewPopulation = YES;
            }
    }
    
    [[self.window contentView] setNeedsDisplay:YES];
    if (requiresViewPopulation) [self populateViews];
}

//This is for pressing ESC
-(void)cancelOperation:(id)sender {
    [self close];
}

#pragma mark Theme methods
-(void)setTheme:(NSString *)theme {
    [self.window setTheme:theme]; //cascade
}

@end
