//
//  main.m
//  Assign
//
//  Created by Jan-Yves on 21/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JRAppDelegate.h"

int main(int argc, char *argv[])
{
    NSApplication * application = [NSApplication sharedApplication];
    JRAppDelegate *appDelegate = [[JRAppDelegate alloc] init];
    
    [application setDelegate:appDelegate];
    [application run];
    
    return EXIT_SUCCESS;
}
