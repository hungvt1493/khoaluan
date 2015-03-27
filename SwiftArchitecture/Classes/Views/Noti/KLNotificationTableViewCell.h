//
//  KLNotificationTableViewCell.h
//  KhoaLuan2015
//
//  Created by Mac on 3/25/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLNotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) NSString *notiId;
@property (strong, nonatomic) NSString *userSendId;
@property (strong, nonatomic) NSString *userReceiveId;
@property (assign, nonatomic) int isRead;
@property (assign, nonatomic) int type;
@end
