//
//  JRMenu.h
//  Assign
//
//  Created by Jan-Yves on 21/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JRMenu : NSMenu {}

+(id)menuWithAssignOptions;
+(id)menuWithoutAssignOptions;

#pragma mark Update
+(void)updateMenuItems;

@end

