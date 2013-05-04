//
//  JRAssignView.m
//  Assign
//
//  Created by Jan-Yves on 28/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRAssignView.h"
#import "JRIconView.h"
#import "JRDropdownButton.h"

static const float kVMargin = 10; // TODO switch to CGFloat for use in NSRect
static const float kIconView = 55;
static const float kSearchText = 15;
static NSDictionary *kBackgroundColour;
static NSDictionary *kTextColour;

@implementation JRAssignView

#pragma mark Class initializer
+(void)initialize {
    kBackgroundColour = @{
        @"Light": [NSColor colorWithCalibratedHue:0.5 saturation:0.1 brightness:1.0 alpha:0.6],
        @"Dark": [NSColor colorWithCalibratedHue:0.5 saturation:0.1 brightness:0.0 alpha:0.6]
    };
    kTextColour = @{@"Light": [NSColor blackColor], @"Dark": [NSColor whiteColor]};
}

#pragma mark Initializers and Factories
+(id)viewWithWidth:(int)width {
    return [[self alloc] initWithWidth:width];
}

-(id)initWithWidth:(int)width {
    if (self = [super init]) {
        
        //Allocate various views
        //IconView
        iconView = [JRIconView view];
        [self addSubview:iconView];
        
        searchText = [[NSTextField alloc] initWithFrame:NSMakeRect(0,kVMargin,width,kSearchText)];
        [searchText setSelectable:NO];
        [searchText setBezeled:NO];
        [searchText setDrawsBackground:NO];
        [searchText setAlignment:NSCenterTextAlignment];
        [self addSubview:searchText];

        button = [JRDropdownButton buttonInFrame:[self frame]];
        [self addSubview:button];
    }
    return self;
}

#pragma mark - Set values on the view

-(void)setSearchText:(NSString *)text {
    [searchText setStringValue:text];
}

-(void)setIcons:(NSArray *)icons {
    [iconView setIcons:icons];
}

#pragma mark View-related methods
-(void)repositionElements {
    int width = [self bounds].size.width;
    NSRect iconViewFrame = NSMakeRect(0, [self bounds].size.height - [JRAssignView topMargin], width, kIconView);
    [iconView setFrame:iconViewFrame];
    
    [button positionInFrame:[self frame]];
}

#pragma mark Inherited methods

- (void)drawRect:(NSRect)dirtyRect
{    
    NSBezierPath *background = [NSBezierPath bezierPathWithRoundedRect:[self frame] xRadius:10 yRadius:10];
    [backgroundColor setFill];
    [background fill];
}

#pragma mark Theme methods
-(void)setTheme:(NSString *)theme {
    backgroundColor = kBackgroundColour[theme];
    [searchText setTextColor:kTextColour[theme]];
    [iconView setTheme:theme];
}

#pragma mark Constants
//Referenced by JRAssignURLViews, JRWindow
+(int)bottomMargin{ return kVMargin + kSearchText; }
//References by JRWindow
+(int)topMargin{ return kVMargin + kIconView; }
@end
