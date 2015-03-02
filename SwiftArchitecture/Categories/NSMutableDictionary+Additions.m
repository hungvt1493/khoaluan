//
//  NSMutableDictionary+Additions.m
//  winner21
//
//  Created by Hieu Bui on 3/11/13.
//  Copyright (c) 2013 PIPU. All rights reserved.
//

#import "NSMutableDictionary+Additions.h"

@implementation NSMutableDictionary (Additions)


- (void)setBool:(BOOL)b forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithBool:b] forKey:key];
}

- (void)setInteger:(NSInteger)i forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithInteger:i] forKey:key];
}

- (void)setFloat:(float)f forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithFloat:f] forKey:key];
}

- (void)setDouble:(double)d forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithDouble:d] forKey:key];
}

- (void)setArray:(NSArray *)arr forKey:(NSString *)key
{
    [self setObject:arr forKey:key];
}

@end
