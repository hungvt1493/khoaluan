//
//  SWTabbarItem.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWTabbarItem.h"

@implementation SWTabbarItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
        nomarlImage:(UIImage *)nomarlImage
      selectedImage:(UIImage *)hoverImage
              title:(NSString*)title
             offset:(float)offset {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        tabNomarl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        tabSelected = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        tabNomarl.image = nomarlImage;
//        tabSelected.image = hoverImage;
        
        int x = 25;
        tabNomarl = [[UIImageView alloc] initWithFrame:CGRectMake(x, 4 + offset, frame.size.width, frame.size.height)];
        tabSelected = [[UIImageView alloc] initWithFrame:CGRectMake(x, 4 + offset, frame.size.width, frame.size.height)];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,  25, SCREEN_WIDTH_PORTRAIT/4, 30)];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 49);
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        tabNomarl.image = nomarlImage;
        tabSelected.image = hoverImage;
        titleLabel.text = title;
        
        [self addSubview:tabNomarl];
        [self addSubview:tabSelected];
        [self addSubview:titleLabel];
        [self setSelected:NO];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        tabNomarl.hidden = YES;
        tabSelected.hidden = NO;
        self.backgroundColor = [UIColor colorWithHex:Green_Color alpha:1.0];
        titleLabel.textColor = [UIColor whiteColor];
    }
    else {
        tabNomarl.hidden = NO;
        tabSelected.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor colorWithHex:Gray_Color alpha:1.0];

    }
}

@end
