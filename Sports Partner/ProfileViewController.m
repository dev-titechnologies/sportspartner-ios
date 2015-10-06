//
//  ProfileViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 06/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "ProfileViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "SportsCell.h"
#import "SBJSON.h"
#import "FeedViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import "AFNetworking.h"
#define ZOOM_STEP 1.5
#import "ViewController.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize USER_ID,TOCKEN,MSG_RESET_FLAG,NOTIF_RESET_FLAG;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    style=[[Styles alloc]init];
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];
    
    header_view.backgroundColor=[style colorWithHexString:@"042e5f"];
    
    
    self.screenName=@"SP Profile Screen";
    
    NSLog(@"DIDLOAD");
   // PROFILE_FLAG=0;
    ///////// ALLOCATIONS //////////
    FOLLOW_FLAG=0;
    order_button.hidden=YES;
    connectobj=[[connection alloc]init];
    
    complete_sports_list=[[NSMutableArray alloc]init];
    favourite_sports_list=[[NSMutableArray alloc]init];
    Unselected_sports_list=[[NSMutableArray alloc]init];
    image_array=[[NSMutableArray alloc]init];
    sports_collection_view.backgroundColor=[style colorWithHexString:terms_of_services_color];
    
    bgg_image.backgroundColor=[style colorWithHexString:terms_of_services_color];
    progress_bar.popUpViewAnimatedColors = @[[style colorWithHexString:age_color], [style colorWithHexString:terms_of_services_color]];
    
    
    /////////// TABBAR///////////////////////////
    
    CGSize tabBarSize = [tabbar frame].size;
    UIView	*tabBarFakeView = [[UIView alloc] initWithFrame:
                               CGRectMake(0,0,tabBarSize.width, tabBarSize.height)];
    [tabbar insertSubview:tabBarFakeView atIndex:0];
    
    [tabBarFakeView setBackgroundColor:[style colorWithHexString:@"f2e7ea"]];
    tabbar_border_label.backgroundColor=[style colorWithHexString:@"e80243"];
    
    tabbar.translucent=YES;

    [tabbar setSelectedItem:[tabbar.items objectAtIndex:1]];
    
    //////////// PROFILE DETAILS////////////////
  //  self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"follower_bg.png"]];
    empty_photo_label.font=[UIFont fontWithName:@"Roboto-Regular" size:18];
    name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:22];
    name_label.shadowColor=[style colorWithHexString:@"7F000000"];
    age_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
        place_label.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    place_label.shadowColor=[style colorWithHexString:@"7F000000"];
    
    message_notification_count.layer.cornerRadius=9.0;
    message_notification_count.layer.masksToBounds=YES;
    message_notification_count.backgroundColor=[UIColor redColor];
    
    
    alert_notifiction_count.layer.cornerRadius=9.0;
    alert_notifiction_count.layer.masksToBounds=YES;
    alert_notifiction_count.backgroundColor=[UIColor redColor];
    
    
    ////////// TABLE VIEW DESIGN ////////////
    
    un_selected_table.backgroundColor=[UIColor clearColor];
    favourite_table_view.backgroundColor=[UIColor clearColor];
    
    
    [right_arrow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right_arrow.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    [right_arrow setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-double-angle-right"] forState:UIControlStateNormal];
    
    [left_arrow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    left_arrow.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    [left_arrow setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-double-angle-left"] forState:UIControlStateNormal];
    
    header_view.backgroundColor=[style colorWithHexString:@"042e5f"];
    header_label.font=[UIFont fontWithName:@"Roboto-Regular" size:23];
    header_label.textColor=[UIColor whiteColor];
    
    header_view1.backgroundColor=[style colorWithHexString:@"042e5f"];
    header_label1.font=[UIFont fontWithName:@"Roboto-Regular" size:23];
    header_label1.textColor=[UIColor whiteColor];
    
    ////////////// PHOTO GALLERY SECTION ////////////////
    
    profile_pic.contentMode=UIViewContentModeScaleAspectFill;
    profile_pic.clipsToBounds=YES;
    prof_pic.layer.cornerRadius=25.0;
    prof_pic.layer.masksToBounds=YES;
    gallery_collection_view.backgroundColor=[UIColor whiteColor];
    prof_pic.contentMode=UIViewContentModeScaleAspectFill;
    prof_pic.clipsToBounds=YES;
    //////////// HEADER VIEW ///////////////////////
    
       
    
    //////////// LOCAL DB///////////////
    
    sqlfunction=[[SQLFunction alloc]init];
    [sqlfunction load_sports_list];
    //[sqlfunction load_all_sports_list];
    [sqlfunction loadUserDetailsTable];
    [sqlfunction SP_ALL_SPORTS];
    
    ///////// FUNCTIONS ///////
    
//    PROFILE_FLAG=0;
//    [self USER_DETAILS];
    
    scrollview.delegate = self;
    scrollview.maximumZoomScale = 100.0;
    gallery_image_view.userInteractionEnabled=YES;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [gallery_image_view addGestureRecognizer:doubleTap];
    like_button.hidden=YES;
    NOTIF_RESET_FLAG=0;
    MSG_RESET_FLAG=0;
    
    
    
    ///////// TAG_VIEW///////////
    
    
    tagline_view.layer.cornerRadius=8.0;
    tagline_view.layer.borderColor=[UIColor whiteColor].CGColor;
    
    tag_save_button.layer.borderColor=[UIColor whiteColor].CGColor;
    tag_save_button.layer.borderWidth=1.0;
    
    tag_cancel_button.layer.borderWidth=1.0;
    tag_cancel_button.layer.borderColor=[UIColor whiteColor].CGColor;
    
    
}



- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height
{
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}

//-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
//{
//    float oldWidth = sourceImage.size.width;
//    float scaleFactor = i_width / oldWidth;
//    
//    float newHeight = sourceImage.size.height * scaleFactor;
//    float newWidth = oldWidth * scaleFactor;
//    
//    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
//    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
//{
//    // not equivalent to image.size (which depends on the imageOrientation)!
//    double refWidth = CGImageGetWidth(image.CGImage);
//    double refHeight = CGImageGetHeight(image.CGImage);
//    
//    double x = (refWidth - size.width) / 2.0;
//    double y = (refHeight - size.height) / 2.0;
//    
//    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRectSports Partner);
//    
//    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationDown];
//    CGImageRelease(imageRef);
//    
//    return cropped;
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor=[style colorWithHexString:terms_of_services_color];
    NSLog(@"ViewDidAppear ddddddd");
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
    PROFILE_PHOTO=0;
   
    sports_collection_view.backgroundColor=[style colorWithHexString:terms_of_services_color];
    if (PROFILE_PHOTO_FLAG==1)
    {
        NSLog(@"PHOTO_PROFILE_FLAG");
        PROFILE_PHOTO_FLAG=0;
      
        [HUD hide:YES];
        [self stopSpin];

    }
   else if (IMAGE_UPLOAD_FLAG==1)
    {
        
        
        if ([[UIScreen mainScreen]bounds].size.height ==480)
        {
            scroll_view.frame=CGRectMake(0, 20, 320, 410);
            t_view.frame=CGRectMake(0, 60, 320, 420);
            progress_view.frame=CGRectMake(0, 0, 320, 432);
            pgress_bg.frame=CGRectMake(17,170,287,113);
            tabbar_border_label.frame=CGRectMake(0, 430, 320,1);

        }
        else
        {
            t_view.frame=CGRectMake(0, 60, 320, 508);
        }

        NSLog(@"MULTIPLE IMAGE UPLOAD");
    }
    else
    {
        NSLog(@"PRRRRRRRRRR");
        
        if ([[UIScreen mainScreen]bounds].size.height ==480)
        {
            scroll_view.frame=CGRectMake(0, 20, 320, 408);
            
            profile_pic.frame=CGRectMake(0, 0, 320, 235);
            
//            [scroll_view addSubview:prof_pic];
        }
        else
        {
            t_view.frame=CGRectMake(0, 60, 320, 508);
        }

        
        [self GET_PROFILE_UPLOAD];
        PROFILE_FLAG=0;
        [self USER_DETAILS];
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
        [user_timer invalidate];
         user_timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target: self selector: @selector(GET_USER_DATA_NEW) userInfo: nil repeats: YES];
        }
    }
    
    if ([[UIScreen mainScreen]bounds].size.height ==480)
    {
        scroll_view.frame=CGRectMake(0, 20, 320, 408);
        
        profile_pic.frame=CGRectMake(0, 0, 320, 235);
        
    }
    else
    {
        
    }

}

- (void)view:(UIView*)view setCenter:(CGPoint)centerPoint
{
    CGRect vf = view.frame;
    CGPoint co = scrollview.contentOffset;
    CGFloat x = centerPoint.x - vf.size.width / 2.0;
    CGFloat y = centerPoint.y - vf.size.height / 2.0;
    
    if(x < 0)
    {
        co.x = -x;
        vf.origin.x = 0.0;
    }
    else
    {
        vf.origin.x = x;
    }
    if(y < 0)
    {
        co.y = -y;
        vf.origin.y = 0.0;
    }
    else
    {
        vf.origin.y = y;
    }
    
    view.frame = vf;
    scrollview.contentOffset = co;
}

// MARK: - UIScrollViewDelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return  gallery_image_view;
}

- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    UIView* zoomView = [sv.delegate viewForZoomingInScrollView:sv];
    CGRect zvf = zoomView.frame;
    if(zvf.size.width < sv.bounds.size.width)
    {
        zvf.origin.x = (sv.bounds.size.width - zvf.size.width) / 2.0;
    }
    else
    {
        zvf.origin.x = 0.0;
    }
    if(zvf.size.height < sv.bounds.size.height)
    {
        zvf.origin.y = (sv.bounds.size.height - zvf.size.height) / 2.0;
    }
    else
    {
        zvf.origin.y = 0.0;
    }
    zoomView.frame = zvf;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    float newScale = [scrollview zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [scrollview zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [scrollview frame].size.height / scale;
    zoomRect.size.width  = [scrollview frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}



-(void)GET_COMPLETE_SPORTS_LIST
{
    index_array=[[NSMutableArray alloc]init];
    fav_array=[[NSMutableArray alloc]init];
    un_fav_array=[[NSMutableArray alloc]init];
    Unselected_sports_list=[[NSMutableArray alloc]init];
    
   // [sqlfunction search_all_sports_list_Feed];
    NSString *sports_string=[sqlfunction SEARCH_ALL_SPORTS];
    if ([sports_string isEqualToString:@""] || [sports_string isEqual:[NSNull null]] || sports_string==NULL || sports_string==nil)
    {
        NSLog(@"LOCAL NULL profile sports");
            BOOL netStatus = [connectobj checkNetwork];
            if(netStatus == true)
            {
                networkErrorView.hidden=YES;
                [self showPageLoader];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSString *urlpath;
                    urlpath=[ [connectobj value] stringByAppendingString:@"apiservices/allsports?"];
                    NSURL *url=[[NSURL alloc] initWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSString *a = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
                    
                    if (![a isEqualToString:@""]|| ![a isEqual:[NSNull null]] )
                    {
                        SBJSON *parser=[[SBJSON alloc]init];
                        NSDictionary *results=[parser objectWithString:a error:nil];
                        NSInteger status=[[results objectForKey:@"status"]intValue];
                        
                        if(status==1)
                        {
                            
                            [sqlfunction delete_all_sports_list_Feed];
                            [sqlfunction SP_ALL_SPORTS_SAVE:USER_ID sports:a];
                            complete_sports_list=[[results objectForKey:@"result"]mutableCopy];
                            
                            for (int i=0; i<complete_sports_list.count; i++)
                            {
                                dict_a=[[NSMutableDictionary alloc]init];
                                dict_a=[[complete_sports_list objectAtIndex:i]mutableCopy];
                                [dict_a setObject:@"0" forKey:@"flag"];
                                [complete_sports_list replaceObjectAtIndex:i withObject:dict_a];
                            }
                           
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                
                                
                                [sqlfunction search_sports_list_Feed:USER_ID];
                                favourite_sports_list=sqlfunction.sports_array;
                                
                                
                                
                                for (int i=0; i<complete_sports_list.count; i++)
                                {
                                    for (int j=0; j<favourite_sports_list.count; j++)
                                    {
                                        
                                        if ([[[favourite_sports_list objectAtIndex:j]objectForKey:@"id"]isEqualToString:[[complete_sports_list objectAtIndex:i]objectForKey:@"id"]])
                                        {
                                           dict_b=[[NSMutableDictionary alloc]init];
                                            dict_b=[[complete_sports_list objectAtIndex:i]mutableCopy];
                                            [dict_b setObject:@"1" forKey:@"flag"];
                                            [fav_array addObject:dict_b];
                                            
                                            
                                            dict1=[[NSMutableDictionary alloc]init];
                                            dict1=[[complete_sports_list objectAtIndex:i]mutableCopy];
                                            [dict1 setObject:@"1" forKey:@"flag"];
                                            [complete_sports_list replaceObjectAtIndex:i withObject:dict1];
                                        }
                                    }
                                }
                                index_array=[[NSMutableArray alloc]init];
                                for (int i=0; i<fav_array.count; i++)
                                {
                                    [index_array addObject:[[fav_array objectAtIndex:i]objectForKey:@"id"]];
                                }
                                
                                NSMutableSet *complete_set=[NSMutableSet setWithArray:complete_sports_list];
                                
                                NSSet *favourite_set=[NSSet setWithArray:fav_array];
                                
                                [complete_set minusSet:favourite_set];
                                
                                NSArray *result_array=[complete_set allObjects];
                                
                                [Unselected_sports_list  addObjectsFromArray:result_array];
                                
                                combined_sports_array=[NSMutableArray arrayWithArray:[fav_array arrayByAddingObjectsFromArray:Unselected_sports_list]];
                                
                                [sports_collection_view performBatchUpdates:^{
                                    [sports_collection_view reloadSections:[NSIndexSet indexSetWithIndex:0]];
                                } completion:nil];

                                sports_collection_view.frame=CGRectMake(0, 286, 320, combined_sports_array.count*76/4+75);
                                scroll_view.contentSize=CGSizeMake(320, sports_collection_view.frame.size.height+320);
                                
                                [self stopSpin];
                                
                            });
                            
                        }
                        else if([[results objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self stopSpin];
                                ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                [self presentViewController:view_control animated:YES completion:nil];
                            });
                        }
                    }
                    
                });
            }
            else
            {
                networkErrorView.hidden=YES;
            }
    }
    
  else
  {
      NSLog(@"local not null prof sports");
    NSData* statData = [sports_string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary   *json_db =
    [NSJSONSerialization JSONObjectWithData:statData
                                    options:kNilOptions
                                      error:nil];
    complete_sports_list=[[json_db objectForKey:@"result"]mutableCopy];
      
      for (int i=0; i<complete_sports_list.count; i++)
      {
         dict_sp=[[NSMutableDictionary alloc]init];
          dict_sp=[[complete_sports_list objectAtIndex:i]mutableCopy];
          [dict_sp setObject:@"0" forKey:@"flag"];
          [complete_sports_list replaceObjectAtIndex:i withObject:dict_sp];
      }
   

    [sqlfunction search_sports_list_Feed:USER_ID];
    favourite_sports_list=sqlfunction.sports_array;
    
   
    
    for (int i=0; i<complete_sports_list.count; i++)
    {
        for (int j=0; j<favourite_sports_list.count; j++)
        {
           
            if ([[[favourite_sports_list objectAtIndex:j]objectForKey:@"id"]isEqualToString:[[complete_sports_list objectAtIndex:i]objectForKey:@"id"]])
            {
               dict2=[[NSMutableDictionary alloc]init];
                dict2=[[complete_sports_list objectAtIndex:i]mutableCopy];
                [dict2 setObject:@"1" forKey:@"flag"];
                [fav_array addObject:dict2];
                
                dict3=[[NSMutableDictionary alloc]init];
                dict3=[[complete_sports_list objectAtIndex:i]mutableCopy];
                [dict3 setObject:@"1" forKey:@"flag"];
                [complete_sports_list replaceObjectAtIndex:i withObject:dict3];

            }
        }
    }
    index_array=[[NSMutableArray alloc]init];
    for (int i=0; i<fav_array.count; i++)
    {
        [index_array addObject:[[fav_array objectAtIndex:i]objectForKey:@"id"]];
    }
    
    NSMutableSet *complete_set=[NSMutableSet setWithArray:complete_sports_list];
    
    NSSet *favourite_set=[NSSet setWithArray:fav_array];
    
    [complete_set minusSet:favourite_set];
    
    NSArray *result_array=[complete_set allObjects];
    [Unselected_sports_list  addObjectsFromArray:result_array];
    
    NSLog(@"UNSE: %d",Unselected_sports_list.count);
    combined_sports_array=[NSMutableArray arrayWithArray:[fav_array arrayByAddingObjectsFromArray:Unselected_sports_list]];
    [sports_collection_view performBatchUpdates:^{
        [sports_collection_view reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
     }
    
    
    sports_collection_view.frame=CGRectMake(0, 286, 320, combined_sports_array.count*76/4+75);
    scroll_view.contentSize=CGSizeMake(320, sports_collection_view.frame.size.height+320);
    
//
//    CATransition *animation = [CATransition animation];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFade];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [animation setFillMode:kCAFillModeBoth];
//    [animation setDuration:.3];
//    [[sports_collection_view layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
//    
    
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn;
//    [sports_collection_view.layer addAnimation:transition forKey:nil];
    
       // [sports_collection_view reloadData];
  


}
-(void)USER_DETAILS
{
   
    NSMutableDictionary *dict=[sqlfunction searchUserDetailsTable:USER_ID];
    
    if (dict==NULL || dict.count==0 || [dict isEqual:[NSNull null]])
    {
       
        [self GET_USER_DATA];
        
    }
    else
    {
        NSLog(@"TAG VAlue Is :%@",[dict objectForKey:@"tag"]);
        [name_label setAttributedText:[self GET_SHADOW_STRING:[dict objectForKey:@"name"]]];
        name_label.backgroundColor=[UIColor clearColor];
        [place_label setAttributedText:[self GET_SHADOW_STRING_PLACE:[dict objectForKey:@"place"]]];
        place_label.backgroundColor=[UIColor clearColor];
        
        if ([[dict objectForKey:@"tag"] isEqualToString:@""] || [dict objectForKey:@"tag"]==nil )
        {
            tag_label.attributedText=[self GET_SHADOW_STRING_PLACE:@"Let's do it!!!"];
        }
        else
        {
        
        tag_label.attributedText=[self GET_SHADOW_STRING_PLACE:[dict objectForKey:@"tag"]];
        }
        CGRect beforeFrame = tag_label.frame;
        tag_label.numberOfLines=0;
        tag_label.lineBreakMode=NSLineBreakByWordWrapping;
        [tag_label sizeToFit];
        CGRect afterFrame = tag_label.frame;
        tag_label.frame = CGRectMake(beforeFrame.origin.x + beforeFrame.size.width - afterFrame.size.width, tag_label.frame.origin.y, tag_label.frame.size.width, tag_label.frame.size.height);
        place_label.frame=CGRectMake(4, tag_label.frame.size.height+tag_label.frame.origin.y+5, 273, 30);
        if([dict objectForKey:@"image_data"]==NULL)
        {
            NSLog(@"IMAGE NULL");
            profile_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
            prof_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
            
        }
        else
        {

            profile_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
            prof_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
            NSLog(@"IMAGE NOt NULL");
            
//            UIImage *image=[UIImage imageWithData:[dict objectForKey:@"image_data"]];
//            image = [UIImage imageWithCGImage:[image CGImage] scale:2.0 orientation:UIImageOrientationUp];
//            profile_pic.image=image;
//            prof_pic.image=[UIImage imageWithData:[dict objectForKey:@"image_data"]];
        }

        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
           
            if (PROFILE_PHOTO_FLAG==1)
            {
                NSLog(@"In profile photo flag");
                PROFILE_PHOTO_FLAG=0;
            }
            else
            {
                [self GET_USER_DATA_NEW];
            }
            
        }
        else
        {
            if([[dict objectForKey:@"follow_count"] intValue]>0)
            {
                follower_counr.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"follow_count"]];
                FOLLOW_LABEL.userInteractionEnabled = YES;
                follower_counr.userInteractionEnabled=YES;
                UITapGestureRecognizer *tapGesture =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FOLLOW_TOUCH:)];
                UITapGestureRecognizer *tapGesture1 =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FOLLOW_TOUCH:)];
                [FOLLOW_LABEL addGestureRecognizer:tapGesture1];
                [follower_counr addGestureRecognizer:tapGesture];
                FOLLOW_COUNT_GREATER=1;
            }
            else
            {
                FOLLOW_COUNT_GREATER=0;
                FOLLOW_LABEL.userInteractionEnabled = NO;
                follower_counr.userInteractionEnabled=NO;

            }
            if([[dict objectForKey:@"msg_count"] intValue]>0)
            {
                message_notification_count.hidden=NO;
                message_notification_count.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"msg_count"]];
               
            }
            if([[dict objectForKey:@"notif_count"] intValue]>0)
            {
                alert_notifiction_count.hidden=NO;
                alert_notifiction_count.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"notif_count"]];
            }
            if([[dict objectForKey:@"like_count"] intValue]>0)
            {
                like_button.hidden=NO;
                like_count.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"like_count"]];
            }
        }
        
        [self GET_COMPLETE_SPORTS_LIST];
    }
}
-(NSAttributedString *)GET_SHADOW_STRING:(NSString *)string_value
{
    NSString *str = [string_value capitalizedString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    UIFont *font =[UIFont fontWithName:@"Roboto-Regular" size:22];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]
                             range:NSMakeRange(0, [attributedString length])];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowBlurRadius:1.0];
    [shadow setShadowOffset:CGSizeMake(2, 2)];
    [attributedString addAttribute:NSShadowAttributeName
                             value:shadow
                             range:NSMakeRange(0, [attributedString length])];
    return attributedString;

}


