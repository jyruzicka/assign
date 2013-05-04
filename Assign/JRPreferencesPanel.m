//
//  JRPreferencesPanel.m
//  Assign
//
//  Created by Jan-Yves on 5/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRPreferencesPanel.h"

@implementation JRPreferencesPanel


-(void)dealloc {
    DLog(@"JRPP is dealloced!");
}
//This is left to the controller to solve.
-(void)cancelOperation:(id)sender {
    [(NSResponder *)[self delegate] cancelOperation:sender];
}
@end
