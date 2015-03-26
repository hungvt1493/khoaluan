//
//  KLNewsDetailViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLNewsDetailViewController.h"
#import "KLCommentTableViewCell.h"
#import "IBActionSheet.h"
#import "KRImageViewer.h"

NSMutableArray *_imgContentArr;
NSMutableArray *_imgArr;

@interface KLNewsDetailViewController () <UITableViewDataSource, UITableViewDelegate, IBActionSheetDelegate, KRImageViewerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgAdmin;
@property (nonatomic, strong) KRImageViewer *krImageViewer;
@end

@implementation KLNewsDetailViewController {
    BOOL _isSelected;
    BOOL _haveImages;
    NSArray *_commentArr;
    NSMutableArray *_commentHeightArr;
    NSIndexPath *_selectedIndexPath;
    NSString *_stringBeforeEdit;
    BOOL _willEdit;
    NSMutableArray *_imgArr;
    BOOL _isShow;
    int _bad;
    int _fine;
    int _good;
    BOOL _didFollow;
    NSString *_newsUserId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    _imgArr = [[NSMutableArray alloc] initWithCapacity:10];
    _imgContentArr = [[NSMutableArray alloc] initWithCapacity:10];
    [self setBackButtonWithImage:back_bar_button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    _willEdit = NO;
    _didFollow = NO;
    _toolView.hidden = YES;
    self.krImageViewer = [[KRImageViewer alloc] initWithDragMode:krImageViewerModeOfBoth];
    self.krImageViewer.delegate                    = self;
    self.krImageViewer.maxConcurrentOperationCount = 1;
    self.krImageViewer.dragDisapperMode            = krImageViewerDisapperAfterMiddle;
    self.krImageViewer.allowOperationCaching       = NO;
    self.krImageViewer.timeout                     = 30.0f;
    self.krImageViewer.doneButtonTitle             = @"Đóng";
    //Auto supports the rotations.
    self.krImageViewer.supportsRotations           = YES;
    //It'll release caches when caches of image over than X photos, but it'll be holding current image to display on the viewer.
    self.krImageViewer.overCacheCountRelease       = 200;
    //Sorting Rule, Default ASC is YES, DESC is NO.
    self.krImageViewer.sortAsc                     = YES;
    
    [self.krImageViewer setBrowsingHandler:^(NSInteger browsingPage)
     {
         //Current Browsing Page.
         //...Do Something.
     }];
    
    [self.krImageViewer setScrollingHandler:^(NSInteger scrollingPage)
     {
         //Current Scrolling Page.
         //...Do Something.
     }];
    
    if (_postType == status) {
        _ratebgView.hidden = YES;
    }
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SWUtil appDelegate] hideTabbar:NO];
    [self initUIForContentView];
    [self.krImageViewer useKeyWindow];

    [self initData];
    
    _commentHeightArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    
    self.inputView = [[SOMessageInputView alloc] init];
    self.inputView.delegate = self;
    //self.inputView.tableView = self.commentTableView;
    [self.view addSubview:self.inputView];
    [self.inputView adjustPosition];
}

- (void)removeNavigationBarAnimation {
    self.navigationController.scrollNavigationBar.scrollView = nil;
}

- (BOOL)shouldAutorotate
{
    if (self.inputView.viewIsDragging) {
        return NO;
    }
    return YES;
}

- (void)initData {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNewsWithNewsId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parameters = @{@"news_id": [NSNumber numberWithInteger:_newsId],
                                 @"type": [NSNumber numberWithInt:_postType]};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            _dict = dict;
            _newsUserId = [dict objectForKey:kUserId];
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
    
    NSDictionary *parameters = @{@"news_id": [NSNumber numberWithInteger:_newsId]};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _commentArr = (NSArray*)responseObject;
        } else {
            _commentArr = nil;
        }
        
        [_commentTableView reloadData];
        [self getNumberOfCommentFromServer];
