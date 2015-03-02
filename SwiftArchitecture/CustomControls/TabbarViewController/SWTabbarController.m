//
//  SWTabbarController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWTabbarController.h"
#import "SWTabbarItem.h"

#define SW_HEIGHT_TABBAR 49

@interface SWTabbarController ()

@end

@implementation SWTabbarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)initWithNomarlImages:(NSArray *)normalImages
             selectImages:(NSArray *)selectImages
               backGround:(UIColor *)ground
                     title:(NSArray *)titleArray{
    if (self = [super init]) {
        
        [self hidenOldTabbar];
        //Setup background color
        
        _backGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - SW_HEIGHT_TABBAR, [UIScreen mainScreen].bounds.size.width, SW_HEIGHT_TABBAR)];
        [_backGround setBackgroundColor:ground];
		[self.view addSubview:_backGround];
        
        //adding tabbar items.
        int x = 0;
        for (int i = 0; i < [normalImages count]; i++) {
			
            UIImage *normalImage = [UIImage imageNamed:[normalImages objectAtIndex:i]];
            UIImage *hoverImage = [UIImage imageNamed:[selectImages objectAtIndex:i]];
            
            CGRect tabRect = CGRectMake(x, [UIScreen mainScreen].bounds.size.height - SW_HEIGHT_TABBAR, normalImage.size.width, normalImage.size.height);
            
            SWTabbarItem *cellTab;

            cellTab = [[SWTabbarItem alloc] initWithFrame:tabRect nomarlImage:normalImage selectedImage:hoverImage title:[titleArray objectAtIndex:i] offset:0];
            
            cellTab.tabIndex = i;
            [self.view addSubview:cellTab];
            x+= [UIScreen mainScreen].bounds.size.width / [normalImages count];
			[cellTab addTarget:self action:@selector(tabItemSeleted:) forControlEvents:UIControlEventTouchUpInside];
		}
    }
    return self;
}

- (void)hidenOldTabbar{
    
    //This method will hiden all old tabbar item...
	
	NSArray *subviewsArray = [self.view subviews];
	for ( UIView *subview in subviewsArray) {
		
		if ([subview isKindOfClass:[UITabBar class]]) {
			
			[subview setHidden:YES];
		}
	}
}

#pragma IBAction && @Selector

- (void)tabItemSeleted:(SWTabbarItem *)sender {
    
    if (sender.tabIndex == self.oldSelectedIndex) {
        
        NSArray *controllers = [self viewControllers];
        if ([controllers objectAtIndex:sender.tabIndex] && [[controllers objectAtIndex:sender.tabIndex] isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController *nav = (UINavigationController *)[controllers objectAtIndex:sender.tabIndex];
            [nav popToRootViewControllerAnimated:NO];
        }
    }
    self.oldSelectedIndex = sender.tabIndex;
    [self hoverAtIndex:sender.tabIndex];
}

- (void)hoverAtIndex:(NSInteger)tabIndex {
    
    [self setSelectedIndex:tabIndex];
    
    NSArray *subviews = [self.view subviews];
	for (UIView *tabbarItem in subviews) {
        
        if ([tabbarItem isKindOfClass:[SWTabbarItem class]]) {
            
            SWTabbarItem *item = (SWTabbarItem *)tabbarItem;
            if (item.tabIndex == tabIndex) {
                
                [item setSelected:YES];
            }
            else {
                
                [item setSelected:NO];
            }
        }
    }
}

- (void)hideTabbar:(BOOL)hiden {
    
    if (hiden) {
        _backGround.frame = CGRectMake(0,
                                       [UIScreen mainScreen].bounds.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       SW_HEIGHT_TABBAR);
        for (UIView *subview in [self.view subviews]) {
            
            if ([subview  isKindOfClass:[SWTabbarItem class]] || [subview isKindOfClass:[UITabBar class]]) {
                [subview setHidden:YES];
            }
        }
    }else{
        _backGround.frame = CGRectMake(0,
                                       [UIScreen mainScreen].bounds.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       SW_HEIGHT_TABBAR);
        for (UIView *subview in [self.view subviews]) {
            
            if ([subview  isKindOfClass:[SWTabbarItem class]] || [subview isKindOfClass:[UITabBar class]]) {
                [subview setHidden:NO];
            }
        }
    }
}

@end