-(NSAttributedString *)GET_SHADOW_STRING_PLACE:(NSString *)string_value
{
    NSString *str = [string_value capitalizedString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    UIFont *font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]
                             range:NSMakeRange(0, [attributedString length])];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowBlurRadius:1.0];
    [shadow setShadowOffset:CGSizeMake(2, 2)];
    [attributedString addAttribute:NSShadowAttributeName
                             value:shadow
                             range:NSMakeRange(0, [attributedString length])];
    
    return attributedString;
    
}

-(void)GET_USER_DATA
{
   
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
       
        [self showPageLoader];
        
       
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                                 target: self
                                               selector: @selector(cancelURLConnection:)
                                               userInfo: nil
                                                repeats: NO];
        
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
    [param setObject:TOCKEN forKey:@"token"];
    NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/profiledetails?"];
             NSLog(@"URL: %@",url_str);
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
    NSURL *url=[NSURL URLWithString:url_str];
    
    NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError)
                                {
                               if (data==nil || [data isEqual:[NSNull null]])
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       [HUD hide:YES];
                                       [self stopSpin];
                                   });
                               }
                               else
                               {
                               NSDictionary *json =
                               [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:nil];
                               NSInteger status=[[json objectForKey:@"status"] intValue];
                               
                               if(status==1)
                               {
                                   
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               
                                               if([[json objectForKey:@"user_profile"]isEqualToString:@""])
                                               {
                                                   
                                                   profile_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
                                                   prof_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
                                                   imd_data=UIImageJPEGRepresentation(profile_pic.image, 90);
                                                   
                                               }
                                               else
                                               {
                                                   NSString *image_url=[json objectForKey:@"user_profile"];
                                                   NSURL *url=[NSURL URLWithString:image_url];
                                                   imd_data=[[NSData alloc] initWithContentsOfURL:url];
                                                   [profile_pic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pro_pic_no_image.png"]];
                                                   NSLog(@"PROPIC");
//                                                   profile_pic.image=[self imageWithImage:profile_pic.image scaledToMaxWidth:320 maxHeight:150];
                                                   [prof_pic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pro_pic_no_image.png"]];

                                               }
                                               
                                               [name_label setAttributedText:[self GET_SHADOW_STRING:[json objectForKey:@"user_name"]]];
                                               name_label.backgroundColor=[UIColor clearColor];
                                               place_label.backgroundColor=[UIColor clearColor];
                                               [place_label setAttributedText:[self GET_SHADOW_STRING_PLACE:[json objectForKey:@"user_place"]]];
                                               
                                               if ([[json objectForKey:@"search_user_tagline"] isEqualToString:@""])
                                               {
                                                   tag_label.attributedText=[self GET_SHADOW_STRING_PLACE:@"Let's do it!!!"];
                                               }
                                               else
                                               {
                                                   tag_label.attributedText=[self GET_SHADOW_STRING_PLACE:[NSString stringWithFormat:@"%@",[json objectForKey:@"tagline"]]];
                                               }
                                               CGRect beforeFrame = tag_label.frame;
                                               tag_label.numberOfLines=0;
                                               tag_label.lineBreakMode=NSLineBreakByWordWrapping;
                                               [tag_label sizeToFit];
                                               CGRect afterFrame = tag_label.frame;
                                               tag_label.frame = CGRectMake(beforeFrame.origin.x + beforeFrame.size.width - afterFrame.size.width, tag_label.frame.origin.y, tag_label.frame.size.width, tag_label.frame.size.height);
                                               
                                               place_label.frame=CGRectMake(4, tag_label.frame.size.height+tag_label.frame.origin.y+5, 273, 30);
                                               
                                               
                                               if([[json objectForKey:@"user_total_followers_count"] intValue]>0)
                                               {
                                                   NSLog(@"GREATER FOLLOEWER ");
                                                   FOLLOW_COUNT_GREATER=1;
                                                   follower_counr.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"user_total_followers_count"]];
                                                   FOLLOW_LABEL.userInteractionEnabled = YES;
                                                   follower_counr.userInteractionEnabled=YES;
                                                   UITapGestureRecognizer *tapGesture =
                                                   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FOLLOW_TOUCH:)];
                                                   UITapGestureRecognizer *tapGesture1 =
                                                   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FOLLOW_TOUCH:)];
                                                   [FOLLOW_LABEL addGestureRecognizer:tapGesture1];
                                                   [follower_counr addGestureRecognizer:tapGesture];
                                               }
                                               else
                                               {
                                                   FOLLOW_COUNT_GREATER=0;
                                                   FOLLOW_LABEL.userInteractionEnabled = NO;
                                                   follower_counr.userInteractionEnabled=NO;
                                                   
                                               }

                                               if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]] integerValue]>0)
                                               {
                                                   message_notification_count.hidden=NO;
                                                   message_notification_count.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]];
                                               }
                                               if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_new_notification_count"]] integerValue]>0)
                                                   
                                               {
                                                   alert_notifiction_count.hidden=NO;
                                                   alert_notifiction_count.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"user_new_notification_count"]];
                                               }
                                               if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_total_like_count"]] integerValue]>0)
                                               {
                                                   like_button.hidden=NO;
                                                   like_count.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"user_total_like_count"]];
                                               }
                                               
                                               [sqlfunction saveToUserDetailsTable:USER_ID name:[json objectForKey:@"user_name"] age:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_age"]] place:[json objectForKey:@"user_place"] profile_pic:imd_data like_count:[[json objectForKey:@"user_total_like_count"]intValue ] msg_count:[[json objectForKey:@"user_unread_message_count"] intValue] notif_ccount:[[json objectForKey:@"user_new_notification_count"]intValue] follower_count:[[json objectForKey:@"user_total_followers_count"] intValue] latitude:[NSString stringWithFormat:@"%@",[json objectForKey:@"latitude"]] longitude:[NSString stringWithFormat:@"%@",[json objectForKey:@"longitude"]] gender:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_gender"]] tag_line:[NSString stringWithFormat:@"%@",[json objectForKey:@"tagline"]]];
                                               
                                               [sqlfunction delete_sports_list_Feed:USER_ID];
                                               NSMutableArray *user_selected_sports=[json objectForKey:@"user_selected_sports"];
                                               for (int i=0; i<user_selected_sports.count; i++)
                                               {
                                                   [sqlfunction saves_sports_list:USER_ID spots_name:[[user_selected_sports objectAtIndex:i] objectForKey:@"name"] sports_id:[[[user_selected_sports objectAtIndex:i] objectForKey:@"id"] intValue]];
                                               }
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               
                                               [self GET_COMPLETE_SPORTS_LIST];
                                               
                                           });
                                       }

                               else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                       [self presentViewController:view_control animated:YES completion:nil];
                                   });
                               }
                                   
                               else
                               {
                                   [HUD hide:YES];
                                   [self stopSpin];
                               }
                                   
                                   if (connectionError)
                                   {
                                       
                                       NSLog(@"error detected:%@", connectionError.localizedDescription);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [HUD hide:YES];
                                           [self stopSpin];
                                          // [self alertStatus:@"Error in network connection"];
                                          // return ;
                                       });
                                       
                                   }

                               }
                                    

                               
                        }];
             
         });
        
    }
    else
    {
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
    }
    
}

