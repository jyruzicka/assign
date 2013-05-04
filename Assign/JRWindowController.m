//
//  JRWindowController.m
//  Assign
//
//  Created by Jan-Yves on 21/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRWindowController.h"

@interface JRWindowController ()

@end

@implementation JRWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"Menu"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

//Called when the Quit menu item is selected
- (IBAction)quitItemClicked:(id)sender
{
    [NSApp terminate:sender];
}

@end
