//
//  KLNewsDetailViewController.h
//  KhoaLuan2015
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "SWBaseViewController.h"
#import "SOMessageInputView.h"

@interface KLNewsDetailViewController : SWBaseViewController <SOMessagingDelegate>
@property (weak, nonatomic) IBOutlet UIView *rateContentView;
@property (weak, nonatomic) IBOutlet UIView *ratebgView;
@property (weak, nonatomic) IBOutlet UIButton *btnShowRateView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIView *newsContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (assign, nonatomic) NSInteger newsId;
@property (assign, nonatomic) NSInteger numberOfLikeInNews;
@property (assign, nonatomic) NSInteger numberOfCommentInNews;
@property (weak, nonatomic) IBOutlet UIButton *btnShowTool;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSDictionary *dict;
@property (assign, nonatomic) PostType postType;
@property (weak, nonatomic) IBOutlet UIView *footerNewsView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTime;
@property (strong, nonatomic) SOMessageInputView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *btnRateFine;
@property (weak, nonatomic) IBOutlet UIButton *btnRateBad;
@property (weak, nonatomic) IBOutlet UIButton *btnRateGood;
@property (weak, nonatomic) IBOutlet UIImageView *imgRateChecked;
@property (weak, nonatomic) IBOutlet UILabel *lblRateBad;
@property (weak, nonatomic) IBOutlet UILabel *lblRateFine;
@property (weak, nonatomic) IBOutlet UILabel *lblRateGood;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfFollowers;
@property (assign, nonatomic) NSInteger numberOfFollowInNews;

- (IBAction)btnLikeTapped:(id)sender;
- (void)haveImage:(BOOL)flag;
- (IBAction)btnEditTapped:(id)sender;
- (IBAction)btnDeleteTapped:(id)sender;
- (IBAction)btnShowToolViewTapped:(id)sender;
- (void)removeNavigationBarAnimation;
- (IBAction)btnShowRateViewTapped:(id)sender;
- (IBAction)btnRateBadTapped:(id)sender;
- (IBAction)btnRateFineTapped:(id)sender;
- (IBAction)btnRateGoodTapped:(id)sender;
- (IBAction)btnFollowTapped:(id)sender;
@end
