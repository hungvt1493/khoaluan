//
//  MyPageViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "MyPageViewController.h"
#import "MyPageHeaderView.h"
#import "KLNewsContentTableViewCell.h"
#import "KLPostNewsViewController.h"
#import "KLNewsDetailViewController.h"
#import "KRImageViewer.h"

@interface MyPageViewController () <UITableViewDataSource, UITableViewDelegate, MyPageHeaderViewDelegate, KLNewsContentTableViewCellDelegate, KRImageViewerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myPageTableView;
@property (nonatomic, strong) KRImageViewer *krImageViewer;
@end

@implementation MyPageViewController {
    NSArray *_newsArr;
    NSMutableArray *_fullNewsArr;
    NSDictionary *_friendState;
    int _oldOffset;
    BOOL _endOfRespond;
    int _count;
    int _limit;
    int _checkNewsPost;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _oldOffset = 0;
    _fullNewsArr = [[NSMutableArray alloc] initWithCapacity:10];
    _endOfRespond = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"E3E3E3" alpha:1];
    _count = 0;
    _limit = 6;
    _checkNewsPost = 0;
    [self getFriendState];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidPostMyPage];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
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

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    _myPageTableView.delegate = self;
    _myPageTableView.dataSource = self;
    [self.krImageViewer useKeyWindow];
    BOOL didPostNews = [[NSUserDefaults standardUserDefaults] boolForKey:kDidPostMyPage];
    if (didPostNews) {
        _oldOffset = 0;
        _count = 0;
        _checkNewsPost++;
        [_fullNewsArr removeAllObjects];
        [self initData];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidPostMyPage];
    } else {
        if (_count > 1) {
            _limit = 25;
            _oldOffset = 0;
            _count = 0;
            [_fullNewsArr removeAllObjects];
            [self initData];
        }
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _myPageTableView.delegate = nil;
    _myPageTableView.dataSource = nil;
}

- (void)getFriendState {
    /*
     state = 1; Dang cho accpet cho nguoi gui loi moi ket ban
     state = 2; Dang cho accpet cho nguoi nhan loi moi ket ban
     state = 3; Da la ban be
     */
    NSString *myId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    if (_userId) {
        if ([myId isEqualToString:_userId]) {
            _myPageType = MyPage;
            _userId = myId;
        } else {
            _myPageType = UserPage;
        }
    } else {
        _myPageType = MyPage;
        _userId = myId;
    }
    
    
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uFriendState];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{kUserId: myId,
                                 @"friend_id": _userId};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _friendState = (NSDictionary*)responseObject;
        }
        [[SWUtil sharedUtil] hideLoadingView];
        [self initData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (void)initData {
    [[SWUtil sharedUtil] showLoadingView];

    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNewsWithUserId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"offset": [NSNumber numberWithInt:_oldOffset],
                                 @"user_id": _userId,
                                 @"limit": [NSNumber numberWithInt:_limit],
                                 @"type": [NSNumber numberWithInt:0]};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (_fullNewsArr.count == 0) {
                _limit = 6;
            }
            
            _newsArr = (NSArray*)responseObject;
    
            for (int i = 0; i < _newsArr.count; i++) {
                NSDictionary *newDict = [_newsArr objectAtIndex:i];
                if (![_fullNewsArr containsObject:newDict]) {
                    [_fullNewsArr addObject:newDict];
                }
            }
            _endOfRespond = NO;
            NSLog(@"MY PAGE NEWS JSON: %@", responseObject);
            
            [_myPageTableView reloadData];
    
            _count++;
            _oldOffset = (int)_fullNewsArr.count;
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            _endOfRespond = [[dict objectForKey:@"code"] intValue];
            [_myPageTableView reloadData];
        }
        
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_endOfRespond) {
        return _fullNewsArr.count+1;
    }
    return _fullNewsArr.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"MyPageHeaderView";
        MyPageHeaderView *cell = (MyPageHeaderView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"MyPageHeaderView" bundle:nil] forCellReuseIdentifier:cellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.myPageType = _myPageType;
        }
        cell.fUserId = _userId;
        [cell initUI];
        int code = [[_friendState objectForKey:kCode] intValue];
        if (code == 3) {
            [cell configureAddFriendButton:0];
        } else {
            int state = [[_friendState objectForKey:@"state"] intValue];
            [cell configureAddFriendButton:state];
        }
        return cell;
    }
    
    if (!_endOfRespond && indexPath.row == (_fullNewsArr.count + 1)) {
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
    NSDictionary *dict = [_fullNewsArr objectAtIndex:indexPath.row-1];
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell setData:dict];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
        if (!_endOfRespond) {
            [self initData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_myPageType == MyPage) {
            return 292;
        } else {
            int code = [[_friendState objectForKey:kCode] intValue];
            if (code == 3) {
                return 222;
            } else {
                int state = [[_friendState objectForKey:@"state"] intValue];
                if (state == 2) {
                    return 292;
                }
                return 222;
            }
        }
        
    }
    if (_fullNewsArr.count == 0) {
        return 44;
    }
    if (indexPath.row < (_fullNewsArr.count+1)) {
        NSDictionary *dict = [_fullNewsArr objectAtIndex:indexPath.row-1];
        NSString *content = [dict objectForKey:@"content"];
        int numberOfImage = [[dict objectForKey:@"number_of_image"] intValue];
        return [self calculateHeightOfCellByString:content andNumberOfImage:numberOfImage];
    } else {
        return 44;
    }
    
}

- (void)popViewControllerUseDelegate {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)calculateHeightOfCellByString:(NSString*)str andNumberOfImage:(NSInteger)numberOfImage {
    CGFloat height;
    CGSize  textSize = { 293, 10000.0 };
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14]
                  constrainedToSize:textSize
                      lineBreakMode:NSLineBreakByWordWrapping];
    height = size.height < 30 ? 30 : 77;
    
    if (numberOfImage == 0) {
        height += 118;
    } else {
        height += 278;
    }
    
    return height;
}

#pragma mark - KLNewsContentTableViewCellDelegate
- (void)didDeleteCellAtIndexPath:(NSIndexPath *)indexPath {
    [_fullNewsArr removeObjectAtIndex:indexPath.row-1];
    [_myPageTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_myPageTableView reloadData];
}

- (void)didChooseEditCellAtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dict withType:(PostType)type withImage:(NSArray *)imageArr withImageName:(NSArray *)imageNameArr{
    KLPostNewsViewController *postNewsVC = [[KLPostNewsViewController alloc] init];
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

#pragma mark - MyPageHeaderDelegate
- (void)pushToViewControllerUseDelegete:(UIViewController *)viewController withAnimation:(BOOL)animation{
    [self.navigationController pushViewController:viewController animated:animation];
}

- (void)didAcceptOrRejectUser {
    [self getFriendState];
}

#pragma mark - NewsViewDelegate
- (void)pushToDetailViewControllerUserDelegateForCellAtIndexPath:(NSIndexPath*)indexPath {
    int newsId = [[[_fullNewsArr objectAtIndex:indexPath.row-1] objectForKey:@"news_id"] intValue];
    int type = [[[_fullNewsArr objectAtIndex:indexPath.row-1] objectForKey:@"type"] intValue];
    
    KLNewsDetailViewController *detailVC = [[KLNewsDetailViewController alloc] init];
    //    detailVC.dict = [_fullNewsArr objectAtIndex:indexPath.row];
    detailVC.newsId = newsId;
    detailVC.postType = type;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)pushToUserPageViewControllerUserDelegateForCellAtIndexPath:(NSIndexPath *)indexPath {
    //Do Nothing
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
