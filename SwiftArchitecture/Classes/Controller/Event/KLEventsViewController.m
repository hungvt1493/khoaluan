//
//  NewsViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "KLEventsViewController.h"
#import "KLEventContentTableViewCell.h"
#import "KLPostNewsViewController.h"
#import "KLNewsDetailViewController.h"
#import "KRImageViewer.h"
#import "MyPageViewController.h"

@interface KLEventsViewController () <UITableViewDataSource, UITableViewDelegate, KLEventContentTableViewCellDelegate,KRImageViewerDelegate>
@property (nonatomic, strong) KRImageViewer *krImageViewer;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (nonatomic, strong) PullToRefreshView *pull;
@property (nonatomic, assign) CGFloat previousScrollViewYOffset;
@end

@implementation KLEventsViewController {
    NSArray *_newsArr;
    NSMutableArray *_fullNewsArr;
    int _oldOffset;
    int _limit;
    BOOL _endOfRespond;
    int _checkNewsPost;
    int _count;
    BOOL _isRefresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Sự kiện";
    _isRefresh = NO;
    _oldOffset = 0;
    _limit = 5;
    _fullNewsArr = [[NSMutableArray alloc] initWithCapacity:10];
    _endOfRespond = NO;
    _checkNewsPost = 0;
    _count = 0;
    //pull down to refresh
    self.pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *)_newsTableView];
    [self.pull setDelegate:(id<PullToRefreshViewDelegate>)self];
    [_newsTableView addSubview:self.pull];
    [self.pull setState:PullToRefreshViewStateLoading];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidPostNews];
    
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

    _newsTableView.frame = CGRectMake(0, 0, _newsTableView.bounds.size.width, SCREEN_HEIGHT_PORTRAIT - HEIGHT_NAVBAR - HEIGHT_TABBAR - HEIGHT_STATUSBAR);
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.scrollNavigationBar.scrollView = self.newsTableView;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8) {
        [[UINavigationBar appearance] setTranslucent:NO];
        
    } else {
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    [self.krImageViewer useKeyWindow];
    [[SWUtil appDelegate] hideTabbar:NO];
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;

    BOOL didPostNews = [[NSUserDefaults standardUserDefaults] boolForKey:kDidPostNews];
    if (didPostNews) {
        _endOfRespond = YES;
        _oldOffset = 0;
        _checkNewsPost++;
        _limit = (int)_fullNewsArr.count;
        [_fullNewsArr removeAllObjects];
        [self getNewsHaveMaxFollow];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidPostNews];
    } else {
        if (_count > 0) {
            _count = 0;
            _limit = 10;
            _oldOffset = 0;
            [_fullNewsArr removeAllObjects];
            [self getNewsHaveMaxFollow];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _newsTableView.delegate = nil;
    _newsTableView.dataSource = nil;
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    
    [self.pull setState:PullToRefreshViewStateLoading];
    _oldOffset = 0;
    _limit = 5;
    _endOfRespond = YES;
    _checkNewsPost++;
    _isRefresh = YES;
    [self getNewsHaveMaxFollow];
}

- (void)getNewsHaveMaxFollow {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNewsWithMaxFollow];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_isRefresh) {
            [_fullNewsArr removeAllObjects];
            _isRefresh = NO;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            if (![_fullNewsArr containsObject:dict]) {
                [_fullNewsArr addObject:dict];
            }
        }
        [self getNewsHaveMaxGoodRate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
//        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
        [self getNewsHaveMaxGoodRate];
    }];
}

- (void)getNewsHaveMaxGoodRate {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNewsWithMaxGoodRate];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            if (![_fullNewsArr containsObject:dict]) {
                [_fullNewsArr addObject:dict];
            }
        }
        [self initData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
//        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
        [self initData];
    }];
}

- (void)initData {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNews];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSDictionary *parameters = @{@"offset": [NSNumber numberWithInt:_oldOffset],
                                 @"limit": [NSNumber numberWithInt:_limit],
                                 @"type": [NSNumber numberWithInt:1],
                                 kUserId : userId};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            if (_fullNewsArr.count == 0) {
                _limit = 5;
            }
            _newsArr = (NSArray*)responseObject;
            
            for (int i = 0; i < _newsArr.count; i++) {
                NSDictionary *newDict = [_newsArr objectAtIndex:i];
                NSInteger newsIdFromSV = [[newDict objectForKey:kNewsId] integerValue];
                BOOL haveId = NO;
                for (int j = 0; j<_fullNewsArr.count; j++) {
                    NSInteger newsId = [[[_fullNewsArr objectAtIndex:j] objectForKey:kNewsId] integerValue];
                    if (newsId == newsIdFromSV) {
                        haveId = YES;
                    }
                }
                if (!haveId) {
                    [_fullNewsArr addObject:newDict];
                }
            }
            _endOfRespond = NO;
            
            NSLog(@"NEWS JSON: %@", responseObject);
            [_newsTableView reloadData];
            
            _count++;
            _oldOffset = (int)_fullNewsArr.count;
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            _endOfRespond = [[dict objectForKey:@"code"] intValue];
            [_newsTableView reloadData];
        }
        
        [self.pull finishedLoading];
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //[SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [self.pull finishedLoading];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_endOfRespond) {
        return _fullNewsArr.count;
    }
    return _fullNewsArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_endOfRespond && indexPath.row == _fullNewsArr.count) {
        static NSString *cellIdentifier = @"CELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (_fullNewsArr.count == 0) {
            cell.textLabel.text = The_Last_Cell_Have_No_Data_Title;
        } else {
            cell.textLabel.text = The_Last_Cell_Have_Data_Title;
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }

    NSString *cellIdentifier = [NSString stringWithFormat:@"KLEventContentTableViewCell-%d-%ld", _checkNewsPost, (long)indexPath.row];
    KLEventContentTableViewCell *cell = (KLEventContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"KLEventContentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    NSDictionary *dict = [_fullNewsArr objectAtIndex:indexPath.row];
    [cell setData:dict];
    cell.delegate = self;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
        if (!_endOfRespond) {
            [[SWUtil sharedUtil] showLoadingView];
            [self getNewsHaveMaxFollow];
            _newsTableView.frame = CGRectMake(0, 0, _newsTableView.bounds.size.width, SCREEN_HEIGHT_PORTRAIT - HEIGHT_TABBAR - HEIGHT_STATUSBAR);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fullNewsArr.count == 0) {
        return 44;
    }
    if (indexPath.row < _fullNewsArr.count) {
        NSDictionary *dict = [_fullNewsArr objectAtIndex:indexPath.row];
        NSString *content = [dict objectForKey:@"content"];
        NSString *eventTitle = [dict objectForKey:@"news_event_title"];
        int eventTime = [[dict objectForKey:@"event_time"] intValue];
        NSString *eventTimeStr = [SWUtil convert:eventTime toDateStringWithFormat:FULL_DATE_FORMAT];
        int numberOfImage = [[dict objectForKey:@"number_of_image"] intValue];
        
        return [self calculateHeightOfCellByString:content eventTitle:eventTitle eventTime:eventTimeStr andNumberOfImage:numberOfImage];
    } else {
        return 44;
    }
    
}