-(void)GET_USER_DATA_NEW
{
   
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        PROFILE_PHOTO ++;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
        [param setObject:TOCKEN forKey:@"token"];
        NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/profiledetails?"];
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSURL *url=[NSURL URLWithString:url_str];
        
        NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *connectionError)
         {
             if (data==nil || [data isEqual:[NSNull null]])
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [HUD hide:YES];
                     [self stopSpin];
                 });
             }
             else
             {
                 NSDictionary *json =
                 [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:nil];
               
                 NSInteger status=[[json objectForKey:@"status"] intValue];
                 
                 if(status==1)
                 {
                     
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 
//                                 if([[json objectForKey:@"user_profile"]isEqualToString:@""])
//                                 {
//                                     
//                                     
//                                     profile_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
//                                     prof_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
//                                    // imd_data=UIImageJPEGRepresentation(profile_pic.image, 90);
//                                     
//                                 }
//                                 else
//                                 {
//                                     NSString *image_url=[json objectForKey:@"user_profile"];
//                                     NSURL *url=[NSURL URLWithString:image_url];
//                                    // imd_data=[[NSData alloc] initWithContentsOfURL:url];
//                                     [profile_pic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pro_pic_no_image.png"]];
//                                     [prof_pic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pro_pic_no_image.png"]];
//                                     
//                                 }

                                 
                                 if([[json objectForKey:@"user_total_followers_count"] intValue]>0)
                                 {
                                     FOLLOW_COUNT_GREATER=1;
                                     follower_counr.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"user_total_followers_count"]];
                                     FOLLOW_LABEL.userInteractionEnabled = YES;
                                     follower_counr.userInteractionEnabled=YES;
                                     UITapGestureRecognizer *tapGesture =
                                     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FOLLOW_TOUCH:)];
                                     UITapGestureRecognizer *tapGesture1 =
                                     [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FOLLOW_TOUCH:)];
                                     [FOLLOW_LABEL addGestureRecognizer:tapGesture1];
                                     [follower_counr addGestureRecognizer:tapGesture];
                                 }
                                 else
                                 {
                                     FOLLOW_COUNT_GREATER=0;
                                     FOLLOW_LABEL.userInteractionEnabled = NO;
                                     follower_counr.userInteractionEnabled=NO;
                                     
                                 }
                                 if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]] integerValue]>0)
                                 {
                                     
                                     message_notification_count.hidden=NO;
                                     message_notification_count.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]];
                                     
                                                                         
                                 }
                                 else if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]] integerValue]==0)
                                 {
                                     message_notification_count.hidden=YES;
                                 }
                                 if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_new_notification_count"]] integerValue]>0)
                                     
                                 {
                                     
                                     alert_notifiction_count.hidden=NO;
                                     alert_notifiction_count.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"user_new_notification_count"]];
                                     
                                 }
                                 else if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_new_notification_count"]] integerValue]==0)
                                 {
                                     alert_notifiction_count.hidden=YES;
                                 }
                                 if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_total_like_count"]] integerValue]>0)
                                 {
                                     like_button.hidden=NO;
                                     like_count.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"user_total_like_count"]];
                                 }
                                 PROFILE_FLAG=0;
                                
                             });
                     
                 }
                 else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                         [self presentViewController:view_control animated:YES completion:nil];
                     });
                 }
                 
                 else
                 {
                    
                 }
                 
             }
             if (connectionError)
             {
                 
                 NSLog(@"error detected:%@", connectionError.localizedDescription);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                 });
                 
             }
             
             
             
         }];
               });
        
    }
    else
    {
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
    }
    
    
}


-(void)GET_PROFILE_UPLOAD
{
    NSLog(@"GET_PF_UPLOAD");
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        NSLog(@"IMG PROF DETAIL FUN");
        networkErrorView.hidden=YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithInt:USER_ID] forKey:@"user_id"];
        [param setObject:TOCKEN forKey:@"token"];
        NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/profiledetails?"];
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSURL *url=[NSURL URLWithString:url_str];
        
        NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        photo_q = [[NSOperationQueue alloc] init];
        photo_q.maxConcurrentOperationCount=1;
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:photo_q
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *connectionError)
         {
             if (data==nil || [data isEqual:[NSNull null]])
             {
                
             }
             else
             {
                 NSDictionary *json =
                 [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:nil];
                 NSInteger status=[[json objectForKey:@"status"] intValue];
                 
                 if(status==1)
                 {
                     PROFILE_PHOTO_FLAG=0;
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         
                         if([[json objectForKey:@"user_profile"]isEqualToString:@""])
                         {
                             
                             
                             profile_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
                             prof_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
                             
                         }
                         else
                         {
                             NSString *image_url=[json objectForKey:@"user_profile"];
                             NSURL *url=[NSURL URLWithString:image_url];
                             [profile_pic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pro_pic_no_image.png"]];
                             [prof_pic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pro_pic_no_image.png"]];
                             
                         }
                         

                     });
                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                          
                          
                          if([[json objectForKey:@"user_profile"]isEqualToString:@""])
                          {
                              
                              
                            
                              imd_data=UIImageJPEGRepresentation(profile_pic.image, 90);
                              
                          }
                          else
                          {
                              NSString *image_url=[json objectForKey:@"user_profile"];
                              NSURL *url=[NSURL URLWithString:image_url];
                              imd_data=[[NSData alloc] initWithContentsOfURL:url];
                              
                              
                          }

                    
                          [sqlfunction UpdateUserDetailsTable:USER_ID profile_pic:imd_data];
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              
                          });
                      });
                     
                     
                 }
                 else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                         [self presentViewController:view_control animated:YES completion:nil];
                     });

                 }
                 
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [HUD hide:YES];
                         [self stopSpin];
                     });

                    
                 }
                 
             }
             if (connectionError)
             {
                 
                 NSLog(@"error detected:%@", connectionError.localizedDescription);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [HUD hide:YES];
                     [self stopSpin];
//                     [self alertStatus:@"Error in network connection"];
//                     return ;
                 });
                 
             }
             
             
             
         }];
              
         });
        
    }
    else
    {
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
    }
    
}




-(void)cancelURLConnection:(id)sender
{
    [HUD hide:YES];
    [self stopSpin];
    [timer invalidate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([[UIScreen mainScreen]bounds].size.height !=568)
    {
        profile_pic.frame=CGRectMake(0, 16, 320, 194);
        bg_image.frame=CGRectMake(0, 259, 320, 172);
//        bg_image.image=[UIImage imageNamed:@"320x172.png"];
//        right_arrow.frame=CGRectMake(164, 309, 32, 32);
//        left_arrow.frame=CGRectMake(129, 348, 32, 32);
//        un_selected_table.frame=CGRectMake(1, 300, 126, 128);
//        favourite_table_view.frame=CGRectMake(191, 300, 128, 128);
        image_gallery_bg_view.frame=CGRectMake(0, 16, 320, 464);
        main_gallery_bg_view.frame=CGRectMake(0, 16, 320, 464);
        collectionview.frame=CGRectMake(0, 99, 320, 370);
        gallery_collection_view.frame=CGRectMake(0, 365, 320, 96);
        scrollview.frame=CGRectMake(7, 55, 306, 300);
        gallery_image_view.frame=CGRectMake(7, 55, 306, 300);
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma TABLEVIEW SECTION

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if(tableView==un_selected_table)
   {
       return Unselected_sports_list.count;
   }
    else if (tableView==favourite_table_view)
    {
        return favourite_sports_list.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CELLIDENTIFIER=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    if (tableView==un_selected_table) {
        cell.textLabel.text=[[Unselected_sports_list objectAtIndex:indexPath.row]objectForKey:@"displayname"];
         cell.textLabel.textAlignment=NSTextAlignmentLeft;
    }
    else if (tableView==favourite_table_view)
    {
        cell.textLabel.text=[[favourite_sports_list objectAtIndex:indexPath.row] objectForKey:@"displayname"];
         cell.textLabel.textAlignment=NSTextAlignmentRight;
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
   
    cell.textLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==favourite_table_view)
    {
        LEFT_FLAG=1;
        favourite_sports_name=[favourite_sports_list objectAtIndex:indexPath.row];
    }
    else if(tableView==un_selected_table)
    {
        RIGHT_FLAG=1;
        unselected_sports_name=[Unselected_sports_list objectAtIndex:indexPath.row];
        NSLog(@"NAME :%@",unselected_sports_name);
    }
}

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==favourite_table_view)
    {
    return YES;
    }
    else
    return NO;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if(tableView==favourite_table_view)
    {
    NSString *stringToMove = favourite_sports_list[sourceIndexPath.row];
    [favourite_sports_list removeObjectAtIndex:sourceIndexPath.row];
    [favourite_sports_list insertObject:stringToMove atIndex:destinationIndexPath.row];
    }
}
- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
 */
///////////// BUTTON ACTIONS /////////////


- (IBAction)BACK_ACTION:(id)sender
{
    image_gallery_bg_view.hidden=YES;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [[image_gallery_bg_view layer] addAnimation:transition forKey:@"SwitchToView1"];
    [[self.view layer] addAnimation:transition forKey:@"SwitchToView1"];
}

- (IBAction)GAllERY_BACK:(id)sender
{
    main_gallery_bg_view.hidden=YES;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [[main_gallery_bg_view layer] addAnimation:transition forKey:@"SwitchToView1"];
    [[image_gallery_bg_view layer] addAnimation:transition forKey:@"SwitchToView1"];
}

- (IBAction)Take_Photo:(id)sender
{
}

- (IBAction)ORDER_BUTTON_ACTION:(UIButton *)sender
{
    
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        [self showPageLoader];
        
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

             
             if (index_array.count>0)
             
             {
                 NSString *id_string=[index_array componentsJoinedByString: @","];
                 
                 if ([id_string isEqualToString:@""])
                 {
                     [sqlfunction search_sports_list_Feed:USER_ID];
                     [HUD hide:YES];
                     [self stopSpin];
                     order_button.hidden=YES;
                     [self alertStatus:@"favourite sports list should not be empty"];
                     return;
                 }
                 else
                 {
                     NSMutableDictionary *param = [NSMutableDictionary dictionary];
                     [param setObject:TOCKEN forKey:@"token"];
                     [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                     [param setObject:id_string forKey:@"sports"];
                     
                     NSLog(@"Param is :%@",param);
                     NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/updateusersports?"];
                     
                     NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
                     NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                     
                     NSURL *url=[NSURL URLWithString:url_str];
                     
                     
                     NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                     
                     NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
                     
                     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                     [request setURL:url];
                     [request setHTTPMethod:@"POST"];
                     [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                     [request setHTTPBody:postData];
                     [NSURLConnection sendAsynchronousRequest:request
                                                        queue:[NSOperationQueue mainQueue]
                                            completionHandler:^(NSURLResponse *response,
                                                                NSData *data,
                                                                NSError *connectionError) {
                                                if (data==nil || [data isEqual:[NSNull null]])
                                                {
                                                    [HUD hide:YES];
                                                    [self stopSpin];
                                                }
                                                else
                                                {
                                                    
                                                    
                                                    NSDictionary *json =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:nil];
                                                  
                                                    
                                                    NSInteger status=[[json objectForKey:@"status"] intValue];
                                                    
                                                    if(status==1)
                                                    {
                                                        //                                               [sqlfunction delete_sports_list_Feed:USER_ID];
                                                        //
                                                        //                                               for (int i=0; i<favourite_sports_list.count; i++)
                                                        //                                               {
                                                        //                                                   [sqlfunction saves_sports_list:USER_ID spots_name:[[favourite_sports_list objectAtIndex:i] objectForKey:@"displayname"] sports_id:[[[favourite_sports_list objectAtIndex:i] objectForKey:@"sports_id"]intValue]];
                                                        //                                               }
                                                        //
                                                        //                                               [sqlfunction search_sports_list_Feed:USER_ID];
                                                        
                                                        [HUD hide:YES];
                                                        [self stopSpin];
                                                    }
                                                    else if ([[json objectForKey:@"message"] isEqualToString:@"No sports"])
                                                    {
                                                        
                                                        //                                               [sqlfunction search_sports_list_Feed:USER_ID];
                                                        //                                                favourite_sports_list=sqlfunction.sports_array;
                                                        //                                                [favourite_table_view reloadData];
                                                        [HUD hide:YES];
                                                        [self stopSpin];
                                                        order_button.hidden=YES;
                                                        [self alertStatus:@"Favourite sports list should not be empty"];
                                                        return;
                                                        
                                                    }
                                                    else
                                                    {
                                                        [HUD hide:YES];
                                                        [self stopSpin];
                                                    }
                                                }
                                                if (connectionError)
                                                {
                                                    
                                                    NSLog(@"error detected:%@", connectionError.localizedDescription);
                                                    [HUD hide:YES];
                                                    [self stopSpin];
                                                  //  [self alertStatus:@"Error in network connection"];
                                                    return ;
                                                    
                                                }
                                                
                                            }];
                     
                 }

             }
           
         });
       }
    else
    {
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
    }
  
    
}
-(void)FOLLOW_TOUCH:(id)sender
{
    [self ORDER_BUTTON_ACTION:nil];
    FOLLOW_FLAG=1;
   [self performSegueWithIdentifier:@"PROFILE_FOLLOWER" sender:self];
}
- (IBAction)FOLLOWERS_LIST:(id)sender
{
    [self ORDER_BUTTON_ACTION:nil];
    if (FOLLOW_COUNT_GREATER==1)
    {
        FOLLOW_FLAG=1;
        [self performSegueWithIdentifier:@"PROFILE_FOLLOWER" sender:self];
    }
   
}

