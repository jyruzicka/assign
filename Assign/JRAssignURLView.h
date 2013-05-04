//
//  JRAssignURLView.h
//  Assign
//
//  Created by Jan-Yves on 26/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JRAssignWindow, JRURL, JRAttributedString, JRAssignView;

@interface JRAssignURLView : NSView{
    NSRect titleFrame;
    NSRect subtitleFrame;
    JRAttributedString *title;
    JRAttributedString *subtitle;
    NSColor *backgroundColour;

    
    NSImage *fileImage;
    NSRect imageFrame;
}
@property (nonatomic)  JRURL* url;
@property (nonatomic)  int index;
@property (nonatomic)  BOOL selected;

+(id)viewWithURL:(JRURL *)url index:(int)index insideView:(JRAssignView *)view;
-(id)initWithURL:(JRURL *)url index:(int)index insideView:(JRAssignView *)view;

#pragma mark Theme methods
-(void)setTheme:(NSString *)theme;

#pragma mark Constants
//Referenced by JRAssignView
+(float)itemHeight;
@end
