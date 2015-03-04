//
//  FriendTableViewCell.m
//  SimpleWeather
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _onlineView.layer.borderColor = [UIColor whiteColor].CGColor;
    _onlineView.layer.borderWidth = 3;
    _onlineView.layer.cornerRadius = _onlineView.bounds.size.width / 2.0;
    _onlineView.clipsToBounds = YES;
}

- (void)setOnline:(BOOL)flag {
    _onlineView.hidden = !flag;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
