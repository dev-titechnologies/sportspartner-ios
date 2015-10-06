//
//  FollowerViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 08/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "FeedViewController.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "SearchViewController.h"
#import "Public_Profile_ViewController.h"
#import "MBProgressHUD.h"
#import "connection.h"
#import "SQLFunction.h"
#import "GAITrackedViewController.h"
@interface FollowerViewController : GAITrackedViewController<UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    
   __weak IBOutlet UILabel *tabbar_border_label;
    
    NSInteger total_row_count;
    __weak IBOutlet UIView *msg_bubble_view;
    __weak IBOutlet UILabel *msg_bubble_count;
    NSInteger thread_count;
    NSInteger page_number;
    NSInteger PUBLIC_FLAG;
    NSMutableArray *temp_follow_list_array;
    
    __weak IBOutlet UIButton *back_button;
    __weak IBOutlet UIButton *follow_friends;
    __weak IBOutlet UILabel *no_follower_label;
    __weak IBOutlet UILabel *header_label;
    __weak IBOutlet UIView *header_view;
    __weak IBOutlet UITabBar *tabbar;
    __weak IBOutlet UITableView *follower_table;
    Styles *style;
    NSMutableArray *follow_list_array;
    NSString *conversation_id;
    NSString *image_string;
    NSString *Receiver_id;
    NSString *TARGET_USER_ID;
    __weak IBOutlet UIView *public_profile_view;
    Public_Profile_ViewController *obj;
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    __weak IBOutlet UIView *networkErrorView;
    connection *connectobj;
    __weak IBOutlet UIButton *logout_button;
    NSIndexPath *didselect_indexpath;
     NSTimer *timer;
    __weak IBOutlet UIButton *Back_button;
    NSOperationQueue *queue ;
    SQLFunction *sqlfunction;
    __weak IBOutlet UIView *no_follow_view;
    
    UIView *flash_view;
    UILabel *flash_label;
    UIView *t_view;
    UIView *t_view_1;
    
   
    
}
@property(nonatomic,readwrite)NSInteger PROFILE_FLAG;
@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *TOKEN;

- (IBAction)PUBLIC_VIEW_BACK:(id)sender;

- (IBAction)follow_friends:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *public_view_back;

- (IBAction)BACK_BUTTON:(id)sender;

- (IBAction)LOGOUT:(id)sender;

@end
