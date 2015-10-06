//
//  IntroViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 03/11/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "GAITrackedViewController.h"
@interface IntroViewController : GAITrackedViewController
{
    __weak IBOutlet UIPageControl *pagecontrol;
    __weak IBOutlet UIImageView *image_bg;
    __weak IBOutlet UIButton *skip_btn;
    __weak IBOutlet UIButton *ready_button;
    Styles *styles;
    __weak IBOutlet UIScrollView *scrollview;
    UIImageView *newview;
    NSInteger padding;
}
@property(nonatomic,readwrite)NSInteger USER_ID;
@property(nonatomic,retain)NSString *token;
@property(nonatomic,retain)NSString *device_id;
@property(nonatomic,readwrite)NSInteger LOGIN_FLAG;
- (IBAction)SKIP:(id)sender;
- (IBAction)READY:(id)sender;

@end
