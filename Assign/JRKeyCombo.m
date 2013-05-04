//
//  JRKeyCombo.m
//  Assign
//
//  Created by Jan-Yves on 7/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRKeyCombo.h"
#import <Carbon/Carbon.h>

@implementation JRKeyCombo

#pragma mark Initializers and Factories

-(id)initWithKeyCode:(unsigned short)keyCode character:(NSString *)character modifierFlags:(NSUInteger)flags {
    if (self = [super init]) {
        self.keyCode = keyCode;
        self.character = character;
        self.modifierFlags = flags;
    }
    return self;
}

+(id)keyComboWithKeyCode:(unsigned short)keyCode character:(NSString *)character modifierFlags:(NSUInteger)flags {
    return [[self alloc] initWithKeyCode:keyCode character:character modifierFlags:flags];
}

-(id)initWithIntKeyCode:(int)kc character:(NSString *)c modifierFlags:(int)mf {
    return [self initWithKeyCode:(unsigned short)kc character:c modifierFlags:(NSUInteger)mf];
}

+(id)keyComboWithIntKeyCode:(int)kc character:(NSString *)c modifierFlags:(int)mf {
    return [[self alloc] initWithIntKeyCode:kc character:c modifierFlags:mf];
}

-(id)initWithEvent:(NSEvent *)event {
    return [self initWithKeyCode:[event keyCode] character:[event charactersIgnoringModifiers] modifierFlags:[event modifierFlags]];
}

+(id)keyComboWithEvent:(NSEvent *)event {
    return [[self alloc] initWithEvent:event];
}

#pragma mark -
#pragma mark Other methods

-(NSString *)asString {
    NSString *chr;
    switch ([self keyCode]) {
        case 49:
            chr = @"Space";
            break;
        default:
            chr = self.character;
            break;
    }
    
    NSString *rString = @"";
    if ((self.modifierFlags & NSCommandKeyMask) == NSCommandKeyMask)
        rString = [rString stringByAppendingString:@"⌘"];
    if ((self.modifierFlags & NSAlternateKeyMask) == NSAlternateKeyMask)
        rString = [rString stringByAppendingString:@"⌥"];
    if ((self.modifierFlags & NSControlKeyMask) == NSControlKeyMask)
        rString = [rString stringByAppendingString:@"^"];
    if ((self.modifierFlags & NSShiftKeyMask) == NSShiftKeyMask) {
        if ([chr length] == 1)
            chr = [chr uppercaseString];
        else
            rString = [rString stringByAppendingString:@"⇧"];
    }
    
    rString = [rString stringByAppendingString:chr];
    return rString;
}

-(UInt32)carbonModifierFlags {
    UInt32 newFlags = 0;
	if ((self.modifierFlags & NSControlKeyMask) > 0)     newFlags |= controlKey;
	if ((self.modifierFlags & NSCommandKeyMask) > 0)     newFlags |= cmdKey;
	if ((self.modifierFlags & NSShiftKeyMask) > 0)       newFlags |= shiftKey;
	if ((self.modifierFlags & NSAlternateKeyMask) > 0)   newFlags |= optionKey;
	return newFlags;
}

-(UInt32)carbonKeyCode {
    return (UInt32)self.keyCode;
}

@end
