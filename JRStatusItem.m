//
//  JRStatusItem.m
//  Assign
//
//  Created by Jan-Yves on 26/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRStatusItem.h"
#import "JRMenu.h"

@implementation JRStatusItem


-(id) init
{
    if (self = [super init])
    {
        statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
        [statusItem setImage:[NSImage imageNamed:@"assign-icon-menubar"]];
        [statusItem setMenu:[JRMenu menuWithAssignOptions]];
        [statusItem setHighlightMode:YES];
    }
    return self;
}
@end
