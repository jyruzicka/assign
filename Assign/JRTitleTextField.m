//
//  JRTitleTextField.m
//  Assign
//
//  Created by Jan-Yves on 28/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRTitleTextField.h"
#import "JRAssignURLView.h"
#import "JRAssignWindow.h"

@implementation JRTitleTextField

+(id)fieldWithFrame:(NSRect)f andTitle:(NSString *)str
{
    return [[self alloc] initWithFrame:f andTitle:str];
}

- (id)initWithFrame:(NSRect)frame andTitle:(NSString *)str
{
    if (self = [super initWithFrame:frame]) {
        [self setEditable:NO];
        [self setSelectable:NO];
        [self setBezeled:NO];
        [self setDrawsBackground:NO];
        [self setStringValue:str];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