- (IBAction)MESSAGES_LIST:(id)sender
{
    [self ORDER_BUTTON_ACTION:nil];
   [self performSegueWithIdentifier:@"PROFILE_TO_MESSAGE" sender:self];
}

- (IBAction)GET_NOTIFICATIONS:(id)sender
{
    [self ORDER_BUTTON_ACTION:nil];
    [self performSegueWithIdentifier:@"PROFILE_TO_NOTIFICATION" sender:self];
}

- (IBAction)GET_PHOTOS:(id)sender
{
    [self ORDER_BUTTON_ACTION:nil];
    image_gallery_bg_view.hidden=NO;
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
//        if (IMAGE_UPLOAD_FLAG==1)
//        {
//            NSLog(@"image upload flag");
//        }
//        else
//        {
        NSLog(@"GET_PHOTOS START");
        [HUD hide:YES];
        [self stopSpin];
        [self showPageLoader];
        if ([[UIScreen mainScreen]bounds].size.height !=568)
        {
            t_view.frame=CGRectMake(0, 60, 320, 420);
        }
        else
        {
            t_view.frame=CGRectMake(0, 60, 320, 508);
        }
       // }
        photo_timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                 target: self
                                               selector: @selector(cancelURLConnection_photo:)
                                               userInfo: nil
                                                repeats: NO];
        
        

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:TOCKEN forKey:@"token"];
    [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
   
    
    NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/getphotos?"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:url_str];
    
    
    NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount=1;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               if (data==nil || [data isEqual:[NSNull null]])
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   [HUD hide:YES];
                                   [self stopSpin];
                               });                               }
                               else
                               {
                               NSDictionary *json =
                               [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:nil];
                                   
                               NSInteger status=[[json objectForKey:@"status"] intValue];
                               
                               if(status==1)
                               {
                                 NSMutableArray *image_temp_array=[json objectForKey:@"results"];
                                  
                                   image_array=[[[image_temp_array reverseObjectEnumerator] allObjects] mutableCopy];
                                   //image_array=[json objectForKey:@"results"];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                       collectionview.hidden=NO;
                                       empty_photo_label.hidden=YES;
                                       [collectionview reloadData];
                                       [HUD hide:YES];
                                       [self stopSpin];

                                   });
                                   
                               }
                               else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                               {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       collectionview.hidden=YES;
                                       empty_photo_label.hidden=NO;
                                       [HUD hide:YES];
                                       [self stopSpin];
                                       
                                   });

                                   [HUD hide:YES];
                                   [self stopSpin];
                                   
                               }
                                  
                               else
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [HUD hide:YES];
                                           [self stopSpin];
                                       });

                                   }
                               }
                               if (connectionError)
                               {
                                   
                                   NSLog(@"error detected:%@", connectionError.localizedDescription);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [HUD hide:YES];
                                       [self stopSpin];
                                      //  [self alertStatus:@"Error in network connection"];
                                       return ;
                                   });
                                   
                               }
                               

                           }];
        if (IMAGE_UPLOAD_FLAG==1)
        {
            IMAGE_UPLOAD_FLAG=0;
        }
        else
        {
        [UIView animateWithDuration:0.3 animations:^() {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [[self.view layer] addAnimation:transition forKey:@"SwitchToView1"];
        [[image_gallery_bg_view layer] addAnimation:transition forKey:@"SwitchToView1"];
        
    }];
            }
    }
    else
    {
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
        
    }
}

- (void) alertStatus:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

-(void)cancelURLConnection_photo:(id)sender
{
    [queue cancelAllOperations];
    [HUD hide:YES];
    [self stopSpin];
    [photo_timer invalidate];
}


#pragma PROFILE_PHOTO_EDIT

- (IBAction)PROFILE_EDIT:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing",@"Edit your tagline", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
            break;
            case 2:
        {
            backgroundview=[[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
            [self.view addSubview:backgroundview];
            [self.view addSubview:tagline_view];
            tagline_view.hidden=NO;
            tag_edit_text.text=tag_label.text;
            [tag_edit_text becomeFirstResponder];
        }
            break;
            default:
            break;
            
    }
}
- (void)takeNewPhotoFromCamera
{
        UIImagePickerController *imgpicker=[[UIImagePickerController alloc]init];
        imgpicker.delegate=self;
        imgpicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        imgpicker.allowsEditing=YES;
        imgpicker.navigationController.navigationBar.translucent = NO;
        imgpicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                             UIImagePickerControllerSourceTypeCamera];
       // imgpicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:imgpicker animated:YES completion:nil];

        
}
-(void)choosePhotoFromExistingImages
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.navigationController.navigationBar.translucent = NO;
    //   [inbox_bg_view addSubview:picker.view];
    
    [self presentViewController:picker animated:YES completion:nil];
    
  }



- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)img
                  editingInfo:(NSDictionary *)editingInfo
{
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
           
    networkErrorView.hidden=YES;
    PROFILE_PHOTO_FLAG=1;
    [picker dismissViewControllerAnimated:NO completion:nil];
    NSString    *currentTime;
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    currentTime = [formatter stringFromDate:[NSDate date]];
    currentTime=[currentTime stringByAppendingString:@".jpg"];
    NSData *imageData1 = UIImageJPEGRepresentation(img, 90);
    NSString *base64Encoded = [imageData1 base64EncodedStringWithOptions:0];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
    [param setObject:TOCKEN forKey:@"token"];
    [param setObject:currentTime forKey:@"image_name"];
    [param setObject:base64Encoded forKey:@"user_profile"];
    [param setObject:@"" forKey:@"userCroppedProfile"];
    NSString *urlString = [[connectobj value] stringByAppendingString:@"apiservices/uploadprofilepicture?"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@""
                                                      parameters:param];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
            
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
             {
                 
                 progress_view.hidden=NO;
                 pgress_bg.layer.cornerRadius=6.0;
                 progress_bar.popUpViewCornerRadius = 12.0;
                 progress_bar.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:28];
                 [progress_bar showPopUpViewAnimated:YES];
                 float prog = (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 100);
                 if (prog<=100)
                 {
                     progress_bar.hidden=NO;
                     [progress_bar setProgress:prog/100];
                 }
      //  NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
             }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        progress_view.hidden=YES;
        progress_bar.progress=0.0;
        
        if (responseObject==nil || [responseObject isEqual:[NSNull null]])
            
        {
            
            [HUD hide:YES];
            [self stopSpin];
        }
        
        else
            
        {
            NSDictionary *json1 =  [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];;
            NSLog(@"JSON Response %@",json1);
        
            
            NSInteger status=[[json1 objectForKey:@"status"] intValue];
        
            
            if(status==1)
                
            {
                
                    NSLog(@"Upload success");
                    
                    profile_pic.image=img;
                    prof_pic.image=img;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [sqlfunction UpdateUserDetailsTable:USER_ID profile_pic:imageData1];
                    });
        }
            
        }
        
    NSLog(@"Responsehh: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    }
     
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
            [operation start];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)ARROW_RIGHTACTION:(id)sender
{
    if(RIGHT_FLAG==1)
    {
        order_button.hidden=NO;
        star_image.frame=CGRectMake(225, 261, 36, 36);
    [Unselected_sports_list removeObject:unselected_sports_name];
    [un_selected_table reloadData];
    [favourite_sports_list addObject:unselected_sports_name];
    NSArray *insertIndexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:favourite_sports_list.count-1 inSection:0]];
        [favourite_table_view insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
        
        RIGHT_FLAG=0;
    }
    else
    {
        NSLog(@"NO RIGHT");
    }
  
}

