//
//  SWWardrobeDetailViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWWardrobeDetailViewController.h"
#import "SWAddClotheViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "SWWardrobeCollectionViewCell.h"

@interface SWWardrobeDetailViewController ()
@property(nonatomic, strong) IBOutlet UICollectionView *wardrobeCollectionView;
@property (weak, nonatomic) IBOutlet UIView *contentWardrobeView;

@end

@implementation SWWardrobeDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    [self setRightButtonWithImage:Add highlightedImage:nil target:self action:@selector(addButtonTapped:)];
    
    //Make machine collection
    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    layout.itemSize = CGSizeMake(70,90);//SCREEN_WIDTH_LANDSCAPE/2, self.contentWardrobeView.bounds.size.height/5);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.wardrobeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH_PORTRAIT,self.contentWardrobeView.bounds.size.height ) collectionViewLayout:layout];
    self.wardrobeCollectionView.delegate = self;
    self.wardrobeCollectionView.dataSource = self;
    [self.wardrobeCollectionView setBackgroundColor:[UIColor colorWithHex:@"D3F2ED" alpha:1.0]];
    
    [self.wardrobeCollectionView registerClass:[SWWardrobeCollectionViewCell class] forCellWithReuseIdentifier:Cell];
    [self.wardrobeCollectionView registerNib:[UINib nibWithNibName:@"SWWardrobeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Cell];
    
    [self.contentWardrobeView addSubview:self.wardrobeCollectionView];
}

- (void)initData{
    
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addButtonTapped:(id)sender{
    SWAddClotheViewController *addClothesVC = [[SWAddClotheViewController alloc] initWithNibName:@"SWAddClotheViewController" bundle:nil];
    addClothesVC.typeCategory = addClotherDetail;
    [self.navigationController pushViewController:addClothesVC animated:YES];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 90;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = Cell;
    SWWardrobeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(70,90);//SCREEN_WIDTH_LANDSCAPE/4, self.contentWardrobeView.bounds.size.height/5);
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
