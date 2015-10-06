//
//  DetailFeedViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 19/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "DetailFeedViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "SportsCell.h"
#import "MessageCell.h"
#define INPUT_HEIGHT 40.0f
#define kFontSize 15.0 // fontsize
#define kTextViewWidth 246
#import "AFNetworking.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"
#import "FeedViewController.h"
#import "Public_Profile_ViewController.h"
@interface DetailFeedViewController ()

@end

@implementation DetailFeedViewController

@synthesize type,post_time,poster_name,text_post,prof_pic_user,like_count_feed,comment_count_feed,Post_id,USER_ID,TOKEN,index_count,NOTIF_FLAG;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    POP_UP_COMMENT_FLAG=0;
    COMMENT_FLAG=0;
    feed_array=[[NSMutableArray alloc]init];
    post_textview.text=@"Type your comments....";
    comment_list_array=[[NSMutableArray alloc]init];
    connectobj=[[connection alloc]init];
    row_height=0;
    styles=[[Styles alloc]init];
    text_bg_view.hidden=YES;
    
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];
    
    header_view.backgroundColor=[styles colorWithHexString:@"042e5f"];
    

    
    //////////// PROFILE_DETAILS DESIGN ////////////////
    
   header_bg_view.backgroundColor=[styles colorWithHexString:@"F0F2F1"];
    
    //////// COMMENTS VIEW FUNCTION////////////
    comment_bg_view.backgroundColor=[UIColor whiteColor];
    comment_bg_view.layer.cornerRadius=4.0;
    comment_bg_view.layer.masksToBounds=YES;
    comments_label.font=[UIFont fontWithName:@"Roboto-Bold" size:19];
    done_button.titleLabel.font=[UIFont fontWithName:@"Roboto-Bold" size:18];
    comment_bg_view.hidden=YES;
    
  
    
//    like_btn.layer.cornerRadius=3.0;
//    like_btn.layer.masksToBounds=YES;
//    like_btn.layer.borderWidth=0.50;
//    like_btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    like_btn.backgroundColor=[UIColor clearColor];
    like_btn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    [like_btn setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-heart"] forState:UIControlStateNormal];
    [like_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
//    comment_btn.layer.cornerRadius=3.0;
//    comment_btn.layer.masksToBounds=YES;
//    comment_btn.layer.borderWidth=0.50;
//    comment_btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    comment_btn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    [comment_btn setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-comment"] forState:UIControlStateNormal];
    comment_btn.backgroundColor=[UIColor clearColor];
    [comment_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    comment_like_bg.backgroundColor=[styles colorWithHexString:@"F9F9F9"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    comment_like_bg.hidden=YES;

    [self DETAIL_FEED_FUNCTION];
    
    
    prof_pic.userInteractionEnabled=YES;
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feed_thumbnail_touch:)];
    [prof_pic addGestureRecognizer:gesture];
    UITapGestureRecognizer *gesture_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feed_label_touch:)];
    Name_label.userInteractionEnabled=YES;
    [Name_label addGestureRecognizer:gesture_label];
    
    
    ///////// REPORT ABUSE SPORTS //////////
    
    report_abuse_view.layer.borderColor=[UIColor whiteColor].CGColor;
    report_abuse_view.layer.borderWidth=2.0;
    report_abuse_view.layer.cornerRadius=4.0;
    report_abuse_view.layer.masksToBounds=YES;
    
    abuse_heading_one.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
    abuse_heading_two.font=[UIFont fontWithName:@"Roboto-Regular" size:18];
    abuse_label_one.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    abuse_label_two.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    abuse_label_three.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    abuse_label_four.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    
    report_submit_button.layer.borderColor=[UIColor whiteColor].CGColor;
    report_submit_button.layer.borderWidth=2.0;
    report_submit_button.layer.cornerRadius=4.0;
    report_submit_button.layer.masksToBounds=YES;

}
-(void)feed_thumbnail_touch:(id)sender
{
    
    
    if (USER_ID==[[[feed_array objectAtIndex:0]objectForKey:@"poster_id"] integerValue])
    {
        [self performSegueWithIdentifier:@"DETAIL_PROFILE" sender:self];
    }
    else
    {
        
        Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
        view_control.TOKEN=TOKEN;
        view_control.USER_ID=USER_ID;
        view_control.FEED_FLAG=1;
        view_control.TARGETED_USER_ID=[[feed_array objectAtIndex:0]objectForKey:@"poster_id"];
        [self.view addSubview:view_control.view];
        
    }
    
    
}


-(void)feed_label_touch:(id)sender
{
    
    
    [UIView animateWithDuration:0.2
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         Name_label.alpha=0.5;
                         Name_label.textColor = [styles colorWithHexString:@"4CA5E0"];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2 animations:^{
                             Name_label.alpha=1.0;
                             Name_label.textColor = [styles colorWithHexString:terms_of_services_color];
                             @try
                             {
                                 if (USER_ID==[[[feed_array objectAtIndex:0]objectForKey:@"poster_id"] integerValue])
                                 {
                                     [self performSegueWithIdentifier:@"DETAIL_PROFILE" sender:self];
                                 }
                                 else
                                 {
                                     
                                     Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
                                     view_control.TOKEN=TOKEN;
                                     view_control.USER_ID=USER_ID;
                                     view_control.FEED_FLAG=1;
                                     view_control.TARGETED_USER_ID=[[feed_array objectAtIndex:0]objectForKey:@"poster_id"];
                                     [self.view addSubview:view_control.view];
                                 }
                                 
                             }
                             @catch(NSException *theException){
                                 
                             }
                             
                         }];
                     }];
    
}



-(void)comment_label_touch:(id)sender
{
    NSLog(@"LABBB");
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    MessageCell *p_cell = (MessageCell*)[image_comment_table cellForRowAtIndexPath:indexPath1];
    
    [UIView animateWithDuration:0.2
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         p_cell.Name_label.alpha=0.5;
                         p_cell.Name_label.textColor = [styles colorWithHexString:@"4CA5E0"];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2 animations:^{
                             p_cell.Name_label.alpha=1.0;
                             p_cell.Name_label.textColor = [styles colorWithHexString:terms_of_services_color];
                             @try
                             {
                                 NSLog(@"USERS:%d",USER_ID);
                                 NSLog(@"GHJ: %@",[[comment_list_array objectAtIndex:indexPath1.row]objectForKey:@"comment_poster_id"]);
                                 
                                 if (USER_ID==[[[comment_list_array objectAtIndex:indexPath1.row]objectForKey:@"comment_poster_id"] integerValue])
                                 {
                                     [self performSegueWithIdentifier:@"DETAIL_PROFILE" sender:self];
                                 }
                                 else
                                 {
                                     
                                     Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
                                     view_control.TOKEN=TOKEN;
                                     view_control.USER_ID=USER_ID;
                                     view_control.FEED_FLAG=1;
                                     view_control.TARGETED_USER_ID=[[comment_list_array objectAtIndex:indexPath1.row]objectForKey:@"comment_poster_id"];
                                     [self.view addSubview:view_control.view];
                                     
                                 }
                                 
                             }
                             @catch(NSException *theException){
                                 
                             }
                             
                         }];
                     }];
    
    
}

