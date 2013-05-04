//
//  JRAttributedString.m
//  Assign
//
//  Created by Jan-Yves on 1/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRAttributedString.h"

static NSDictionary *kTextColour;

@implementation JRAttributedString

#pragma mark Class initializer

+(void)initialize {
    kTextColour = @{@"Light": [NSColor blackColor],
                    @"Dark": [NSColor whiteColor]
                    };
}

#pragma mark Initializers and Factories

-(id)initWithString:(NSString *)str size:(float)s {
    NSFont *f = [NSFont fontWithName:@"Helvetica" size:s];
    if (self = [super init]) {
        string = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: f}];
    }
    return self;
}

+(id)stringWithString:(NSString *)str size:(float)s {
    return [[self alloc] initWithString:str size:s];
}

#pragma mark Drawing methods

-(void)drawVerticallyAlignedInRect:(NSRect)rect {
    NSRect newRect = NSMakeRect(rect.origin.x, rect.origin.y-[self yOffset:rect.size.height], rect.size.width, [string size].height);
    [string drawInRect:newRect];
}

-(void)drawHorizontallyAlignedInRect:(NSRect)rect {
    NSRect newRect = NSMakeRect(rect.origin.x+[self xOffset:rect.size.width], rect.origin.y, [string size].width, rect.size.height);
    [string drawInRect:newRect];
}

#pragma mark Setting things

-(void)setTheme:(NSString *)theme {
    [string addAttribute:NSForegroundColorAttributeName value:kTextColour[theme] range:NSMakeRange(0,[string length])];
}

-(void)setString:(NSString *)s {
    NSDictionary *currentAttributes = [string attributesAtIndex:0 effectiveRange:NULL];
    string = [[NSMutableAttributedString alloc] initWithString:s attributes:currentAttributes];
}

#pragma mark Private helper methods
-(int)yOffset:(int)frameHeight{
    int offset = (frameHeight - [string size].height)/2;
    if (offset > 0)
        return offset;
    else
        return 0;
}

-(int)xOffset:(int)frameWidth{
    int offset = (frameWidth - [string size].width)/2;
    if (offset > 0)
        return offset;
    else
        return 0;
}

-(NSRange)wholeString {
    return NSMakeRange(0, [string length]);
}
@end
