//
//  KLNewsDetailViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLNewsDetailViewController.h"
#import "KLCommentTableViewCell.h"

@interface KLNewsDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation KLNewsDetailViewController {
    BOOL _isSelected;
    BOOL _haveImages;
    NSArray *_commentArr;
    NSMutableArray *_commentHeightArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initUIForContentView];
    
    [self initData];
    
    self.navigationController.scrollNavigationBar.scrollView = nil;
    
//    _commentArr = [[NSMutableArray alloc] initWithCapacity:10];
    _commentHeightArr = [[NSMutableArray alloc] initWithCapacity:10];
    
//    [_commentArr addObject:@"Test1"];
//    [_commentArr addObject:@"Test2\n.\n.\n."];
//    [_commentArr addObject:@"Test3 ansdakjnsdkajsdakjsdalkjsdbkasljbdkajsbdasdkbasdlkjbaslkdjbalskdjbalksjbdalksbd"];
//    [_commentArr addObject:@"Test4"];
//    [_commentArr addObject:@"Test5"];
//    [_commentArr addObject:@"Test6"];
//    [_commentArr addObject:@"Test7"];
    
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    
    self.inputView = [[SOMessageInputView alloc] init];
    self.inputView.delegate = self;
    self.inputView.tableView = self.commentTableView;
    [self.view addSubview:self.inputView];
    [self.inputView adjustPosition];
}

- (BOOL)shouldAutorotate
{
    if (self.inputView.viewIsDragging) {
        return NO;
    }
    return YES;
}

- (void)initData {
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNewsWithNewsId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parameters = @{@"news_id": [NSNumber numberWithInt:_newsId],
                                 @"type": [NSNumber numberWithInt:_postType]};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            _dict = dict;
            [self initDataForContentView];
            [self getComment];
        }
        
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];

}

- (void)getComment {
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, cmGetComment];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parameters = @{@"news_id": [NSNumber numberWithInt:_newsId]};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _commentArr = (NSArray*)responseObject;
        } else {
            _commentArr = nil;
        }
        
        [_commentTableView reloadData];
        [self.inputView adjustPosition];
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];

}

- (void)haveImage:(BOOL)flag {
    if (!flag) {
        _imgScrollView.hidden = YES;
        _newsContentView.frame = CGRectMake(0, 63, _newsContentView.frame.size.width, _newsContentView.frame.size.height);
    }
}

