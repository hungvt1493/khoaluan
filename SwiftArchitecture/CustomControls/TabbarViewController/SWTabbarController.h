//
//  SWTabbarController.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTabbarItem.h"
#import "MKNumberBadgeView.h"

@interface SWTabbarController : UITabBarController
{

}
@property (nonatomic,assign) NSInteger oldSelectedIndex;
/*This method only chanr state of TabbarItem frome nomarl to selected*/
- (void)hoverAtIndex:(NSInteger)tabIndex;
//set background by color or image for tabbar
@property (nonatomic,strong) UIImageView *backGround;
@property (nonatomic,strong) MKNumberBadgeView *badge;

- (id)initWithNomarlImages:(NSArray *)normalImages
              selectImages:(NSArray *)selectImages
                backGround:(UIColor *)ground
                     title:(NSArray *)titleArray;

- (void)hideTabbar:(BOOL)hiden;
- (void)setValueForBadge:(NSInteger)value;
@end
