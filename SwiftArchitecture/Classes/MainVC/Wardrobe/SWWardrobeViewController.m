//
//  SWWardrobeViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWWardrobeViewController.h"
#import "SWWardrobeDetailViewController.h"
#import "SWAddClotheViewController.h"

@interface SWWardrobeViewController (){
    NSArray *clothesArr;
    NSArray *clothesIconArr;
}
@property (weak, nonatomic) IBOutlet UITableView *wardrobeTableView;

@end

@implementation SWWardrobeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Wardrobe_Title;
    [self setBackButtonWithImage:Search highlightedImage:nil target:self action:@selector(searchButtonTapped:)];
    [self setRightButtonWithImage:Add highlightedImage:nil target:self action:@selector(addButtonTapped:)];
}

- (void)initData{
    clothesArr = Clothes_Arr;
    clothesIconArr = Clothes_IconArr;
}

- (void)searchButtonTapped:(id)sender{
    
}

- (void)addButtonTapped:(id)sender{
    SWAddClotheViewController *addClothesVC = [[SWAddClotheViewController alloc] initWithNibName:@"SWAddClotheViewController" bundle:nil];
    addClothesVC.typeCategory = addClother;
    [self.navigationController pushViewController:addClothesVC animated:YES];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setTextColor:[UIColor colorWithHex: Gray_Color alpha:1.0]];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [clothesArr objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:[clothesIconArr objectAtIndex:indexPath.row]];
            break;
        case 1:
            cell.textLabel.text = [clothesArr objectAtIndex:indexPath.row + 3];
            cell.imageView.image = [UIImage imageNamed:[clothesIconArr objectAtIndex:indexPath.row + 3]];
            break;
        case 2:
            cell.textLabel.text = [clothesArr objectAtIndex:indexPath.row + 6];
            cell.imageView.image = [UIImage imageNamed:[clothesIconArr objectAtIndex:indexPath.row + 6]];

            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    SWWardrobeDetailViewController *wardrobeDetailVC = [[SWWardrobeDetailViewController alloc] init];
    wardrobeDetailVC.title = cell.textLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"category"];
    
    [self.navigationController pushViewController:wardrobeDetailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_PORTRAIT, 39)];
    [view setBackgroundColor:[UIColor colorWithHex:Green_Color alpha:1.0]];
    UILabel *sectionTitle  = [[UILabel alloc] initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH_PORTRAIT, 25)];
    [view addSubview:sectionTitle];
    sectionTitle.textAlignment = NSTextAlignmentCenter;
    sectionTitle.textColor = [UIColor whiteColor];
    sectionTitle.font = [UIFont fontHelveticaNeue_Medium:15];
    
    switch (section) {
        case 0:
            sectionTitle.text = Skirt;
            break;
        case 1:
            sectionTitle.text = Jeans;
            break;
        case 2:
            sectionTitle.text = Shoe;
            break;
            
        default:
            break;
    }
    return view;
}

@end