-(void)comment_thumbnail_touch:(id)sender
{
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    
    if (USER_ID==[[[comment_list_array objectAtIndex:indexPath1.row]objectForKey:@"comment_poster_id"] integerValue])
    {
        [self performSegueWithIdentifier:@"DETAIL_PROFILE" sender:self];
    }
    else
    {
        
        Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
        view_control.TOKEN=TOKEN;
        view_control.USER_ID=USER_ID;
        view_control.FEED_FLAG=1;
        view_control.TARGETED_USER_ID=[[comment_list_array objectAtIndex:indexPath1.row]objectForKey:@"comment_poster_id"];
        [self.view addSubview:view_control.view];
        
    }

    
}




-(void)DETAIL_FEED_FUNCTION
{
    
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
         networkErrorView.hidden=YES;
        
        if ([connectobj string_check:TOKEN]==true  &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:Post_id]==true)
        {
            [self showPageLoader];
            timer = [NSTimer scheduledTimerWithTimeInterval: 7.0
                                                     target: self
                                                   selector: @selector(cancelURLConnection:)
                                                   userInfo: nil
                                                    repeats: NO];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:Post_id] forKey:@"post_id"];
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/feeddetails?"];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"URL STR IS :%@",jsonString);
            
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
                                           });
                                       }
                                       else
                                       {
                                           
                                           NSLog(@"RESPONSE :%@",response);
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               
                                               comment_like_bg.hidden=NO;
                                               feed_array=[json objectForKey:@"feed_content"];
                                               NSLog(@"FEED COUNT IS :%lu",(unsigned long)feed_array.count);
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [timer invalidate];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   
                                                   if ([[[feed_array objectAtIndex:0] objectForKey:@"like_status"] isEqualToString:@"liked"])
                                                   {
                                                       [like_btn setTitleColor:[styles colorWithHexString:blueButton] forState:UIControlStateNormal];
                                                   }
                                                   else if ([[[feed_array objectAtIndex:0] objectForKey:@"like_status"] isEqualToString:@"unliked"])
                                                       
                                                   {
                                                       [like_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                                                   }
                                                   
                                                   prof_pic.contentMode=UIViewContentModeScaleAspectFill;
                                                   prof_pic.clipsToBounds=YES;
                                                   if ([[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"text"])
                                                   {
                                                       header_bg_view.frame=CGRectMake(0, 46, 320, 60);
                                                       header_bg_view.backgroundColor=[styles colorWithHexString:@"F0F2F1"];
                                                       prof_pic.layer.cornerRadius=6.0;
                                                       prof_pic.layer.masksToBounds=YES;
                                                       
                                                       if ([[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:0]objectForKey:@"poster_picture"]] isEqualToString:@"0"])
                                                           
                                                       {
                                                           NSLog(@"no pro pic");
                                                           prof_pic.image=[UIImage imageNamed:@"noimage.png"];
                                                       }
                                                       else
                                                       {
                                                           NSLog(@"YES pro pic");
                                                           NSString *url_str_profile=[[feed_array objectAtIndex:0]objectForKey:@"poster_picture"];
                                                           
                                                           NSLog(@"PRO URL :%@",url_str_profile);
                                                           
                                                           NSURL *image_url1=[NSURL URLWithString:url_str_profile];
                                                           NSLog(@"PRO URL1 :%@",image_url1);
                                                           [prof_pic setImageWithURL:image_url1 placeholderImage:[UIImage imageNamed:@"noimage"]];
                                                       }
                                                       
                                                       Name_label.text=[[[feed_array objectAtIndex:0]objectForKey:@"poster_name"] capitalizedString];
                                                       Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
                                                       Name_label.textColor=[styles colorWithHexString:terms_of_services_color];
                                                       
                                                       time_label.text=[[feed_array objectAtIndex:0]objectForKey:@"time"];
                                                       time_label.font=[UIFont fontWithName:@"Roboto-Thin" size:13];
                                                       time_label.textColor=[styles colorWithHexString:terms_of_services_color];
                                                       time_label.highlightedTextColor=[UIColor blackColor];
                                                       
                                                       post_text.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
                                                       post_text.textColor=[UIColor grayColor];
                                                       post_text.text=[[feed_array objectAtIndex:0]objectForKey:@"text_message"];
                                                       post_text.numberOfLines = 0;
                                                       [post_text sizeToFit];
                                                       
                                                       CGRect labelFrame = post_text.frame;
                                                       
                                                       collectionview.hidden=YES;
                                                       
                                                       
                                                       comment_like_bg.frame=CGRectMake(0, labelFrame.size.height+labelFrame.origin.y+10, 320,41);
                                                       
                                                       comment_like_frame=comment_like_bg.frame;
                                                       [self Comment_list];
                                                       
                                                       /////////// LIKE_COMMENT DESIGN////////////////
                                                       
                                                       
                                                       like_count.text=[[feed_array objectAtIndex:0]objectForKey:@"post_total_like_count"];
                                                       like_count.textColor=[styles colorWithHexString:terms_of_services_color];
                                                       like_count.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
                                                       
                                                       comment_count.text=[[feed_array objectAtIndex:0]objectForKey:@"post_total_comment_count"];
                                                       comment_count.textColor=[styles colorWithHexString:terms_of_services_color];
                                                       comment_count.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
                                                       text_bg_view.hidden=NO;
                                                       
                                                       
                                                   }
                                                   else if ([[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"image"] || [[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"profile_photo_update"] || [[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"video"])
                                                   {
                                                       
                                                       NSLog(@"PROFILE PHOTO UPDATE");
                                                       sub_image_array=[[NSMutableArray alloc]init];
                                                       
                                                       if ([[[feed_array objectAtIndex:0]objectForKey:@"type"]isEqualToString:@"image"])
                                                       {
                                                           prof_pic.frame=CGRectMake(4, 5, 50, 50);
                                                           UILabel   *photo_label=[[UILabel alloc]initWithFrame:CGRectMake(60, 23, 240, 20)];
                                                           photo_label.font=[UIFont fontWithName:@"Roboto-Regular" size:12];
                                                           photo_label.textColor=[styles colorWithHexString:terms_of_services_color];
                                                           photo_label.textAlignment=NSTextAlignmentLeft;
                                                           photo_label.text=@"Photo_label";
                                                           [header_bg_view addSubview:photo_label];
                                                           time_label.frame=CGRectMake(60, 40, 224, 20);
                                                           time_label.textColor=[styles colorWithHexString:terms_of_services_color];
                                                           time_label.highlightedTextColor=[UIColor blackColor];
                                                           sub_image_array=[[feed_array objectAtIndex:0]objectForKey:@"image"];
                                                           
                                                           
                                                           NSString *image_array_count_str=[NSString stringWithFormat:@"%lu",(unsigned long)sub_image_array.count];
                                                           
                                                           
                                                           NSString *final_name;
                                                           if (sub_image_array.count==1)
                                                           {
                                                               final_name=@"has added a photo";
                                                               NSLog(@"FNSAME :%@",final_name);
                                                           }
                                                           else if(sub_image_array.count>1)
                                                           {
                                                               
                                                               final_name=[@"has added" stringByAppendingString:@" "];
                                                               final_name=[final_name stringByAppendingString:image_array_count_str];
                                                               final_name=[final_name stringByAppendingString:@" photos"];
                                                               NSLog(@"FFFFNSAME :%@",final_name);
                                                           }
                                                           
                                                           photo_label.text=final_name;
                                                           
                                                       }
                                                       else if ([[[feed_array objectAtIndex:0]objectForKey:@"type"]isEqualToString:@"video"])
                                                       {
                                                           prof_pic.frame=CGRectMake(4, 5, 50, 50);
                                                           
                                                           NSString *url_str_video=[[feed_array objectAtIndex:0]objectForKey:@"video_thumb_image"];
                                                           
                                                           
                                                           [sub_image_array addObject:url_str_video];
                                                       }
                                                       else
                                                       {
                                                           [ sub_image_array addObject :[[feed_array objectAtIndex:0]objectForKey:@"image"] ];
                                                       }
                                                       prof_pic.layer.cornerRadius=6.0;
                                                       prof_pic.layer.masksToBounds=YES;
                                                       if([[UIScreen mainScreen]bounds].size.height !=568)
                                                       {
                                                           scrollview.frame=CGRectMake(0, 15, 320, 470);
                                                           
                                                       }
                                                       else
                                                       {
                                                           scrollview.frame=CGRectMake(0, 15, 320, 548);
                                                       }
                                                       header_bg_view.frame=CGRectMake(0, 46, 320, 60);
                                                       
                                                       if ([[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:0]objectForKey:@"poster_picture"]] isEqualToString:@"0"])
                                                           
                                                       {
                                                           prof_pic.image=[UIImage imageNamed:@"noimage.png"];
                                                       }
                                                       else
                                                       {
                                                           NSString *url_str_profile=[[feed_array objectAtIndex:0]objectForKey:@"poster_picture"];
                                                           
                                                           
                                                           NSURL *image_url=[NSURL URLWithString:url_str_profile];
                                                           [prof_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
                                                       }
                                                       
                                                       Name_label.text=[[[feed_array objectAtIndex:0]objectForKey:@"poster_name"] capitalizedString];
                                                       Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
                                                       Name_label.textColor=[styles colorWithHexString:terms_of_services_color];
                                                       
                                                       time_label.text=[[feed_array objectAtIndex:0]objectForKey:@"time"];
                                                       time_label.font=[UIFont fontWithName:@"Roboto-Thin" size:13];
                                                       time_label.textColor=[styles colorWithHexString:terms_of_services_color];
                                                       time_label.highlightedTextColor=[UIColor blackColor];
                                                       
                                                       
                                                       post_text.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
                                                       post_text.textColor=[UIColor grayColor];
                                                       NSString *text_string=[[feed_array objectAtIndex:0]objectForKey:@"text_message"];
                                                       text_string=[text_string stringByReplacingOccurrencesOfString:@"{item:$subject}" withString:@""];
                                                       post_text.text=text_string;
                                                       post_text.numberOfLines = 0;
                                                       [post_text sizeToFit];
                                                       
                                                       CGRect labelFrame = post_text.frame;
                                                       
                                                       collectionview.hidden=NO;
                                                       
                                                       collectionview.frame=CGRectMake(7, labelFrame.size.height+labelFrame.origin.y+10, 310,370);
                                                       
                                                       
                                                       CGRect collectionview_frame=collectionview.frame;
                                                       
                                                       comment_like_bg.frame=CGRectMake(0, collectionview_frame.size.height+collectionview_frame.origin.y+10, 320,41);
                                                       
                                                       
                                                       comment_like_frame=comment_like_bg.frame;
                                                       
                                                       scrollview.contentSize=CGSizeMake(320, comment_like_frame.size.height+comment_like_frame.origin.y+50);
                                                       tableview.hidden=YES;
                                                       [collectionview reloadData];
                                                       [self Comment_list_image];
                                                       
                                                       
                                                       /////////// LIKE_COMMENT DESIGN////////////////
                                                       
                                                       
                                                       like_count.text=[[feed_array objectAtIndex:0]objectForKey:@"post_total_like_count"];
                                                       like_count.textColor=[styles colorWithHexString:terms_of_services_color];
                                                       like_count.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
                                                       
                                                       comment_count.text=[[feed_array objectAtIndex:0]objectForKey:@"post_total_comment_count"];
                                                       comment_count.textColor=[styles colorWithHexString:terms_of_services_color];
                                                       comment_count.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
                                                       text_bg_view.hidden=YES;
                                                   }
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
                                               [self alertStatus:connectionError.localizedDescription];
                                               [HUD hide:YES];
                                               [self stopSpin];
                                           });
                                           
                                       }
                                   }];
 
        }
        else
        {
            [HUD hide:YES];
            [self stopSpin];
            [self alertStatus:@"Server Error"];
            return;
        }
        
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
- (void) alertStatus:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}
-(void)keyboardWillShow {
    // Animate the current view out of the way
   
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
         self.view.frame = CGRectMake(0, -246, 320, 480);
    }
    else
    {
            self.view.frame = CGRectMake(0, -250, 320, 568);
    }
      }