- (IBAction)ARROW_LEFT_ACTION:(id)sender
{
    if(LEFT_FLAG==1)
    {
        
    order_button.hidden=NO;
    star_image.frame=CGRectMake(225, 261, 36, 36);
    [favourite_sports_list removeObject:favourite_sports_name];
    [favourite_table_view reloadData];
    [Unselected_sports_list addObject:favourite_sports_name];
    NSArray *insertIndexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:Unselected_sports_list.count-1 inSection:0]];
    [un_selected_table insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    LEFT_FLAG=0;
    }
   
}

#pragma Collection View Functions

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==sports_collection_view)
    {
        return combined_sports_array.count;
    }
    else
    return image_array.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath  *)indexPath{
    static NSString  *identifier = @"CELL";
    if(collectionView==collectionview)
    {
        
        SportsCell *cell = (SportsCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        //cell.backgroundColor=[style colorWithHexString:terms_of_services_color];
        cell.prof_images.contentMode=UIViewContentModeScaleAspectFill;
        NSString *imurl=[[image_array objectAtIndex:indexPath.row]objectForKey:@"photo"];
        if([imurl isEqual:[NSNull null]])
        {
            [cell.prof_images setImage:[UIImage imageNamed:@"no_im_feed.png"]];
        }
        else
        {
            
            
            
            NSURL *urlv = [NSURL URLWithString:imurl];
            [cell.prof_images setImageWithURL:urlv placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
            
        }
        
       

        return cell;
    }
    else if (collectionView==sports_collection_view)
    {
        
        NSLog(@"COLLECTION IMAGE VIEW : %@",[[combined_sports_array objectAtIndex:indexPath.row]objectForKey:@"image"]);
        
        
        static NSString  *identifier = @"CELL";
        SportsCell *cell = (SportsCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.layer.borderWidth=1.0;
        cell.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.backgroundColor=[style colorWithHexString:terms_of_services_color];
        
        CATransform3D rotation = CATransform3DMakeRotation( (90.0*M_PI)/90, .0, 0.5, 0.5);
        cell.contentView.alpha = 0.8;
        cell.contentView.layer.transform = rotation;
        cell.contentView.layer.anchorPoint = CGPointMake(0, 0.5);
        
        [UIView animateWithDuration:.5
                         animations:^{
                             cell.contentView.layer.transform = CATransform3DIdentity;
                             cell.contentView.alpha = 1;
                             cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
                         } completion:^(BOOL finished) {
                         }];
        

       cell.layer.cornerRadius=8.0;
       cell.layer.masksToBounds=YES;
        
        NSString *image_url=[connectobj image_value];
        image_url=[image_url stringByAppendingString:[[combined_sports_array objectAtIndex:indexPath.row]objectForKey:@"image"]];
        NSURL *url1=[NSURL URLWithString:image_url];
        [cell.sport_image setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"no_im_feed.png"]];
        
        if ([[[combined_sports_array objectAtIndex:indexPath.row]objectForKey:@"flag"]isEqualToString:@"1"])
        {
             cell.layer.backgroundColor = [style colorWithHexString:terms_of_services_color].CGColor;
            
            
            [UIView animateWithDuration:2.0 animations:^{
               cell.layer.backgroundColor=[style colorWithHexString:favourite_sports_selected_color].CGColor;
            } completion:NULL];
           
        }
        
        cell.sports_name_label.text=[[combined_sports_array objectAtIndex:indexPath.row]objectForKey:@"name"];
        return cell;

    }
 else
    {

        
        SportsCell *cell = (SportsCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        NSString *imurl=[[image_array objectAtIndex:indexPath.row]objectForKey:@"photo"];
         cell.prof_images.contentMode=UIViewContentModeScaleAspectFill;
        if([imurl isEqual:[NSNull null]])
        {
            [cell.prof_images setImage:[UIImage imageNamed:@"no_im_feed.png"]];
        }
        else
        {
            
                
            
                NSURL *urlv = [NSURL URLWithString:imurl];
                [cell.prof_images setImageWithURL:urlv placeholderImage:[UIImage imageNamed:@"no_im_feed.png"]];
                
        }

        //cell.backgroundColor=[style colorWithHexString:terms_of_services_color];
       // cell.prof_images.image=[image_array objectAtIndex:indexPath.row];
        cell.prof_images.layer.cornerRadius=4.0;
        cell.prof_images.layer.masksToBounds=YES;
        cell.prof_images.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.prof_images.layer.borderWidth=2.0;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (collectionView==collectionview)
    {
        main_gallery_bg_view.hidden=NO;
        [gallery_collection_view reloadData];
        [UIView animateWithDuration:0.3 animations:^() {
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [[self.view layer] addAnimation:transition forKey:@"SwitchToView1"];
            [[main_gallery_bg_view layer] addAnimation:transition forKey:@"SwitchToView1"];
             [gallery_collection_view scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

        }];
        
        NSString *imurl=[[image_array objectAtIndex:indexPath.row]objectForKey:@"photo"];
        if([imurl isEqual:[NSNull null]])
        {
            [gallery_image_view setImage:[UIImage imageNamed:@"no_im_feed.png"]];
        }
        else
        {
            NSURL *urlv = [NSURL URLWithString:imurl];
            [gallery_image_view setImageWithURL:urlv placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
            
        }
        
    }
    
  else if (collectionView==sports_collection_view)
    {
        
        
        SportsCell *cell = (SportsCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor=[style colorWithHexString:favourite_sports_selected_color];
        cell.prof_images.hidden=NO;
        NSString *selected_index=[[combined_sports_array objectAtIndex:indexPath.row]objectForKey:@"id"];
        
        NSInteger selected_id=[[[combined_sports_array objectAtIndex:indexPath.row]objectForKey:@"id"]integerValue];
        
        if(index_array.count>0)
        {
            if([index_array containsObject:selected_index])
            {
                if (index_array.count==1)
                {
                    [self alertStatus:@"favourite sports list should not be empty"];
                    return;
                }
                else
                {

               
                cell.layer.backgroundColor = [style colorWithHexString:favourite_sports_selected_color].CGColor;
                
                [UIView animateWithDuration:2.0 animations:^{
                    cell.layer.backgroundColor=[UIColor clearColor].CGColor;
                } completion:NULL];
                
                
               // cell.backgroundColor=[UIColor clearColor];
                cell.prof_images.hidden=YES;
                [index_array removeObject:selected_index];
                [combined_sports_array mutableCopy];
                dict_raw=[[NSMutableDictionary alloc]init];
                dict_raw=[[combined_sports_array objectAtIndex:indexPath.row]mutableCopy];
                [dict_raw setObject:@"0" forKey:@"flag"];
                [combined_sports_array replaceObjectAtIndex:indexPath.row withObject:dict_raw];
                CATransform3D rotation = CATransform3DMakeRotation( (90.0*M_PI)/90, .0, 0.5, 0.5);
                cell.contentView.alpha = 0.8;
                cell.contentView.layer.transform = rotation;
                cell.contentView.layer.anchorPoint = CGPointMake(0.5, 0);
                
                [UIView animateWithDuration:.5
                                 animations:^{
                                     cell.contentView.layer.transform = CATransform3DIdentity;
                                     cell.contentView.alpha = 1;
                                     cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
                                 } completion:^(BOOL finished) {
                                 }];
                [sqlfunction delete_selected_sports:selected_id userid:USER_ID];
                }  //[selected_sports_array removeObject:[complete_sports_list objectAtIndex:indexPath.row]];
            }
            else
            {
                cell.layer.backgroundColor = [style colorWithHexString:terms_of_services_color].CGColor;
                
                [UIView animateWithDuration:2.0 animations:^{
                    cell.layer.backgroundColor=[style colorWithHexString:favourite_sports_selected_color].CGColor;
                } completion:NULL];
                cell.prof_images.hidden=NO;
                [index_array addObject:selected_index];
                dict_raw_1=[[NSMutableDictionary alloc]init];
                dict_raw_1=[[combined_sports_array objectAtIndex:indexPath.row]mutableCopy];
                [dict_raw_1 setObject:@"1" forKey:@"flag"];
                [combined_sports_array replaceObjectAtIndex:indexPath.row withObject:dict_raw_1];
                
                CATransform3D rotation = CATransform3DMakeRotation( (90.0*M_PI)/90, .0, 0.5, 0.5);
                cell.contentView.alpha = 0.8;
                cell.contentView.layer.transform = rotation;
                cell.contentView.layer.anchorPoint = CGPointMake(0, 0.5);
                
                [UIView animateWithDuration:.5
                                 animations:^{
                                     cell.contentView.layer.transform = CATransform3DIdentity;
                                     cell.contentView.alpha = 1;
                                     cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
                                 } completion:^(BOOL finished) {
                                 }];
 [sqlfunction saves_sports_list:USER_ID spots_name:[[combined_sports_array objectAtIndex:indexPath.row]objectForKey:@"name"] sports_id:selected_id];
                //[selected_sports_array addObject:[complete_sports_list objectAtIndex:indexPath.row]];
            }
                    }
        else
        {
            [index_array addObject:selected_index];
           dict_raw_2=[[NSMutableDictionary alloc]init];
            dict_raw_2=[[combined_sports_array objectAtIndex:indexPath.row]mutableCopy];
            [dict_raw_2 setObject:@"1" forKey:@"flag"];
            [combined_sports_array replaceObjectAtIndex:indexPath.row withObject:dict_raw_2];
            CATransform3D rotation = CATransform3DMakeRotation( (90.0*M_PI)/90, .0, 0.5, 0.5);
            cell.contentView.alpha = 0.8;
            cell.contentView.layer.transform = rotation;
            cell.contentView.layer.anchorPoint = CGPointMake(0, 0.5);
            [UIView animateWithDuration:.5
                             animations:^{
                                 cell.contentView.layer.transform = CATransform3DIdentity;
                                 cell.contentView.alpha = 1;
                                 cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
                             } completion:^(BOOL finished) {
                             }];
[sqlfunction saves_sports_list:USER_ID spots_name:[[combined_sports_array objectAtIndex:indexPath.row]objectForKey:@"name"] sports_id:selected_id];
            // [selected_sports_array addObject:[complete_sports_list objectAtIndex:indexPath.row]];
            
        }
    }
    
    else
    {
        NSString *imurl=[[image_array objectAtIndex:indexPath.row]objectForKey:@"photo"];
        if([imurl isEqual:[NSNull null]])
        {
            [gallery_image_view setImage:[UIImage imageNamed:@"no_im_feed.png"]];
        }
        else
        {
            NSURL *urlv = [NSURL URLWithString:imurl];
            [gallery_image_view setImageWithURL:urlv placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
            
        }

    }
    
   
  
    
}

////////// IMAGE Auto SIZE ////////



//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(collectionView==collectionview)
//    {
//    UIImage *image;
//    
//    image =[image_array objectAtIndex:indexPath.row];
//    
//    return image.size;
//    }
//    else
//    return;
//}


#pragma TABBAR FUNCTION


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
        [self ORDER_BUTTON_ACTION:nil];
        [user_timer invalidate];
        user_timer=nil;
    
    switch (item.tag) {
        case 0:
        {
            [user_timer invalidate];
            [self performSegueWithIdentifier:@"PROFILE_FEED" sender:self];
        }

            break;
        case 1:
            
            break;
        case 2:
        {
            [user_timer invalidate];
            [self performSegueWithIdentifier:@"PROFILE_SEARCH" sender:self];
        }
            break;
        case 3:
        {
                [user_timer invalidate];
                 [self performSegueWithIdentifier:@"PROFILE_FOLLOWER" sender:self];
        }
            
            break;
        case 4:
        {
            [user_timer invalidate];
            [self performSegueWithIdentifier:@"PROFILE_SETTINGS" sender:self];
        }
            break;
            
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PROFILE_FEED"])
    {
        FeedViewController *feedcontrol=segue.destinationViewController;
        feedcontrol.TOCKEN=TOCKEN;
        feedcontrol.USER_ID=USER_ID;
    }
    else if ([segue.identifier isEqualToString:@"PROFILE_TO_MESSAGE"])
    {
        MessageViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOKEN=TOCKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"PROFILE_SEARCH"])
    {
        SearchViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOKEN=TOCKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"PROFILE_FOLLOWER"])
    {
        FollowerViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOKEN=TOCKEN;
        
        if (FOLLOW_FLAG==1)
        {
            msgcontrol.PROFILE_FLAG=1;
        }
        
        
    }
    else if ([segue.identifier isEqualToString:@"PROFILE_SETTINGS"])
    {
        SettingViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOCKEN=TOCKEN;
        
    } else if ([segue.identifier isEqualToString:@"PROFILE_TO_NOTIFICATION"])
    {
        NotificationViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOKEN=TOCKEN;
        
    }
}


////////////// LOADER//////////////////

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}
- (void) startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}
- (void) stopSpin
{
    [t_view removeFromSuperview];
    [t_view_1 removeFromSuperview];
    [imageView removeFromSuperview];
    [imageView stopAnimating];
}

-(void)showPageLoader
{
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 430)];
    }
    else
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 518)];
    }
    t_view.backgroundColor=[UIColor blackColor];
    t_view.alpha=.4;
    t_view.hidden=NO;
    [self.view addSubview:t_view];
    
    t_view_1=[[UIView alloc]initWithFrame:CGRectMake(110, 209, 100, 100)];
    t_view_1.layer.cornerRadius=4.0;
    t_view_1.clipsToBounds=YES;
    t_view_1.backgroundColor=[UIColor blackColor];
    t_view_1.alpha=.5;
    [self.view addSubview:t_view_1];
    
    imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(110, 209, 100, 100) ];
    [self.view addSubview:imageView];
    imageView.animationImages = [[NSArray alloc] initWithObjects:
                                 [UIImage imageNamed:@"1.png"],
                                 [UIImage imageNamed:@"2.png"],
                                 [UIImage imageNamed:@"3.png"],
                                 [UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"5.png"],[UIImage imageNamed:@"6.png"],[UIImage imageNamed:@"7.png"],[UIImage imageNamed:@"8.png"],[UIImage imageNamed:@"9.png"],[UIImage imageNamed:@"10.png"],[UIImage imageNamed:@"11.png"],[UIImage imageNamed:@"12.png"],[UIImage imageNamed:@"13.png"],[UIImage imageNamed:@"14.png"],[UIImage imageNamed:@"15.png"],[UIImage imageNamed:@"16.png"],[UIImage imageNamed:@"17.png"],[UIImage imageNamed:@"18.png"],[UIImage imageNamed:@"19.png"],
                                 nil];
    imageView.animationDuration=5;
    [imageView startAnimating];
    
    
}

