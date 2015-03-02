//
//  MyPageHeaderView.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "MyPageHeaderView.h"

@implementation MyPageHeaderView

- (id)initWithFrame:(CGRect)frame
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    if (array == nil || [array count] == 0)
        return nil;
    frame = [[array objectAtIndex:0] frame];
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:[array objectAtIndex:0]];
        
        //UITapGestureRecognizer *tapGestureViewController = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOptionGrid)];
        //[self addGestureRecognizer:tapGestureViewController];
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _btnSetting.layer.borderWidth = 0;
    _btnSetting.layer.cornerRadius = _btnSetting.bounds.size.width / 2.0;
    
    _btnWriteNewPost.layer.borderWidth = 0;
    _btnWriteNewPost.layer.cornerRadius = 5;
    
    _imgAvatar.layer.cornerRadius = _imgAvatar.bounds.size.width / 2.0;
    _imgAvatar.layer.borderWidth = 1;
    _imgAvatar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _imgAvatar.clipsToBounds = YES;
    
    _avatarBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarBgView.layer.borderWidth = 1;
    _avatarBgView.layer.cornerRadius = _avatarBgView.bounds.size.width / 2.0;
}

@end
