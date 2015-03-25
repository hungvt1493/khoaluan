//
//  SWUtil.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
//@class AppDelegate;
#import "GCDispatch.h"


@interface SWUtil : NSObject

@property (strong, nonatomic) MBProgressHUD *progressView;

+ (SWUtil *)sharedUtil;
+ (AppDelegate *)appDelegate;

- (void)showLoadingView;
- (void)showLoadingViewWithTitle:(NSString *)title;
- (void)hideLoadingView;

/*
 * Making univesal Viewcontroller with two .xib UI
 */
+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className;
+ (void)showConfirmAlert:(NSString *)title message:(NSString *)message cancelButton:(NSString*)cancel otherButton:(NSString *)other tag: (NSInteger )tag delegate:(id)delegate;

+ (void)showConfirmAlert:(NSString *)title message:(NSString *)message delegate:(id)delegate;
+ (void)showConfirmAlertWithMessage:(NSString *)message delegate:(id)delegate;
+ (void)showConfirmAlertWithMessage:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate;
/**
 *  Convert from NSDate to NSString
 */
+ (NSString*)convertDate:(NSDate*)date toStringFormat:(NSString*)format;

/**
 * Convert from date string to int
 */
+ (NSNumber*)convertFromDateStringToInt:(NSString*)date withDateFormat:(NSString*)format;
/**
 * Convert from date to int
 */
+ (NSNumber *)convertDateToNumber:(NSDate *)dateValue;
/**
 *
 */
+ (NSDate *)convertNumberToDate:(int)date;

+ (NSString*)convert:(int)dateValue toDateStringWithFormat:(NSString*)format;
/**
 *Get string data from server, used for table view
 */

+ (NSString *)currentDateTime;

+ (NSString*)changeToUnsign:(NSString*)text;
@end
