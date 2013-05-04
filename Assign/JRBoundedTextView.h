//
//  JRBoundedTextView.h
//  Assign
//
//  Created by Jan-Yves on 1/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JRBoundedTextView : NSView{
    int verticalOffset;
    int horizontalOffset;
}

@property (readonly) NSMutableAttributedString *string;
@property (readonly) NSRect frame;
@property (readonly)BOOL centreAligned;

//Custom setters
-(void)setFrame:(NSRect)f;
-(void)setCentreAligned:(BOOL)c;

-(id)initWithString:(NSString *)s frame:(NSRect)f;
+(id)viewWithString:(NSString *)s frame:(NSRect)f;

-(void)setTextSize:(float)size;
@end
