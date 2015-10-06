//
//  SettingViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 08/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "TextFieldValidator.h"
#import "SQLFunction.h"
#import "FeedViewController.h"
#import "ProfileViewController.h"
#import "SearchViewController.h"
#import "FollowerViewController.h"
#import "MBProgressHUD.h"
#import "connection.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "GAITrackedViewController.h"
@interface SettingViewController : GAITrackedViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    __weak IBOutlet UITabBar *tabbar;
    __weak IBOutlet UIScrollView *scrollview;
    __weak IBOutlet TextFieldValidator *old_password_field;
    __weak IBOutlet TextFieldValidator *new_password_field;
    __weak IBOutlet TextFieldValidator *confirm_password_field;
    __weak IBOutlet UIView *view1;
    __weak IBOutlet UIView *view2;
    __weak IBOutlet UIView *view3;
    __weak IBOutlet UIButton *save_button;
    __weak IBOutlet UIView *header_bg_view;
    MBProgressHUD *HUD;
    BOOL animating;
    
    __weak IBOutlet UIView *networkErrorView;
    UITextField *activeField;
    BOOL keyboardVisible;
	CGPoint offset;
     Styles *style;
    SQLFunction *sqlfunction;
    connection *connectobj;
    IBOutlet UIView *backview;
    
    __weak IBOutlet UILabel *header_label;
    __weak IBOutlet UIButton *logout_button;
    
    NSTimer *timer;
    NSOperationQueue *queue;
    NSTimer *logout_timer;
    NSOperationQueue *logout_queue;
    
    UIView *t_view;
    UIView *t_view_1;
 UIImageView *imageView;
    
     __weak IBOutlet UILabel *tabbar_border_label;
    
}

@property(nonatomic,retain)NSString *TOCKEN;
@property(nonatomic,readwrite)NSInteger USER_ID;
- (IBAction)SAVE_BUTTON_ACTION:(id)sender;
- (IBAction)LOGOUT:(id)sender;

@end
