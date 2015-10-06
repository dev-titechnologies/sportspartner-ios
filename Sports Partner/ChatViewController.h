//
//  ChatViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 13/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "JSMessagesViewController.h"
#import "SQLFunction.h"
#import "MBProgressHUD.h"
#import "connection.h"
#import "GAITrackedViewController.h"
@interface ChatViewController :JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource,MBProgressHUDDelegate>


{
    NSInteger page_number;
    NSInteger total_row_count;
    __weak IBOutlet UILabel *no_msg_label;
    Styles *style;
    IBOutlet UIButton *Back_Button;
    NSMutableDictionary *dict;
    SQLFunction *sqlfunction;
    NSData *image_data;
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    __weak IBOutlet UIView *networkErrorView;
    connection *connectobj;
    UIImage *sender_image;
    UIImage *receiver_image;
    __weak IBOutlet UIView *no_chat_view;
    
    __weak IBOutlet UILabel *header_label;
    NSTimer *timer;
    NSOperationQueue *queue;
    
    
    NSTimer *send_timer;
    NSOperationQueue *send_queue;
    
    __weak IBOutlet UIView *header_view;
    UIView *t_view;
    UIView *t_view_1;
    NSMutableArray *message_push_array;
    NSMutableArray *message_temp_array;
}
@property(nonatomic,readwrite)NSInteger SEARCH_FLAG;
@property(nonatomic,readwrite)NSInteger PUBLIC_PROFILE_FLAG;
@property(nonatomic,retain)NSString *URL_STRING;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *TOKEN;
@property(nonatomic,retain)NSString *RECEIVER_ID;
@property(nonatomic,retain)NSString *conversation_id;
@property(nonatomic,retain)NSMutableArray *message_array;

- (IBAction)BACK_ACTION:(id)sender;

@end
