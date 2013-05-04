//
//  JRAssignView.h
//  Assign
//
//  Created by Jan-Yves on 28/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JRAssignWindow, JRAttributedString, JRIconView, JRDropdownButton;

@interface JRAssignView : NSView{
    NSTextField *searchText;
    JRAttributedString *title;
    JRIconView *iconView;
    JRDropdownButton *button;
    NSColor *backgroundColor;
}

#pragma mark Initializers and Factories
+(id)viewWithWidth:(int)width;
-(id)initWithWidth:(int)width;

#pragma mark -
#pragma mark Set values on the view
-(void)setSearchText:(NSString *)text;
-(void)setIcons:(NSArray *)icons;

#pragma mark View-related methods
-(void)repositionElements;

#pragma mark Theme methods
-(void)setTheme:(NSString *)theme;

#pragma mark Constants
+(int)bottomMargin;
+(int)topMargin;
@end