-(void)keyboardWillHide {
    // Animate the current view back to its original position
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
          self.view.frame = CGRectMake(0, 0, 320, 480);
    }
    else
    {
    self.view.frame = CGRectMake(0, 0, 320, 568);
    }
}
-(void)SEND_POST:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DETAIL_FEED"])
    {
        FeedViewController *feed=segue.destinationViewController;
        feed.index_count=index_count;
        feed.DETAIL_FLAG=1;
        feed.USER_ID=USER_ID;
        feed.TOCKEN=TOKEN;
    }
    else if([segue.identifier isEqualToString:@"DETAIL_PROFILE"])
    {
       
        ProfileViewController *profile_controller=segue.destinationViewController;
        profile_controller.USER_ID=USER_ID;
        profile_controller.TOCKEN=TOKEN;
    }
}

- (IBAction)Back_Action:(id)sender
{
    if (NOTIF_FLAG==1)
    {
        [self performSegueWithIdentifier:@"DETAIL_NOTIF" sender:self];
    }
    else
    {
    [self performSegueWithIdentifier:@"DETAIL_FEED" sender:self];
    }
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [sub_image_array count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *identifier = @"CELL";
    
    SportsCell *cell = (SportsCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *url_str;
    if ([[[feed_array objectAtIndex:0]objectForKey:@"type"]isEqualToString:@"profile_photo_update"])
    {
        url_str=[sub_image_array objectAtIndex:0];
    }
    
    else
    {
        url_str=[sub_image_array objectAtIndex:indexPath.row];
    }
    
    NSURL *image_url=[NSURL URLWithString:url_str];
    [cell.prof_images setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
    cell.play_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:40];
    [cell.play_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-play-circle"] forState:UIControlStateNormal];
    [cell.play_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.play_button addTarget:self action:@selector(video_play_action:) forControlEvents:UIControlEventTouchUpInside];
    cell.play_button.hidden=YES;
    cell.backgroundColor=[UIColor blackColor];
     if ([[[feed_array objectAtIndex:0]objectForKey:@"type"]isEqualToString:@"video"])
    {
       
        cell.play_button.hidden=NO;
    }

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"INDEX SELECTED");
}
-(CGFloat)collectionView:(UICollectionView *)collectionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 365;
}
-(void)video_play_action:(UIButton *)sender
{
    
    
    NSLog(@"VIDEO BUTTON CLICKED");
    NSString *url_str=[[feed_array objectAtIndex:0]objectForKey:@"video"];
    
    MPMoviePlayerViewController *playerVC =[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url_str]];
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:playerVC
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:playerVC.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerVC.moviePlayer];
    
    // Set the modal transition style of your choice
    playerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentMoviePlayerViewControllerAnimated:playerVC];
    
    [playerVC.moviePlayer prepareToPlay];
    [playerVC.moviePlayer play];
    
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
        // [self dismissModalViewControllerAnimated:YES];
        [self dismissMoviePlayerViewControllerAnimated];
    }
}





