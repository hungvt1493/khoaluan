//
//  NewsView.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "NewsContentView.h"

@implementation NewsContentView

- (id)initWithFrame:(CGRect)frame
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    if (array == nil || [array count] == 0)
        return nil;
    frame = [[array objectAtIndex:0] frame];
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:[array objectAtIndex:0]];
        
        //UITapGestureRecognizer *tapGestureViewController = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOptionGrid)];
        //[self addGestureRecognizer:tapGestureViewController];
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _bgView.layer.cornerRadius = 3;
    _bgView.clipsToBounds = YES;
    
    _btnLike.layer.borderWidth = 0;
    _btnLike.layer.cornerRadius = 5;
    
    _btnMessage.layer.cornerRadius = 5;
    _btnMessage.layer.borderWidth = 1;
    _btnMessage.layer.borderColor = [UIColor blackColor].CGColor;
    
    _btnShowMore.layer.cornerRadius = 5;
    _btnShowMore.layer.borderWidth = 1;
    _btnShowMore.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)haveImage:(BOOL)flag {
    if (!flag) {
        _scrollView.hidden = YES;
        //_bgView.frame = CGRectMake(_bgView.frame.origin.x, _bgView.frame.origin.y, _bgView.frame.size.width, _bgView.frame.size.height);
        _contentView.frame = CGRectMake(0, _scrollView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height);
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - _scrollView.frame.size.height);
    }
}

- (IBAction)btnReadMoreTapped:(id)sender {
}

- (void)setData:(NSDictionary*)dict {
    int numberOfImage = [[dict objectForKey:@"number_of_image"] intValue];
    
    if (numberOfImage == 0) {
        [self haveImage:NO];
    }
    
    NSString *likesNumber = [NSString stringWithFormat:@" %@",[dict objectForKey:@"likes"]];
    [_btnLike setTitle:likesNumber forState:UIControlStateNormal];
    
    int time = [[dict objectForKey:@"time"] intValue];
    NSDate *date = [SWUtil convertNumberToDate:time];
    
    NSString *ago = [date timeAgo];
    _lblTime.text = ago;
    NSLog(@"Output is: \"%@\" - %@", ago, date);
    
    NSString *content = [dict objectForKey:@"content"];
    _lblContent.text = content;
    
    NSString *imgPath = [dict objectForKey:@"avatar"];
    NSString *imageLink = [NSString stringWithFormat:@"%@%@", URL_IMG_BASE, imgPath];
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:imageLink]
                         placeholderImage:[UIImage imageNamed:@"default-avatar"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    if (image) {
                                        
                                    } else {
                                        
                                    }
                                }];
}

/*
- (void)wrappedString:(NSString*)str {
    CGRect rect=CGRectMake(51, 16, 257, 0);
    _lblContent.text = str;
    CGSize size=[str sizeWithFont:self.lblContent.font constrainedToSize:CGSizeMake(257, 3000) lineBreakMode:self.lblContent.lineBreakMode];
    int lines=(size.height/self.lblContent.font.pointSize);
    self.lblContent.numberOfLines=lines;
    rect.size=size;
    if(lines>2)
    {
        if(lines==3 &&[str length]>66)
        {
            str=[str substringToIndex:66];
            str=[str stringByAppendingString:@"...Read More"];
            size=[str sizeWithFont:self.lblContent.font constrainedToSize:CGSizeMake(257, 67) lineBreakMode:self.lblContent.lineBreakMode];
            
            int lines=(size.height/self.lblContent.font.pointSize);
            self.lblContent.numberOfLines=lines;
            
            rect.size=CGSizeMake(257, 67);
        }
        else if(lines>3)
        {
            str=[str stringByAppendingString:@"...Read More"];
            size=[str sizeWithFont:self.lblContent.font constrainedToSize:CGSizeMake(257, 67) lineBreakMode:self.lblContent.lineBreakMode];
            
            int lines=(size.height/self.lblContent.font.pointSize);
            self.lblContent.numberOfLines=lines;
            
            rect.size=CGSizeMake(257, 67);
        }
        
        //self.lblQuestion.lineBreakMode=NSLineBreakByTruncatingHead;
    }
    _lblContent.text = str;
    NSLog(@"TEXT: %@", _lblContent.text);
}
 */
@end
