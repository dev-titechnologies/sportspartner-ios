//
//  NotificationViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 07/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "MBProgressHUD.h"
#import "connection.h"
#import "FXBlurView.h"
#import "DetailFeedViewController.h"
#import "Public_Profile_ViewController.h"
@interface NotificationViewController : UIViewController<MBProgressHUDDelegate,UIGestureRecognizerDelegate>
{
    
    NSInteger page_number;
    NSInteger total_row_count;
    NSMutableArray *notif_temp_array;
    
    __weak IBOutlet UIButton *bacl_button;
    __weak IBOutlet UITableView *notif_table_view;
    __weak IBOutlet UIButton *Back_Button;
    Styles *style;
    NSMutableArray *notification_array;
    
    __weak IBOutlet UITableView *user_names_table;
    __weak IBOutlet UIView *networkErrorView;
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    connection *connectobj;
    NSMutableArray *user_name_array;
    __weak IBOutlet UIView *user_name_bg_view;
    FXBlurView *backgroundview;
    NSInteger POST_ID;
    
    __weak IBOutlet UIView *public_profile_view;
    Public_Profile_ViewController *obj;
    NSString *TARGET_USER_ID;
    
    NSTimer *timer;
    NSOperationQueue *queue;
    __weak IBOutlet UIView *no_notif_view;

    __weak IBOutlet UIView *header_view;
    __weak IBOutlet UILabel *header_label;
    
    UIView *t_view;
    UIView *t_view_1;
    
    NSString *notification_id;
    
}
@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *TOKEN;
- (IBAction)BACK_ACTION:(id)sender;
- (IBAction)public_prof_back:(id)sender;

@end
