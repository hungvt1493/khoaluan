//
//  KLCommentTableViewCell.m
//  KhoaLuan2015
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLCommentTableViewCell.h"

@implementation KLCommentTableViewCell {
    BOOL _isSelected;
}

- (void)awakeFromNib {
    // Initialization code
    _btnLike.layer.borderWidth = 0;
    _btnLike.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnLikeTapped:(id)sender {
}

- (void)setContentUIByString:(NSDictionary*)dict {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    
    NSString *content = [dict objectForKey:@"content"];
    _lblContent.text = content;
    [_lblContent sizeToFit];
    
    CGSize textSize = CGSizeMake(_lblContent.frame.size.width  , 9999);
    
    CGFloat height = 0;
    
    if (SYSTEM_VERSION <7) {
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14]
                  constrainedToSize:textSize
                      lineBreakMode:NSLineBreakByWordWrapping];
        height = size.height;
    } else {
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:14], NSFontAttributeName,
                                              nil];
        CGRect requiredHeight = [content boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
        height = requiredHeight.size.height;
    }
    
    CGRect lblContentFrame = _lblContent.frame;
    lblContentFrame.origin.y = 0;
    lblContentFrame.size.height = height+10;
    _lblContent.frame = lblContentFrame;
    
    CGRect lblToolFrame = _toolView.frame;
    lblToolFrame.origin.y = height + 12;
    _toolView.frame = lblToolFrame;
    
    int time = [[dict objectForKey:@"time"] intValue];
    NSDate *date = [SWUtil convertNumberToDate:time];
    
    NSString *ago = [date timeAgo];//[date timeAgo];
    _lblTime.text = ago;
    
    NSString *imgAvatarPath = [[NSUserDefaults standardUserDefaults] objectForKey:kAvatar];
    if (imgAvatarPath.length > 0) {
        NSString *imageLink = [NSString stringWithFormat:@"%@%@", URL_IMG_BASE, imgAvatarPath];
        [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:imageLink]
                          placeholderImage:[UIImage imageNamed:@"default-avatar"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image) {
                                         
                                     } else {
                                         
                                     }
                                 }];
    }

    NSArray *userLikeArr = [dict objectForKey:@"user_like"];
    self.numberOfLikeInNews = userLikeArr.count;
    if (userLikeArr.count == 0) {
        [self didLike:NO];
        _isSelected = NO;
    } else {
        for (int i = 0; i < userLikeArr.count; i++) {
            NSDictionary *uDict = [userLikeArr objectAtIndex:i];
            NSString *idStr = [uDict objectForKey:@"user_like_id"];
            if ([idStr isEqualToString:userId]) {
                [self didLike:YES];
                _isSelected = YES;
            }
        }
    }
    
    NSString *likesNumber = [NSString stringWithFormat:@" %d", (int)self.numberOfLikeInNews];
    [_btnLike setTitle:likesNumber forState:UIControlStateNormal];
    [_btnLike sizeToFit];
    CGRect btnLikeFrame = _btnLike.frame;
    btnLikeFrame.size.width += 8;
    btnLikeFrame.size.height = 25;
    _btnLike.frame = btnLikeFrame;

}

- (void)didLike:(BOOL)flag {
    if (flag) {
        _btnLike.backgroundColor = [UIColor colorWithHex:Blue_Color alpha:1];
    } else {
        _btnLike.backgroundColor = [UIColor colorWithHex:Like_Button_color alpha:1];
    }
}
@end
