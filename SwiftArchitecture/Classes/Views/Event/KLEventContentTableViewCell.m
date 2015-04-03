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
    NSMutableArray *_imgContentArr;
    NSMutableArray *_imgArr;
    NSMutableArray *_imgName;
    BOOL _isShow;
    int _bad;
    int _fine;
    int _good;
    BOOL _didFollow;
}

- (void)awakeFromNib {
    // Initialization code
    _imgArr = [[NSMutableArray alloc] initWithCapacity:10];
    _imgContentArr = [[NSMutableArray alloc] initWithCapacity:10];
    _imgName = [[NSMutableArray alloc] initWithCapacity:10];
    [self initUI];
    _isSelected = NO;
    _didFollow = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI {
    _imgRateChecked.hidden = YES;
    self.clipsToBounds = YES;
    
    _bgView.layer.cornerRadius = 3;
    _bgView.clipsToBounds = YES;
    
    _rateContentView.layer.borderColor = [UIColor colorWithHex:Blue_Color alpha:1].CGColor;
    _rateContentView.layer.borderWidth = 1;
    _rateContentView.layer.cornerRadius = 5;
    [_btnShowRateView setImage:[UIImage imageNamed:@"Down Circular"] forState:UIControlStateNormal];
    _isShow = NO;
    [_ratebgView setFrame:CGRectMake(_ratebgView.frame.origin.x, -_ratebgView.bounds.size.height+20, _ratebgView.bounds.size.width, _ratebgView.bounds.size.height)];
    
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

    UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailViewControllerForCell)];
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailViewControllerForCell)];
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailViewControllerForCell)];
    _lblContent.userInteractionEnabled = YES;
    _lblEventTitle.userInteractionEnabled = YES;
    _lblEventTime.userInteractionEnabled = YES;
    
    [_lblContent addGestureRecognizer:contentTap];
    [_lblEventTitle addGestureRecognizer:titleTap];
    [_lblEventTime addGestureRecognizer:timeTap];
    
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserPageViewControllerForCell)];
    userTap.numberOfTapsRequired = 1;
    userTap.numberOfTouchesRequired = 1;
    _lblName.userInteractionEnabled = YES;
    [_lblName addGestureRecognizer:userTap];
    
    UITapGestureRecognizer *imgUserTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserPageViewControllerForCell)];
    imgUserTap.numberOfTapsRequired = 1;
    imgUserTap.numberOfTouchesRequired = 1;
    _imgAvatar.userInteractionEnabled = YES;
    [_imgAvatar addGestureRecognizer:imgUserTap];;
}

- (void)showDetailViewControllerForCell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToDetailViewControllerUserDelegateForCellAtIndexPath:)]) {
        [self.delegate pushToDetailViewControllerUserDelegateForCellAtIndexPath:_indexPath];
    }
}

