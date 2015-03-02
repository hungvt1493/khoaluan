//
//  NewsViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsContentView.h"

@interface NewsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)initUI {
    int yPos = 0;
    
    for (int i=0; i < 10; i++) {
        
        NewsContentView *newsView = [[NewsContentView alloc] initWithFrame:CGRectZero];

        CGRect frame = [newsView frame];
        frame.origin.y = yPos;
        yPos += frame.size.height;
        [newsView setFrame:frame];
        [self.scrollView addSubview:newsView];
    }
    
    CGSize contentSize = [self.scrollView contentSize];
    contentSize.height = yPos;
    [self.scrollView setContentSize:contentSize];

}
@end
