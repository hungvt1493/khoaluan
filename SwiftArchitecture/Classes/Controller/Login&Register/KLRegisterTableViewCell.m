//
//  KLRegisterTableViewCell.m
//  KhoaLuan2015
//
//  Created by Mac on 3/11/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLRegisterTableViewCell.h"

@implementation KLRegisterTableViewCell 

- (void)awakeFromNib {
    // Initialization code
    _tvInput.hidden = YES;
    
    CGRect tvFrame = self.tvInput.frame;
    tvFrame.size.width = _tfInput.frame.size.width;
    tvFrame.origin.x = _tfInput.frame.origin.x;
    self.tvInput.frame = tvFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeightForCell:(NSInteger)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
@end
