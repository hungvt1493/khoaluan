//
//  SWUtil.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "SWUtil.h"
@implementation SWUtil

+ (SWUtil *)sharedUtil {
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (void)dealloc {
    
}

+ (AppDelegate *)appDelegate {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

#pragma mark Loading View
- (MBProgressHUD *)progressView
{
    if (!_progressView) {
        _progressView = [[MBProgressHUD alloc] initWithView:[SWUtil appDelegate].window];
        if (IS_IPAD()) {
            _progressView.minSize = CGSizeMake(200.0f, 200.0f);
        }

        _progressView.animationType = MBProgressHUDAnimationFade;
        _progressView.dimBackground = NO;
        [[SWUtil appDelegate].window addSubview:_progressView];
    }
    return _progressView;
}

- (void)showLoadingView {
    [self showLoadingViewWithTitle:@""];
}

- (void)showLoadingViewWithTitle:(NSString *)title {
    self.progressView.labelText = title;
    
    [[SWUtil appDelegate].window bringSubviewToFront:self.progressView];
    [self.progressView show:NO];
}

- (void)hideLoadingView {
    
    [self.progressView hide:NO];
}

+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className {
    
    if ([className length] > 0) {
        // Nib name from className
        Class c = NSClassFromString(className);
        NSString *nibName = @"";
        
        if (IS_IPAD()) {
            
            nibName = [NSString stringWithFormat:@"%@-iPad", className];
        }
        else if (IS_IPHONE_5) {
            
            nibName = [NSString stringWithFormat:@"%@-568h", className];
        }
        else {
            
            nibName = [NSString stringWithFormat:@"%@", className];
            
        }
        
        if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil) {
            //file found
            return [[c alloc] initWithNibName:nibName bundle:nil];
            
        } else {
            
            return [[UIViewController alloc] init];
        }
    }
    return nil;
}

+ (void)showConfirmAlert:(NSString *)title message:(NSString *)message cancelButton:(NSString*)cancel otherButton:(NSString *)other tag: (NSInteger )tag delegate:(id)delegate {
    
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:other, nil];
    alrt.tag = tag;
    [alrt show];
}

+ (void)showConfirmAlert:(NSString *)title message:(NSString *)message delegate:(id)delegate {
    
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Đóng" otherButtonTitles: nil];
    [alrt show];
}

+ (void)showConfirmAlertWithMessage:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate {
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:nil message:message delegate:delegate cancelButtonTitle:@"Đóng" otherButtonTitles:nil, nil];
    alrt.tag = tag;
    [alrt show];
}

+ (void)showConfirmAlertWithMessage:(NSString *)message delegate:(id)delegate {
    
    [self showConfirmAlertWithMessage:message tag:0 delegate:delegate];
}

+ (NSString*)convertDate:(NSDate*)date toStringFormat:(NSString*)format
{
    NSString *_dateString;
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:format];
    _dateString = [_dateFormatter stringFromDate:date];
    return _dateString;
}

+ (NSNumber*)convertFromDateStringToInt:(NSString *)date withDateFormat:(NSString*)format{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format];
    [objDateformat setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *objUTCDate = [objDateformat dateFromString:date];
    return [self convertDateToNumber:objUTCDate];
}

+ (NSNumber *)convertDateToNumber:(NSDate *)date {
    NSInteger milliseconds = (NSInteger)([date timeIntervalSince1970]);
    return [NSNumber numberWithLongLong:milliseconds];
}

+ (NSDate *)convertNumberToDate:(int)dateValue {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateValue];
    return date;
}

+ (NSString*)convert:(int)dateValue toDateStringWithFormat:(NSString*)format {
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format];
    [objDateformat setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateValue];
    NSString *stringFromDate = [objDateformat stringFromDate:date];
    
    return stringFromDate;
}

+ (NSString *)currentDateTime{
    NSString *dateTimeString;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    //    dateTimeString = [SWUtil convertDate:date toStringFormat:Date_Format];
    
    return dateTimeString;
}

@end
