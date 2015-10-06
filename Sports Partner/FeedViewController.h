//
//  FeedViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 08/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "AFTableViewCell.h"
#import "Video_Table_Cell.h"
#import "Text_Cell.h"
#import <CoreLocation/CoreLocation.h>
#import "ProfileViewController.h"
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "FollowerViewController.h"
#import "connection.h"
#import "AFNetworking.h"
#import "CTAssetsPickerController.h"
#import "CTAssetsPageViewController.h"
#import "MBProgressHUD.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SQLFunction.h"
#import "HPGrowingTextView.h"
#import "SportsCell.h"
#import "ASPopUpView.h"
#import "ASProgressPopUpView.h"
#import "GAITrackedViewController.h"
@interface FeedViewController : GAITrackedViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate,CTAssetsPickerControllerDelegate,UIPopoverControllerDelegate,MBProgressHUDDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,HPGrowingTextViewDelegate,ASProgressPopUpViewDataSource,ASProgressPopUpViewDelegate,ASPopUpViewDelegate>
{
    __weak IBOutlet UILabel *tabbar_border_label;
    
    __weak IBOutlet UIView *pgress_bg;
    __weak IBOutlet ASProgressPopUpView *progress_bar;
    __weak IBOutlet UILabel *header_label;
    __weak IBOutlet UIView *progress_view;
    __weak IBOutlet UIView *msg_bubble_view;
    __weak IBOutlet UILabel *msg_bubble_count;
    
    NSInteger COMPOSE_FLAG;
    NSInteger SELECT_PHOTO_FLAG;
    NSInteger SELECT_VIDEO_FLAG;
    NSInteger cv;
    __weak IBOutlet UILabel *name_label_share;
    __weak IBOutlet UIImageView *pro_pic_share;
    __weak IBOutlet UIView *header_view;
    __weak IBOutlet UIButton *post_cancel_button;
    __weak IBOutlet UIButton *follow_friend;
    NSMutableArray *test_image;
    __weak IBOutlet UIButton *logout_button;
    __weak IBOutlet UIImageView *cover_pic;
    __weak IBOutlet UITabBar *tabbar;
    __weak IBOutlet UIImageView *profile_pic;
    __weak IBOutlet UILabel *name_label;
    __weak IBOutlet UILabel *place_label;
    __weak IBOutlet UILabel *age_label;
    __weak IBOutlet UITableView *feed_table;
    __weak IBOutlet UITextView *feed_post_dummy_field;
    __weak IBOutlet UIButton *post_button;
    __weak IBOutlet UIView *post_bg_view;
    __weak IBOutlet UITextView *text_post_field;
    __weak IBOutlet UIView *view1;
    __weak IBOutlet UIButton *feed_goes_here_button;
    
    __weak IBOutlet UIView *netwok_error_view;
    __weak IBOutlet UILabel *Australia_label;
    __weak IBOutlet UIView *view3;
    __weak IBOutlet UIView *view2;
    NSOperationQueue  *video_queue ;
    Video_Table_Cell *Video_Cell;
    Text_Cell *t_cell;
    Styles *style;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    connection *connectobj;
    NSMutableArray *feed_array;
    NSIndexPath *image_indexpath;
    NSIndexPath *detail_feed_index;
    NSString *longitude;
    NSString *latitude;
    NSString *location_string;
   
    NSString *im_str;
    NSMutableArray *im_name;
    NSMutableArray *image_array;
    MBProgressHUD *HUD;
    UIView *thud;
    BOOL animating;
    UIImageView *imageView;
    NSMutableArray *sub_image_array;
    UIPanGestureRecognizer  *_pullDownGestureRecognizer;
    NSMutableDictionary *IMAGE_DICT;
    NSMutableArray *images_array;
    SQLFunction *sqlfunction;
    NSMutableArray *sql_image_array;
    NSMutableArray *image_array_1;
    
    NSInteger DB_FLAG;
    NSInteger SERVER_FLAG;
    NSMutableArray *comment_list_array;
    NSInteger POST_ID_FEED;
  
    NSInteger page_number;
    __weak IBOutlet UIView *comment_bg_view;
    __weak IBOutlet UILabel *comments_label;
    __weak IBOutlet UIButton *done_button;
    __weak IBOutlet UITableView *image_comment_table;
    
    FXBlurView *backgroundview;
    
    UIView *containerView;
    HPGrowingTextView *textView;
    NSMutableArray *feed_temp_array;
    NSIndexPath *indexPath_comment;
    NSInteger Comment_flag;
    NSCache *imageCache;
    NSInteger IMAGE_LOAD_FLAG;
    
    __weak IBOutlet UIButton *collection_done_button;
    __weak IBOutlet UICollectionView *collection_view;
   
    NSTimer *video_timer;
    NSString *message_string;
    __weak IBOutlet UIView *collection_bg_view;
    __weak IBOutlet UIView *no_feed_view;
    
    NSTimer *timer;
    NSOperationQueue *queue;
    NSMutableArray *clarity_image_array;
    NSMutableArray *image_feed_array;
    __weak IBOutlet UILabel *no_feed_label;
    NSInteger FEED_FLAG_POST;
    __weak IBOutlet UIScrollView *feed_post_scroll;
    __weak IBOutlet UIView *feed_post_footer;
    float text_height;
    
    __weak IBOutlet UICollectionView *img_preview_collection;
    NSURL *videoUrl;
    UIImage *thumbnail_video;
    NSInteger VIDEO_FLAG;
    NSString *moviePath;
    float height;
    UIView *t_view;
    UIView *t_view_1;
    __weak IBOutlet UIView *likes_view;
    
    __weak IBOutlet UITableView *like_table;
    
    NSMutableArray *liked_users;
    
    NSInteger thread_count;
    
    
    
    
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
   
    
    /////////// flash view///////////////
    UIView *flash_view;
    UILabel *flash_label;
    
    
    NSTimer * timer_feed;
    
}

-(IBAction)CHECK_BOX:(UIButton *)sender;
- (IBAction)REPORT_SUBMIT:(id)sender;

@property(nonatomic,retain)NSString *model;
@property(nonatomic,readwrite) NSInteger Feed_post_Flag;
@property(nonatomic,readwrite)NSInteger index_count;
@property(nonatomic,readwrite)NSInteger DETAIL_FLAG;
@property (nonatomic, retain) NSMutableArray *assets;
@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *TOCKEN;
@property (nonatomic, strong) UIPopoverController *popover;
@property(nonatomic,retain) NSString *reported_feed_id;

- (IBAction)liked_user_cancel:(id)sender;

- (IBAction)collect_Done_action:(id)sender;
- (IBAction)follow_friend:(id)sender;

- (IBAction)post_cancel_action:(id)sender;

- (IBAction)DONE_BUTTON_ACTION:(id)sender;
- (IBAction)LOGOUT:(id)sender;
- (IBAction)FEED_TEXT_BUTTON:(id)sender;
- (IBAction)POST_BUTTON:(id)sender;
- (IBAction)SELECT_VIDEO:(id)sender;
- (IBAction)SELECT_PHOTO:(id)sender;


@end
