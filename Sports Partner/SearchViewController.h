//
//  SearchViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 08/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "ProfileViewController.h"
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "FeedViewController.h"
#import "FollowerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FXBlurView.h"
#import "MBProgressHUD.h"
#import "connection.h"
#import "SQLFunction.h"
#import "SportsCell.h"
#import "DWBubbleMenuButton.h"
#import "GAITrackedViewController.h"
#import "MessageViewController.h"
#import <MapKit/MapKit.h>
@interface SearchViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UIView *search_table_bg_view;
    
    __weak IBOutlet UIButton *name_search_close_button;
    
    __weak IBOutlet UITableView *search_name_table;
    
    __weak IBOutlet UIButton *map_up_button;
    
    __weak IBOutlet UILabel *search_header_label;
    
    UILabel *slider_label;
    __weak IBOutlet UILabel *IN_label;
    __weak IBOutlet UILabel *tabbar_border_label;
    __weak IBOutlet UIView *msg_bubble_view;
    __weak IBOutlet UILabel *msg_bubble_count;
    UILabel *homeLabel;
    DWBubbleMenuButton *upMenuView ;
    __weak IBOutlet UIButton *edit_button;
    __weak IBOutlet UIButton *select_sports_button;
    __weak IBOutlet UIButton *up_arrow;
    __weak IBOutlet UIView *search_view;
    __weak IBOutlet UILabel *select_sports_label;
    __weak IBOutlet UIView *header_view;
    __weak IBOutlet UILabel *header_label;
    __weak IBOutlet UISegmentedControl *l_segment_control;
      __weak IBOutlet UIButton *report_abuse_button;
    __weak IBOutlet UILabel *no_search_label;
    __weak IBOutlet UITabBar *tabbar;
    __weak IBOutlet UILabel *searching_label;
    __weak IBOutlet UIButton *male_button;
    __weak IBOutlet UIButton *female_button;
    __weak IBOutlet UILabel *within_label;
    __weak IBOutlet UILabel *km_label;
    __weak IBOutlet UILabel *from_label;
    __weak IBOutlet UITextField *Place_field;
    __weak IBOutlet UIButton *find_button;
    __weak IBOutlet UIView *line_view;
    Styles *style;
    __weak IBOutlet UISlider *slider;
    NSInteger M_FLAG;
    NSInteger F_FLAG;
    
    __weak IBOutlet UIView *location_view;
    __weak IBOutlet UILabel *place_label;
    __weak IBOutlet UILabel *age_label;
    __weak IBOutlet UILabel *name_label;
    __weak IBOutlet UIButton *repoert_abuse_button;
    __weak IBOutlet UIButton *eye_button;
    __weak IBOutlet UIButton *chat_button;
    __weak IBOutlet UIImageView *public_prf_pic;
    __weak IBOutlet UIButton *like_button;

    __weak IBOutlet UIView *public_profile_view;
    __weak IBOutlet UITableView *search_table;
    
    CAShapeLayer *image_layer_up;
    CAShapeLayer *image_layer_down;
    NSInteger GENDER_FLAG;
    NSString *slider_value;
    
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *latitude;
    NSString *longitude;
    CLLocation *location;
    NSString *location_string;
    NSMutableArray *search_array;
    NSMutableArray *fav_spots_array;
    __weak IBOutlet UILabel *fav_sports_label;
    __weak IBOutlet UITableView *sports_tbl;
    __weak IBOutlet UIView *fav_sports_view;
    FXBlurView *backgroundview;
    NSString *USER_PROFILE_ID;
    NSString *prof_pic_string;
    NSString *Chat_status_id;
    NSString *follow_status;
    NSString *abuse_description;
    NSString *post_id;
    
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
    
    __weak IBOutlet UIButton *logout_button;
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    __weak IBOutlet UIView *networkErrorView;
     connection *connectobj;
    SQLFunction *sqlfunction;
      NSString *user_location;
    NSString *current_location;
    NSString *user_latitude;
    NSString *user_longitude;
    NSString *current_latitude;
    NSString *current_longitude;
    NSTimer *timer;
    NSIndexPath *didselect_index;
    NSString *search_user_name;
    
    __weak IBOutlet UIButton *no_search;
    NSOperationQueue  *queue;
    __weak IBOutlet UIButton *select_sports_done_button;
    __weak IBOutlet UIView *select_sports_bg_view;

    __weak IBOutlet UICollectionView *select_sp_collectionview;
    __weak IBOutlet UIButton *select_sports_cancel_button;
    NSMutableArray *complete_sports_list;
    NSMutableArray *favourite_sports_list;
    NSMutableArray *Unselected_sports_list;
    
    NSMutableArray *index_array;
    NSMutableArray *selected_sports_array;
    NSString *id_string;
    NSMutableArray *search_fav_sports_array;
    NSMutableArray *temp_index_array;
    UIView *flash_view;
    UILabel *flash_label;
    __weak IBOutlet UIButton *star_button;
    NSInteger Public_search_flag;
    NSInteger CURRENT_LOCATION_FLAG;
    UIView *t_view;
    UIView *t_view_1;
    NSInteger CORELOCATION_FLAG;
    
    dispatch_queue_t queue_location;
    
    NSInteger thread_count;
    
    NSInteger page_number;
    
    NSMutableArray *search_temp_array;
    
    
    ////////////////////// MKMAPVIEW INTEGRATION ///////////////////////////////
    
    NSMutableArray *search_name_arry;
    MKAnnotationView *pinView;
    UIButton *search;
    UILabel *location_name_label;
    NSMutableArray *filteredTableData;
    __weak IBOutlet UITextField *search_name_textfield;
    
    MKCircleView *circleView;
    MKCircle *circle;
    NSString *search_type;
    CLLocationCoordinate2D touchMapCoordinate;
   
    BOOL isShowUserLocation;
}
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property(nonatomic,retain)MKPolyline *routeLine;
@property(nonatomic,retain)MKPolylineView *routeLineView;
@property(nonatomic,readwrite)NSInteger Index_did;
@property(nonatomic,readwrite)NSInteger CHAT_FLAG;
@property(nonatomic,readwrite)NSInteger INTRO_FLAG;
@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *TOKEN;

- (IBAction)NAME_SEARCH_CLOSE_ACTION:(id)sender;

- (IBAction)SEARCH_VIEW_BACK:(id)sender;

- (IBAction)MAP_UP_ACTION:(id)sender;

- (IBAction)EDIT_ACTION:(id)sender;

- (IBAction)SELECT_SPORTS:(id)sender;
- (IBAction)select_sports_done:(id)sender;
- (IBAction)UP_arrow:(id)sender;

- (IBAction)select_sports_cancel:(id)sender;

- (IBAction)BACK:(id)sender;
- (IBAction)FOLLOW_ACTION:(id)sender;
- (IBAction)REPORT_ABUSE:(id)sender;
- (IBAction)Fav_Sports_action:(id)sender;
-(IBAction)CHECK_BOX:(UIButton *)sender;
- (IBAction)CHAT_ACTION:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)FIND_ACTION:(UIButton *)sender;
- (IBAction)MALE_ACTION:(UIButton *)sender;
- (IBAction)FEMALE_ACTION:(id)sender;
- (IBAction)REPORT_SUBMIT:(id)sender;
- (IBAction)LIKE_ACTION:(id)sender;
- (IBAction)LOGOUT_ACTION:(id)sender;


@end
