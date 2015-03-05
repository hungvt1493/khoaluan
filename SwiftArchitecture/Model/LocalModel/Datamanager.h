//
//  SWVerticalLabel.h
//  SwiftArchitecture
//
//  Created by Hung Vuong on 6/19/14.
//  Copyright (c) 2014 Hung Vuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData+MagicalRecord.h"

@interface DataManager : NSObject
{

}
+ (DataManager*)sharedInstance;
+ (BOOL)saveAllChanges;
+ (void)revertLocalChanges;
@end
