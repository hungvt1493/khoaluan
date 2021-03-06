//
//  KLNewsContentTableViewCell.h
//  KhoaLuan2015
//
//  Created by Mac on 3/12/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLNewsContentTableViewCellDelegate <NSObject>

- (void)didDeleteCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)didChooseEditCellAtIndexPath:(NSIndexPath*)indexPath withData:(NSDictionary*)dict withType:(PostType)type withImage:(NSArray*)imageArr withImageName:(NSArray*)imageNameArr;
- (void)pushToDetailViewControllerUserDelegateForCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)pushToUserPageViewControllerUserDelegateForCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)didChooseImage:(NSArray*)imagesArr AtIndex:(NSInteger)index;
@end

@interface KLNewsContentTableViewCell : UITableViewCell

@property (weak, nonatomic) id<KLNewsContentTableViewCellDelegate>delegate;

@property (assign, nonatomic) PostType postType;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdmin;

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
@property (weak, nonatomic) IBOutlet UIButton *btnShowTool;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) NSIndexPath *indexPath;

- (void)setData:(NSDictionary*)dict;
- (IBAction)btnLikeTapped:(id)sender;
- (void)haveImage:(BOOL)flag;
- (IBAction)btnEditTapped:(id)sender;
- (IBAction)btnDeleteTapped:(id)sender;
- (IBAction)btnShowToolViewTapped:(id)sender;
- (IBAction)btnMessageTapped:(id)sender;
- (IBAction)btnMoreTapped:(id)sender;
@end
