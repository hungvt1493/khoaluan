//
//  NSManagedObject+Ext.m
//  newwindsoft
//
//  Created by Vu Hoang Minh on 6/6/13.
//  Copyright (c) 2013 newwindsoft . All rights reserved.
//

#import "NSManagedObject+Ext.h"

@implementation NSManagedObject (Ext)
-(NSString *)getObjectID
{
    NSString *objId = @"";
    NSString *objectIDDesc = self.objectID.description;
    if (objectIDDesc.length > 0) {
        NSArray *arr = [objectIDDesc componentsSeparatedByString:@"/"];
        objId = ((NSString *)[arr lastObject]);
        NSUInteger searchLastComponent = [objId rangeOfString:@">"].location;
        if (searchLastComponent != NSNotFound) {
            objId = [objId substringToIndex:searchLastComponent];
        }
//        NSLog(@"DBG: %@", objId);
    }
    return objId;
}
@end
