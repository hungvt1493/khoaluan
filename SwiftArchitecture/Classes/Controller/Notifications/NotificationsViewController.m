//
//  NotificationsViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "NotificationsViewController.h"
#import "KLNotificationTableViewCell.h"
#import "MyPageViewController.h"

@interface NotificationsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *notiTable;

@end

@implementation NotificationsViewController {
    NSArray *_notiArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Noti_Title;
    
    self.notiTable.delegate = self;
    self.notiTable.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SWUtil appDelegate] hideTabbar:NO];
    [self initData];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)initData {
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, notiGetNotification];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSDictionary *parameters = @{kUserId: userId};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _notiArr = (NSArray*)responseObject;
        }
        
        int count = 0;
        for (int i = 0; i<_notiArr.count; i++) {
            NSDictionary *dict = [_notiArr objectAtIndex:i];
            int isRead = [[dict objectForKey:@"is_read"] intValue];
            if (isRead == 0) {
                count++;
            }
        }
        
        [[SWUtil appDelegate] setBadgeValue:count];
        
        [_notiTable reloadData];
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
//        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
//        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _notiArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CELL";

    KLNotificationTableViewCell *cell = (KLNotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"KLNotificationTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = [_notiArr objectAtIndex:indexPath.row];
    
    NSString *imgAvatarPath = EMPTY_IF_NULL_OR_NIL([[NSUserDefaults standardUserDefaults] objectForKey:kAvatar]);
    if (imgAvatarPath.length > 0) {
        NSString *imageLink = [NSString stringWithFormat:@"%@%@", URL_IMG_BASE, imgAvatarPath];
        [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:imageLink]
                          placeholderImage:[UIImage imageNamed:@"default-avatar"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image) {
                                         
                                     } else {
                                         
                                     }
                                 }];
    }
    
    cell.lblContent.text = [dict objectForKey:@"content"];
    
    int time = [[dict objectForKey:@"time"] intValue];
    NSDate *date = [SWUtil convertNumberToDate:time];
    
    NSString *ago = [date timeAgo];
    cell.lblTime.text = ago;
    
    int isRead = [[dict objectForKey:@"is_read"] intValue];
    
    CGRect frame = cell.imageView.frame;
    frame.origin.x = 0;
    cell.imageView.frame = frame;
    
    if (isRead == 0) {
        cell.backgroundColor = [UIColor colorWithHex:@"029eca" alpha:1];
        cell.lblContent.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.lblContent.textColor = [UIColor colorWithHex:@"029eca" alpha:1];
    }
    
    cell.isRead = isRead;
    cell.notiId = [dict objectForKey:@"noti_id"];
    cell.type = [[dict objectForKey:@"type"] intValue];
    cell.userSendId = [dict objectForKey:@"user_send_id"];
    cell.userReceiveId = [dict objectForKey:@"user_receive_id"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLNotificationTableViewCell *cell = (KLNotificationTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.isRead == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.lblContent.textColor = [UIColor colorWithHex:@"029eca" alpha:1];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, notiReadNotification];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
        NSDictionary *parameters = @{@"noti_id": cell.notiId};
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self initData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        if (cell.type == 1) {
            MyPageViewController *userPageVC = [[MyPageViewController alloc] init];
            userPageVC.myPageType = UserPage;
            userPageVC.userId = cell.userSendId;

            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHideBackButtonInUserPage];
            [self.navigationController pushViewController:userPageVC animated:YES];
            [tableView  deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


@end
