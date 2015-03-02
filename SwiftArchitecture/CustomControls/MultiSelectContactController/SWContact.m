//
//  SWContact.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWContact.h"

@implementation SWContact
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize fullName = _fullName;
@synthesize sectionNumber = _sectionNumber;
@synthesize isSelected = _isSelected;

- (NSString *)sorterFirstName {

    if (nil != _firstName && ![_firstName isEqualToString:@""]) {
        
        return _firstName;
    }
    if (nil != _lastName && ![_lastName isEqualToString:@""]) {
        
        return _lastName;
    }
    if (nil != self.fullName && ![self.fullName isEqualToString:@""]) {
        
        return self.fullName;
    }
    return nil;
}

- (NSString *)sorterLastName {
    
    if (nil != _firstName && ![_firstName isEqualToString:@""]) {
        
        return _firstName;
    }
    if (nil != _lastName && ![_lastName isEqualToString:@""]) {
        
        return _lastName;
    }
    if (nil != self.fullName && ![self.fullName isEqualToString:@""]) {
        
        return self.fullName;
    }
    return nil;
}

- (NSString *)sorterFullName {
    
    if (nil != self.fullName && ![self.fullName isEqualToString:@""]) {
       
        return self.fullName;
    }
    if (nil != self.fullName && ![self.fullName isEqualToString:@""]) {
        
        return self.fullName;
    }
    return nil;
}

@end