- (NSInteger)calculateHeightOfCellByString:(NSString*)str eventTitle:(NSString*)eventTitle eventTime:(NSString*)eventTime andNumberOfImage:(NSInteger)numberOfImage {
    CGFloat height;
    CGSize  textSize = { 293, 10000.0 };
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:textSize
                          lineBreakMode:NSLineBreakByWordWrapping];
    height = size.height < 30 ? 30 : 77;
    
    CGSize eventTitleSize = [eventTitle sizeWithFont:[UIFont systemFontOfSize:14]
                  constrainedToSize:textSize
                      lineBreakMode:NSLineBreakByWordWrapping];

    CGSize eventTimeSize = [eventTime sizeWithFont:[UIFont systemFontOfSize:14]
                            constrainedToSize:textSize
                                lineBreakMode:NSLineBreakByWordWrapping];
    
    if (numberOfImage == 0) {
        height = height + eventTitleSize.height + eventTimeSize.height + 123;
    } else {
        height = height + eventTitleSize.height + eventTimeSize.height + 283;
    }
    
    return height;
}

- (void)didDeleteCellAtIndexPath:(NSIndexPath *)indexPath {
    [_fullNewsArr removeObjectAtIndex:indexPath.row];
    [_newsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_newsTableView reloadData];
}

- (void)didChooseEditCellAtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dict withType:(PostType)type withImage:(NSArray *)imageArr withImageName:(NSArray *)imageNameArr {
    KLPostNewsViewController *postNewsVC = [[KLPostNewsViewController alloc] init];
    [postNewsVC removeNavigationBarAnimation];
    postNewsVC.pageType = edit;
    PostType postType = type;
    postNewsVC.postType = postType;
    postNewsVC.newsId = [[dict objectForKey:kNewsId] integerValue];
    postNewsVC.imgArr = [[NSMutableArray alloc] initWithArray:imageArr];
    postNewsVC.imgNameArr = [[NSMutableArray alloc] initWithArray:imageNameArr];

    if (postType == event) {
        NSString *eventTitle = [dict objectForKey:@"news_event_title"];
        postNewsVC.eventTitleStr = eventTitle;
        
        int dateInt = [[dict objectForKey:@"event_time"] intValue];
        NSString *eventTime = [SWUtil convert:dateInt toDateStringWithFormat:FULL_DATE_FORMAT];
        postNewsVC.timeStr = eventTime;
    }
    
    NSString *content = [dict objectForKey:@"content"];
    postNewsVC.contentStr = content;
    
    [self.navigationController pushViewController:postNewsVC animated:YES];
}

- (void)pushToDetailViewControllerUserDelegateForCellAtIndexPath:(NSIndexPath*)indexPath {
    int newsId = [[[_fullNewsArr objectAtIndex:indexPath.row] objectForKey:@"news_id"] intValue];
    int type = [[[_fullNewsArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue];
    
    KLNewsDetailViewController *detailVC = [[KLNewsDetailViewController alloc] init];
    detailVC.newsId = newsId;
    detailVC.postType = type;
    detailVC.title = [[_fullNewsArr objectAtIndex:indexPath.row] objectForKey:@"news_event_title"];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC removeNavigationBarAnimation];
}

- (void)pushToUserPageViewControllerUserDelegateForCellAtIndexPath:(NSIndexPath*)indexPath {
    NSString *newsUserId = [[_fullNewsArr objectAtIndex:indexPath.row] objectForKey:kUserId];
    
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uGetUserByUserId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    NSDictionary *parameters = @{kUserId: newsUserId};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MyPageViewController *userPageVC = [[MyPageViewController alloc] init];
        userPageVC.myPageType = UserPage;
        userPageVC.userId = newsUserId;
        userPageVC.userDict = (NSDictionary*)responseObject;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHideBackButtonInUserPage];
        [self.navigationController pushViewController:userPageVC animated:YES];
        
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
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

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
@end
