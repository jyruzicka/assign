//
//  JRAssignWindowController.h
//  Assign
//
//  Created by Jan-Yves on 17/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JRFolderCollection;
@class JRAssignWindow;

@interface JRAssignWindowController : NSResponder {
    NSMutableString *searchString;
}

@property JRFolderCollection* collection;
@property NSArray* files;
@property JRAssignWindow* window;

#pragma mark Initializers and Factories
-(id)initWithFolderCollection:(JRFolderCollection *)collection targetFiles:(NSArray *)files theme:(NSString *)theme;
+(id)windowWithFolderCollection:(JRFolderCollection *)collection targetFiles:(NSArray *)files theme:(NSString *)theme;

#pragma mark -
#pragma mark Window control methods
-(void)show;
-(void)close;
-(void)populateViews;

#pragma mark Theme methods
-(void)setTheme:(NSString *)theme;

@end

