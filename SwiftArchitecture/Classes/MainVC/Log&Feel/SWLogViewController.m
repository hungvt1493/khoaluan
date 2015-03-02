//
//  SWLogViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWLogViewController.h"
#import "SWFeelViewController.h"

@interface SWLogViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
- (IBAction)feelButtonTapped:(id)sender;

@end

@implementation SWLogViewController

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
    self.title = Log_Title;
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
}

- (void)initData{
    
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)feelButtonTapped:(id)sender {
    SWFeelViewController *feelVC = [[SWFeelViewController alloc] initWithNibName:@"SWFeelViewController" bundle:nil];
    [self.navigationController pushViewController:feelVC animated:YES];
}
@end
