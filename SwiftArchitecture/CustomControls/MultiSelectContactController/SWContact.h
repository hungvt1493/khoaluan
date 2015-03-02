//
//  SWContact.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWContact : NSObject
{

}
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *fullName;
@property (nonatomic,assign) NSInteger sectionNumber;
@property (nonatomic) BOOL isSelected;

//Sorting method
- (NSString *)sorterFirstName;
- (NSString *)sorterLastName;
- (NSString *)sorterFullName;
@end
