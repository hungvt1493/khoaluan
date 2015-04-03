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

+ (NSString*)changeToUnsign:(NSString*)text {
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *aStr = @"à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ";
    NSArray *aStrArray = [aStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < aStrArray.count; i++) {
        text = [text stringByReplacingOccurrencesOfString:[aStrArray objectAtIndex:i] withString:@"a"];
    }
    
    NSString *eStr = @"è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ";
    NSArray *eStrArray = [eStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < eStrArray.count; i++) {
        text = [text stringByReplacingOccurrencesOfString:[eStrArray objectAtIndex:i] withString:@"e"];
    }
    
    NSString *iStr = @"ì|í|ị|ỉ|ĩ";
    NSArray *iStrArray = [iStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < iStrArray.count; i++) {
        text = [text stringByReplacingOccurrencesOfString:[iStrArray objectAtIndex:i] withString:@"i"];
    }
    
    NSString *oStr = @"ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ";
    NSArray *oStrArray = [oStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < oStrArray.count; i++) {
        text = [text stringByReplacingOccurrencesOfString:[oStrArray objectAtIndex:i] withString:@"o"];
    }
    
    NSString *uStr = @"ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ";
    NSArray *uStrArray = [uStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < uStrArray.count; i++) {
        text = [text stringByReplacingOccurrencesOfString:[uStrArray objectAtIndex:i] withString:@"u"];
    }
    
    NSString *yStr = @"ỳ|ý|ỵ|ỷ|ỹ";
    NSArray *yStrArray = [yStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < yStrArray.count; i++) {
        text = [text stringByReplacingOccurrencesOfString:[yStrArray objectAtIndex:i] withString:@"y"];
    }
    
    NSString *dStr = @"đ";
    NSArray *dStrArray = [dStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < dStrArray.count; i++) {
        text = [text stringByReplacingOccurrencesOfString:[dStrArray objectAtIndex:i] withString:@"d"];
    }
    
    return text;
}

+ (void)postNotification:(NSString*)content forUser:(NSString*)userReceive type:(int)type {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    NSString *notiurl = [NSString stringWithFormat:@"%@%@", URL_BASE, notiSendNotification];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kName];
    name = [name stringByAppendingString:content];

    NSDictionary *notiparameters = @{@"content"             : name,
                                     @"user_send_id"        : userId,
                                     @"user_receive_id"     : userReceive,
                                     @"type"                : [NSNumber numberWithInt:type]};
    
    [manager POST:notiurl parameters:notiparameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+ (void)saveUserInfo:(NSDictionary*)userDict {
    NSString *avatarUrl = EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kAvatar]);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:avatarUrl forKey:kAvatar];
    [userDefault setObject:[userDict objectForKey:kUserId] forKey:kUserId];
    [userDefault setObject:[userDict objectForKey:kIsAdmin] forKey:kIsAdmin];
    [userDefault setObject:[userDict objectForKey:kUserName] forKey:kUserName];
    [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kStudentId]) forKey:kStudentId];
    [userDefault setInteger:[[userDict objectForKey:kBirthDay] integerValue] forKey:kBirthDay];
    [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kFaculty]) forKey:kFaculty];
    [userDefault setObject:[userDict objectForKey:kName] forKey:kName];
    [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kTimelineImage]) forKey:kTimelineImage];
    [userDefault setObject:[userDict objectForKey:kGender] forKey:kGender];
    [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kAboutMe]) forKey:kAboutMe];
    [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kEmail]) forKey:kEmail];
}

+ (NSDictionary*)getUserInfo {
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *avatarUrl = EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kAvatar]);
    [userDict setObject:avatarUrl forKey:kAvatar];
    [userDict setObject:EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kUserId]) forKey:kUserId];
    [userDict setObject:EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kIsAdmin]) forKey:kIsAdmin];
    [userDict setObject:EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kUserName]) forKey:kUserName];
    [userDict setObject:EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kStudentId]) forKey:kStudentId];
    [userDict setObject:[NSNumber numberWithInteger:[[userDefault objectForKey:kBirthDay] integerValue]] forKey:kBirthDay];
    [userDict setObject:EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kFaculty]) forKey:kFaculty];
    [userDict setObject:EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kName]) forKey:kName];
    [userDict setObject:EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kTimelineImage]) forKey:kTimelineImage];
    [userDict setObject:[userDefault objectForKey:kGender] forKey:kGender];
    [userDict setObject:EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kAboutMe]) forKey:kAboutMe];
    [userDict setObject:EMPTY_IF_NULL_OR_NIL([userDefault objectForKey:kEmail]) forKey:kEmail];
    
    return userDict;
}

@end
