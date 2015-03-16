//
//  KLNewsContentTableViewCell.m
//  KhoaLuan2015
//
//  Created by Mac on 3/12/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLEventContentTableViewCell.h"

@implementation KLEventContentTableViewCell {
    BOOL _isSelected;
    NSDictionary *_cellData;
}

- (void)awakeFromNib {
    // Initialization code
    [self initUI];
    _isSelected = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI {
    _bgView.layer.cornerRadius = 3;
    _bgView.clipsToBounds = YES;
    
    _btnLike.layer.borderWidth = 0;
    _btnLike.layer.cornerRadius = 5;
    
    _btnMessage.layer.cornerRadius = 5;
    _btnMessage.layer.borderWidth = 1;
    _btnMessage.layer.borderColor = [UIColor blackColor].CGColor;
    
    _btnShowMore.layer.cornerRadius = 5;
    _btnShowMore.layer.borderWidth = 1;
    _btnShowMore.layer.borderColor = [UIColor blackColor].CGColor;
    
    _toolView.layer.cornerRadius = 5;
    _toolView.clipsToBounds = YES;
    _toolView.layer.borderColor = [UIColor blackColor].CGColor;
    _toolView.layer.borderWidth = 1;
    _toolView.hidden = YES;
}

- (void)haveImage:(BOOL)flag {
    if (!flag) {
        _scrollView.hidden = YES;
        _bgView.frame = CGRectMake(_bgView.frame.origin.x, _bgView.frame.origin.y, _bgView.frame.size.width, _bgView.frame.size.height);
        _newsContentView.frame = CGRectMake(0, 63, _newsContentView.frame.size.width, _newsContentView.frame.size.height);
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - _scrollView.frame.size.height);
    }
}

