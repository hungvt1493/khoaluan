//
//  NewsViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "NewsViewController.h"
#import "KLNewsContentTableViewCell.h"
#import "KLPostNewsViewController.h"
#import "KLNewsDetailViewController.h"
#import "KRImageViewer.h"
#import "MyPageViewController.h"

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate, KLNewsContentTableViewCellDelegate,KRImageViewerDelegate>
@property (nonatomic, strong) KRImageViewer *krImageViewer;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (nonatomic, strong) PullToRefreshView *pull;
@property (nonatomic, assign) CGFloat previousScrollViewYOffset;
@end

@implementation NewsViewController {
    NSArray *_newsArr;
    NSMutableArray *_fullNewsArr;
    int _oldOffset;
    int _limit;
    BOOL _endOfRespond;
    int _checkNewsPost;
    int _count;
    BOOL _isRefresh;
    BOOL _pullToRefresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Tin mới";
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
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidPostNews];
    _pullToRefresh = NO;
    [self.pull setState:PullToRefreshViewStateLoading];
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
    
    _newsTableView.frame = CGRectMake(0, 0, _newsTableView.bounds.size.width, SCREEN_HEIGHT_PORTRAIT - HEIGHT_TABBAR - HEIGHT_STATUSBAR);
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.krImageViewer useKeyWindow];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.scrollNavigationBar.scrollView = self.newsTableView;
    [[SWUtil appDelegate] hideTabbar:NO];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8) {
        [[UINavigationBar appearance] setTranslucent:NO];
        
    } else {
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;

    BOOL didPostNews = [[NSUserDefaults standardUserDefaults] boolForKey:kDidPostNews];
    if (didPostNews) {
        _endOfRespond = YES;
        _oldOffset = 0;
        _checkNewsPost++;
        _limit = (int)_fullNewsArr.count;
        [_fullNewsArr removeAllObjects];
        [self initData];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidPostNews];
    } else {
        if (_count > 0) {
            _count = 0;
            _limit = 10;
            _oldOffset = 0;
            [_fullNewsArr removeAllObjects];
            [self initData];
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
    _pullToRefresh = YES;
    _checkNewsPost++;
    [self initData];
}

- (void)initData {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNews];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSDictionary *parameters = @{@"offset": [NSNumber numberWithInt:_oldOffset],
                                 @"limit": [NSNumber numberWithInt:_limit],
                                 @"type": [NSNumber numberWithInt:0],
                                 kUserId : userId};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (_pullToRefresh) {
                [_fullNewsArr removeAllObjects];
                _pullToRefresh = NO;
            }
            if (_fullNewsArr.count == 0) {
                _limit = 5;
            }
            _newsArr = (NSArray*)responseObject;
            
            for (int i = 0; i < _newsArr.count; i++) {
                NSDictionary *newDict = [_newsArr objectAtIndex:i];
                if (![_fullNewsArr containsObject:newDict]) {
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

    
    NSString *cellIdentifier = [NSString stringWithFormat:@"KLNewsContentTableViewCell-%d-%ld", _checkNewsPost, (long)indexPath.row];
    KLNewsContentTableViewCell *cell = (KLNewsContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"KLNewsContentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
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
            [self initData];
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
        int numberOfImage = [[dict objectForKey:@"number_of_image"] intValue];
        
        return [self calculateHeightOfCellByString:content andNumberOfImage:numberOfImage];
    } else {
        return 44;
    }
    
}


- (NSInteger)calculateHeightOfCellByString:(NSString*)str andNumberOfImage:(NSInteger)numberOfImage {
    CGFloat height;
    CGSize  textSize = { 293, 10000.0 };
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:textSize
                          lineBreakMode:NSLineBreakByWordWrapping];
    height = size.height < 30 ? 30 : 77;

    if (numberOfImage == 0) {
        height += 117;
    } else {
        height += 277;
    }
    
    return height;
}

- (void)didDeleteCellAtIndexPath:(NSIndexPath *)indexPath {
    [_fullNewsArr removeObjectAtIndex:indexPath.row];
    [_newsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_newsTableView reloadData];
}

- (void)didChooseEditCellAtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dict withType:(PostType)type withImage:(NSArray*)imageArr withImageName:(NSArray*)imageName{
    KLPostNewsViewController *postNewsVC = [[KLPostNewsViewController alloc] init];
    [postNewsVC removeNavigationBarAnimation];
    postNewsVC.pageType = edit;
    PostType postType = type;
    postNewsVC.postType = postType;
    postNewsVC.newsId = [[dict objectForKey:kNewsId] integerValue];
    postNewsVC.imgArr = [[NSMutableArray alloc] initWithArray:imageArr];
    postNewsVC.imgNameArr = [[NSMutableArray alloc] initWithArray:imageName];
    
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
//    detailVC.dict = [_fullNewsArr objectAtIndex:indexPath.row];
    detailVC.newsId = newsId;
    detailVC.postType = type;
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
