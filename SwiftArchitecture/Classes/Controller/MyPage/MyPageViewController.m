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

@interface MyPageViewController () <UITableViewDataSource, UITableViewDelegate, MyPageHeaderViewDelegate, KLNewsContentTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myPageTableView;

@end

@implementation MyPageViewController {
    NSArray *_newsArr;
    NSMutableArray *_fullNewsArr;
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
    [self initData];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidPostMyPage];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _myPageTableView.delegate = self;
    _myPageTableView.dataSource = self;
    
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

- (void)initData {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNewsWithUserId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"offset": [NSNumber numberWithInt:_oldOffset],
                                 @"user_id": userId,
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
        return 292;
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

- (void)didChooseEditCellAtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)dict withType:(PostType)type{
    KLPostNewsViewController *postNewsVC = [[KLPostNewsViewController alloc] init];
    postNewsVC.pageType = edit;
    PostType postType = type;
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

#pragma mark - MyPageHeaderDelegate
- (void)pushToViewControllerUseDelegete:(UIViewController *)viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
