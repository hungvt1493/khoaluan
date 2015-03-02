//
//  SWAddClotheViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWAddClotheViewController.h"
#import "SWUtil.h"


@interface SWAddClotheViewController (){
    NSMutableArray *tableViewArr;
}
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UITableView *addClotheTableView;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sizeImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

- (IBAction)addButton:(id)sender;
- (IBAction)colorButton:(id)sender;
- (IBAction)categoryButton:(id)sender;
- (IBAction)sizeButton:(id)sender;

@end

@implementation SWAddClotheViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    //[self initData];
}

- (void)initUI{
    
    self.title = AddClothe_Title;
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    [self setRightButtonWithImage:Check_Mark highlightedImage:nil target:self action:@selector(checkButtonTapped:)];
    
    self.addClotheTableView.hidden = YES;
    self.addClotheTableView.alpha = 0;
    self.nameTextField.textColor = [UIColor colorWithHex:Gray_Color alpha:1.0];
    
    if (self.typeCategory == addClotherDetail) {
        self.categoryLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"category"];
        self.categoryImageView.hidden = YES;
    }
    [self checkSizeLabel];
}

- (void)initData{
    
    switch (self.typeTableView) {
        case color:
            tableViewArr = [[NSMutableArray alloc] initWithArray:Color_Arr];
            break;
        case category:
            tableViewArr = [[NSMutableArray alloc] initWithArray:Clothes_Arr];
            break;
        case size:
        {
            if ([self.categoryLabel.text containsString:@"Giày"]) {
                tableViewArr = [[NSMutableArray alloc] initWithArray:Size_Shoes_Arr];

            } else {
                tableViewArr = [[NSMutableArray alloc] initWithArray:Size_Clothes_Arr];
            }
        }
            break;
        default:
            break;
    }
}

- (void)checkSizeLabel{
    if ([self.categoryLabel.text containsString:@"Giày"]) {
        self.sizeLabel.text = @"36";
    }
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPopupWithImageView:(UIImageView *)imageView{
    if (self.addClotheTableView.hidden) {
        
        self.addClotheTableView.hidden = NO;
        imageView.image = [UIImage imageNamed:Up];
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.addClotheTableView.alpha = 0;
        } completion:^(BOOL finished) {
            imageView.image = [UIImage imageNamed:Down];
            self.addClotheTableView.hidden = YES;
        }];
    }
}

- (void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
//    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
//    picker.cameraViewTransform = translate;
//    CGAffineTransform scale = CGAffineTransformScale(translate, 1.333333, 1.333333);
//    picker.cameraViewTransform = scale;
//    
//    UIView * overlayView = [[UIView alloc]init];
//    overlayView.frame = CGRectMake(0, 0, SCREEN_WIDTH_PORTRAIT, SCREEN_HEIGHT_PORTRAIT);
//    picker.cameraOverlayView = overlayView;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)chooseFromLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Action

- (void)checkButtonTapped:(id)sender{
    if (self.nameTextField.text.length == 0) {
        [SWUtil showConfirmAlert:Title_Alert_Validate message:Message_Alert_Validate cancelButton:OK_Button otherButton:nil tag:1 delegate:self];
        return;
    }
    if (self.photoImageView.image == nil) {
        [SWUtil showConfirmAlert:Title_Alert_Validate message:Message_Alert_Camera cancelButton:OK_Button otherButton:nil tag:2 delegate:self];

    }else{
        [SWUtil showConfirmAlert:Title_Alert message:Message_Alert cancelButton:Cancel otherButton:Yes tag:0 delegate:self];

    }
    
}
- (IBAction)addButton:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SWUtil showConfirmAlert:Title_Alert_Validate message:Message_Camera cancelButton:OK_Button otherButton:nil tag:3 delegate:self];
    }else {
        UIActionSheet *addPhotoActionSheet = [[UIActionSheet alloc] initWithTitle:Title_ActionSheet
                                                                     delegate:self
                                                            cancelButtonTitle:Cancel_ActionSheet
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:TakePhoto_ActionSheet,PhotoLibrary_ActionSheet,nil];
        [addPhotoActionSheet showInView:self.view];
    }
}

- (IBAction)colorButton:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    CGRect frame = self.addClotheTableView.frame;
    frame.origin.y = button.frame.origin.y + button.frame.size.height;
    self.addClotheTableView.frame = frame;
    
    self.typeTableView = color;
    [self initData];
    [self.addClotheTableView reloadData];
    [self showPopupWithImageView:self.colorImageView];
}

- (IBAction)categoryButton:(id)sender {
    
    if (self.typeCategory == addClother) {
        UIButton *button = (UIButton*)sender;
        CGRect frame = self.addClotheTableView.frame;
        frame.origin.y = button.frame.origin.y + button.frame.size.height;
        self.addClotheTableView.frame = frame;
        
        self.typeTableView = category;
        [self initData];
        [self.addClotheTableView reloadData];
        [self showPopupWithImageView:self.categoryImageView];
    }
}

- (IBAction)sizeButton:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    CGRect frame = self.addClotheTableView.frame;
    frame.origin.y = button.frame.origin.y + button.frame.size.height;
    self.addClotheTableView.frame = frame;
    
    self.typeTableView = size;
    [self initData];
    [self.addClotheTableView reloadData];
    [self showPopupWithImageView:self.sizeImageView];
}

#pragma mark - TableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableViewArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = [UIColor colorWithHex:Gray_Color alpha:1.0];
    cell.textLabel.text = [tableViewArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    switch (self.typeTableView) {
        case color:
            self.colorLabel.text = cell.textLabel.text;
            break;
        case category:
            self.categoryLabel.text = cell.textLabel.text;
            break;
        case size:
            self.sizeLabel.text = cell.textLabel.text;
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - TextField

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.addClotheTableView setHidden:YES];
    self.colorImageView.image = [UIImage imageNamed:Down];
    self.categoryImageView.image = [UIImage imageNamed:Down];
    self.sizeImageView.image = [UIImage imageNamed:Down];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
}

#pragma mark - ActionSheet

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self chooseFromLibrary];
            break;
        case 2:
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.photoImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end
