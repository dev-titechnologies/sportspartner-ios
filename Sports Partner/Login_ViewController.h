//
//  Login_ViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 04/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "ViewController.h"
#import "Styles.h"
#import "SQLFunction.h"
#import "TextFieldValidator.h"
#import "MBProgressHUD.h"
#import "connection.h"
#import "FXBlurView.h"
#import "GAITrackedViewController.h"
@interface Login_ViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>

{
   
    __weak IBOutlet UIView *web_user_view;
    __weak IBOutlet UILabel *web_user_label;
    __weak IBOutlet UITextField *web_user_password;
    __weak IBOutlet UIButton *web_user_rest_button;
    
    UITextField *userNameFeild;
    UITextField *passWordFeild;
    UITableView *mainLoginInfo;
    UITextField *activeField;
    
    __weak IBOutlet UIView *networkErrorView;
    SQLFunction *sqlfunction;
    connection *connectobj;
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    
    UIImageView  *email_image;
    UIImageView *password_image;
    BOOL keyboardVisible;
	CGPoint offset;
	
    __weak IBOutlet UIButton *Sign_In_button;
    __weak IBOutlet UIButton *back_button;
    __weak IBOutlet UIScrollView *scrollview;
    
    __weak IBOutlet UIButton *forgot_password;
    UILabel *placeholderLabel;
   
    NSInteger USER_ID;
    NSString *TOCKEN;
    NSTimer *timer;
    FXBlurView *backgroundview;
    NSInteger WEB_USER_FLAG;
    
    UIView *t_view;
    UIView *t_view_1;
    Styles *style;

}
- (IBAction)SGN_IN:(id)sender;
- (IBAction)Forgot_password:(id)sender;
- (IBAction)BACK:(id)sender;
- (IBAction)rest_btn_action:(id)sender;
- (IBAction)web_user_close:(id)sender;


@end
