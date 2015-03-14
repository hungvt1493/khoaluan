//
//  KLNewsContentTableViewCell.h
//  KhoaLuan2015
//
//  Created by Mac on 3/12/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLNewsContentTableViewCell : UITableViewCell
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
@property (strong, nonatomic) NSString *newsId;
@property (assign, nonatomic) NSInteger numberOfLikeInNews;
@property (assign, nonatomic) NSInteger numberOfCommentInNews;
@property (weak, nonatomic) IBOutlet UIButton *btnShowTool;
- (void)setData:(NSDictionary*)dict;
@property (weak, nonatomic) IBOutlet UIView *toolView;

- (IBAction)btnLikeTapped:(id)sender;
- (void)haveImage:(BOOL)flag;
- (IBAction)btnEditTapped:(id)sender;
- (IBAction)btnDeleteTapped:(id)sender;
- (IBAction)btnShowToolViewTapped:(id)sender;
@end
