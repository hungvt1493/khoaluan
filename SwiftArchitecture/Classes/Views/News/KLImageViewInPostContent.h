//
//  KLImageViewInPostContent.h
//  KhoaLuan2015
//
//  Created by Mac on 3/22/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLImageViewInPostContentDelegate <NSObject>

- (void)didDeleteImageAtIndex:(NSInteger)index;

@end

@interface KLImageViewInPostContent : UIView
@property (weak, nonatomic) id<KLImageViewInPostContentDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (assign, nonatomic) NSInteger index;
- (IBAction)btnDeleteTapped:(id)sender;
@end
