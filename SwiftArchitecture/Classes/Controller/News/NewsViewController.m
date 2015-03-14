//
//  NewsViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "NewsViewController.h"
#import "KLNewsContentTableViewCell.h"

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property(nonatomic, strong) PullToRefreshView *pull;
@end

@implementation NewsViewController {
    NSArray *newsArr;
    NSMutableArray *fullNewsArr;
    int _oldOffset;
    BOOL _endOfRespond;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;
    _oldOffset = 0;
    fullNewsArr = [[NSMutableArray alloc] initWithCapacity:10];
    _endOfRespond = NO;
    //[self initData];
    
    //pull down to refresh
    self.pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *)_newsTableView];
    [self.pull setDelegate:(id<PullToRefreshViewDelegate>)self];
    [_newsTableView addSubview:self.pull];
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    
    [self.pull setState:PullToRefreshViewStateLoading];
    _oldOffset = 0;
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
    
    NSDictionary *parameters = @{@"offset": [NSNumber numberWithInt:_oldOffset]};
    
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
            NSLog(@"NEWS JSON: %@", responseObject);
            [_newsTableView reloadData];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_oldOffset inSection:0];
            [_newsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            _oldOffset += newsArr.count;
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            _endOfRespond = [[dict objectForKey:@"code"] intValue];
            [_newsTableView reloadData];
        }
        
        [self.pull finishedLoading];
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
        return fullNewsArr.count;
    }
    return fullNewsArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_endOfRespond && indexPath.row == fullNewsArr.count) {
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
        NSDictionary *dict = [fullNewsArr objectAtIndex:indexPath.row];
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
    if (fullNewsArr.count == 0) {
        return 44;
    }
    if (indexPath.row < fullNewsArr.count) {
        NSDictionary *dict = [fullNewsArr objectAtIndex:indexPath.row];
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
@end
