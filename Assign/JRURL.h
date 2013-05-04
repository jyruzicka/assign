//
//  JRURL.h
//  Assign
//
//  Created by Jan-Yves on 1/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JRFolderCollection;

@interface JRURL : NSObject

@property (nonatomic) NSURL* root;
@property (nonatomic) NSURL* url;

#pragma mark Initializers and Factories
+(id)URLWithURL:(NSURL *)url parent:(JRFolderCollection *)parent;
-(id)initWithURL:(NSURL *)url parent:(JRFolderCollection *)parent;

#pragma mark As various base classes
-(NSString *)pathRelativeToParent;
@end