#pragma TABLEVIEW FUNCTIONS

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
    
    NSLog(@"TABLEVIE SELECTED :%d",comment_list_array.count);
    
    return [comment_list_array count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"AAA SELECTED");
    if (tableView==image_comment_table)
    {
        UILabel *lbel_msg;
        NSString *CELLIDENTIFIER=@"CELL";
        MessageCell *message_cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        message_cell.backgroundColor=[UIColor clearColor];
        message_cell.Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
        message_cell.profile_pic.layer.cornerRadius=25.0;
        message_cell.profile_pic.layer.masksToBounds=YES;
        message_cell.profile_pic.contentMode=UIViewContentModeScaleAspectFill;
        message_cell.profile_pic.clipsToBounds=YES;
        message_cell.Name_label.textColor=[styles colorWithHexString:terms_of_services_color];
        message_cell.time_label.font=[UIFont fontWithName:@"Roboto-Thin" size:12];
        message_cell.time_label.textColor=[styles colorWithHexString:terms_of_services_color];
        message_cell.Message_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
        message_cell.like_count.textColor=[styles colorWithHexString:@"8e949b"];
        message_cell.like_count.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
         message_cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        message_cell.like_btn.layer.cornerRadius=3.0;
//        message_cell.like_btn.layer.masksToBounds=YES;
//        message_cell.like_btn.layer.borderWidth=1.0;
//        message_cell.like_btn.layer.borderColor=[UIColor grayColor].CGColor;
        message_cell.profile_pic.userInteractionEnabled=YES;
        message_cell.profile_pic.tag = indexPath.row;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_thumbnail_touch:)];
        [message_cell.profile_pic addGestureRecognizer:gesture];
        
        UITapGestureRecognizer *gesture_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_label_touch:)];
        message_cell.Name_label.userInteractionEnabled=YES;
        message_cell.Name_label.tag=indexPath.row;
        [message_cell.Name_label addGestureRecognizer:gesture_label];
        
        message_cell.like_btn.backgroundColor=[UIColor clearColor];
        message_cell.like_btn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
        [message_cell.like_btn setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-heart"] forState:UIControlStateNormal];
        [message_cell.like_btn setTitleColor:[styles colorWithHexString:@"8e949b"] forState:UIControlStateNormal];
        
        message_cell.like_btn.tag=indexPath.row;
        [message_cell.like_btn addTarget:self action:@selector(comment_like_btn_action:) forControlEvents:UIControlEventTouchUpInside];
        
        message_cell.like_background_button.tag=indexPath.row;
        [message_cell.like_background_button addTarget:self action:@selector(comment_like_btn_action:) forControlEvents:UIControlEventTouchUpInside];

        //////////// Cell Content ////////
        if ([[NSString stringWithFormat:@"%@",[[comment_list_array objectAtIndex:indexPath.row]objectForKey:@"like_status"]] isEqualToString:@"0"])
            
        {
            [message_cell.like_btn setTitleColor:[styles colorWithHexString:@"8e949b"] forState:UIControlStateNormal];
        }
        else if (![[NSString stringWithFormat:@"%@",[[comment_list_array objectAtIndex:indexPath.row]objectForKey:@"like_status"]] isEqualToString:@"0"])
            
            
        {
            [message_cell.like_btn setTitleColor:[styles colorWithHexString:blueButton] forState:UIControlStateNormal];
        }
        
        if ([[NSString stringWithFormat:@"%@",[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_poster_profilepic"]] isEqualToString:@"0"])
            
        {
            message_cell.profile_pic.image=[UIImage imageNamed:@"noimage.png"];
        }
        else
        {
            NSString *url_str=[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_poster_profilepic"];
            NSURL *image_url=[NSURL URLWithString:url_str];
            [message_cell.profile_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
        }
        
        lbel_msg=[[UILabel alloc]initWithFrame:CGRectMake(62, 35, 250, 24)];
        lbel_msg.font=[UIFont fontWithName:@"Roboto-Regular" size:13];
        lbel_msg.textColor=[UIColor grayColor];
        lbel_msg.tag = 1001;
        lbel_msg.numberOfLines=0;
        lbel_msg.text=[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_body"];
        [lbel_msg sizeToFit];
        
        if (([message_cell.contentView viewWithTag:1001]))
        {
            [[message_cell.contentView viewWithTag:1001]removeFromSuperview];
            
        }
        [message_cell.contentView addSubview:lbel_msg];
        
        
        message_cell.Name_label.text=[[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_poster_name"] capitalizedString];
        message_cell.time_label.text=[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_posted_time"];
        
        message_cell.like_count.text=[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_total_likes"];
        CGRect message_label_frame=lbel_msg.frame;
        message_cell.like_view.frame=CGRectMake(0, message_label_frame.size.height+message_label_frame.origin.y+10,320,30);
        
        //  message_cell.like_view.backgroundColor=[UIColor greenColor];
        return message_cell;

    }
    else
    {
    NSString *CELLIDENTIFIER=@"CELL";
    MessageCell *message_cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    /////// CELL DESIGN ///////
    
    message_cell.backgroundColor=[UIColor clearColor];
    message_cell.selectionStyle=UITableViewCellSelectionStyleNone;
    message_cell.Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    message_cell.profile_pic.layer.cornerRadius=25.0;
    message_cell.profile_pic.layer.masksToBounds=YES;
        message_cell.profile_pic.contentMode=UIViewContentModeScaleAspectFill;
         message_cell.profile_pic.clipsToBounds=YES;
    message_cell.Name_label.textColor=[styles colorWithHexString:terms_of_services_color];
    message_cell.time_label.font=[UIFont fontWithName:@"Roboto-Regular" size:12];
    message_cell.time_label.textColor=[styles colorWithHexString:terms_of_services_color];
    message_cell.Message_label.font=[UIFont fontWithName:@"Roboto-Regular" size:13];
        message_cell.Message_label.textColor=[UIColor grayColor];
   
    message_cell.like_count.textColor=[styles colorWithHexString:terms_of_services_color];
    message_cell.like_count.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
//    message_cell.like_btn.layer.cornerRadius=3.0;
//    message_cell.like_btn.layer.masksToBounds=YES;
//    message_cell.like_btn.layer.borderWidth=1.0;
//    message_cell.like_btn.layer.borderColor=[UIColor grayColor].CGColor;
    message_cell.like_btn.backgroundColor=[UIColor clearColor];
    message_cell.like_btn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    [message_cell.like_btn setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-heart"] forState:UIControlStateNormal];
    [message_cell.like_btn setTitleColor:[styles colorWithHexString:@"8e949b"] forState:UIControlStateNormal];
    
    message_cell.like_btn.tag=indexPath.row;
    [message_cell.like_btn addTarget:self action:@selector(comment_like_btn_action:) forControlEvents:UIControlEventTouchUpInside];
    message_cell.like_background_button.tag=indexPath.row;
    [message_cell.like_background_button addTarget:self action:@selector(comment_like_btn_action:) forControlEvents:UIControlEventTouchUpInside];
        message_cell.profile_pic.userInteractionEnabled=YES;
        message_cell.profile_pic.tag = indexPath.row;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_thumbnail_touch:)];
        [message_cell.profile_pic addGestureRecognizer:gesture];
        
        UITapGestureRecognizer *gesture_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_label_touch:)];
        message_cell.Name_label.userInteractionEnabled=YES;
        message_cell.Name_label.tag=indexPath.row;
        [message_cell.Name_label addGestureRecognizer:gesture_label];

      //////////// Cell Content ////////
    if ([[NSString stringWithFormat:@"%@",[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_poster_profilepic"]] isEqualToString:@"0"])
        
    {
        message_cell.profile_pic.image=[UIImage imageNamed:@"noimage.png"];
    }
    else
    {
        NSString *url_str=[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_poster_profilepic"];
        NSURL *image_url=[NSURL URLWithString:url_str];
        [message_cell.profile_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
    }
    if ([[NSString stringWithFormat:@"%@",[[comment_list_array objectAtIndex:indexPath.row]objectForKey:@"like_status"]] isEqualToString:@"0"])
        
    {
        [message_cell.like_btn setTitleColor:[styles colorWithHexString:@"8e949b"] forState:UIControlStateNormal];
    }
    else if (![[NSString stringWithFormat:@"%@",[[comment_list_array objectAtIndex:indexPath.row]objectForKey:@"like_status"]] isEqualToString:@"0"])
        
    {
        [message_cell.like_btn setTitleColor:[styles colorWithHexString:blueButton] forState:UIControlStateNormal];
    }
    
    message_cell.Name_label.text=[[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_poster_name"] capitalizedString];
    message_cell.time_label.text=[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_posted_time"];
    message_cell.Message_label.text=[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_body"];
    message_cell.like_count.text=[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_total_likes"];
    message_cell.Message_label.numberOfLines=0;
    [message_cell.Message_label sizeToFit];
    CGRect message_label_frame=message_cell.Message_label.frame;
    message_cell.like_view.frame=CGRectMake(0, message_label_frame.size.height+message_label_frame.origin.y+10,320,30);
    return message_cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TTTTT");
    CGSize size = [[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_body"]
                   sizeWithFont:[UIFont systemFontOfSize:14]
                   constrainedToSize:CGSizeMake(230, CGFLOAT_MAX)];
     row_height=row_height+size.height+80;
    return size.height+80;
    
}
-(void)comment_like_btn_action:(UIButton *)sender
{
    NSLog(@"IN LIKE FUNCtION");
    @try {
          NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        if ([[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"image"] || [[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"video"] ||  [[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"profile_photo_update"])
        {
              cell_p = (MessageCell*)[image_comment_table cellForRowAtIndexPath:indexPath1];
        }
        else
        {
           cell_p = (MessageCell*)[tableview cellForRowAtIndexPath:indexPath1];
        }
        
      
      
        cell_p.like_btn.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            cell_p.like_btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
        }];
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            
            
            
            if ([connectobj string_check:TOKEN]==true &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:[[[feed_array objectAtIndex:0] objectForKey:@"post_id"]integerValue]]==true &&[connectobj int_check:[[[comment_list_array objectAtIndex:indexPath1.row] objectForKey:@"comment_poster_id"]integerValue]]==true &&[connectobj int_check:[[[comment_list_array objectAtIndex:indexPath1.row] objectForKey:@"comment_id"]integerValue]]==true)
            {
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[[[feed_array objectAtIndex:0] objectForKey:@"post_id"]integerValue]] forKey:@"post_id"];
                [param setObject:[NSNumber numberWithInteger:[[[comment_list_array objectAtIndex:indexPath1.row] objectForKey:@"comment_poster_id"]integerValue]] forKey:@"poster_id"];
                [param setObject:[NSNumber numberWithInteger:[[[comment_list_array objectAtIndex:indexPath1.row] objectForKey:@"comment_id"]integerValue]] forKey:@"comment_id"];
                // [param setObject:@"like" forKey:@"type"];
                
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/commentlikeunlike?"];
                
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
                NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"URL STR IS :%@",jsonString);
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
                
                NSOperationQueue  *comment_like_queue = [[NSOperationQueue alloc] init];
                comment_like_queue.maxConcurrentOperationCount=1;
                
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:comment_like_queue
                                       completionHandler:^(NSURLResponse *response,
                                                           NSData *data,
                                                           NSError *connectionError) {
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
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                       
                                                       if ([[json objectForKey:@"type"] isEqualToString:@"like"])
                                                       {
                                                           [cell_p.like_btn setTitleColor:[styles colorWithHexString:blueButton] forState:UIControlStateNormal];
                                                           cell_p.like_count.text=[json objectForKey:@"comment_total_like_count"];
                                                           
                                                           
                                                           comment_list_array=[comment_list_array mutableCopy];
                                                           NSMutableDictionary *entry = [[comment_list_array objectAtIndex:indexPath1.row]mutableCopy];
                                                           [entry setObject:@"1" forKey:@"like_status"];
                                                           [entry setObject:[json objectForKey:@"comment_total_like_count"] forKey:@"comment_total_likes"];
                                                           [entry mutableCopy];
                                                           [comment_list_array replaceObjectAtIndex:indexPath1.row withObject:entry];
                                                       }
                                                       else  if ([[json objectForKey:@"type"] isEqualToString:@"unlike"])
                                                       {
                                                           [cell_p.like_btn setTitleColor:[styles colorWithHexString:@"8e949b"] forState:UIControlStateNormal];
                                                           cell_p.like_count.text=[json objectForKey:@"comment_total_like_count"];
                                                           
                                                           comment_list_array=[comment_list_array mutableCopy];
                                                           NSMutableDictionary *entry = [[comment_list_array objectAtIndex:indexPath1.row]mutableCopy];
                                                           [entry setObject:@"0" forKey:@"like_status"];
                                                           [entry setObject:[json objectForKey:@"comment_total_like_count"] forKey:@"comment_total_likes"];
                                                           [entry mutableCopy];
                                                           [comment_list_array replaceObjectAtIndex:indexPath1.row withObject:entry];
                                                       }
                                                       
                                                   });
                                                   
                                                   NSLog(@"LIKE FUN SUCCESS");
                                                   
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
                                               });
                                               
                                           }
                                       }];
                
            }
            else
            {
                [HUD hide:YES];
                [self stopSpin];
                [self alertStatus:@"Server Error"];
                return;
            }

            
            
        }
    }
    @catch (NSException *exception) {
    }
    
    
}


- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
{
    float horizontalPadding = 18;
    float verticalPadding = 20;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    float height = [string sizeWithFont:[UIFont systemFontOfSize:kFontSize] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height;
    
}
- (void) textViewDidChange:(UITextView *)textView
{
    self.model = post_textview.text;
    if ([self heightForTextView:post_textview containingString:self.model]<100) {
        
        
        float height = [self heightForTextView:post_textview containingString:self.model];
        
        CGRect textViewRect = CGRectMake(20, 10, kTextViewWidth,height+20 );
        
        post_textview.frame = textViewRect;
        
        post_textview.contentSize = CGSizeMake(kTextViewWidth, [self heightForTextView:post_textview containingString:self.model]);
        if ([[UIScreen mainScreen]bounds].size.height !=568)
        {
            text_bg_view.frame =CGRectMake(0,470-[self heightForTextView:post_textview containingString:self.model],320,[self heightForTextView:post_textview containingString:self.model]+40);

        }
        else
        {
        
        text_bg_view.frame =CGRectMake(0,530-[self heightForTextView:post_textview containingString:self.model],320,[self heightForTextView:post_textview containingString:self.model]+40);
            
             send_button.frame=CGRectMake(277,text_bg_view.frame.size.height-50, 40, 40);
        }
        
        
        post_textview.text = self.model;
    }
    
    
}
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([post_textview.text isEqualToString:@"Type your comments...."]) {
        post_textview.text = @"";
        
    }
    
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    // isgroupchat=YES;
    
    if ([post_textview.text isEqualToString:@""]) {
        post_textview.text = @"Type your comments....";
        
    }
    
    
}

-(void)Comment_list
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
        if ([connectobj string_check:TOKEN]==true &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:Post_id]==true)
        {
            [HUD hide:YES];
            [self stopSpin];

            [self showPageLoader_send];
            comment_list_timer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                                                  target: self
                                                                selector: @selector(cancelURLConnection_comment_list:)
                                                                userInfo: nil
                                                                 repeats: NO];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:Post_id] forKey:@"post_id"];
            
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/listfeedcomments?"];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"URL STR IS :%@",jsonString);
            
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
            
            comment_list_queue = [[NSOperationQueue alloc] init];
            comment_list_queue.maxConcurrentOperationCount=1;
            
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:comment_list_queue
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *connectionError) {
                                       if (data==nil || [data isEqual:[NSNull null]])
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [HUD hide:YES];
                                               [self stopSpin];
                                           });
                                       }
                                       else
                                       {
                                           NSLog(@"RESPONSE :%@",response);
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               comment_list_array=[json objectForKey:@"result"];
                                               
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   
                                                   [tableview reloadData];
                                                   tableview.frame=CGRectMake(0, comment_like_frame.size.height+comment_like_frame.origin.y+10, 320,row_height);
                                                   
                                                   CGRect table_view_frame=tableview.frame;
                                                   
                                                   
                                                   
                                                   scrollview.contentSize=CGSizeMake(320, table_view_frame.size.height+table_view_frame.origin.y+50);
                                            
                                                   NSLog(@"Scroll height :%f",scrollview.contentSize.height);
                                                   
                                                   if (COMMENT_FLAG==1)
                                                   {
                                                       
                                                       if (scrollview.contentSize.height>520)
                                                       {
                                                           CGPoint bottomOffset = CGPointMake(0, scrollview.contentSize.height - scrollview.bounds.size.height);
                                                           [scrollview setContentOffset:bottomOffset animated:YES];
                                                       }

                                                       if ([UIScreen mainScreen].bounds.size.height !=568)
                                                       {
                                                           if (scrollview.contentSize.height>425)
                                                           {
                                                               CGPoint bottomOffset = CGPointMake(0, scrollview.contentSize.height - scrollview.bounds.size.height);
                                                               [scrollview setContentOffset:bottomOffset animated:YES];
                                                           }

                                                       }
                                                       
                                                       comment_count.text=[NSString stringWithFormat:@"%d",comment_list_array.count];
                                                       COMMENT_FLAG=0;
                                                   }
                                                   
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
                                           });
                                           
                                       }
                                   }];

        }
        else
        {
            [HUD hide:YES];
            [self stopSpin];
            [self alertStatus:@"Server Error"];
            return;
        }

        
            }
    else
    {
        [HUD hide:YES];
        [self stopSpin];
    }

}

