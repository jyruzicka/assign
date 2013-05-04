//
//  JRAssignWindow.m
//  Assign
//
//  Created by Jan-Yves on 24/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRAssignWindow.h"
#import "JRAssignView.h"
#import "JRAssignURLView.h"
#import "JRURL.h"

@implementation JRAssignWindow

const float kWindowWidth = 400;
const float kMargin = 5;
const int kMaxEntries = 5;

#pragma mark Initializers and Factories
+(id)windowWithController:(NSResponder *)c {
    return [[self alloc] initWithController:c];
}

-(id)initWithController:(NSResponder *)c {
    NSRect initialFrame = [self centredFrameWithHeight:kMargin*2];
    if (self = [super initWithContentRect:initialFrame
                                styleMask:NSBorderlessWindowMask
                                  backing: NSBackingStoreBuffered defer:YES])
    {
        //Set up the window to look and behave how we wish
        [self setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary ];
        [self setLevel:NSModalPanelWindowLevel];
        [self setBackgroundColor: [NSColor clearColor]];
        [self setOpaque:NO];
        
        //Assign controller nextResponder status - allow for keypresses etc.
        [self setNextResponder:c];

        //Custom content view
        [self setContentView:[JRAssignView viewWithWidth:kWindowWidth]];
        
        //Initialize variables
        index = 0;
        [[urlViews objectAtIndex:0] setSelected:YES];
        
        urlViews = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark Index manipulation
-(void)increaseIndex {
    [self setIndex:index+1];
}

-(void)decreaseIndex {
    [self setIndex:index-1];
}

-(void)setIndex:(int)i {
    if (i < [urlViews count] && i >= 0) {
        [[urlViews objectAtIndex:index] setSelected:NO];
        index = i;
        [[urlViews objectAtIndex:index] setSelected:YES];
    }
}

#pragma mark URL manipulation
-(NSURL *)selectedURL {
    return [[(JRAssignURLView *)[urlViews objectAtIndex:index] url] url];
}

#pragma mark View methods
-(void)setIcons:(NSArray *)icons {
    [(JRAssignView *)[self contentView] setIcons:icons];
}

-(void)setSearchText:(NSString *)str {
    [(JRAssignView *)[self contentView] setSearchText:str];
}

#pragma mark Overridden window methods
-(BOOL)canBecomeKeyWindow {return YES; }
-(void)cancelOperation:(id)sender{ [[self nextResponder] cancelOperation:sender]; }

#pragma mark Window methods
//Change size based on number of new URL views.
-(void)resizeToFitObjects:(int)numObjects {
    int verticalSize = numObjects * [JRAssignURLView itemHeight] + [JRAssignView topMargin] + [JRAssignView bottomMargin];
    [self setFrame:[self centredFrameWithHeight:verticalSize] display:YES];
    [[self contentView] repositionElements];
}

-(void)populateWithURLs:(NSArray *)URLs {
    //First remove all previous data
    for (JRAssignURLView *v in urlViews)
        [v removeFromSuperview];
    [urlViews removeAllObjects];
    
    //Remove excessive URLs
    if ([URLs count] > kMaxEntries)
        URLs = [URLs subarrayWithRange:NSMakeRange(0, kMaxEntries)];
    
    int count = (int)[URLs count];
    DLog(@"Being populated with %i views", count);
    
    //Resize the window
    [self resizeToFitObjects:count];
    
    //Make views for these URLs
    for (int i=0; i < count; i++) {
        JRAssignURLView *v = [JRAssignURLView viewWithURL:[URLs objectAtIndex:i] index:i insideView:[self contentView]];
        [v setTheme:theme];
        [urlViews addObject:v];
        [[self contentView] addSubview:v];
    }
    
    [self setIndex:0];
}

#pragma mark Theme methods
-(void)setTheme:(NSString *)t {
    theme = t;
    [self.contentView setTheme:t];
    for (JRAssignURLView *v in urlViews) [v setTheme:t];
}

#pragma mark -
#pragma mark Private methods

//Makes a frame centred on the main screen, with a given height
-(NSRect)centredFrameWithHeight:(int)h {
    NSSize screenSize = [[NSScreen mainScreen] frame].size;
    int top = (screenSize.height - h)/2;
    int left = (screenSize.width - kWindowWidth)/2;
    return NSMakeRect(left, top, kWindowWidth, h);
}
@end
