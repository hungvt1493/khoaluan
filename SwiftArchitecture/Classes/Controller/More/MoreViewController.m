//
//  MoreViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "MoreViewController.h"
#import "KLEventManagerViewController.h"
#import "KLUserManagerViewController.h"

#define NORMAL_ARRAY @[@"Đăng xuất"];
#define ADMIN_ARRAY @[@"Quản lý tài khoản",@"Quản lý sự kiện",@"Đăng xuất"];

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
    NSInteger isAdmin = [[NSUserDefaults standardUserDefaults] integerForKey:kIsAdmin];
    
    if (isAdmin == 0) {
        [[SWUtil appDelegate] logoutFunction];
    } else {
        switch (indexPath.row) {
            case 0:
            {
                KLUserManagerViewController *userManager = [[KLUserManagerViewController alloc] init];
                [self.navigationController pushViewController:userManager animated:YES];
            }
                break;
            case 1:
            {
                KLEventManagerViewController *eventManagerVC = [[KLEventManagerViewController alloc] init];
                [self.navigationController pushViewController:eventManagerVC animated:YES];
            }
                break;
            case 2:
            {
                [[SWUtil appDelegate] logoutFunction];
            }
                break;
            default:
                break;
        }
    }
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