-(void)cancelURLConnection_comment_list:(id)sender
{
    [comment_list_queue cancelAllOperations];
    [HUD hide:YES];
    [self stopSpin];
    [comment_list_timer invalidate];
}


-(void)Comment_list_image
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
        if ([connectobj string_check:TOKEN]==true &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:Post_id]==true)
        {
            [HUD hide:YES];
            [self stopSpin];

            [self showPageLoader_send];
            comment_list_timer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                                                  target: self
                                                                selector: @selector(cancelURLConnection_comment_list:)
                                                                userInfo: nil
                                                                 repeats: NO];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            [param setObject:TOKEN forKey:@"token"];
            
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:Post_id] forKey:@"post_id"];
            
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/listfeedcomments?"];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"URL STR IS :%@",jsonString);
            
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
            
            comment_list_queue = [[NSOperationQueue alloc] init];
            comment_list_queue.maxConcurrentOperationCount=1;
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:comment_list_queue
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *connectionError) {
                                       if (data==nil || [data isEqual:[NSNull null]])
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [HUD hide:YES];
                                               [self stopSpin];
                                           });
                                       }
                                       else
                                       {
                                           NSLog(@"RESPONSE :%@",response);
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   
                                                   comment_list_array=[json objectForKey:@"result"];
                                                   [image_comment_table reloadData];
                                                   NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:comment_list_array.count-1 inSection:0];
                                                   [image_comment_table selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                                                   
                                                   if (COMMENT_FLAG==1)
                                                   {
                                                       comment_count.text=[NSString stringWithFormat:@"%d",comment_list_array.count];
                                                       COMMENT_FLAG=0;
                                                   }
                                                   if([[UIScreen mainScreen]bounds].size.height !=568)
                                                   {
                                                       scrollview.frame=CGRectMake(0, 15, 320, 470);
                                                       
                                                   }
                                               });
                                               //                                           tableview.frame=CGRectMake(0, comment_like_frame.size.height+comment_like_frame.origin.y+10, 320,row_height);
                                               //
                                               //                                           CGRect table_view_frame=tableview.frame;
                                               //
                                               //
                                               //
                                               //                                           scrollview.contentSize=CGSizeMake(320, table_view_frame.size.height+table_view_frame.origin.y+50);
                                               
                                               // [image_comment_table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                               
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
                                           });
                                           
                                       }
                                   }];

        }
        else
        {
            [HUD hide:YES];
            [self stopSpin];
            [self alertStatus:@"Server Error"];
            return;
 
        }
        
            }
    else
    {
        [HUD hide:YES];
        [self stopSpin];
    }
    
}


