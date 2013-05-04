//
//  JRMenu.h
//  Assign
//
//  Created by Jan-Yves on 21/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JRAssignWindow;

@interface JRMenu : NSMenu {
    JRAssignWindow *window;
}

+(id)menuWithAssignOptions;
+(id)menuWithoutAssignOptions;
@end