//        [self.inputView adjustPosition];
//        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (void)getNumberOfCommentFromServer {
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nCountCommentInNews];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *parameters = @{@"news_id": [NSNumber numberWithInteger:_newsId]};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary*)responseObject;
        int code = [[dict objectForKey:@"code"] intValue];
        NSString *commentsNumber = @" 0";
        if (code != 1) {
            commentsNumber = [NSString stringWithFormat:@" %@",[dict objectForKey:@"comments"]];
        }
        self.numberOfCommentInNews = [[dict objectForKey:@"comments"] integerValue];
        [_btnMessage setTitle:commentsNumber forState:UIControlStateNormal];
        
        [_btnMessage sizeToFit];
        CGRect btnMessFrame = _btnMessage.frame;
        btnMessFrame.size.width += 12;
        btnMessFrame.size.height = 30;
        _btnMessage.frame = btnMessFrame;
        
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
    _rateContentView.layer.borderColor = [UIColor colorWithHex:Blue_Color alpha:1].CGColor;
    _rateContentView.layer.borderWidth = 1;
    _rateContentView.layer.cornerRadius = 5;
    _imgRateChecked.hidden = YES;
    _isShow = NO;
    [_ratebgView setFrame:CGRectMake(_ratebgView.frame.origin.x, -_ratebgView.bounds.size.height+26, _ratebgView.bounds.size.width, _ratebgView.bounds.size.height)];
    [_btnShowRateView setImage:[UIImage imageNamed:@"Down Circular"] forState:UIControlStateNormal];
    
    _bgView.layer.cornerRadius = 3;
    _bgView.clipsToBounds = YES;
    
    _btnLike.layer.borderWidth = 0;
    _btnLike.layer.cornerRadius = 5;
    
    _btnMessage.layer.cornerRadius = 5;
    _btnMessage.layer.borderWidth = 1;
    _btnMessage.layer.borderColor = [UIColor blackColor].CGColor;
    
    _btnFollow.layer.cornerRadius = 5;
    _btnFollow.layer.borderWidth = 1;
    _btnFollow.layer.borderColor = [UIColor blackColor].CGColor;
    
    _toolView.layer.cornerRadius = 5;
    _toolView.clipsToBounds = YES;
    _toolView.layer.borderColor = [UIColor blackColor].CGColor;
    _toolView.layer.borderWidth = 1;
    _toolView.hidden = YES;
}