- (IBAction)SEND:(id)sender
{
    NSLog(@"SEND FUN");
    COMMENT_FLAG=1;
    NSLog(@"TEXT IS  :%@",textView.text);
    NSString *comment_string;
    if (POP_UP_COMMENT_FLAG==1)
    {
        NSLog(@"DDDFF");
        t_view.frame=CGRectMake(0, 0, 320, 508);
        comment_string=textView.text;
        POP_UP_COMMENT_FLAG=0;
    }
    else
    {
        comment_string=post_textview.text;
    }
    NSLog(@"COMMENT STRING :%@",comment_string);
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
         networkErrorView.hidden=YES;
       
        if ( [comment_string isEqualToString:@"Type your comments...."] || [comment_string isEqualToString:@""] ) {
            [self alertStatus:@"Please enter your comment"];
            return;
        }
      
        
       else
       {
           [self showPageLoader_send];
           if ([connectobj string_check:TOKEN]==true &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:Post_id]==true)
           {
               NSMutableDictionary *param = [NSMutableDictionary dictionary];
               [param setObject:TOKEN forKey:@"token"];
               [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
               [param setObject:[NSNumber numberWithInteger:Post_id] forKey:@"post_id"];
               if ([[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"text"])
               {
                   
                   [param setObject:post_textview.text forKey:@"comment"];
                   
               }
               else
               {
                   [param setObject:textView.text forKey:@"comment"];
               }
               
               NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/postcomment?"];
               
               NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
               
               NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
               
               NSLog(@"URL STR IS :%@",jsonString);
               
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
               
               NSOperationQueue *comment_send_queue = [[NSOperationQueue alloc] init];
               comment_send_queue.maxConcurrentOperationCount=1;
               [NSURLConnection sendAsynchronousRequest:request
                                                  queue:comment_send_queue
                                      completionHandler:^(NSURLResponse *response,
                                                          NSData *data,
                                                          NSError *connectionError) {
                                          if (data==nil || [data isEqual:[NSNull null]])
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [HUD hide:YES];
                                                  [self stopSpin];
                                              });
                                          }
                                          else
                                          {
                                              NSLog(@"RESPONSE :%@",response);
                                              NSDictionary *json =
                                              [NSJSONSerialization JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                                error:nil];
                                              
                                              NSInteger status=[[json objectForKey:@"status"] intValue];
                                              
                                              if(status==1)
                                              {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      [HUD hide:YES];
                                                      [self stopSpin];
                                                      
                                                      if ([[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"image"] || [[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"video"] ||  [[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"profile_photo_update"])
                                                      {
                                                          [self Comment_list_image];
                                                          
                                                      }
                                                      else
                                                      {
                                                          post_textview.text=@"Type your comments....";
                                                          if([[UIScreen mainScreen]bounds].size.height !=568)
                                                          {
                                                              text_bg_view.frame=CGRectMake(0, 434, 320, 46);
                                                          }
                                                          else
                                                          {
                                                              text_bg_view.frame=CGRectMake(0, 522, 320, 46);
                                                          }
                                                          post_textview.frame=CGRectMake(37, 6, 223, 34);
                                                          send_button.frame=CGRectMake(277, 3, 40, 40);
                                                          [post_textview resignFirstResponder];
                                                          row_height=0;
                                                          [self Comment_list];
                                                      }
                                                      
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
                                              });
                                              
                                          }
                                          
                                      }];

           }
           else
           {
               [HUD hide:YES];
               [self stopSpin];
               [self alertStatus:@"Server Error"];
               return;

           }
           
               }
    }
    else
    {
        networkErrorView.hidden=NO;
    }
    
 
}

