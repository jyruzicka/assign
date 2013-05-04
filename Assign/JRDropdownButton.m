//
//  JRDropdownButton.m
//  Assign
//
//  Created by Jan-Yves on 19/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRDropdownButton.h"
#import "JRMenu.h"

static const int _offset=20;
static const int _size=12;

@implementation JRDropdownButton

#pragma mark Initializers and Factories

+(id)buttonInFrame:(NSRect)frame {
    return [[self alloc] initInFrame:frame];
}

-(id)initInFrame:(NSRect)frame {
    NSRect newFrame = NSMakeRect(frame.size.width - _offset - _size,
                                 frame.size.height - _offset - _size,
                                 _size, _size);
    if (self = [super initWithFrame:newFrame])
        [self setMenu:[JRMenu menuWithoutAssignOptions]];
    return self;
}

#pragma mark Repositioning in the frame 

-(void)positionInFrame:(NSRect)frame {
    NSRect newFrame = NSMakeRect(frame.size.width - _offset - _size,
                                frame.size.height - _offset - _size,
                                _size, _size);
    [self setFrame:newFrame];
}

#pragma mark Inherited methods
- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    int width = [self bounds].size.width;
    int height = [self bounds].size.height;
    
    NSBezierPath *circle = [NSBezierPath bezierPathWithOvalInRect:[self bounds]];
    [[NSColor colorWithCalibratedWhite:0.2 alpha:1] setFill];
    [circle fill];
    
    NSBezierPath *arrow = [NSBezierPath bezierPath];
    [arrow moveToPoint:NSMakePoint(width/4, height*2/3)];
    [arrow lineToPoint:NSMakePoint(width*3/4, height*2/3)];
    [arrow lineToPoint:NSMakePoint(width/2, height/3)];
    [arrow lineToPoint:NSMakePoint(width/4, height*2/3)];
    [[NSColor whiteColor] setFill];
    [arrow fill];
}

-(void)mouseDown:(NSEvent *)theEvent {
    [NSMenu popUpContextMenu:[self menu] withEvent:theEvent forView:self];
}

@end
