//
//  SWGlobal.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved
//

#ifndef SwiftArchitecture_SWGlobal_h
#define SwiftArchitecture_SWGlobal_h

#define UPER_DATA_COUNT 10
#define dataHasChanged @"dataHasChanged"
#define CacheFoder @"CacheFoder"

/*TYPE ENUM*/
typedef enum {
    color = 0,
    category,
    size
}TableViewType;

typedef enum{
    register_new = 0,
    edit_infor
}UserType;

typedef enum {
    addClother = 0,
    addClotherDetail
}TypeCategory;

/*TITLE*/
#define Register_Title @"Đăng ký"
#define Login_Title @"Đăng nhập"
#define DressTime_Title @"Lựa chọn quần áo"
#define Wardrobe_Title @"Bộ sưu tập"
#define AddClothe_Title @"Thêm mới"
#define Log_Title @"Lịch sử"
#define Feel_Title @"Cảm nhận"
#define Setting_Title @"Cài đặt"
#define InforUser_Title @"Thông tin của bạn"
#define About_Title @"Thông tin ứng dụng"

/*TEXT*/
#define First_Name_Message @"Mời bạn nhập họ!"
#define Last_Name_Message @"Mời bạn nhập tên!"
#define Height_Message @"Mời bạn nhập chiều cao!"
#define Weight_Message @"Mời bạn nhập cân nặng!"
#define Telephone_Message @"Số điện thoại không đúng!"
#define Email_Message @"Email không tồn tại!"
#define Password_Message @"Mật khẩu của bạn chưa đủ kí tự"
#define Re_Password_Message @"Mật khẩu chưa đúng"
#define Complete_Button @"Hoàn thành"
#define Register_Button @"Đăng ký"

#define Dress_Time_Title @"Lựa chọn"
#define Wardrobe_Title @"Bộ sưu tập"
#define Log_Title @"Lịch sử"
#define Setting_Title @"Cài đặt"
#define Skirt @"ÁO"
#define Jeans @"QUẦN/VÁY"
#define Shoe @"GIÀY/DÉP"
#define Cell @"Cell"

#define Title_ActionSheet @"Chọn ảnh"
#define Cancel_ActionSheet @"Thoát"
#define TakePhoto_ActionSheet @"Chụp ảnh"
#define PhotoLibrary_ActionSheet @"Chọn từ thư viện"
#define Message_Camera @"Thiết bị không có camera"
#define Title_Alert @"Xác nhận"
#define Title_Alert_Validate @"Thông báo"
#define Message_Alert @"Bạn có chắc chắn thêm mới không?"
#define Message_Alert_Validate @"Bạn chưa nhập tên trang phục!"
#define Message_Alert_Camera @"Bạn chưa có ảnh trang phục"
#define Cancel @"Không"
#define Yes @"Có"
#define OK_Button @"OK"

#define Date_Format @"dd/MM/yyyy"
#define Time_Format @"HH:mm"

/*IMAGE*/
#define Back_Button @"back_green.png"
#define Dress_Time_On @"t_shirt_on.png"
#define Dress_Time_Off @"t_shirt_off.png"
#define Wardrobe_On @"wardrobe_on.png"
#define Wardrobe_Off @"wardrobe_off.png"
#define Log_On @"bookmark_on.png"
#define Log_Off @"bookmark_off.png"
#define Setting_On @"settings_filled.png"
#define Setting_Off @"settings_off.png"
#define Search @"search.png"
#define Add @"plus.png"
#define Check_Mark @"checkmark.png"
#define Up @"up4.png"
#define Down @"down.png"
#define Edit @"edit_green.png"

#define Gray_Weather @"_gray.png"
#define Red_Weather @"_red.png"

/*COLOR*/
#define Gray_Color @"939393"
#define Button_bg @"EAEAEA"
#define Button_bg_Selected @"40CCBB"
#define White_Color @"FFFFFF"
#define Black_Color @"000000"
#define Green_Color @"40CCBB"
#define Red_Color @"F65D63"

/*ARRAY*/
#define Clothes_Arr @[@"Áo sơ mi",@"Áo phông",@"Áo khoác",@"Áo len",@"Quần jeans",@"Váy",@"Giày thể thao",@"Giày hài",@"Giày bốt"]
#define Clothes_IconArr @[@"shirt_red.png",@"t_shirt_red.png",@"coat_red.png",@"jacket_red.png",@"trousers_red.png",@"skirt_red.png",@"trainers_red.png",@"shoe_woman_red.png",@"winter_boots_red.png"]
#define Color_Arr @[@"Đỏ",@"Xanh da trời",@"Tím",@"Vàng",@"Hồng",@"Đen",@"Cam",@"Nâu",@"Xanh lá cây",@"Xanh nõn chuối",@"Hồng đỏ"]
#define Size_Clothes_Arr @[@"S",@"M",@"L",@"XL",@"XXL"]
#define Size_Shoes_Arr @[@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44"]

/*SIZE*/


#endif