- (IBAction)COMMENT_ACTION:(id)sender
{
    if ([[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"image"] || [[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"profile_photo_update"] || [[[feed_array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"video"])
    {
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, comment_bg_view.frame.size.height - 50, comment_bg_view.frame.size.width, 50)];
    containerView.backgroundColor=[styles colorWithHexString:text_bg_color];
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 7, 240, 50)];
    textView.layer.cornerRadius=4.0;
    textView.layer.borderColor=[UIColor clearColor].CGColor;
    textView.layer.borderWidth=1.0;
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
        
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
        
    textView.returnKeyType = UIReturnKeyDefault; //just as an e xample
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Type your comments....";
    
    [self.view addSubview:containerView];
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [containerView addSubview:textView];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(containerView.frame.size.width - 57, 4, 42, 42);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:@"" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"fling.png"] forState:UIControlStateNormal];
        
    //[doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
        
    [containerView addSubview:doneBtn];
    [comment_bg_view addSubview:containerView];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    backgroundview=[[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:backgroundview];
    [self.view addSubview:comment_bg_view];
    comment_bg_view.hidden=NO;
    }
}
- (IBAction)LIKE_ACTION:(id)sender
{
    NSLog(@"IN LIKE FUNCtION");
    @try {
        
        like_btn.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            like_btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
        }];
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            if ([connectobj string_check:TOKEN]==true &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:[[[feed_array objectAtIndex:0] objectForKey:@"post_id"]integerValue]]==true &&[connectobj int_check:[[[feed_array objectAtIndex:0] objectForKey:@"poster_id"]integerValue]]==true)
            {
                
                networkErrorView.hidden=YES;
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[[[feed_array objectAtIndex:0] objectForKey:@"post_id"]integerValue]] forKey:@"post_id"];
                [param setObject:[NSNumber numberWithInteger:[[[feed_array objectAtIndex:0] objectForKey:@"poster_id"]integerValue]] forKey:@"poster_id"];
                // [param setObject:@"like" forKey:@"type"];
                
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/feedlikeunlike?"];
                
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
                NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"URL STR IS :%@",jsonString);
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
                
                NSOperationQueue *like_queue = [[NSOperationQueue alloc] init];
                like_queue.maxConcurrentOperationCount=1;
                
                
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:like_queue
                                       completionHandler:^(NSURLResponse *response,
                                                           NSData *data,
                                                           NSError *connectionError) {
                                           if (data==nil || [data isEqual:[NSNull null]])
                                           {
                                               
                                           }
                                           else
                                           {
                                               NSLog(@"RESPONSE :%@",response);
                                               NSDictionary *json =
                                               [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
                                               
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               if(status==1)
                                               {
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       if ([[json objectForKey:@"type"] isEqualToString:@"like"])
                                                       {
                                                           [like_btn setTitleColor:[styles colorWithHexString:blueButton] forState:UIControlStateNormal];
                                                       }
                                                       else  if ([[json objectForKey:@"type"] isEqualToString:@"unlike"])
                                                       {
                                                           [like_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                                                       }
                                                       
                                                       like_count.text=[json objectForKey:@"post_total_like_count"];
                                                       
                                                       
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
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                               });
                                               
                                           }
                                           
                                       }];

                
            }
            else
            {
                [HUD hide:YES];
                [self stopSpin];
                [self alertStatus:@"Server Error"];
                return;
            }

            
            
        }
        else
        {
            networkErrorView.hidden=NO;
            [HUD hide:YES];
            [self stopSpin];

        }
    }
    @catch (NSException *exception) {
    }

}

