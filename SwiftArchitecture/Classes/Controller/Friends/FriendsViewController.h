//
//  FriendsViewController.h
//  SimpleWeather
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "SWBaseViewController.h"

@protocol FriendsViewControllerDelegate <NSObject>

- (void)didBackToUserPage;
@end

@interface FriendsViewController : SWBaseViewController
@property (weak, nonatomic) id<FriendsViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tbFriend;
@property (strong, nonatomic) NSString *userId;
@end
