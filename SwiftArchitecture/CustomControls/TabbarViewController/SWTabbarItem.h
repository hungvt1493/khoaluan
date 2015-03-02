//
//  SWTabbarItem.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWTabbarItem : UIControl
{
@private
    /*Hold icon images and colors for text - only using for Part type*/
    UIImageView  *tabNomarl;
    UIImageView *tabSelected;
    UILabel *titleLabel;
}

@property (nonatomic,assign) NSInteger tabIndex;

/*Using image contain icon,text for tabbar item*/
- (id)initWithFrame:(CGRect)frame
        nomarlImage:(UIImage *)nomarlImage
      selectedImage:(UIImage *)hoverImage
              title:(NSString*)title
             offset:(float)offset ;

@end