- (IBAction)DONE_ACTION:(id)sender
{
    
    [backgroundview removeFromSuperview];
    comment_bg_view.hidden=YES;
    [textView resignFirstResponder];
}

-(id)init
{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}




-(void)resignTextView
{
    POP_UP_COMMENT_FLAG=1;
    [self SEND:nil];
    textView.text=@"";
    [textView resignFirstResponder];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion

     
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)-75;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
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
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 60, 320, 420)];
    }
    else
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 60, 320, 508)];
    }
    t_view.backgroundColor=[UIColor blackColor];
    t_view.alpha=.2;
    t_view.hidden=NO;
    [self.view addSubview:t_view];
    
    t_view_1=[[UIView alloc]initWithFrame:CGRectMake(110, 209,
                                                     100, 100)];
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



-(void)showPageLoader_send
{
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    else
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }
    t_view.backgroundColor=[UIColor blackColor];
    t_view.alpha=.2;
    t_view.hidden=NO;
    [self.view addSubview:t_view];
    
    t_view_1=[[UIView alloc]initWithFrame:CGRectMake(110, 209,
                                                     100, 100)];
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


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
    //text_bg_view.hidden=YES;
    
    /////////////////////////////////////// FLASH VIEW //////////////////////////////////////////////
    
    flash_view=[[UIView alloc]initWithFrame:CGRectMake(5, 280, 310, 50)];
    flash_view.layer.cornerRadius=8.0;
    flash_view.clipsToBounds=YES;
    flash_view.backgroundColor=[UIColor blackColor];
    flash_view.alpha=.3;
    flash_label =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 310, 40)];
    flash_label.textAlignment=NSTextAlignmentCenter;
    flash_label.numberOfLines=1.0;
    flash_label.font=[UIFont fontWithName:@"Open Sans" size:15];
    //flash_label.text=@"You started following this person";
    flash_label.textColor=[UIColor whiteColor];
    [flash_view addSubview:flash_label];
    [self.view addSubview:flash_view];
    flash_view.hidden=YES;
    
}

-(void)show_flash_view:(NSString *)flash_message
{
    flash_label.text=flash_message;
    flash_view.hidden = NO;
    flash_view.alpha = 0.1;
    [UIView animateWithDuration:2 animations:^{
        flash_view.alpha = 0.50f;
    } completion:^(BOOL finished) {
        // do some
    }];
    
    
    [UIView animateWithDuration:2 animations:^{
        // flash_view.frame =  CGRectMake(130, 30, 0, 0);
        [flash_view setAlpha:0.1f];
    } completion:^(BOOL finished)
     {
         flash_view.hidden = YES;
     }];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([[UIScreen mainScreen]bounds].size.height ==480)
    {
        comment_bg_view.frame=CGRectMake(3, 25, 314, 450);
        image_comment_table.frame=CGRectMake(3, 59, 308, 344);
        text_bg_view.frame=CGRectMake(0, 430, 320, 46);
        report_abuse_view.frame=CGRectMake(8, 70, 304, 364);
        
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did end decelerating");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   // [post_textview resignFirstResponder];
  //  [textView resignFirstResponder];
    
        //    NSLog(@"Did scroll");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    NSLog(@"Did end dragging");
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did begin decelerating");
}

- (void)REPORT_FEED:(id)sender
{

    
    
}
-(void)HIDE_REPORT_ABUSE :(id)sender
{
    [backgroundview removeFromSuperview];
    report_abuse_view.hidden=YES;
}
-(IBAction)CHECK_BOX:(UIButton *)sender
{
    if (sender.tag==0)
    {
        [button_one setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        [button_two setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        [button_three setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        [button_four setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        abuse_description=@"It's spam";
    }
    else if (sender.tag==1)
    {
        abuse_description=@"It's annoying";
        [button_two setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        [button_one setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        [button_three setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        [button_four setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
    }
    else if (sender.tag==2)
    {
        abuse_description=@"Nudity";
        [button_three setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        [button_one setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        [button_two setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        [button_four setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
    }
    
    else if (sender.tag==3)
    {
        abuse_description=@"I think it sounds violence";
        [button_four setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        [button_one setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        [button_three setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        [button_two setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)REPORT_SUBMIT:(id)sender
{
    NSLog(@"DES: %@",abuse_description);
    if ([abuse_description isEqualToString:@""] || abuse_description==Nil || [abuse_description isEqual:[NSNull null]])
    {
        [self alertStatus:@"Select a Problem"];
        return ;
    }
    
    else
    {
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            
            [self showPageLoader];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:Post_id] forKey:@"subject_id"];
            [param setObject:@"post" forKey:@"subject_type"];
            [param setObject:abuse_description forKey:@"description"];
            
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/reportabuse"];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"URL STR IS :%@",jsonString);
            
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
                                           [self stopSpin];
                                           [backgroundview removeFromSuperview];
                                           report_abuse_view.hidden=YES;
                                       }
                                       else
                                       {
                                           NSLog(@"REPORT RESPONSE :%@",response);
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           NSLog(@"REPORT RESULT  is :%@",json);
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               NSLog(@"REPORT SUCCESS");
                                                [self stopSpin];
                                               [backgroundview removeFromSuperview];
                                               report_abuse_view.hidden=YES;
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   abuse_description=@"";
                                                   [button_two setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
                                                   [button_one setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
                                                   [button_three setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
                                                   [button_four setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
                                                   [self show_flash_view:@"Post has been reported"];
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
                                               [self stopSpin];
                                               [backgroundview removeFromSuperview];
                                               report_abuse_view.hidden=YES;
                                               
                                               
                                           }

                                           
                                       }
                                       if (connectionError)
                                       {
                                           
                                           NSLog(@"error detected:%@", connectionError.localizedDescription);
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [HUD hide:YES];
                                               [self stopSpin];
                                           });
                                           
                                       }
                                   }];
        }
        else
        {
        }
    }
    
    
}


- (IBAction)REPORT_ABUSE:(id)sender
{
    backgroundview=[[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:backgroundview];
    [self.view addSubview:report_abuse_view];
    backgroundview.userInteractionEnabled=YES;
    report_abuse_view.hidden=NO;
    UITapGestureRecognizer *gestureView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HIDE_REPORT_ABUSE:)];
    [backgroundview addGestureRecognizer:gestureView];
}
@end