- (void)initDataForContentView {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSString *newsUserId = [_dict objectForKey:@"user_id"];
    
    int isAdmin = [[_dict objectForKey:kIsAdmin] intValue];
    if (isAdmin == 0) {
        _imgAdmin.hidden = YES;
    } else {
        _imgAdmin.hidden = NO;
    }
    
    int type = [[_dict objectForKey:@"type"] intValue];
    if (type == 2) {
        _ratebgView.hidden = YES;
    }
    
    if (_postType == event || _postType == notifi) {
        _lblEventLabel.hidden = NO;
        _lblEventTime.hidden = NO;
        
        if (_postType == event) {
            _btnFollow.hidden = NO;
            _lblNumberOfFollowers.hidden = NO;
        } else {
            _btnFollow.hidden = YES;
            _lblNumberOfFollowers.hidden = YES;
        }
        
        
        NSString *eventTitle = [_dict objectForKey:@"news_event_title"];
        _lblEventLabel.text = eventTitle;
        [_lblEventLabel sizeToFit];
        
        CGRect lblEventTitleFrame = _lblEventLabel.frame;
        
        if ([_dict objectForKey:@"event_time"] != [NSNull null]) {
            int eventTime = [[_dict objectForKey:@"event_time"] intValue];
            NSString *eventTimeStr = [SWUtil convert:eventTime toDateStringWithFormat:FULL_DATE_FORMAT];
            _lblEventTime.text = eventTimeStr;
            [_lblEventTime sizeToFit];
            
            NSDate *currentDate = [NSDate date];
            int now = [[SWUtil convertDateToNumber:currentDate] intValue];
            
            if (now > eventTime) {
                int type = [[_dict objectForKey:@"type"] intValue];
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
        
        self.numberOfFollowInNews = [[_dict objectForKey:@"follow"] integerValue];
        _lblNumberOfFollowers.text = [NSString stringWithFormat:@"%d", (int)self.numberOfFollowInNews];
        
        NSArray *didFollowArr = [_dict objectForKey:@"did_follow"];
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

    } else {
        _lblEventLabel.hidden = YES;
        _lblEventTime.hidden = YES;
        _btnFollow.hidden = YES;
        _lblNumberOfFollowers.hidden = YES;
    }
    
    if ([userId isEqualToString:newsUserId]) {
        _btnShowTool.hidden = NO;
    } else {
        _btnShowTool.hidden = YES;
    }
    
    _newsId = [[_dict objectForKey:@"news_id"] integerValue];
    
    int numberOfImage = [[_dict objectForKey:@"number_of_image"] intValue];
    
    if (numberOfImage == 0) {
        [self haveImage:NO];
    } else {
        _imgArr = [_dict objectForKey:@"images"];
        
        if (_imgArr.count > 0) {
            [self setUIScroll];
        }
    }
    
    NSString *commentsNumber = [NSString stringWithFormat:@" %@",[_dict objectForKey:@"comments"]];
    self.numberOfCommentInNews = [[_dict objectForKey:@"comments"] integerValue];
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

    CGSize  textSize = { 310, 10000.0 };
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:textSize
                          lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect lblContentFrame = _lblContent.frame;
    if (_postType == status) {
        lblContentFrame.origin.y = -7;
    } else {
        lblContentFrame.origin.y = _lblEventTime.frame.origin.y + _lblEventTime.bounds.size.height;
    }
    
    lblContentFrame.size.height = size.height+20;
    _lblContent.frame = lblContentFrame;
    
    CGRect lblFooterNewsViewFrame = _footerNewsView.frame;

    CGRect newsFrame = _newsContentView.frame;
    if (numberOfImage == 0) {
        newsFrame.origin.y = 71;
    } else {
        newsFrame.origin.y = 233;
    }
    newsFrame.size.height = lblContentFrame.origin.y + lblContentFrame.size.height + lblFooterNewsViewFrame.size.height;
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

- (void)setUIScroll {
    for (UIView *subview in _imgScrollView.subviews) {
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
        
        [_imgScrollView addSubview:imgView];
    }
    _imgScrollView.pagingEnabled = YES;
    CGSize contentSize = [_imgScrollView contentSize];
    contentSize.width=xPos;
    [_imgScrollView setContentSize:contentSize];
}

-(void)imgToFullScreen:(UITapGestureRecognizer*)gestureRecognizer {
    UIImageView *gestureView = (UIImageView *)[gestureRecognizer view];
    [self didChooseImage:_imgContentArr AtIndex:gestureView.tag];
}

- (void)didChooseImage:(NSArray *)imagesArr AtIndex:(NSInteger)index {
    
    [self.krImageViewer browseImages:imagesArr startIndex:index+1];
}

#pragma KRImageViewerDelegate
-(void)krImageViewerIsScrollingToPage:(NSInteger)_scrollingPage
{
    //The ImageViewer is Scrolling to which page and trigger here.
    //...
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
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
            
            if (![userId isEqualToString:_newsUserId]) {
                NSArray *contentArr;
                
                if (_postType == status) {
                    contentArr = [_lblContent.text componentsSeparatedByString:@" "];
                } else {
                    contentArr = [_lblEventLabel.text componentsSeparatedByString:@" "];
                }
                
                NSMutableArray *shortContentArr = [[NSMutableArray alloc] initWithCapacity:10];
                int count = 10;
                if (contentArr.count < count) {
                    count = (int)contentArr.count;
                }
                for (int i = 0; i < count; i++) {
                    [shortContentArr addObject:[contentArr objectAtIndex:i]];
                }
                
                NSString *shortContent;
                if (_postType == status) {
                    shortContent = @" đã thích bài viết: ";
                } else {
                    shortContent = @" đã thích sự kiện: ";
                }
                
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
        if (_isShow) {
            _isShow = NO;
            [self showRateView:NO];
        }
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
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    [self showActionSheet];
//    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
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
    
    height += 61;
    
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
    [self.view endEditing:YES];
    if (message.length > 0 && !_willEdit) {
        
        [[SWUtil sharedUtil] showLoadingView];
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, cmAddComment];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
        NSDictionary *parameters = @{@"content"        : NULL_IF_NIL(message),
                                     @"news_id"        : [NSNumber numberWithInteger:_newsId],
                                     @"user_id"        : userId};
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self getComment];
            
            if (![userId isEqualToString:_newsUserId]) {
                NSArray *contentArr = [_lblContent.text componentsSeparatedByString:@" "];
                NSMutableArray *shortContentArr = [[NSMutableArray alloc] initWithCapacity:10];
                int count = 10;
                if (contentArr.count < count) {
                    count = (int)contentArr.count;
                }
                for (int i = 0; i < count; i++) {
                    [shortContentArr addObject:[contentArr objectAtIndex:i]];
                }
                
                NSString *shortContent = @" đã bình luận bài viết: ";
                NSString *str = [shortContentArr componentsJoinedByString:@" "];
                shortContent = [shortContent stringByAppendingString:str];
                [SWUtil postNotification:shortContent forUser:_newsUserId type:0];
            }
            
            NSLog(@"POST MESSAGE SUCCESS");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
            [[SWUtil sharedUtil] hideLoadingView];
        }];
        
    } else {
        if (![message isEqualToString:_stringBeforeEdit] && message.length > 0) {
            
            [[SWUtil sharedUtil] showLoadingView];
            NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, cmEditComment];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSInteger commentId = [[[_commentArr objectAtIndex:_selectedIndexPath.row] objectForKey:kCommentId] integerValue];
            NSDictionary *parameters = @{kCommentId             : [NSNumber numberWithInteger:commentId],
                                         kCommentContent        : NULL_IF_NIL(message)};
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self getComment];
                NSLog(@"UPDATE MESSAGE SUCCESS");
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
                [[SWUtil sharedUtil] hideLoadingView];
                NSLog(@"UPDATE MESSAGE FAILED");
            }];
        }
    }
}

