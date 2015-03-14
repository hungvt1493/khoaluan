//
//  FriendsViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendTableViewCell.h"

@interface FriendsViewController ()  <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackButtonWithImage:back_bar_button title:Back_Bar_Title highlightedImage:nil target:self action:@selector(backBarButtonTapped)];
    self.navigationController.navigationBarHidden = NO;
    self.title = Friend_Title;
    _tbFriend.delegate = self;
    _tbFriend.dataSource = self;
    
    [[SWUtil appDelegate] hideTabbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (void)backBarButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"FriendTableViewCell";
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row %2 == 0) {
        [cell setOnline:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