- (void)showUserPageViewControllerForCell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToUserPageViewControllerUserDelegateForCellAtIndexPath:)]) {
        [self.delegate pushToUserPageViewControllerUserDelegateForCellAtIndexPath:_indexPath];
    }
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
    _newsUserId = [dict objectForKey:kUserId];
    
    _cellData = dict;
    _postType = [[dict objectForKey:@"type"] intValue];
    
    if (_postType == event) {
        _btnShowMore.hidden = NO;
        _lblNumberOfFollowers.hidden = NO;
    } else {
        _btnShowMore.hidden = YES;
        _lblNumberOfFollowers.hidden = YES;
    }
    
    int isAdmin = [[dict objectForKey:kIsAdmin] intValue];

    if (isAdmin == 0) {
        _imgAdmin.hidden = YES;
    } else {
        _imgAdmin.hidden = NO;
        [self bringSubviewToFront:_imgAdmin];
    }
    
    int type = [[dict objectForKey:@"type"] intValue];
    if (type == 2) {
        _ratebgView.hidden = YES;
    }
    
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
    } else {
        _imgArr = [dict objectForKey:@"images"];
        
        if (_imgArr.count > 0) {
            [self setUIScroll];
        }
    }
    
    NSString *commentsNumber = [NSString stringWithFormat:@" %@",[dict objectForKey:@"comments"]];
    self.numberOfCommentInNews = [[dict objectForKey:@"comments"] integerValue];
    [_btnMessage setTitle:commentsNumber forState:UIControlStateNormal];
    
    [_btnMessage sizeToFit];
    CGRect btnMessFrame = _btnMessage.frame;    
    btnMessFrame.size.width += 12;
    btnMessFrame.size.height = 30;
    _btnMessage.frame = btnMessFrame;
    
    _lblName.text = [dict objectForKey:@"name"];
    
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
        
        NSDate *currentDate = [NSDate date];
        int now = [[SWUtil convertDateToNumber:currentDate] intValue];
        
        if (now > eventTime) {
            int type = [[dict objectForKey:@"type"] intValue];
            if (type == 2) {
                _ratebgView.hidden = YES;
            } else {
                _ratebgView.hidden = NO;
            }
            
        } else {
            _ratebgView.hidden = YES;
        }
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
        
    NSString *imgAvatarPath = EMPTY_IF_NULL_OR_NIL([dict objectForKey:kAvatar]);
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
    
    self.numberOfFollowInNews = [[dict objectForKey:@"follow"] integerValue];
    _lblNumberOfFollowers.text = [NSString stringWithFormat:@"%d", (int)self.numberOfFollowInNews];
    
    NSArray *didFollowArr = [dict objectForKey:@"did_follow"];
    if (didFollowArr.count > 0) {
        for (int i =0; i < didFollowArr.count; i++) {
            NSDictionary *uDict = [didFollowArr objectAtIndex:i];
            NSString *idStr = [uDict objectForKey:@"user_id"];
            if ([idStr isEqualToString:userId]) {
                _didFollow = YES;
                [self didFollow:YES];
            }
        }
    } else {
        _didFollow = NO;
        [self didFollow:NO];
    }
}

- (void)setUIScroll {
    for (UIView *subview in _scrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    int xPos = 0;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    
    for (int i = 0; i < _imgArr.count; i++) {
        NSDictionary *imgDict = [_imgArr objectAtIndex:i];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.clipsToBounds = YES;
        imgView.tag = i;
        NSString *imageLink = [NSString stringWithFormat:@"%@%@", URL_IMG_BASE, [imgDict objectForKey:@"link"]];
        NSString *imageName = [imageLink lastPathComponent];
        if (![_imgName containsObject:imageName]) {
            [_imgName addObject:imageName];
        }
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageLink]
                   placeholderImage:[UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                              if (image) {
                                  imgView.contentMode = UIViewContentModeScaleAspectFill;
                                  if (![_imgContentArr containsObject:image]) {
                                      [_imgContentArr addObject:image];
                                  }
                              } else {
                                  
                              }
                          }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgToFullScreen:)];
        tap.delegate = self;
        [imgView addGestureRecognizer:tap];
        tap.enabled = YES;
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        imgView.userInteractionEnabled = YES;
        
        
        CGRect frame = [imgView frame];
        frame.origin.x = xPos;
        frame.size.width = _newsContentView.bounds.size.width;
        frame.size.height = 160;
        xPos += frame.size.width;
        [imgView setFrame:frame];
        
        [_scrollView addSubview:imgView];
    }
    _scrollView.pagingEnabled = YES;
    CGSize contentSize = [_scrollView contentSize];
    contentSize.width=xPos;
    [_scrollView setContentSize:contentSize];
}

-(void)imgToFullScreen:(UITapGestureRecognizer*)gestureRecognizer {
    UIImageView *gestureView = (UIImageView *)[gestureRecognizer view];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChooseImage:AtIndex:)]) {
        [self.delegate didChooseImage:_imgContentArr AtIndex:gestureView.tag];
    }
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
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
        NSDictionary *parameters = @{@"user_id": userId,
                                     @"news_id": [NSNumber numberWithInteger:_newsId]};
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (![userId isEqualToString:_newsUserId]) {
                NSArray *contentArr = [_lblEventTitle.text componentsSeparatedByString:@" "];
                NSMutableArray *shortContentArr = [[NSMutableArray alloc] initWithCapacity:10];
                int count = 10;
                if (contentArr.count < count) {
                    count = (int)contentArr.count;
                }
                for (int i = 0; i < count; i++) {
                    [shortContentArr addObject:[contentArr objectAtIndex:i]];
                }
                
                NSString *shortContent = @" đã thích sự kiện: ";
                NSString *str = [shortContentArr componentsJoinedByString:@" "];
                shortContent = [shortContent stringByAppendingString:str];
                [SWUtil postNotification:shortContent forUser:_newsUserId type:0];
            }
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
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChooseEditCellAtIndexPath:withData:withType:withImage:withImageName:)]) {
        [self.delegate didChooseEditCellAtIndexPath:_indexPath withData:_cellData withType:_postType withImage:_imgContentArr withImageName:_imgName];
        [self hiddenView:_toolView];
    }
}