-(void)showPageLoader_im_upload
{
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 430)];
    }
    else
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 518)];
    }
    t_view.backgroundColor=[UIColor blackColor];
    t_view.alpha=.2;
    t_view.hidden=NO;
    [self.view addSubview:t_view];
    
    t_view_1=[[UIView alloc]initWithFrame:CGRectMake(110, 209, 100, 100)];
    t_view_1.layer.cornerRadius=4.0;
    t_view_1.clipsToBounds=YES;
    t_view_1.backgroundColor=[UIColor blackColor];
    t_view_1.alpha=.4;
    [self.view addSubview:t_view_1];
    
    imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(110, 209, 100, 100) ];
    [self.view addSubview:imageView];
    imageView.animationImages = [[NSArray alloc] initWithObjects:
                                 [UIImage imageNamed:@"1.png"],
                                 [UIImage imageNamed:@"2.png"],
                                 [UIImage imageNamed:@"3.png"],
                                 [UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"5.png"],[UIImage imageNamed:@"6.png"],[UIImage imageNamed:@"7.png"],[UIImage imageNamed:@"8.png"],[UIImage imageNamed:@"9.png"],[UIImage imageNamed:@"10.png"],[UIImage imageNamed:@"11.png"],[UIImage imageNamed:@"12.png"],[UIImage imageNamed:@"13.png"],[UIImage imageNamed:@"14.png"],[UIImage imageNamed:@"15.png"],[UIImage imageNamed:@"16.png"],[UIImage imageNamed:@"17.png"],[UIImage imageNamed:@"18.png"],[UIImage imageNamed:@"19.png"],
                                 nil];
    imageView.animationDuration=5;
    [imageView startAnimating];
    
}



-(void) refreshNetworkStatus:(NSTimer*)time
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
    }
    else
    {
        NSLog(@"NONET");
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
    }
}


#pragma PROFILE PHOTOS
- (IBAction)TAG_CANCEL:(id)sender
{
    [backgroundview removeFromSuperview];
    tagline_view.hidden=YES;
    [tag_edit_text resignFirstResponder];
}

- (IBAction)TAG_SAVE:(id)sender
{
    NSString *rawString = [tag_edit_text text];
    NSLog(@"TExt len:%d",[rawString length]);
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([tag_edit_text.text isEqualToString:@"Write something about you..."] || [tag_edit_text.text isEqualToString:@""] || [trimmed length]==0 )
    {
        [self alertStatus:@"Tagline field should not be empty"];
        return;
    }
    if([rawString length] > 100)
    {
        [self alertStatus:@"Tagline should not be exceed 100 characters"];
        return;
    }
    else
    {
        
        [backgroundview removeFromSuperview];
        tagline_view.hidden=YES;
        [tag_edit_text resignFirstResponder];
        [self tag_line];
    }

}

- (IBAction)GET_GALLERY:(id)sender
{
    [self GET_PHOTOS:nil];
}

- (IBAction)SELECT_PHOTO:(id)sender
{
    
    self.assets = [[NSMutableArray alloc] init];
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allPhotos];
    picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    picker.delegate             = self;
    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
    
    // iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.popover.delegate = self;
        [self.popover presentPopoverFromBarButtonItem:sender
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    }
    else
    {
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover = nil;
}


