//
//  SWGlobal.h
//  KhoaLuan2015
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 HungVT. All rights reserved
//

#ifndef KhoaLuan2015_SWGlobal_h
#define KhoaLuan2015_SWGlobal_h

#define UPER_DATA_COUNT 10
#define dataHasChanged @"dataHasChanged"
#define CacheFoder @"CacheFoder"

#define kKeyChain @"KhoaLuan2015AppLogin"

#define URL_BASE @"http://localhost/restserver/index.php/api/"

#define URL_IMG_BASE @"http://localhost/restserver/"

#define uLogin @"users/api_login"
#define uReg @"users/api_register"
#define nGetNews @"news/api_getNews"
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
#define Back_Bar_Title @"Trở về"

#define Login_Title @"Đăng nhập"
#define Noti_Title @"Thông báo"
#define Friend_Title @"Bạn bè"
#define Register_Title @"Đăng ký"
#define Complete_Button @"Hoàn thành"
#define InforUser_Title @"Thông tin của bạn"
/*TEXT*/
#define Avatar_Message @"Không thể chọn ảnh!"
#define Name_Message @"Bạn chưa nhập tên!"
#define Email_Message @"Email không đúng định dạng!"
#define Email_Require_Message @"Email là bắt buộc"
#define Password_Message @"Mật khẩu cần ít nhất 6 kí tự"
#define Re_Password_Message @"Mật khẩu và Nhắc lại mật khẩu cần giống nhau"

/*IMAGE*/

#define hnue_news_act @"News-hnue-blue"
#define hnue_news @"News-hnue-grey"
#define news_act @"News-blue"
#define news @"News-grey"
#define home_act @"HomeFilled-blue"
#define home @"HomeFilled-grey"
#define noti_act @"Globe-blue"
#define noti @"Globe-grey"
#define noti_act @"Globe-blue"
#define noti @"Globe-grey"
#define more_act @"More-blue"
#define more @"More-grey"
#define back_bar_button @"Back"
#define Edit @"edit_green"
#define avatar @"User"
#define checked @"checked-login"
#define unchecked @"uncheck-login"

/*COLOR*/
#define White_Color @"FFFFFF"
#define Gray_Color @"7f8c8d"
#define Button_bg @"EAEAEA"
#define Button_bg_Selected @"40CCBB"
#define Nav_Bg_Color @"F2F2F2"
#define Black_Color @"000000"
#define Blue_Color @"2980b9"
#define Red_Color @"F65D63"

/*ARRAY*/


#endif
