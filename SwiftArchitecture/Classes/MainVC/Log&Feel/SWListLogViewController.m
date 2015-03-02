//
//  SWListLogViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 2/11/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWListLogViewController.h"
#import "SWLogViewController.h"

@interface SWListLogViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listLogTableView;

@end

@implementation SWListLogViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Log_Title;
}

- (void)initData{
    
}

#pragma mark - TableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"partly_cloudy_day_red.png"];
    cell.textLabel.text = @"4:00PM/Thứ tư/4/2/2015";
    cell.textLabel.font = [UIFont fontHelveticaNeue_Medium:17.0f];
    cell.textLabel.textColor = [UIColor colorWithHex:Gray_Color alpha:1.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWLogViewController *logVC = [[SWLogViewController alloc] init];
    [self.navigationController pushViewController:logVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
