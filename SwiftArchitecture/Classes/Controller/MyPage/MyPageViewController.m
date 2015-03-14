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

@interface MyPageViewController () <UITableViewDataSource, UITableViewDelegate, MyPageHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myPageTableView;

@end

@implementation MyPageViewController {
    NSArray *newsArr;
    NSMutableArray *fullNewsArr;
    int _oldOffset;
    BOOL _endOfRespond;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _myPageTableView.delegate = self;
    _myPageTableView.dataSource = self;
    _oldOffset = 0;
    fullNewsArr = [[NSMutableArray alloc] initWithCapacity:10];
    _endOfRespond = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"E3E3E3" alpha:1];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)initData {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_ID];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNewsWithUserId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"offset": [NSNumber numberWithInt:_oldOffset],
                                 @"user_id": userId};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            newsArr = (NSArray*)responseObject;
            
            for (int i = 0; i < newsArr.count; i++) {
                NSDictionary *dict = [newsArr objectAtIndex:i];
                
                if (![fullNewsArr containsObject:dict]) {
                    [fullNewsArr addObject:dict];
                }
            }
            _endOfRespond = NO;
            NSLog(@"MY PAGE NEWS JSON: %@", responseObject);
            [_myPageTableView reloadData];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_oldOffset inSection:0];
            [_myPageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            _oldOffset += newsArr.count;
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
        return fullNewsArr.count+1;
    }
    return fullNewsArr.count+2;
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
    if (!_endOfRespond && indexPath.row == (fullNewsArr.count + 1)) {
        static NSString *cellIdentifier = @"CELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (fullNewsArr.count == 0) {
            cell.textLabel.text = The_Last_Cell_Have_No_Data_Title;
        } else {
            cell.textLabel.text = The_Last_Cell_Have_Data_Title;
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
    
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"KLNewsContentTableViewCell-%ld", (long)indexPath.row];
    KLNewsContentTableViewCell *cell = (KLNewsContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"KLNewsContentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = [fullNewsArr objectAtIndex:indexPath.row-1];
        [cell setData:dict];
    }
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
    if (fullNewsArr.count == 0) {
        return 44;
    }
    if (indexPath.row < (fullNewsArr.count+1)) {
        NSDictionary *dict = [fullNewsArr objectAtIndex:indexPath.row-1];
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

#pragma mark -MyPageHeaderDelegate
- (void)pushToViewControllerUseDelegete:(UIViewController *)viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
