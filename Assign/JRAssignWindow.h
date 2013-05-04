//
//  JRAssignWindow.h
//  Assign
//
//  Created by Jan-Yves on 24/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JRAssignWindow : NSWindow {
    int index;
    NSMutableArray *urlViews;
    NSString *theme;
}

#pragma mark Initializers and Factories
+(id)windowWithController:(NSResponder *)c;
-(id)initWithController:(NSResponder *)c;

#pragma mark -
#pragma mark Index manipulation
-(void)increaseIndex;
-(void)decreaseIndex;
-(void)setIndex:(int)i;

#pragma mark URL manipulation
-(NSURL *)selectedURL;

#pragma mark View methods
-(void)setIcons:(NSArray *)icons;
-(void)setSearchText:(NSString *)str;

#pragma mark Window methods
-(void)resizeToFitObjects:(int)numObjects;
-(void)populateWithURLs:(NSArray *)URLs;

#pragma mark Theme methods
-(void)setTheme:(NSString *)theme;
@end
