//
//  JRIconView.h
//  Assign
//
//  Created by Jan-Yves on 17/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JRAttributedString;

@interface JRIconView : NSView {
    JRAttributedString *titleString;
}

@property NSArray* icons;

#pragma mark Initializers and Factories
+(id)view;
-(id)init;

+(id)viewWithFrame:(NSRect)f icons:(NSArray *)i;
-(id)initWithFrame:(NSRect)f icons:(NSArray *)i;

-(NSString *)title;
-(void)setTheme:(NSString *)theme;
@end

