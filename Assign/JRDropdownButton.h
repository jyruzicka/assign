//
//  JRDropdownButton.h
//  Assign
//
//  Created by Jan-Yves on 19/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JRDropdownButton : NSView

+(id)buttonInFrame:(NSRect)frame;
-(id)initInFrame:(NSRect)frame;

-(void)positionInFrame:(NSRect)frame;
@end
