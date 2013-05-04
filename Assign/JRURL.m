//
//  JRURL.m
//  Assign
//
//  Created by Jan-Yves on 1/03/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRURL.h"
#import "JRFolderCollection.h"

@implementation JRURL

#pragma mark Initializers and Factories
+(id)URLWithURL:(NSURL *)url parent:(JRFolderCollection *)parent {
    return [[JRURL alloc] initWithURL:url parent:parent];
}

-(id)initWithURL:(NSURL *)url parent:(JRFolderCollection *)parent {
    if (self = [super init])
    {
        self.url = url;
        self.root = [parent rootFolder];
    }
    return self;
}

-(NSString *)pathRelativeToParent {
    return [[self.url path] stringByReplacingOccurrencesOfString:[self.root path] withString:@"" options:NSAnchoredSearch range:NSMakeRange(0, [[self.url path]length])];
}
@end
