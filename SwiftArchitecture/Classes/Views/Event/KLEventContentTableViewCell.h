//
//  KLNewsContentTableViewCell.h
//  KhoaLuan2015
//
//  Created by Mac on 3/12/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLEventContentTableViewCellDelegate <NSObject>

- (void)didDeleteCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)didChooseEditCellAtIndexPath:(NSIndexPath*)indexPath withData:(NSDictionary*)dict withType:(PostType)type withImage:(NSArray*)imageArr withImageName:(NSArray*)imageNameArr;
- (void)pushToDetailViewControllerUserDelegateForCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)pushToUserPageViewControllerUserDelegateForCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)didChooseImage:(NSArray*)imagesArr AtIndex:(NSInteger)index;
@end

@interface KLEventContentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *rateContentView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdmin;
@property (weak, nonatomic) id<KLEventContentTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *ratebgView;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTime;
@property (assign, nonatomic) PostType postType;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnShowMore;
@property (weak, nonatomic) IBOutlet UIView *newsContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (assign, nonatomic) NSInteger newsId;
@property (strong, nonatomic) NSString *newsUserId;
@property (assign, nonatomic) NSInteger numberOfLikeInNews;
@property (assign, nonatomic) NSInteger numberOfCommentInNews;
@property (assign, nonatomic) NSInteger numberOfFollowInNews;
@property (weak, nonatomic) IBOutlet UIButton *btnShowTool;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *btnShowRateView;
@property (weak, nonatomic) IBOutlet UILabel *lblRateBad;
@property (weak, nonatomic) IBOutlet UILabel *lblRateFine;
@property (weak, nonatomic) IBOutlet UILabel *lblRateGood;
@property (weak, nonatomic) IBOutlet UIButton *btnRateFine;
@property (weak, nonatomic) IBOutlet UIButton *btnRateBad;
@property (weak, nonatomic) IBOutlet UIButton *btnRateGood;
@property (weak, nonatomic) IBOutlet UIImageView *imgRateChecked;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfFollowers;

- (void)setData:(NSDictionary*)dict;
- (IBAction)btnLikeTapped:(id)sender;
- (void)haveImage:(BOOL)flag;
- (IBAction)btnEditTapped:(id)sender;
- (IBAction)btnDeleteTapped:(id)sender;
- (IBAction)btnShowToolViewTapped:(id)sender;
- (IBAction)btnMessageTapped:(id)sender;
- (IBAction)btnMoreTapped:(id)sender;
- (IBAction)btnShowRateViewTapped:(id)sender;
- (IBAction)btnRateBadTapped:(id)sender;
- (IBAction)btnRateFineTapped:(id)sender;
- (IBAction)btnRateGoodTapped:(id)sender;
@end
