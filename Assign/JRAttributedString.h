//
//  JRAttributedString.h
//  Assign
//
//  Created by Jan-Yves on 1/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRAttributedString : NSObject {
    NSMutableAttributedString *string;
}

#pragma mark Initializers and Factories
-(id)initWithString:(NSString *)str size:(float)s;
+(id)stringWithString:(NSString *)str size:(float)s;

#pragma mark Setting values
-(void)setString:(NSString *)string;
-(void)setTheme:(NSString *)theme;

#pragma mark Drawing
-(void)drawVerticallyAlignedInRect:(NSRect)rect;
-(void)drawHorizontallyAlignedInRect:(NSRect)rect;

@end
