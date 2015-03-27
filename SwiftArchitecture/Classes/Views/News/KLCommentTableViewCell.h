//
//  KLCommentTableViewCell.h
//  KhoaLuan2015
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (assign, nonatomic) NSInteger numberOfLikeInNews;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) NSString *commentUserId;
- (IBAction)btnLikeTapped:(id)sender;
- (void)setContentUIByString:(NSDictionary*)dict;
@end
