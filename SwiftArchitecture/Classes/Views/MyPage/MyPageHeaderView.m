//
//  MyPageHeaderView.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "MyPageHeaderView.h"
#import "FriendsViewController.h"
#import "KLPostNewsViewController.h"

@implementation MyPageHeaderView

- (void)awakeFromNib {
    // Initialization code
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithHex:@"E3E3E3" alpha:1];
    
    _btnSetting.layer.borderWidth = 0;
    _btnSetting.layer.cornerRadius = _btnSetting.bounds.size.width / 2.0;
    
    _btnWriteNewPost.layer.borderWidth = 0;
    _btnWriteNewPost.layer.cornerRadius = 5;
    
    _imgAvatar.layer.cornerRadius = _imgAvatar.bounds.size.width / 2.0;
    _imgAvatar.layer.borderWidth = 1;
    _imgAvatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgAvatar.clipsToBounds = YES;
    
    _avatarBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarBgView.layer.borderWidth = 1;
    _avatarBgView.layer.cornerRadius = _avatarBgView.bounds.size.width / 2.0;
}

- (IBAction)btnFriendTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToViewControllerUseDelegete:)]) {
        FriendsViewController *friendVC = [[FriendsViewController alloc] init];
        [self.delegate pushToViewControllerUseDelegete:friendVC];
    }
}

- (IBAction)btnPostNewsTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToViewControllerUseDelegete:)]) {
        KLPostNewsViewController *postNewsVC = [[KLPostNewsViewController alloc] init];
        [self.delegate pushToViewControllerUseDelegete:postNewsVC];
    }
}
@end