#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (self.popover != nil)
        [self.popover dismissPopoverAnimated:YES];
    else
       
    
    self.assets = [NSMutableArray arrayWithArray:assets];
    [self image_upload];
        IMAGE_UPLOAD_FLAG=1;
     [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)image_upload
{
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        im_name=[[NSMutableArray alloc]init];
        // NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath: moviepath]];
        NSString *urlString = [[connectobj value]stringByAppendingString:@"apiservices/feedpost?"];
        NSURL* url = [NSURL URLWithString:urlString];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                        {
                                            
                                            NSString *param3 = [NSString stringWithFormat:@"%@",TOCKEN];
                                            
                                            [formData appendPartWithFormData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
                                            
                                            
                                            NSString *param4 = [NSString stringWithFormat:@"%d",USER_ID];
                                            
                                            [formData appendPartWithFormData:[[NSString stringWithString:param4] dataUsingEncoding:NSUTF8StringEncoding] name:@"user_id"];
                                            
                                            
                                            NSString *param5 = [NSString stringWithFormat:@"image"];
                                            
                                            [formData appendPartWithFormData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
                                            
                                            [formData appendPartWithFormData:[@"dddd" dataUsingEncoding:NSUTF8StringEncoding] name:@"location"];
                                            
                                            [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"text_message"];
                                            
                                            [formData appendPartWithFormData:[@"0" dataUsingEncoding:NSUTF8StringEncoding] name:@"video_id"];
                                            
                                            for(int i=0;i<self.assets.count;i++)
                                            {
                                                ALAsset *asset = [self.assets objectAtIndex:i];
                                                NSString *image_str=[@"image" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
                                                NSLog(@"ISTR :%@",image_str);
                                                [im_name addObject:image_str];
                                                NSData *imageData = UIImageJPEGRepresentation( [UIImage imageWithCGImage:asset.aspectRatioThumbnail], 90);
                                                [formData appendPartWithFileData:imageData name:image_str fileName:@"image.png" mimeType:@"image/png"];
                                            }
                                            NSString *new_string=[im_name componentsJoinedByString:@","];
                                            NSString *param9 = [NSString stringWithFormat:@"%@",new_string];
                                            
                                            [formData appendPartWithFormData:[[NSString stringWithString:param9] dataUsingEncoding:NSUTF8StringEncoding] name:@"image_file"];
                                            
                                            
                                            
                                        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
         
         {
          //   NSLog(@"UPLOSSS:");
             progress_view.hidden=NO;
             pgress_bg.layer.cornerRadius=6.0;
             progress_bar.popUpViewCornerRadius = 12.0;
             progress_bar.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:28];
             [progress_bar showPopUpViewAnimated:YES];
             float prog = (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 100);
             if (prog<=100)
             {
                 progress_bar.hidden=NO;
                 [progress_bar setProgress:prog/100];
             }
             
            // NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
         }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         
         {
             
             if (responseObject==nil || [responseObject isEqual:[NSNull null]])
                 
             {
                 
                 progress_view.hidden=YES;
                 
                 progress_bar.progress=0.0;
                 
                 [HUD hide:YES];
                 
                 [self stopSpin];
             }
             
             else
                 
             {
                 
                 NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];;
                 NSLog(@"JSON Response %@",json);
                 
                 if ([[json objectForKey:@"status"] integerValue]==1)
                     
                 {
                     progress_view.hidden=YES;
                     progress_bar.progress=0.0;
                     [HUD hide:YES];
                     [self stopSpin];
                     IMAGE_UPLOAD_FLAG=1;
                     [self GET_PHOTOS:nil];
                     
                     
                   
                 }
                 
                 else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"
                          
                          ])
                     
                 {
                     progress_view.hidden=YES;
                     progress_bar.progress=0.0;
                     ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                     [self presentViewController:view_control animated:YES completion:nil];
                 }
                 
                 else
                     
                 {
                     progress_view.hidden=YES;
                     progress_bar.progress=0.0;
                     [self alertStatus:[json objectForKey:@"message"]];
                     return ;
                 }
                 
                 
             }
         }
         
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
             progress_view.hidden=YES;
             
             progress_bar.progress=0.0;
             
             [self alertStatus:operation.responseString];
             
             return ;
             
             NSLog(@"error: %@",  operation.responseString);
             
         }
         ];
        
        [operation start];
        
    }
    else
    {
        
    }
    
}


//-(void)image_upload
//{
//    BOOL netStatus = [connectobj checkNetwork];
//    if(netStatus == true)
//    {
//        NSLog(@"Gallery image upload");
//        [HUD removeFromSuperview];
//        [imageView removeFromSuperview];
//        [HUD hide:YES];
//        [self stopSpin];
//        [self showPageLoader];
//        if ([[UIScreen mainScreen]bounds].size.height !=568)
//        {
//            t_view.frame=CGRectMake(0, 60, 320, 420);
//        }
//        else
//        {
//            t_view.frame=CGRectMake(0, 60, 320, 508);
//        }
//
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        im_name=[[NSMutableArray alloc]init];
//        
//        NSString *urlString1 =[ [connectobj value] stringByAppendingString:@"apiservices/feedpost?"];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:[NSURL URLWithString:urlString1]];
//        [request setHTTPMethod:@"POST"];
//        NSMutableData *body = [NSMutableData data];
//        NSString *boundary = @"---------------------------14737809831466499882746641449";
//        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//        
//        // Another text parameter
//        NSString *param3 = [NSString stringWithFormat:@"%@",TOCKEN];
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        // Another text parameter
//        NSString *param4 = [NSString stringWithFormat:@"%d",USER_ID];
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:param4] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        
//        
//        // Another text parameter
//        NSString *param5 = [NSString stringWithFormat:@"image"];
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        
//        
//        // Another text parameter
//        NSString *param6 = [NSString stringWithFormat:@"%@",@"Kaloor"];
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:param6] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        
//        
//        // Another text parameter
//        NSString *param7 = [NSString stringWithFormat:@"0"];
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:param7] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        // Another text parameter
//        NSString *param8 = @"";
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"text_message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:param8] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        
//           
//            NSLog(@"Image appending completed");
//        for(int i=0;i<self.assets.count;i++)
//        {
//            ALAsset *asset = [self.assets objectAtIndex:i];
//            
//            NSString *image_str=[@"image" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
//            [im_name addObject:image_str];
//            NSData *imageData = UIImageJPEGRepresentation( [UIImage imageWithCGImage:asset.aspectRatioThumbnail], 90);
//            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@\"; filename=\".jpeg\"\r\n",image_str] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[NSData dataWithData:imageData]];
//            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            
//        }
//        NSString *new_string=[im_name componentsJoinedByString:@","];
//        NSString *param9 = [NSString stringWithFormat:@"%@",new_string];
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_file\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:param9] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        // set request body
//        [request setHTTPBody:body];
//        //
//        NSOperationQueue *image_queue = [[NSOperationQueue alloc] init];
//        image_queue.maxConcurrentOperationCount=1;
//        
//
//        [NSURLConnection sendAsynchronousRequest:request
//                                           queue:image_queue
//                               completionHandler:^(NSURLResponse *response,
//                                                   NSData *data,
//                                                   NSError *connectionError) {
//                                     NSLog(@"Image appending send");
//                                   NSLog(@"RESS: %@",response);
//                                   
//                                  
//                                   if (data==nil || [data isEqual:[NSNull null]])
//                                   {
//                                       NSLog(@"Data parameter is nillllll");
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//
//                                       [HUD hide:YES];
//                                       [self stopSpin];
//                                       });
//                                   }
//                                   else
//                                   {
//                                       NSDictionary *json =
//                                       [NSJSONSerialization JSONObjectWithData:data
//                                                                       options:kNilOptions
//                                                                         error:nil];
//                                   NSLog(@"RESSsss: %@",json);
//                                   
//                                   if ([[json objectForKey:@"status"] integerValue]==1)
//                                   {
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//
//                                       NSLog(@"Image upload succccccccc");
//                                       IMAGE_UPLOAD_FLAG=1;
//                                       [self GET_PHOTOS:nil];
//                                           
//                                       });
//                                   }
//                                   else
//                                   {
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//
//                                       [HUD hide:YES];
//                                       [self stopSpin];
//                                       });
//                                   }
//                                   if (connectionError)
//                                   {
//                                       
//                                       NSLog(@"error detected:%@", connectionError.localizedDescription);
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                           [HUD hide:YES];
//                                           [self stopSpin];
//                                       });
//                                       
//                                   }
//                                   }
//                                   
//                               }];
//        });
//    }
//    else
//    {
//        
//    }
//    
//}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count > 4)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Please select not more than 5 Photos"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Your asset has not yet been downloaded to your device"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count < 5 && asset.defaultRepresentation != nil);
}

-(void)tag_line
{
    NSLog(@"In TAG");
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        [self showPageLoader];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        if ([connectobj string_check:TOCKEN]==true && [connectobj string_check:tag_edit_text.text]==true &&[connectobj int_check:USER_ID]==true)
        {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOCKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInt:USER_ID] forKey:@"user_id"];
            [param setObject:tag_edit_text.text forKey:@"tagline"];
            
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/updatetagline?"];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"URL STR_TAg IS :%@",jsonString);
            NSURL *url=[NSURL URLWithString:url_str];
            
            
            NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *connectionError) {
                                       NSLog(@"RESPONSE :%@",response);
                                       
                                       if (data==nil || [data isEqual:[NSNull null]])
                                       {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                           [HUD hide:YES];
                                           [self stopSpin];
                                            });
                                       }
                                       else
                                       {
                                           
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           NSLog(@"DIC is :%@",json);
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               [sqlfunction UPDATE_TAGLINE:USER_ID tagline:tag_edit_text.text];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   tag_label.frame=CGRectMake(4, 41, 273, 28);
                                                   tag_label.attributedText=[self GET_SHADOW_STRING_PLACE:tag_edit_text.text];
                                                   CGRect beforeFrame = tag_label.frame;
                                                   tag_label.numberOfLines=0;
                                                   tag_label.lineBreakMode=NSLineBreakByWordWrapping;
                                                   [tag_label sizeToFit];
                                                   CGRect afterFrame = tag_label.frame;
                                                   tag_label.frame = CGRectMake(beforeFrame.origin.x + beforeFrame.size.width - afterFrame.size.width, tag_label.frame.origin.y, tag_label.frame.size.width, tag_label.frame.size.height);
                                                   
                                                   place_label.frame=CGRectMake(4, tag_label.frame.size.height+tag_label.frame.origin.y+5, 273, 30);
                                                   

                                               });
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                                   [self presentViewController:view_control animated:YES completion:nil];
                                               });
                                               
                                           }
                                           else
                                           {
                                               
                                           }
                                           if (connectionError)
                                           {
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error in network" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                               [alert show];
                                               NSLog(@"error detected:%@", connectionError.localizedDescription);
                                               
                                           }
                                       }
                                   }];
            
        }
        else
        {
            
            [self alertStatus:@"Server Error"];
            return;
        }
        
        });
        
        
    }
    else
    {
        networkErrorView.hidden=YES;
        //[self alertStatus:@"Error in network connection"];
        return;
    }
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
        else {
            return NO;
        }
    }
    else if([[textView text] length] > 99 )
    {
        return NO;
    }
    return YES;
    
}


@end
