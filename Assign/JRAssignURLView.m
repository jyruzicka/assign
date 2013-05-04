//
//  JRAssignURLView.m
//  Assign
//
//  Created by Jan-Yves on 26/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRAssignURLView.h"
#import "JRURL.h"
#import "JRBoundedTextView.h"
#import "JRAttributedString.h"
#import "JRAssignView.h" //only need it for the bottom margin

static const float kItemHeight = 50;
static const float kMargin = 5;
static const float kTitleHeight = 25;
static const float kSubtitleHeight = 15;
static NSDictionary *kBackgroundColour;

@implementation JRAssignURLView

#pragma mark Class initializer
+(void)initialize {
    kBackgroundColour = @{
                          @"Light":[NSColor colorWithCalibratedHue:0.0 saturation:0.0 brightness:1.0 alpha:0.5],
                          @"Dark": [NSColor colorWithCalibratedHue:0.0 saturation:0.0 brightness:0.0 alpha:0.5]
  };
}

#pragma mark Initializers and Factories

+(id)viewWithURL:(JRURL *)url index:(int)index insideView:(JRAssignView *)view {
    return [[self alloc] initWithURL:url index:index insideView:view];
}

-(id)initWithURL:(JRURL *)url index:(int)index insideView:(JRAssignView *)view {
    float startHeight = [view bounds].size.height - [JRAssignView topMargin] - (index + 1)*kItemHeight;
    NSRect f = NSMakeRect(0,startHeight, [view bounds].size.width, kItemHeight);
    if (self = [super initWithFrame:f])
    {
        self.url = url;
        self.index = index;
        NSURL *file = [self.url url];
        
        float innerWidth = [self bounds].size.width - (kMargin*2);
        
        //Make title
        titleFrame = NSMakeRect(kMargin + kTitleHeight, kItemHeight - kMargin - kTitleHeight, innerWidth - kTitleHeight, kTitleHeight);
        title = [JRAttributedString stringWithString:[file lastPathComponent] size:15.0];

        //Make subtitle
        subtitleFrame = NSMakeRect(kMargin, kMargin, innerWidth, kSubtitleHeight);
        subtitle = [JRAttributedString stringWithString:[self.url pathRelativeToParent] size:10.0];

        //Make image of folder
        NSImage *img;
        [file getResourceValue:&img forKey:NSURLEffectiveIconKey error:nil];
        fileImage = img;
        
        imageFrame = NSMakeRect(kMargin,kMargin + kSubtitleHeight,kTitleHeight, kTitleHeight);
    }
    return self;
}

#pragma mark Inherited from NSView

- (void)drawRect:(NSRect)dirtyRect
{
    // Draw bounding box.
    if (self.selected) {
        NSRect insetBounds = NSInsetRect([self bounds], 0.5, 0.5);
        NSBezierPath *bp =[NSBezierPath bezierPathWithRoundedRect:insetBounds xRadius:10.0 yRadius:10.0];
        [backgroundColour setFill];
        [bp fill];
    }
    
    //Draw icon
    if (fileImage)
        [fileImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    //Draw title
    [title drawVerticallyAlignedInRect:titleFrame];
    [subtitle drawVerticallyAlignedInRect:subtitleFrame];
}

#pragma mark Theme methods
-(void)setTheme:(NSString *)theme {
    backgroundColour = kBackgroundColour[theme];
    [title setTheme:theme];
    [subtitle setTheme:theme];
}

#pragma mark Constants
//Referenced by JRAssignView
+(float)itemHeight {return kItemHeight;}

@end
