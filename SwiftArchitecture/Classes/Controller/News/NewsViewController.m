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

@implementation NewsViewController {
    NSArray *newsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)initData {
    [[SWUtil sharedUtil] showLoadingView];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nGetNews];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        newsArr = (NSArray*)responseObject;
        [self initUI];
        NSLog(@"NEWS JSON: %@", responseObject);
    
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (void)initUI {
    int yPos = 0;
    
    for (int i=0; i < newsArr.count; i++) {
        
        NSDictionary *dict = [newsArr objectAtIndex:i];
        
        NewsContentView *newsView = [[NewsContentView alloc] initWithFrame:CGRectZero];
        
        [newsView setData:dict];
        
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
