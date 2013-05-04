//
//  JRIconView.m
//  Assign
//
//  Created by Jan-Yves on 17/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRIconView.h"
#import "JRAttributedString.h"

static const float kIconHeight=40;
static const float kIconTextHeight=15;

@implementation JRIconView

#pragma mark Initializers and Factories
+(id)view {
    return [[self alloc] init];
}

-(id)init {
    return [self initWithFrame:NSMakeRect(0,0,0,0) icons:nil];
}

+(id)viewWithFrame:(NSRect)f icons:(NSArray *)i {
    return [[self alloc] initWithFrame:f icons:i];
}

-(id)initWithFrame:(NSRect)f icons:(NSArray *)icons {
    if (self = [super initWithFrame:f]) {
        titleString = [JRAttributedString stringWithString:@"0 items" size:10];
        self.icons = icons;
    }

    return self;
}

-(NSString *)title {
    if ([self.icons count] == 1)
        return [(NSURL*)[self.icons objectAtIndex:0] lastPathComponent];
    else
        return [NSString stringWithFormat:@"%lu items", [self.icons count]];
}


- (void)drawRect:(NSRect)dirtyRect
{
    int numberOfIcons = (int)[self.icons count];
    
    //Each icon is a 40x40 box. If possible, they don't overlap
    //If they don't overlap, "spacing" is 40px.
    int iconSpacing = [self bounds].size.width / numberOfIcons;
    if (iconSpacing > kIconHeight) iconSpacing = kIconHeight;
    
    //This is how much space all of the icons will take up in total
    int allIconsWidth = (iconSpacing * (numberOfIcons-1))+40;
    
    //And this is where we should start placing icons, to centre them
    int iconX = ([self bounds].size.width - allIconsWidth)/2;
    int iconY = [self bounds].size.height - kIconHeight;
    
    //Draw the icons!
    NSImage *img;
    for(int i=0;i<numberOfIcons;i++) { //TODO Refactor
        NSURL *file = (NSURL*)[self.icons objectAtIndex:i];
        [file getResourceValue:&img forKey:NSURLEffectiveIconKey error:nil];
        
        int rectStart = iconX + iconSpacing*i;
        NSRect drawingRect = NSMakeRect(rectStart, iconY, kIconHeight, kIconHeight);
        [img drawInRect:drawingRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
    
    //Draw the title
    [titleString setString:[self title]];
    NSRect titleFrame = NSMakeRect(0, 0, [self bounds].size.width, kIconTextHeight);
    [titleString drawHorizontallyAlignedInRect:titleFrame];
}

-(void)setTheme:(NSString *)theme {
    [titleString setTheme:theme];
}

@end
