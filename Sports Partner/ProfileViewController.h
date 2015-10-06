//
//  ProfileViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 06/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "SQLFunction.h"
#import "SettingViewController.h"
#import "SearchViewController.h"
#import "FollowerViewController.h"
#import "connection.h"
#import "MBProgressHUD.h"
#import "CTAssetsPickerController.h"
#import "CTAssetsPageViewController.h"
#import "MBProgressHUD.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ADLivelyCollectionView.h"
#import "FXBlurView.h"
#import "ASProgressPopUpView.h"
#import "ASPopUpView.h"
#import "GAITrackedViewController.h"
@interface ProfileViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,UIScrollViewDelegate,CTAssetsPickerControllerDelegate>
{
    NSMutableDictionary *dict_sp;
    NSMutableDictionary *dict2;
    NSMutableDictionary *dict3;
    NSMutableDictionary *dict_a;
    NSMutableDictionary *dict_b;
    NSMutableDictionary *dict1;
    NSMutableDictionary *dict_raw;
    NSMutableDictionary *dict_raw_1;
    NSMutableDictionary *dict_raw_2;
    FXBlurView *backgroundview;
    
    __weak IBOutlet UIView *pgress_bg;
    
    __weak IBOutlet ASProgressPopUpView *progress_bar;
    __weak IBOutlet UIView *progress_view;

    __weak IBOutlet UIButton *tag_save_button;
    __weak IBOutlet UIButton *tag_cancel_button;
    __weak IBOutlet UITextView *tag_edit_text;
    __weak IBOutlet UIView *tagline_view;
    __weak IBOutlet UILabel *tag_label;
    __weak IBOutlet UIImageView *bgg_image;
    __weak IBOutlet UICollectionView *sports_collection_view;
    __weak IBOutlet UILabel *empty_photo_label;
    __weak IBOutlet UIButton *like_button;
    __weak IBOutlet UIImageView *star_image;
    Styles *style;
    connection *connectobj;
    __weak IBOutlet UITabBar *tabbar;
    __weak IBOutlet UIImageView *profile_pic;
    __weak IBOutlet UILabel *message_notification_count;
    __weak IBOutlet UITableView *un_selected_table;
    __weak IBOutlet UITableView *favourite_table_view;
    __weak IBOutlet UILabel *alert_notifiction_count;
    __weak IBOutlet UILabel *follower_counr;
    __weak IBOutlet UILabel *like_count;
     __weak IBOutlet UILabel *name_label;
    __weak IBOutlet UILabel *place_label;
    __weak IBOutlet UILabel *age_label;
    __weak IBOutlet UIButton *right_arrow;
    __weak IBOutlet UIButton *left_arrow;
    __weak IBOutlet UIButton *order_button;
    __weak IBOutlet UIImageView *bg_image;
    __weak IBOutlet UIImageView *prof_pic;
    __weak IBOutlet UIView *image_gallery_bg_view;
    __weak IBOutlet UICollectionView *collectionview;
    __weak IBOutlet UIButton *Back_Button;
    __weak IBOutlet UICollectionView *gallery_collection_view;
    __weak IBOutlet UIButton *gallery_back;
    __weak IBOutlet UIView *main_gallery_bg_view;
    
    __weak IBOutlet UIImageView *gallery_image_view;
    
    NSMutableArray *complete_sports_list;
    NSMutableArray *favourite_sports_list;
    NSMutableArray *Unselected_sports_list;
    
    NSString *favourite_sports_name;
    NSString *unselected_sports_name;
    NSInteger RIGHT_FLAG;
    NSInteger LEFT_FLAG;
    NSMutableArray *image_array;
    SQLFunction *sqlfunction;
    NSData *imd_data;
    __weak IBOutlet UIView *networkErrorView;
   
    __weak IBOutlet UIScrollView *scrollview;
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    
    NSString *im_str;
    NSMutableArray *im_name;
    
    NSInteger PROFILE_FLAG;
   
    __weak IBOutlet UILabel *FOLLOW_LABEL;
   
    NSInteger FOLLOW_FLAG;
    
    NSTimer *timer;
    NSOperationQueue *queue;
     NSTimer *photo_timer;
    MBProgressHUD *notif_HUD;
    NSInteger PROFILE_PHOTO_FLAG;
    NSInteger FOLLOW_COUNT_GREATER;

    __weak IBOutlet UILabel *header_label;
    __weak IBOutlet UIView *header_view;
    __weak IBOutlet UIView *header_view1;
    NSMutableArray *img_tmp_array;
    __weak IBOutlet UILabel *header_label1;
    NSInteger IMAGE_UPLOAD_FLAG;
    NSOperationQueue *photo_q;
    NSInteger PROFILE_PHOTO;
    NSMutableArray *index_array;
    UIView *t_view;
    UIView *t_view_1;
    NSTimer *user_timer;
    NSMutableArray *fav_array;
    NSMutableArray *un_fav_array;
    NSMutableArray *combined_sports_array;
    
     __weak IBOutlet UILabel *tabbar_border_label;
    
    __weak IBOutlet UIScrollView *scroll_view;
    
}
@property (nonatomic,retain) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) NSArray *assets;
@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *TOCKEN;
@property (nonatomic, strong) UIPopoverController *popover;
@property(nonatomic,readwrite)NSInteger NOTIF_RESET_FLAG;
@property(nonatomic,readwrite)NSInteger MSG_RESET_FLAG;


- (IBAction)TAG_CANCEL:(id)sender;
- (IBAction)TAG_SAVE:(id)sender;

- (IBAction)GET_GALLERY:(id)sender;
- (IBAction)SELECT_PHOTO:(id)sender;
- (IBAction)BACK_ACTION:(id)sender;
- (IBAction)GAllERY_BACK:(id)sender;
- (IBAction)Take_Photo:(id)sender;
- (IBAction)ORDER_BUTTON_ACTION:(UIButton *)sender;
- (IBAction)FOLLOWERS_LIST:(id)sender;
- (IBAction)MESSAGES_LIST:(id)sender;
- (IBAction)GET_NOTIFICATIONS:(id)sender;
- (IBAction)GET_PHOTOS:(id)sender;
- (IBAction)PROFILE_EDIT:(id)sender;
- (IBAction)ARROW_RIGHTACTION:(id)sender;
- (IBAction)ARROW_LEFT_ACTION:(id)sender;




@end