- (void)setData:(NSDictionary*)dict {
    _cellData = dict;
    _postType = [[dict objectForKey:@"type"] intValue];
    
    self.backgroundColor = [UIColor colorWithHex:@"E3E3E3" alpha:1];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSString *newsUserId = [dict objectForKey:@"user_id"];
    if ([userId isEqualToString:newsUserId]) {
        _btnShowTool.hidden = NO;
    } else {
        _btnShowTool.hidden = YES;
    }
    
    _newsId = [[dict objectForKey:@"news_id"] integerValue];
    
    int numberOfImage = [[dict objectForKey:@"number_of_image"] intValue];
    
    if (numberOfImage == 0) {
        [self haveImage:NO];
    }
    
    NSString *commentsNumber = [NSString stringWithFormat:@" %@",[dict objectForKey:@"comments"]];
    self.numberOfLikeInNews = [[dict objectForKey:@"comments"] integerValue];
    [_btnMessage setTitle:commentsNumber forState:UIControlStateNormal];
    
    [_btnMessage sizeToFit];
    CGRect btnMessFrame = _btnMessage.frame;    
    btnMessFrame.size.width += 12;
    btnMessFrame.size.height = 30;
    _btnMessage.frame = btnMessFrame;
    
    _lblName.text = [dict objectForKey:@"username"];
    
    int time = [[dict objectForKey:@"time"] intValue];
    NSDate *date = [SWUtil convertNumberToDate:time];
    
    NSString *ago = [date timeAgo];//[date timeAgo];
    _lblTime.text = ago;
    //NSLog(@"Output is: \"%@\" - %@", ago, date);
    
    NSString *eventTitle = [dict objectForKey:@"news_event_title"];
    _lblEventTitle.text = eventTitle;
    [_lblEventTitle sizeToFit];
    
    CGRect lblEventTitleFrame = _lblEventTitle.frame;
    
    if ([dict objectForKey:@"event_time"] != [NSNull null]) {
        int eventTime = [[dict objectForKey:@"event_time"] intValue];
        NSString *eventTimeStr = [SWUtil convert:eventTime toDateStringWithFormat:FULL_DATE_FORMAT];
        _lblEventTime.text = eventTimeStr;
        [_lblEventTime sizeToFit];
    }
    
    CGRect lblEventTimeFrame = _lblEventTime.frame;
    lblEventTimeFrame.origin.y = lblEventTitleFrame.origin.y + lblEventTitleFrame.size.height;
    _lblEventTime.frame = lblEventTimeFrame;
    
    NSString *content = [dict objectForKey:@"content"];
    _lblContent.text = content;
    CGFloat height;
    CGSize  textSize = { 293, 10000.0 };
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14]
                  constrainedToSize:textSize
                      lineBreakMode:NSLineBreakByWordWrapping];
    height = size.height < 30 ? 30 : 77;
    size.height = height;
    
    CGRect lblContentFrame = _lblContent.frame;
    lblContentFrame.origin.y = lblEventTimeFrame.origin.y + lblEventTimeFrame.size.height;
    lblContentFrame.size.height = height;
    _lblContent.frame = lblContentFrame;
    
    CGRect newsFrame = _newsContentView.frame;
    if (numberOfImage == 0) {
        newsFrame.origin.y = 71;
    } else {
        newsFrame.origin.y = 233;
    }
    newsFrame.size.height = height + 41 + lblEventTitleFrame.size.height + lblEventTimeFrame.size.height;
    _newsContentView.frame = newsFrame;
        
    NSString *imgPath = [dict objectForKey:@"avatar"];
    NSString *imageLink = [NSString stringWithFormat:@"%@%@", URL_IMG_BASE, imgPath];
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:imageLink]
                      placeholderImage:[UIImage imageNamed:@"default-avatar"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 if (image) {
                                     
                                 } else {
                                     
                                 }
                             }];
    
    NSArray *userLikeArr = [dict objectForKey:@"user_like"];
    self.numberOfLikeInNews = userLikeArr.count;
    if (userLikeArr.count == 0) {
        [self didLike:NO];
        _isSelected = NO;
    } else {
        for (int i =0; i < userLikeArr.count; i++) {
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
    btnLikeFrame.size.width += 12;
    btnLikeFrame.size.height = 30;
    _btnLike.frame = btnLikeFrame;
}

- (IBAction)btnLikeTapped:(id)sender {
    _isSelected = !_isSelected;
    [self didLike:_isSelected];
    
    if (_isSelected) {
        self.numberOfLikeInNews++;
        
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nLikeNews];
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"user_id": userId,
                                     @"news_id": [NSNumber numberWithInteger:_newsId]};
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"like sucess - user: %@ - like news_id: %d", userId, (int)_newsId);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSLog(@"like faild - user: %@ - like news_id: %d", userId, (int)_newsId);
        }];
        NSString *likesNumber = [NSString stringWithFormat:@" %d",(int)self.numberOfLikeInNews];
        [_btnLike setTitle:likesNumber forState:UIControlStateNormal];
    } else {
        if (self.numberOfLikeInNews > 0) {
            self.numberOfLikeInNews--;
            NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nDeleteLikeNews];
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary *parameters = @{@"user_id": userId,
                                         @"news_id": [NSNumber numberWithInteger:_newsId]};
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"delete like sucess - user: %@ - like news_id: %d", userId, (int)_newsId);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                NSLog(@"delete like faild - user: %@ - like news_id: %d", userId, (int)_newsId);
            }];
            NSString *likesNumber = [NSString stringWithFormat:@" %d",(int)self.numberOfLikeInNews];
            [_btnLike setTitle:likesNumber forState:UIControlStateNormal];
        }
        
    }
}

- (void)didLike:(BOOL)flag {
    if (flag) {
        _btnLike.backgroundColor = [UIColor colorWithHex:Blue_Color alpha:1];
    } else {
        _btnLike.backgroundColor = [UIColor colorWithHex:Like_Button_color alpha:1];
    }
}

- (void)showView:(UIView*)view{
    
    [view setAlpha:0.0f];
    view.hidden = NO;
    
    [UIView animateWithDuration:0.6f animations:^{
        
        [view setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenView:(UIView*)view {
    
    [view setAlpha:1];
    
    [UIView animateWithDuration:0.6f animations:^{
        
        [view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        
        view.hidden = YES;
    }];
}

- (IBAction)btnEditTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChooseEditCellAtIndexPath:withData:withType:)]) {
        [self.delegate didChooseEditCellAtIndexPath:_indexPath withData:_cellData withType:_postType];
    }
}

- (IBAction)btnDeleteTapped:(id)sender {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nDeleteNews];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"news_id"  :  [NSNumber numberWithInteger:_newsId]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSDictionary *dict = (NSDictionary*)responseObject;
        [[SWUtil sharedUtil] hideLoadingView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteCellAtIndexPath:)]) {
            [self.delegate didDeleteCellAtIndexPath:_indexPath];
            NSLog(@"Delete cell at index %d success - news_id: %d", (int)_indexPath.row, (int)_newsId);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Delete cell at index %d faild - news_id: %d", (int)_indexPath.row, (int)_newsId);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (IBAction)btnShowToolViewTapped:(id)sender {
    if (_toolView.hidden) {
        [self showView:_toolView];
    } else {
        [self hiddenView:_toolView];
    }
}

@end
