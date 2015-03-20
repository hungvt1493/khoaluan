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
#define uLogout @"users/api_logout"
#define uReg @"users/api_register"
#define uUpdate @"users/api_updateUser"

#define uGetFriend @"users/api_getFriend"
#define uAddFriend @"users/api_addFriend"

#define uUpdateTimelineImage @"users/api_updateTimelineImage"
#define uUpdatePassword @"users/api_updateUserPassword"

#define nGetNews @"news/api_getNewsWithOffset"
#define nGetNewsWithUserId @"news/api_getNewsByUserIdWithOffset"
#define nGetNewsWithNewsId @"news/api_getNewsWithNewsId"

#define nLikeNews @"news/api_insertLike"
#define nDeleteLikeNews @"news/api_deleteLike"
#define nPostNews @"news/api_insertNews"
#define nDeleteNews @"news/api_deleteNews"
#define nEditNews @"news/api_updateNews"

#define cmGetComment @"comments/api_getComments"
#define cmAddComment @"comments/api_insertComment"
#define cmEditComment @"comments/api_updateComment"
#define cmDeleteComment @"comments/api_deleteComment"
#define cmLikeComment @"comments/api_deleteComment"
//Key
#define kCode @"code"
#define kMessage @"message"
#define kUserId @"user_id"
#define kName @"name"
#define kUserName @"username"
#define kBirthDay @"birthday"
#define kStudentId @"student_id"
#define kFaculty @"faculty"
#define kEmail @"email"
#define kGender @"gender"
#define kAvatar @"avatar"
#define kTimelineImage @"timeline_image"
#define kIsAdmin @"is_admin"
#define kNewsId @"news_id"
#define kAboutMe @"about_me"
#define kisOnline @"is_online"

#define kCommentId @"comment_id"
#define kCommentContent @"content"
/*TYPE ENUM*/
typedef enum {
    color = 0,
    category,
    size
}TableViewType;

typedef enum{
    register_new = 0,
    edit_info,
    change_password
}UserType;

typedef enum {
    addClother = 0,
    addClotherDetail
}TypeCategory;

typedef enum {
    status = 0,
    event
}PostType;

typedef enum {
    add = 0,
    edit
}PageType;

#define DATE_FORMAT @"dd/MM/yyyy"
#define FULL_DATE_FORMAT @"dd/MM/yyyy HH:mm"
#define PULL_DOWN_DATE                                       @"MM/dd , HH:mm"

/*TITLE*/
#define Back_Bar_Title @"Trở về"

#define Login_Title @"Đăng nhập"
#define Noti_Title @"Thông báo"
#define Friend_Title @"Bạn bè"
#define Register_Title @"Đăng ký"
#define Complete_Button @"Hoàn thành"
#define InforUser_Title @"Thông tin của bạn"
#define Change_Password_Title @"Đổi mật khẩu"
#define Update_Status_Title @"Cập nhật trạng thái"
#define Create_Event_Title @"Tạo sự kiện"
#define The_Last_Cell_Have_No_Data_Title @"Không có bài viết"
#define The_Last_Cell_Have_Data_Title @"Đang tải"
#define Post_News_Title @"Đăng"
#define Edit_News_Title @"Sửa"
#define Post_News_Success_Title @"Đăng thành công"
#define Edit_News_Success_Title @"Sửa thành công"
/*TEXT*/
#define Avatar_Message @"Không thể chọn ảnh!"
#define Name_Message @"Bạn chưa nhập tên!"
#define Email_Message @"Email không đúng định dạng!"
#define Email_Require_Message @"Email là bắt buộc"
#define Password_Message @"Mật khẩu cần ít nhất 6 kí tự"
#define Old_Password_Message @"Mật khẩu cũ cần ít nhất 6 kí tự"
#define Re_Password_Message @"Mật khẩu và Nhắc lại mật khẩu cần giống nhau"
#define Post_Event_No_Title_Error @"Bạn chưa nhập tên sự kiện"
#define Post_Event_No_Time_Error @"Bạn chưa chọn thời gian cho sự kiện"
#define Post_Status_No_Content_Error @"Bạn chưa nhập trạng thái"
#define Post_Status_Are_You_Sure_Warning_Title @"Bạn chưa đăng trạng thái"
#define Post_Status_Are_You_Sure_Warning_Message @"Bạn có chắc không?"
#define Date_Warning_Title @"Ngày diễn ra sự kiện không được trước thời điểm hiện tại"
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
#define back_bar_button_blue @"BlueBack"
#define Edit @"BlueEdit"
#define back_bar_button @"Back"
#define avatar @"User"
#define checked @"checked-login"
#define unchecked @"uncheck-login"
#define male @"Male"
#define female @"Female"
#define male_blue @"Male-Blue"
#define female_blue @"Female-Blue"
/*COLOR*/
#define White_Color @"FFFFFF"
#define Gray_Color @"7f8c8d"
#define Button_bg @"EAEAEA"
#define Button_bg_Selected @"40CCBB"
#define Nav_Bg_Color @"F2F2F2"
#define Black_Color @"000000"
#define Blue_Color @"2980b9"
#define Red_Color @"F65D63"
#define Like_Button_color @"21D726"
/*ARRAY*/

#define kDidPostNews @"kDidPostNews"
#define kDidPostMyPage @"kDidPostMyPage"
#endif