- (IBAction)btnDeleteTapped:(id)sender {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nDeleteNews];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    NSDictionary *parameters = @{@"news_id"  :  [NSNumber numberWithInteger:_newsId]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSDictionary *dict = (NSDictionary*)responseObject;
        [[SWUtil sharedUtil] hideLoadingView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteCellAtIndexPath:)]) {
            [self.delegate didDeleteCellAtIndexPath:_indexPath];
            [self hiddenView:_toolView];
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
        if (_isShow) {
            _isShow = NO;
            [self showRateView:NO];
        }
    } else {
        [self hiddenView:_toolView];
    }
}

- (IBAction)btnMessageTapped:(id)sender {
    [self showDetailViewControllerForCell];
}

- (IBAction)btnMoreTapped:(id)sender {
    _didFollow = !_didFollow;
    [self didFollow:_didFollow];
    
    if (_didFollow) {
        self.numberOfFollowInNews++;
        
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nInsertFollow];
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
        NSDictionary *parameters = @{@"user_id": userId,
                                     @"news_id": [NSNumber numberWithInteger:_newsId]};
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (![userId isEqualToString:_newsUserId]) {
                NSArray *contentArr = [_lblEventTitle.text componentsSeparatedByString:@" "];
                NSMutableArray *shortContentArr = [[NSMutableArray alloc] initWithCapacity:10];
                int count = 10;
                if (contentArr.count < count) {
                    count = (int)contentArr.count;
                }
                for (int i = 0; i < count; i++) {
                    [shortContentArr addObject:[contentArr objectAtIndex:i]];
                }
                
                NSString *shortContent = @" đã follow sự kiện: ";
                NSString *str = [shortContentArr componentsJoinedByString:@" "];
                shortContent = [shortContent stringByAppendingString:str];
                [SWUtil postNotification:shortContent forUser:_newsUserId type:0];
            }
            NSLog(@"follow sucess - user: %@ - follow news_id: %d", userId, (int)_newsId);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSLog(@"follow faild - user: %@ - follow news_id: %d", userId, (int)_newsId);
        }];
        
        _lblNumberOfFollowers.text = [NSString stringWithFormat:@"%d", (int)self.numberOfFollowInNews];
    } else {
        if (self.numberOfFollowInNews > 0) {
            self.numberOfFollowInNews--;
            NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nDeleteFollow];
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
            NSDictionary *parameters = @{@"user_id": userId,
                                         @"news_id": [NSNumber numberWithInteger:_newsId]};
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"delete follow sucess - user: %@ - follow news_id: %d", userId, (int)_newsId);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                NSLog(@"delete follow faild - user: %@ - follow news_id: %d", userId, (int)_newsId);
            }];
            _lblNumberOfFollowers.text = [NSString stringWithFormat:@"%d", (int)self.numberOfFollowInNews];
        }
    }
}

- (void)didFollow:(BOOL)flag {
    if (flag) {
        _lblNumberOfFollowers.textColor = [UIColor colorWithHex:Blue_Color alpha:1];
    } else {
        _lblNumberOfFollowers.textColor = [UIColor blackColor];
    }
}

- (IBAction)btnShowRateViewTapped:(id)sender {
    _isShow = !_isShow;
    
    if (_isShow) {
        [self getRateInfo];
    } else {
        [self showRateView:_isShow];
    }
}

