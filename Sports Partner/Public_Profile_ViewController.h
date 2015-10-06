//
//  Public_Profile_ViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 26/09/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "FXBlurView.h"
#import "connection.h"
#import "MBProgressHUD.h"
#import "DWBubbleMenuButton.h"
#import "GAITrackedViewController.h"
@interface Public_Profile_ViewController : GAITrackedViewController<UIGestureRecognizerDelegate,MBProgressHUDDelegate>

{
   
    UILabel *homeLabel;
    IBOutlet UIButton *Back_Button;
    __weak IBOutlet UILabel *place_label;
    __weak IBOutlet UILabel *age_label;
    __weak IBOutlet UILabel *name_label;
    __weak IBOutlet UIButton *repoert_abuse_button;
    __weak IBOutlet UIButton *eye_button;
    __weak IBOutlet UIButton *chat_button;
    __weak IBOutlet UIImageView *public_prf_pic;
    __weak IBOutlet UIButton *like_button;
    __weak IBOutlet UILabel *tag_label;
        CAShapeLayer *image_layer_up;
        CAShapeLayer *image_layer_down;
        Styles *style;
    NSString *prof_pic_string;
    NSMutableArray *user_details_array;
    NSMutableArray *favourite_sports_array;
    NSMutableDictionary *dict;
    
    
    __weak IBOutlet UILabel *fav_sports_label;
    __weak IBOutlet UITableView *sports_tbl;
    __weak IBOutlet UIView *fav_sports_view;
    FXBlurView *backgroundview;
    
    ////////////// REPORT ABUSE /////////////////
    
    __weak IBOutlet UILabel *abuse_label_four;
    __weak IBOutlet UILabel *abuse_label_three;
    __weak IBOutlet UILabel *abuse_label_two;
    __weak IBOutlet UILabel *abuse_label_one;
    __weak IBOutlet UIView *report_abuse_view;
    __weak IBOutlet UILabel *abuse_heading_one;
    __weak IBOutlet UILabel *abuse_heading_two;
    __weak IBOutlet UIButton *report_submit_button;
    __weak IBOutlet UIButton *button_one;
    __weak IBOutlet UIButton *button_two;
    __weak IBOutlet UIButton *button_three;
    __weak IBOutlet UIButton *button_four;
    NSString *abuse_description;
    
    
    NSString *Chat_status_id;
    NSString *follow_status;
    NSString *post_id;
    __weak IBOutlet UIView *networkErrorView;
    connection *connectobj;
    
    __weak IBOutlet UIButton *star_button;
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    UIView *flash_view;
    UILabel *flash_label;
    
    UIView *t_view;
    UIView *t_view_1;
    
    DWBubbleMenuButton *upMenuView ;

}
@property(nonatomic,readwrite)NSInteger FEED_FLAG;
@property(nonatomic,readwrite)NSInteger LIKE_FLAG;
@property(nonatomic,readwrite)NSInteger CHAT_FLAG;
@property(nonatomic,retain)IBOutlet UIView *public_profile_view;
@property(nonatomic,retain)NSString *TOKEN;
@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *TARGETED_USER_ID;
@property(nonatomic,readwrite) NSInteger UN_FOLLOW_FLAG;
@property(nonatomic,readwrite) NSInteger FOLLOW_FLAG;

- (IBAction)BACK_ACTION:(id)sender;

-(void)swipe_up:(UIView *)sender_view;
-(void)swipe_down:(UIView *)sender_view;
-(void)Clear;

- (IBAction)FOLLOW_ACTION:(id)sender;
- (IBAction)REPORT_ABUSE:(id)sender;
- (IBAction)Fav_Sports_action:(id)sender;

-(IBAction)CHECK_BOX:(UIButton *)sender;
- (IBAction)REPORT_SUBMIT:(id)sender;


- (IBAction)CHAT_ACTION:(id)sender;

- (IBAction)LIKE_ACTION:(id)sender;
@end
