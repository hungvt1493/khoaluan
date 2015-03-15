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

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate, KLNewsContentTableViewCellDelegate>

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _oldOffset = 0;
    _limit = 6;
    _fullNewsArr = [[NSMutableArray alloc] initWithCapacity:10];
    _endOfRespond = NO;
    _checkNewsPost = 0;
    _count = 0;
    //pull down to refresh
    self.pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *)_newsTableView];
    [self.pull setDelegate:(id<PullToRefreshViewDelegate>)self];
    [_newsTableView addSubview:self.pull];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidPostNews];
    
    self.navigationController.scrollNavigationBar.scrollView = self.newsTableView;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
            _limit = 25;
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
    _limit = 6;
    [_fullNewsArr removeAllObjects];
    _checkNewsPost++;
    [self initData];
}

- (void)initData {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNews];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"offset": [NSNumber numberWithInt:_oldOffset],
                                 @"limit": [NSNumber numberWithInt:_limit]};
    
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
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_endOfRespond) {
        NSLog(@"COUNT 1: %d", _fullNewsArr.count);
        return _fullNewsArr.count;
    }
    NSLog(@"COUNT 2: %d", _fullNewsArr.count+1);
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
        height += 119;
    } else {
        height += 279;
    }
    
    return height;
}

- (void)didDeleteCellAtIndexPath:(NSIndexPath *)indexPath {
    [_fullNewsArr removeObjectAtIndex:indexPath.row];
    [_newsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_newsTableView reloadData];
}

- (void)didChooseEditCellAtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dict {
    KLPostNewsViewController *postNewsVC = [[KLPostNewsViewController alloc] init];
    postNewsVC.pageType = edit;
    PostType postType = [[dict objectForKey:@"type"] intValue];
    postNewsVC.postType = postType;
    postNewsVC.newsId = [[dict objectForKey:kNewsId] integerValue];
    
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
@end