- (void)initUIForContentView {
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

- (void)initDataForContentView {
    
    _postType = [[_dict objectForKey:@"type"] intValue];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSString *newsUserId = [_dict objectForKey:@"user_id"];
    if ([userId isEqualToString:newsUserId]) {
        _btnShowTool.hidden = NO;
    } else {
        _btnShowTool.hidden = YES;
    }
    
    _newsId = [[_dict objectForKey:@"news_id"] integerValue];
    
    int numberOfImage = [[_dict objectForKey:@"number_of_image"] intValue];
    
    if (numberOfImage == 0) {
        [self haveImage:NO];
    }
    
    NSString *commentsNumber = [NSString stringWithFormat:@" %@",[_dict objectForKey:@"comments"]];
    self.numberOfLikeInNews = [[_dict objectForKey:@"comments"] integerValue];
    [_btnMessage setTitle:commentsNumber forState:UIControlStateNormal];
    
    [_btnMessage sizeToFit];
    CGRect btnMessFrame = _btnMessage.frame;
    btnMessFrame.size.width += 12;
    btnMessFrame.size.height = 30;
    _btnMessage.frame = btnMessFrame;
    
    _lblName.text = [_dict objectForKey:@"name"];
    
    int time = [[_dict objectForKey:@"time"] intValue];
    NSDate *date = [SWUtil convertNumberToDate:time];
    
    NSString *ago = [date timeAgo];//[date timeAgo];
    _lblTime.text = ago;
    //NSLog(@"Output is: \"%@\" - %@", ago, date);
    
    NSString *content = [_dict objectForKey:@"content"];
    _lblContent.text = content;

    CGSize  textSize = { 320, 10000.0 };
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:textSize
                          lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect lblContentFrame = _lblContent.frame;
    lblContentFrame.origin.y = -7;
    lblContentFrame.size.height = size.height+20;
    _lblContent.frame = lblContentFrame;
    
    CGRect lblFooterNewsViewFrame = _footerNewsView.frame;

    CGRect newsFrame = _newsContentView.frame;
    if (numberOfImage == 0) {
        newsFrame.origin.y = 71;
    } else {
        newsFrame.origin.y = 233;
    }
    newsFrame.size.height = size.height + 20 + lblFooterNewsViewFrame.size.height;
    _newsContentView.frame = newsFrame;
    
    lblFooterNewsViewFrame.origin.y = newsFrame.size.height - lblFooterNewsViewFrame.size.height;
    _footerNewsView.frame = lblFooterNewsViewFrame;
    
    
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

    NSArray *userLikeArr = [_dict objectForKey:@"user_like"];
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

- (IBAction)btnEditTapped:(id)sender {

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_commentHeightArr removeAllObjects];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"KLCommentTableViewCell";
    KLCommentTableViewCell *cell = (KLCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"KLCommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.preservesSuperviewLayoutMargins = NO;
    NSDictionary *comment = [_commentArr objectAtIndex:indexPath.row];
    [cell setContentUIByString:comment];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = [self calculateHeightOfCommentCellByString:[[_commentArr objectAtIndex:indexPath.row] objectForKey:@"content"]];
//    NSLog(@"HEIGHT: %d", height);
    [_commentHeightArr addObject:[NSNumber numberWithInteger:height]];
    
    if (indexPath.row == (_commentArr.count - 1)) {
        NSInteger tbHeight = 0;
        for (int i = 0; i < _commentHeightArr.count; i++) {
            NSInteger cellHeight = [[_commentHeightArr objectAtIndex:i] integerValue];
            tbHeight += cellHeight;
            
            if (i == (_commentHeightArr.count - 1)) {
                //NSLog(@"HEIGHT: %@", _commentHeightArr);
                [_commentHeightArr removeAllObjects];
            }
        }
        
        CGRect commentTableFrame = _commentTableView.frame;
        commentTableFrame.origin.y = _newsContentView.frame.origin.y + _newsContentView.bounds.size.height;
        commentTableFrame.size.height = tbHeight;
        _commentTableView.frame = commentTableFrame;
        
        CGSize scrollContentSize = _scrollView.contentSize;
        scrollContentSize.height = _commentTableView.frame.origin.y + _commentTableView.bounds.size.height + 50;
        _scrollView.contentSize = scrollContentSize;
        
        //NSLog(@"%@ -- TB: %@ - SC: %@ -- %d", NSStringFromCGRect(_newsContentView.frame), NSStringFromCGRect(commentTableFrame), NSStringFromCGSize(scrollContentSize), tbHeight);
    }
    
    return height;
}

- (NSInteger)calculateHeightOfCommentCellByString:(NSString*)str {
    CGFloat height = 0;
    CGSize  textSize = { 255, 9999 };
    
    if (SYSTEM_VERSION <7) {
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14]
                         constrainedToSize:textSize
                             lineBreakMode:NSLineBreakByWordWrapping];
        height = size.height;
    } else {
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:14], NSFontAttributeName,
                                              nil];
        CGRect requiredHeight = [str boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
        height = requiredHeight.size.height;
    }
    
    height += 43;
    
    return height;
}

/**
 * Called when user tap the media image view
 */
- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell {
    
}

/**
 * Called when user tap on send button
 */
- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message {
    
    if (message.length > 0) {
        [[SWUtil sharedUtil] showLoadingView];
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, cmAddComment];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
        NSDictionary *parameters = @{@"content"        : NULL_IF_NIL(message),
                                     @"news_id"        : [NSNumber numberWithInteger:_newsId],
                                     @"user_id"        : userId};
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[SWUtil sharedUtil] hideLoadingView];
            [self getComment];
            NSLog(@"POST MESSAGE SUCCESS");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
            [[SWUtil sharedUtil] hideLoadingView];
        }];
    }
    
}

/**
 * Called when user tap on attach media button
 */
- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView {
    
}
@end
