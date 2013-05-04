//
//  JRFolderCollection.m
//  Assign
//
//  Created by Jan-Yves on 26/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//
// A lot of this is based on the DDHotKey livrary
// https://github.com/aglee/Hotness/blob/master/DDHotKey/DDHotKeyCenter.m

#import "JRFolderCollection.h"
#import "JRURL.h"
#import <Carbon/Carbon.h>
#import "JRAppDelegate.h"
#import "JRKeyCombo.h"

#pragma mark Private globals
static UInt32 kNextHotkeyID = 1;
OSStatus handleHotkey(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData);

@implementation JRFolderCollection

#pragma mark Initializers and Factories

+(id)folderCollectionWithDictionary:(NSDictionary *)d {
    return [[self alloc] initWithDictionary:d];
}

-(id)initWithDictionary:(NSDictionary *)d {
    if (self = [super init]) {
        self.rootFolder = [NSURL fileURLWithPath:(NSString*)d[@"rootFolder"]];

        int keyCode = [(NSNumber*)d[@"keyCode"] intValue];
        NSString *character = (NSString *)d[@"character"];
        int modifierFlags = [(NSNumber*)d[@"modifierFlags"] intValue];
        
        if (keyCode != -1) { // Ensure keyCombo isn't nil
            JRKeyCombo *kc = [JRKeyCombo keyComboWithIntKeyCode:keyCode character:character modifierFlags:modifierFlags];
            [self registerHotkey:kc];
        }
        
    }
    return self;
}

+(id)folderCollectionWithURL:(NSURL *)url
{
    return [[JRFolderCollection alloc] initWithURL:url];
}

-(id)initWithURL:(NSURL *)url
{
    if (self = [super init])
        self.rootFolder = url; // Auto-initiate scan

    return self;
}

+(id)defaultFolderCollection {
    NSString *rootFolderPath = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    NSURL *rootFolder = [NSURL fileURLWithPath:rootFolderPath];
    JRKeyCombo *kc = [JRKeyCombo keyComboWithKeyCode:49 character:@" " modifierFlags:NSCommandKeyMask+NSControlKeyMask];
    JRFolderCollection *fc = [self folderCollectionWithURL:rootFolder];
    [fc registerHotkey:kc];
    
    return fc;
}

-(void)dealloc {
    [self deregisterHotkey];
}

#pragma mark -
#pragma mark Exporters
-(NSDictionary *)toDictionary {
    // These might be nil - need to supply the right value
    NSNumber *keyCode;
    NSString *character;
    NSNumber *modifierFlags;
    
    if (self.keyCombo == nil) {
        keyCode = [NSNumber numberWithInt:-1];
        character = @"";
        modifierFlags = [NSNumber numberWithInt:-1];
        
    }
    else {
        keyCode = [NSNumber numberWithInt:[self.keyCombo keyCode]];
        character = [self.keyCombo character];
        modifierFlags = [NSNumber numberWithInteger:[self.keyCombo modifierFlags]];
    }
    
    return @{
             @"rootFolder":[[self rootFolder] path],
             @"keyCode": keyCode,
             @"character": character,
             @"modifierFlags": modifierFlags
    };
}

#pragma mark FolderCollection methods
-(void)setRootFolder:(NSURL *)rootFolder {
    _rootFolder = rootFolder;
    [self backgroundScanForFolders];
}

-(void)backgroundScanForFolders {
    NSThread *scanThread = [[NSThread alloc] initWithTarget:self selector:@selector(scanForFolders) object:nil];
    [scanThread start];
}

-(void)scanForFolders
{
    if (self.rootFolder) {
        // We will store our new collection in here, then swap them over at the end.
        NSMutableArray *newCollection = [NSMutableArray array];
    
        NSFileManager *fm = [NSFileManager defaultManager];
        NSDirectoryEnumerator *de = [fm enumeratorAtURL:self.rootFolder includingPropertiesForKeys:@[NSURLIsDirectoryKey, NSURLIsPackageKey] options:NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants errorHandler:nil];

        for (NSURL *theURL in de) {
            NSNumber *isDir;
            NSNumber *isPackage;
            [theURL getResourceValue:&isDir forKey:NSURLIsDirectoryKey error:NULL];
            [theURL getResourceValue:&isPackage forKey:NSURLIsPackageKey error:NULL];
            if ([isDir boolValue] && ![isPackage boolValue])
                [newCollection addObject: [JRURL URLWithURL:theURL parent:self]];
        }
        self.folders = newCollection;
        DLog(@"%lu folders", [self.folders count]);
    }

}

-(NSArray *)urlsFilteredByString:(NSString *)str
{
    NSMutableString *fuzzyString = [NSMutableString stringWithString:@"*"];
    for (int i=0; i < [str length]; i++)
        [fuzzyString appendFormat:@"%c*", [str characterAtIndex:i]];
        
    return [self.folders filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathRelativeToParent LIKE[cd] %@",fuzzyString]];
}

#pragma mark -
#pragma mark Hotkey methods
-(void)registerHotkey:(JRKeyCombo *)hotKey {
    //Have we already got a hotkey set? If so, unset it
    [self deregisterHotkey];
    
    //Next set our new ID, auto-increment
    int hotKeyID = kNextHotkeyID;
    kNextHotkeyID++;
    
    //Register global Hotkey
    
    //This is the event type we're using
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    
    //Add a handler
    InstallApplicationEventHandler(&handleHotkey,1,&eventType,(__bridge void*)self,NULL);

    //This is the reference to the event hotkey
    EventHotKeyRef gMyHotKeyRef;
    
    //This is the ID of the hotkey register
    EventHotKeyID gMyHotKeyID;
    gMyHotKeyID.signature='htk1';
    gMyHotKeyID.id=hotKeyID;
    
    //Register hotkey with handler
    RegisterEventHotKey([hotKey carbonKeyCode], [hotKey carbonModifierFlags], gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    
    [self setRegisteredHotkey:[NSValue valueWithPointer:gMyHotKeyRef]];
    
    //And finally, set our keyCombo appropriately
    self.keyCombo = hotKey;
}

-(void)deregisterHotkey {
    EventHotKeyRef hk = (EventHotKeyRef)[[self registeredHotkey]pointerValue];
    if (hk != nil) {
        UnregisterEventHotKey(hk);
        [self setRegisteredHotkey:nil];
    }
}
@end

#pragma mark Out-of-class hotkey methods

OSStatus handleHotkey(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData) {
    [(JRAppDelegate *)[NSApp delegate] openAssignWindowForFolderCollection: (__bridge JRFolderCollection *)userData];
    return noErr;
}