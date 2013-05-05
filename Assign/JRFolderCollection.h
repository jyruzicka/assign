//
//  JRFolderCollection.h
//  Assign
//
//  Created by Jan-Yves on 26/02/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
@class JRURL, JRKeyCombo, JRAppDelegate;

@interface JRFolderCollection : NSObject {
    NSThread *scanningThread;
}
@property (nonatomic) NSURL *rootFolder;
@property (nonatomic) NSMutableArray *folders;
@property (nonatomic) NSValue *registeredHotkey;
@property (nonatomic) JRKeyCombo *keyCombo;
@property (nonatomic) int rescanInterval;
@property (nonatomic) NSTimer *timer;

#pragma mark Initializers and Factories
+(id)folderCollectionWithDictionary:(NSDictionary *)d;
-(id)initWithDictionary:(NSDictionary *)d;

+(id)folderCollectionWithURL:(NSURL *)url;
-(id)initWithURL:(NSURL *)url;

+(id)defaultFolderCollection;

#pragma mark Exporter etc.
-(NSDictionary *)toDictionary;
-(void)save;

#pragma mark Setters
-(void)setRootFolder:(NSURL *)rootFolder;
-(void)setRescanInterval:(int)rescanInterval;

#pragma mark Other methods
-(void)timerFireMethod:(NSTimer *)timer;
-(void)backgroundScanForFolders;
-(void)scanForFolders;
-(NSArray *) urlsFilteredByString:(NSString *)str;

#pragma mark Hotkey methods
-(void)registerHotkey:(JRKeyCombo *)hotkey;
-(void)deregisterHotkey;
@end
