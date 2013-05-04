//
//  JRBoundedTextView.m
//  Assign
//
//  Created by Jan-Yves on 1/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRBoundedTextView.h"

@implementation JRBoundedTextView
@synthesize string;
@synthesize frame;
@synthesize centreAligned;

- (id)initWithString:(NSString *)s frame:(NSRect)f
{
    if (self = [super initWithFrame:frame]) {
        string = [[NSMutableAttributedString alloc] initWithString:s];
        [self setVerticalOffset];
    }
    
    return self;
}

+(id)viewWithString:(NSString *)s frame:(NSRect)f {
    return [[self alloc] initWithString:s frame:f];
}

- (void)drawRect:(NSRect)dirtyRect
{
    int rectHeight = [string size].height;
    if (frame.size.height < rectHeight)
        rectHeight = frame.size.height;
    
    int rectWidth = [string size].width;
    if (frame.size.width < rectWidth)
        rectWidth = frame.size.width;
    
    NSRect drawingRect = NSMakeRect(horizontalOffset, verticalOffset, rectWidth, rectHeight);
    [string drawInRect:drawingRect];
}

//Custom setters
-(void)setFrame:(NSRect)f {
    frame = f;
    [self setOffsets];
}

-(void)setCentreAligned:(BOOL)c {
    centreAligned = c;
    [self setOffsets];
}

-(void)setTextSize:(float)size {
    NSFont *f = [NSFont fontWithName:@"Helvetica" size:size];
    [string setAttributes:@{NSFontAttributeName:f} range:NSMakeRange(0, [string length])];
    [self setOffsets];
}

// Set the offsets based on string height and frame height
-(void)setOffsets {
    [self setVerticalOffset];
    [self setHorizontalOffet];
}
-(void) setVerticalOffset {
    verticalOffset = (frame.size.height - [string size].height)/2;
    if (verticalOffset < 0)
        verticalOffset = 0;
}

-(void)setHorizontalOffet {
    if (centreAligned) {
        horizontalOffset = (frame.size.width - [string size].width)/2;
        if (horizontalOffset < 0)
            horizontalOffset = 0;
    }
    
    else
        horizontalOffset = 0;
}

@end
