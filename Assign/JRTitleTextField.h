//
//  JRTitleTextField.h
//  Assign
//
//  Created by Jan-Yves on 28/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JRAssignURLView;

@interface JRTitleTextField : NSTextField{
}

+(id)fieldWithFrame:(NSRect)f andTitle:(NSString *)str;
-(id)initWithFrame:(NSRect)f andTitle:(NSString *)str;
@end
