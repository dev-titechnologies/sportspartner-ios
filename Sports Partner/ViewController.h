//
//  ViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 04/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import <FacebookSDK/FacebookSDK.h>
#import "connection.h"
#import "MBProgressHUD.h"
#import "SQLFunction.h"
#import "GAITrackedViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController : GAITrackedViewController<UIActionSheetDelegate,MBProgressHUDDelegate,UIGestureRecognizerDelegate,AVAudioPlayerDelegate>

{
    AVAudioPlayer *audioPlayer;
    __weak IBOutlet UIButton *sign_in_facebook_button;
    __weak IBOutlet UIButton *sign_in_button;
  
    __weak IBOutlet UIButton *sign_up_button;
    __weak IBOutlet UIButton *sign_up_f_button;
  
    __weak IBOutlet UIView *test_view;
    Styles *style;
    
    CAShapeLayer *sign_in_f_mask;
    CAShapeLayer *sign_in_mask;
    
    CAShapeLayer *sign_up_f_mask;
    CAShapeLayer *sign_up_mask;
    __weak IBOutlet UILabel *label;
   
    __weak IBOutlet UIButton *terms_of_service;

    __weak IBOutlet UILabel *copyright;
    
    __weak IBOutlet UITextView *terms_text_view;
    __weak IBOutlet UILabel *terms_label;
    __weak IBOutlet UIView *terms_view;
    __weak IBOutlet UIView *terms_bg_view;
    NSInteger FB_FLAG_1;
    NSInteger FB_LOGIN_FLAG;
  
    NSInteger USER_ID_1;
    
    NSString *TOCKEN_1;
    
    __weak IBOutlet UIView *networkErrorView_1;
    SQLFunction *sqlfunction_1;
    connection *connectobj_1;
    MBProgressHUD *HUD_1;
    BOOL animating_1;
    UIImageView *imageView_1;
    
    
    
    UIView *animation_main_view;
    UIView *animation_sub_view;
    UIImageView *anim_imageView;

}
- (void)userLoggedIn;
- (void)userLoggedOut;
- (IBAction)close_button:(id)sender;
- (IBAction)Sign_in_action:(id)sender;
- (IBAction)TERMS_ACTION:(id)sender;
- (IBAction)Sign_up_action:(id)sender;
- (IBAction)fb_connect_action:(id)sender;

@end