/**
 * Called when user tap on attach media button
 */
- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView {
    
}

- (void)showActionSheet {
    [[SWUtil appDelegate] hideTabbar:YES];
    IBActionSheet *actionSheet = [[IBActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Đóng"
                                               destructiveButtonTitle:nil
                                               otherButtonTitlesArray:@[@"Sửa", @"Xóa"]];
    [actionSheet setButtonTextColor:[UIColor redColor] forButtonAtIndex:1];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[SWUtil appDelegate] hideTabbar:NO];
    [_commentTableView deselectRowAtIndexPath:_selectedIndexPath animated:YES];

    switch (buttonIndex) {
        case 0: // Edit
        {
            KLCommentTableViewCell *cell = (KLCommentTableViewCell*)[_commentTableView cellForRowAtIndexPath:_selectedIndexPath];
            [self.inputView textViewActiveByContent:cell.lblContent.text ];
            _stringBeforeEdit = cell.lblContent.text;
            _willEdit = YES;
        }
            break;
        case 1: // Delete
        {
            [SWUtil showConfirmAlert:@"" message:@"Bạn có chắc chắn muốn xóa bình luận này?" cancelButton:@"Không" otherButton:@"Có" tag:111 delegate:self];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteComment];
    }
}

- (void)deleteComment {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, cmDeleteComment];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSInteger commentId = [[[_commentArr objectAtIndex:_selectedIndexPath.row] objectForKey:kCommentId] integerValue];
    NSDictionary *parameters = @{kCommentId   : [NSNumber numberWithInteger:commentId]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self getComment];
        NSLog(@"DELETE MESSAGE SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
        NSLog(@"DELETE MESSAGE FAILED");
    }];
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
        [_ratebgView setFrame:CGRectMake(_ratebgView.frame.origin.x, -_ratebgView.bounds.size.height+26, _ratebgView.bounds.size.width, _ratebgView.bounds.size.height)];
        
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
                             
                             [_ratebgView setFrame:CGRectMake(_ratebgView.frame.origin.x, -_ratebgView.bounds.size.height+26, _ratebgView.bounds.size.width, _ratebgView.bounds.size.height)];
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
    
    NSDictionary *parameters = @{kUserId   : [NSNumber numberWithInteger:userId],
                                 kNewsId   : [NSNumber numberWithInteger:_newsId],
                                 @"status" : [NSNumber numberWithInteger:rate]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"rate post success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"rate post success error: %@", error);
    }];
}

- (IBAction)btnFollowTapped:(id)sender {
    _didFollow = !_didFollow;
    [self didFollow:_didFollow];
    
    if (_didFollow) {
        self.numberOfFollowInNews++;
        
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nInsertFollow];
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSDictionary *parameters = @{@"user_id": userId,
                                     @"news_id": [NSNumber numberWithInteger:_newsId]};
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (![userId isEqualToString:_newsUserId]) {
                NSArray *contentArr;
                
                if (_postType == status) {
                    contentArr = [_lblContent.text componentsSeparatedByString:@" "];
                } else {
                    contentArr = [_lblEventLabel.text componentsSeparatedByString:@" "];
                }
                
                NSMutableArray *shortContentArr = [[NSMutableArray alloc] initWithCapacity:10];
                int count = 10;
                if (contentArr.count < count) {
                    count = (int)contentArr.count;
                }
                for (int i = 0; i < count; i++) {
                    [shortContentArr addObject:[contentArr objectAtIndex:i]];
                }
                
                NSString *shortContent;
                if (_postType == status) {
                    shortContent = @" đã thích bài viết: ";
                } else {
                    shortContent = @" đã thích sự kiện: ";
                }
                NSString *str = [shortContentArr componentsJoinedByString:@" "];
                shortContent = [shortContent stringByAppendingString:str];
                [SWUtil postNotification:shortContent forUser:_newsUserId type:0];
            }
            NSLog(@"like sucess - user: %@ - like news_id: %d", userId, (int)_newsId);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSLog(@"like faild - user: %@ - like news_id: %d", userId, (int)_newsId);
        }];
        
        _lblNumberOfFollowers.text = [NSString stringWithFormat:@"%d", (int)self.numberOfFollowInNews];
    } else {
        if (self.numberOfFollowInNews > 0) {
            self.numberOfFollowInNews--;
            NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nDeleteFollow];
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            NSDictionary *parameters = @{@"user_id": userId,
                                         @"news_id": [NSNumber numberWithInteger:_newsId]};
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"delete like sucess - user: %@ - like news_id: %d", userId, (int)_newsId);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                NSLog(@"delete like faild - user: %@ - like news_id: %d", userId, (int)_newsId);
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

@end
