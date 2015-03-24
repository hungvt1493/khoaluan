//
//  MoreViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "MoreViewController.h"
#import "KLEventManagerViewController.h"

#define NORMAL_ARRAY @[@"Đăng xuất"];
#define ADMIN_ARRAY @[@"Quản lý sự kiện",@"Đăng xuất"];

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbMore;

@end

@implementation MoreViewController {
    NSArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tbMore.delegate = self;
    _tbMore.dataSource = self;
    
    NSInteger isAdmin = [[NSUserDefaults standardUserDefaults] integerForKey:kIsAdmin];
    
    if (isAdmin == 0) {
        _dataArr = NORMAL_ARRAY;
    } else {
        _dataArr = ADMIN_ARRAY;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.textLabel.text = [_dataArr objectAtIndex:indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:@"Đăng xuất"]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArr.count-1) {
        [[SWUtil appDelegate] logoutFunction];
    } else {
        KLEventManagerViewController *eventManagerVC = [[KLEventManagerViewController alloc] init];
        [self.navigationController pushViewController:eventManagerVC animated:YES];
    }
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
