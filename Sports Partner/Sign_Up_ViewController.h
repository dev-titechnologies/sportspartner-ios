//
//  Sign_Up_ViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 04/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "ViewController.h"
#import "Styles.h"
#import "KSEnhancedKeyboard.h"
#import "TextFieldValidator.h"
#import <CoreLocation/CoreLocation.h>
#import "SQLFunction.h"
#import "MBProgressHUD.h"
#import "connection.h"
#import "GAITrackedViewController.h"
@interface Sign_Up_ViewController : GAITrackedViewController<UITextFieldDelegate,KSEnhancedKeyboardDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
{
    UITextField *activeField;
    UIImageView  *email_image;
    UIImageView *password_image;
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    
    __weak IBOutlet UIView *header_view;
    __weak IBOutlet UILabel *gender_label;
    IBOutlet TextFieldValidator *NameField;
    IBOutlet TextFieldValidator *EmailField;
    IBOutlet TextFieldValidator *PasswordField;
    IBOutlet TextFieldValidator *PIN;
    IBOutlet UITextField *country_field;
    
    __weak IBOutlet UIButton *Back_button;
    __weak IBOutlet UIScrollView *scrollview;
    __weak IBOutlet UISegmentedControl *segmented_control;
    __weak IBOutlet UIButton *sign_up_button_1;

    BOOL keyboardVisible;
	CGPoint offset;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *date_string;
    NSString *gender_string;
    NSString *date_of_birth;
    NSString *longitude;
    CLLocation *location;
    NSString *location_string;
    NSInteger USER_ID;
    NSString *TOCKEN;
    
    SQLFunction *sqlfunction;
    Styles *styles;
    connection *connectobj;
    __weak IBOutlet UIView *networkErrorView;
    
    NSString *birthday;
    NSString *day;
    NSString *year;
    NSString *month;
    NSString *first_name;
    NSString *last_name;
    NSString *gender;
    NSString *email;
    IBOutlet UIView *back_view;

    UIView *t_view;
    UIView *t_view_1;
    
}
@property(nonatomic,readwrite)NSInteger FB_FLAG;
@property (strong, nonatomic) NSMutableArray *formItems;
@property (strong, nonatomic) KSEnhancedKeyboard *enhancedKeyboard;

- (IBAction)Sign_Up_Action:(id)sender;
- (IBAction)Back:(id)sender;
-(IBAction)segmentedControlIndexChanged:(id)sender;

@end
