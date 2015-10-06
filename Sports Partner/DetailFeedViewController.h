//
//  DetailFeedViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 19/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "connection.h"
#import "HPGrowingTextView.h"
#import "FXBlurView.h"
#import "MBProgressHUD.h"
#import "MessageCell.h"
#import "GAITrackedViewController.h"
@interface DetailFeedViewController : GAITrackedViewController<UITextFieldDelegate,UITextViewDelegate,HPGrowingTextViewDelegate,MBProgressHUDDelegate>

{
    FXBlurView *backgroundview;
    UIView *containerView;
    HPGrowingTextView *textView;
    
    __weak IBOutlet UIView *header_view;
    __weak IBOutlet UIButton *send_button;
    __weak IBOutlet UITextView *post_textview;
    __weak IBOutlet UIView *text_bg_view;
    __weak IBOutlet UITableView *tableview;
    __weak IBOutlet UILabel *comment_count;
    __weak IBOutlet UIButton *comment_btn;
    __weak IBOutlet UILabel *like_count;
    __weak IBOutlet UIButton *like_btn;
    __weak IBOutlet UIView *comment_like_bg;
    __weak IBOutlet UICollectionView *collectionview;
    __weak IBOutlet UILabel *post_text;
    __weak IBOutlet UIView *header_bg_view;
    __weak IBOutlet UIImageView *prof_pic;
    __weak IBOutlet UILabel *time_label;
    __weak IBOutlet UILabel *Name_label;
    __weak IBOutlet UIButton *Back_Button;
    Styles *styles;
    __weak IBOutlet UIScrollView *scrollview;
    NSString *message_string;
     NSInteger row_height;
    UIToolbar *toolbar;
    NSMutableArray *comment_list_array;
    connection *connectobj;
    CGRect comment_like_frame;
    
    __weak IBOutlet UIView *comment_bg_view;
    __weak IBOutlet UILabel *comments_label;
    __weak IBOutlet UIButton *done_button;
    __weak IBOutlet UITableView *image_comment_table;
    
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    NSMutableArray *sub_image_array;
    NSMutableArray *feed_array;
    MessageCell *cell_p;
    __weak IBOutlet UIView *networkErrorView;
    
    NSInteger COMMENT_FLAG;
    NSTimer *timer;
     NSTimer *comment_list_timer;
    NSOperationQueue *queue;
    NSOperationQueue *comment_list_queue;
    NSInteger POP_UP_COMMENT_FLAG;
    
    UIView *t_view;
    UIView *t_view_1;
    
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
    
}

-(IBAction)CHECK_BOX:(UIButton *)sender;
- (IBAction)REPORT_SUBMIT:(id)sender;

- (IBAction)REPORT_ABUSE:(id)sender;

@property(nonatomic,readwrite)NSInteger NOTIF_FLAG;
@property(nonatomic,readwrite)NSInteger index_count;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *poster_name;
@property(nonatomic,retain)NSString *text_post;
@property(nonatomic,retain)NSString *post_time;
@property(nonatomic,retain)NSString *like_count_feed;
@property(nonatomic,retain)NSString *comment_count_feed;
@property(nonatomic,retain)NSString *prof_pic_user;
@property(nonatomic,readwrite)NSInteger Post_id;
@property(nonatomic,retain)NSString *model;
@property(nonatomic,retain)UIToolbar *toolBar;
@property(nonatomic,retain)UITextView *textView;
@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *TOKEN;
- (IBAction)LIKE_ACTION:(id)sender;

- (IBAction)DONE_ACTION:(id)sender;
- (IBAction)Back_Action:(id)sender;
- (IBAction)SEND:(id)sender;
- (IBAction)COMMENT_ACTION:(id)sender;


@end
