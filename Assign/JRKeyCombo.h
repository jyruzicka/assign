//
//  JRKeyCombo.h
//  Assign
//
//  Created by Jan-Yves on 7/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRKeyCombo : NSObject

@property (nonatomic) unsigned short keyCode;
@property (nonatomic) NSUInteger modifierFlags;
@property (nonatomic) NSString *character;

-(id)initWithKeyCode:(unsigned short)keyCode character:(NSString *)character modifierFlags:(NSUInteger)flags;
+(id)keyComboWithKeyCode:(unsigned short)keyCode character:(NSString *)character modifierFlags:(NSUInteger)flags;

-(id)initWithIntKeyCode:(int)kc character:(NSString *)c modifierFlags:(int)mf;
+(id)keyComboWithIntKeyCode:(int)kc character:(NSString *)c modifierFlags:(int)mf;

-(id)initWithEvent:(NSEvent *)event;
+(id)keyComboWithEvent:(NSEvent *)event;

-(NSString *)asString;
-(UInt32)carbonModifierFlags;
-(UInt32)carbonKeyCode;


@end
