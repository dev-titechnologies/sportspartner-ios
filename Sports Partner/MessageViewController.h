//
//  MessageViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 07/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "MBProgressHUD.h"
#import "connection.h"
@interface MessageViewController : UIViewController<MBProgressHUDDelegate,UIActionSheetDelegate>
{

    
    NSInteger total_row_count;
    NSInteger page_number;
    
    NSMutableArray *message_temp_array;
    
    __weak IBOutlet UIButton *Back_Button;
    
    __weak IBOutlet UILabel *no_msg_label;
    __weak IBOutlet UITableView *message_table_view;
    Styles *style;
    NSMutableArray *message_array;
    NSString *conversation_id;
    NSString *receiver_id;
    NSURL *image_url;
    NSString *image_string;
    
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    __weak IBOutlet UIView *networkErrorView;
    connection *connectobj;
    NSIndexPath *indexPath_longpress;
    
    __weak IBOutlet UIView *no_message_view;
    NSTimer *timer;
    NSOperationQueue *queue;

    __weak IBOutlet UIView *header_view;
    __weak IBOutlet UILabel *header_label;
    
    UIView *t_view;
    UIView *t_view_1;
    NSCache *cache ;
    
}

@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *TOKEN;

- (IBAction)BACK_ACTION:(id)sender;

@end
