//
//  KLEventManagerViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 3/24/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLEventManagerViewController.h"
#import "KLEventInformationTableViewCell.h"
#import "KLNewsDetailViewController.h"

@interface KLEventManagerViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation KLEventManagerViewController {
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
    _tbEventManager.delegate = self;
    _tbEventManager.dataSource = self;
    
    _oldOffset = 0;
    _limit = 5;
    _fullNewsArr = [[NSMutableArray alloc] initWithCapacity:10];
    _endOfRespond = NO;
    _checkNewsPost = 0;
    _count = 0;
    
    self.title = Event_Manager_Title;
    [self setBackButtonWithImage:back_bar_button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[SWUtil appDelegate] hideTabbar:YES];
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
                if (![_fullNewsArr containsObject:newDict]) {
                    [_fullNewsArr addObject:newDict];
                }
            }
            _endOfRespond = NO;
            
            NSLog(@"NEWS JSON: %@", responseObject);
            [_tbEventManager reloadData];
            
            _count++;
            _oldOffset = (int)_fullNewsArr.count;
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            _endOfRespond = [[dict objectForKey:@"code"] intValue];
            [_tbEventManager reloadData];
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

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"KLEventInformationTableViewCell-%d-%ld", _checkNewsPost, (long)indexPath.row];
    KLEventInformationTableViewCell *cell = (KLEventInformationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"KLEventInformationTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [_fullNewsArr objectAtIndex:indexPath.row];
    [cell setData:dict];

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
    int newsId = [[[_fullNewsArr objectAtIndex:indexPath.row] objectForKey:@"news_id"] intValue];
    int type = [[[_fullNewsArr objectAtIndex:indexPath.row] objectForKey:@"type"] intValue];
    
    KLNewsDetailViewController *detailVC = [[KLNewsDetailViewController alloc] init];
    detailVC.newsId = newsId;
    detailVC.postType = type;
    [self.navigationController pushViewController:detailVC animated:YES];
//    [detailVC removeNavigationBarAnimation];
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

@end