- (void)showRateView:(BOOL)show {
    
    if (show) {
        if (!_toolView.hidden) {
            [self hiddenView:_toolView];
        }
        [_ratebgView setFrame:CGRectMake(_ratebgView.frame.origin.x, -_ratebgView.bounds.size.height+20, _ratebgView.bounds.size.width, _ratebgView.bounds.size.height)];

        [UIView animateWithDuration:0.3f
                         animations:^{
                             [_ratebgView setFrame:CGRectMake(_ratebgView.frame.origin.x, -2, _ratebgView.bounds.size.width, _ratebgView.bounds.size.height)];
                         }
                         completion:^(BOOL finished) {
                             [_btnShowRateView setImage:[UIImage imageNamed:@"Up Circular"] forState:UIControlStateNormal];
                         }];
        
    } else {
        [_ratebgView setFrame:CGRectMake(_ratebgView.frame.origin.x, -2, _ratebgView.bounds.size.width, _ratebgView.bounds.size.height)];
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             
                             [_ratebgView setFrame:CGRectMake(_ratebgView.frame.origin.x, -_ratebgView.bounds.size.height+20, _ratebgView.bounds.size.width, _ratebgView.bounds.size.height)];
                         }
                         completion:^(BOOL finished) {
                             [_btnShowRateView setImage:[UIImage imageNamed:@"Down Circular"] forState:UIControlStateNormal];
                         }];
    }
}

- (IBAction)btnRateBadTapped:(id)sender {
    [self rate:Bad];
    _imgRateChecked.hidden = NO;
    _imgRateChecked.frame = _btnRateBad.frame;
}

- (IBAction)btnRateFineTapped:(id)sender {
    [self rate:Fine];
    _imgRateChecked.hidden = NO;
    _imgRateChecked.frame = _btnRateFine.frame;
}

- (IBAction)btnRateGoodTapped:(id)sender {
    [self rate:Good];
    _imgRateChecked.hidden = NO;
    _imgRateChecked.frame = _btnRateGood.frame;
}


- (void)getRateInfo {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetRate];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserId];
    NSDictionary *parameters = @{kNewsId    : [NSNumber numberWithInteger:_newsId],
                                 kUserId    : [NSNumber numberWithInteger:userId]};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            
            _bad = [[dict objectForKey:@"status 1"] intValue];
            _lblRateBad.text = [NSString stringWithFormat:@"%d", _bad];
            
            _fine = [[dict objectForKey:@"status 2"] intValue];
            _lblRateFine.text = [NSString stringWithFormat:@"%d", _fine];
            
            _good = [[dict objectForKey:@"status 3"] intValue];
            _lblRateGood.text = [NSString stringWithFormat:@"%d", _good];
            
            NSArray *didRate = [dict objectForKey:@"did_rate"];
            if (didRate.count > 0) {
                NSDictionary *didRateDict = [didRate objectAtIndex:0];
                int status = [[didRateDict objectForKey:@"status"] intValue];
                _imgRateChecked.hidden = NO;
                switch (status) {
                    case Bad:
                        _imgRateChecked.frame = _btnRateBad.frame;
                        break;
                    case Fine:
                        _imgRateChecked.frame = _btnRateFine.frame;
                        break;
                    case Good:
                        _imgRateChecked.frame = _btnRateGood.frame;
                        break;
                    default:
                        break;
                }
                
                _btnRateBad.enabled = NO;
                _btnRateFine.enabled = NO;
                _btnRateGood.enabled = NO;
            } else {
                _imgRateChecked.hidden = YES;
                _btnRateBad.enabled = YES;
                _btnRateFine.enabled = YES;
                _btnRateGood.enabled = YES;
            }
        }
        [self showRateView:_isShow];
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get Rate Error: %@", error);
        [SWUtil showConfirmAlert:[error localizedDescription] message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (void)rate:(RateStaus)rate {
    _btnRateBad.enabled = NO;
    _btnRateFine.enabled = NO;
    _btnRateGood.enabled = NO;
    
    switch (rate) {
        case Bad:
            _bad++;
            _lblRateBad.text = [NSString stringWithFormat:@"%d", _bad];
            break;
        case Fine:
            _fine++;
            _lblRateFine.text = [NSString stringWithFormat:@"%d", _fine];
            break;
        case Good:
            _good++;
            _lblRateGood.text = [NSString stringWithFormat:@"%d", _good];
            break;
        default:
            break;
    }
    
    NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserId];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nInsertRate];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    NSDictionary *parameters = @{kUserId   : [NSNumber numberWithInteger:userId],
                                 kNewsId   : [NSNumber numberWithInteger:_newsId],
                                 @"status" : [NSNumber numberWithInteger:rate]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"rate post success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"rate post success error: %@", error);
    }];
}
@end
