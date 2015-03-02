//
//  SWAboutViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 2/8/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWAboutViewController.h"

@interface SWAboutViewController ()

@end

@implementation SWAboutViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = About_Title;
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
}

- (void)initData{
    
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
