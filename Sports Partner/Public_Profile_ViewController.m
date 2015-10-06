//
//  Public_Profile_ViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 26/09/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "Public_Profile_ViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "AFNetworking.h"
#import "FollowerViewController.h"
#import "ChatViewController.h"
#import "ViewController.h"
#import "DWBubbleMenuButton.h"
#define kDefaultAnimationDuration 0.25f


@interface Public_Profile_ViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) NSMutableArray *buttonContainer;
@property (nonatomic, assign) CGRect originFrame;

@end

@implementation Public_Profile_ViewController
@synthesize USER_ID,TARGETED_USER_ID,TOKEN,UN_FOLLOW_FLAG,FOLLOW_FLAG,public_profile_view,CHAT_FLAG,LIKE_FLAG,FEED_FLAG;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];
    
    self.screenName=@"Sp public Profile";
    style=[[Styles alloc]init];
    connectobj=[[connection alloc]init];
    user_details_array=[[NSMutableArray alloc]init];
    favourite_sports_array=[[NSMutableArray alloc]init];
    
    name_label.font=[UIFont fontWithName:@"Roboto-Bold" size:25];
    name_label.textColor=[UIColor whiteColor];
    place_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    place_label.textColor=[UIColor whiteColor];
    age_label.textColor=[style colorWithHexString:age_color];
    age_label.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    place_label.shadowColor=[style colorWithHexString:@"7F000000"];
    name_label.shadowColor=[style colorWithHexString:@"7F000000"];
    
    UN_FOLLOW_FLAG=0;
    FOLLOW_FLAG=0;
    
    LIKE_FLAG=0;
    
    ///////// FAVOURITE SPORTS //////////
    
    fav_sports_view.layer.borderColor=[UIColor whiteColor].CGColor;
    fav_sports_view.layer.borderWidth=2.0;
    fav_sports_view.layer.cornerRadius=4.0;
    fav_sports_view.layer.masksToBounds=YES;
    sports_tbl.backgroundColor=[UIColor clearColor];
    fav_sports_label.font=[UIFont fontWithName:@"Roboto-Regular" size:19];
    
    ///////// REPORT ABUSE SPORTS //////////
    
    report_abuse_view.layer.borderColor=[UIColor whiteColor].CGColor;
    report_abuse_view.layer.borderWidth=2.0;
    report_abuse_view.layer.cornerRadius=4.0;
    report_abuse_view.layer.masksToBounds=YES;
    
    abuse_heading_one.font=[UIFont fontWithName:@"Roboto-Regular" size:16];
    abuse_heading_two.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    abuse_label_one.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    abuse_label_two.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    abuse_label_three.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    abuse_label_four.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    
    report_submit_button.layer.borderColor=[UIColor whiteColor].CGColor;
    report_submit_button.layer.borderWidth=2.0;
    report_submit_button.layer.cornerRadius=4.0;
    report_submit_button.layer.masksToBounds=YES;
    
    public_profile_view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"settings-BG.png"]];
    public_prf_pic.contentMode=UIViewContentModeScaleAspectFit;
    
    
//    chat_button.imageView.layer.cornerRadius = 7.0f;
//    chat_button.layer.shadowRadius = 5.0f;
//    chat_button.layer.shadowColor = [UIColor blackColor].CGColor;
//    chat_button.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    chat_button.layer.shadowOpacity = 1.5f;
//    chat_button.layer.masksToBounds = NO;
//    
//    eye_button.imageView.layer.cornerRadius = 7.0f;
//    eye_button.layer.shadowRadius = 5.0f;
//    eye_button.layer.shadowColor = [UIColor blackColor].CGColor;
//    eye_button.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    eye_button.layer.shadowOpacity = 1.5f;
//    eye_button.layer.masksToBounds = NO;
//    
//    star_button.imageView.layer.cornerRadius = 7.0f;
//    star_button.layer.shadowRadius = 5.0f;
//    star_button.layer.shadowColor = [UIColor blackColor].CGColor;
//    star_button.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    star_button.layer.shadowOpacity = 1.5f;
//    star_button.layer.masksToBounds = NO;
//    
//    repoert_abuse_button.imageView.layer.cornerRadius = 7.0f;
//    repoert_abuse_button.layer.shadowRadius = 5.0f;
//    repoert_abuse_button.layer.shadowColor = [UIColor blackColor].CGColor;
//    repoert_abuse_button.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    repoert_abuse_button.layer.shadowOpacity = 1.5f;
//    repoert_abuse_button.layer.masksToBounds = NO;
    
    sports_tbl.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    Back_Button.hidden=YES;
    if (FEED_FLAG==1 || FEED_FLAG==2)
    {
        Back_Button.hidden=NO;
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
        
        recognizer.direction = UISwipeGestureRecognizerDirectionUp;
        recognizer.numberOfTouchesRequired = 1;
        recognizer.delegate = self;
        self.view.userInteractionEnabled=YES;
        [self.view addGestureRecognizer:recognizer];
        
        UISwipeGestureRecognizer *recognizer_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer_down:)];
        recognizer_down.direction = UISwipeGestureRecognizerDirectionDown;
        recognizer_down.numberOfTouchesRequired = 1;
        recognizer_down.delegate = self;
        self.view.userInteractionEnabled=YES;
        [self.view addGestureRecognizer:recognizer_down];
    }
   

}
- (void) SwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE LEFT ***");
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE RIGHT ***");
        
    }
    if ( sender.direction== UISwipeGestureRecognizerDirectionUp )
    {
        NSLog(@"SWIPE UP");
       

        [self swipe_up:self.view];
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionDown ){
        
        NSLog(@" *** SWIPE DOWN ***");
        
    }
}
- (void) SwipeRecognizer_down:(UISwipeGestureRecognizer *)sender {
    
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE LEFT ***");
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE RIGHT ***");
        
    }
    if ( sender.direction== UISwipeGestureRecognizerDirectionUp )
    {
        
        //public_profile_view.hidden=YES;
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionDown )
    {
        
        NSLog(@" *** SWIPE DOWN ***");
        [self swipe_down:self.view];
        
    }
}

-(void)GET_TARGET_USER_PROFILE
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
    networkErrorView.hidden=YES;
        [self showPageLoader];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
    [param setObject:TOKEN forKey:@"token"];
    [param setObject:[NSNumber numberWithInteger:[TARGETED_USER_ID integerValue]] forKey:@"target_user_id"];
    NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/getuserdetails?"];
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
                                   
                                       [HUD hide:YES];
                                       [self stopSpin];
                                 
                               }
                               else
                               {
                                   NSDictionary *json =
                                   [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:nil];
                                   NSLog(@"DETAIL : %@",json);
                                    NSInteger status=[[json objectForKey:@"status"] intValue];
                                   
                                   if(status==1)
                                   {
                                       
                                           
                                           [HUD hide:YES];
                                           [self stopSpin];
                                           user_details_array=[json objectForKey:@"results"];
                                       
                                    //
                                   
                                       homeLabel = [self createHomeButtonView];
                                       if ([UIScreen mainScreen].bounds.size.height==480)
                                       {
                                           upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(139,
                                                                                                             425,
                                                                                                             177,
                                                                                                             50.0)
                                                                               expansionDirection:DirectionUp];
                                       }
                                       else
                                       {
                                        [upMenuView removeFromSuperview];
                                       upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(139,
                                                                                                                             self.view.frame.size.height - homeLabel.frame.size.height,
                                                                                                                             177,
                                                                                                                             50.0)
                                                                                               expansionDirection:DirectionUp];
                                       }
                                      
                                       upMenuView.homeButtonView = homeLabel;
                                       [upMenuView addButtons:[self createDemoButtonArray]];
                                       [self.view addSubview:upMenuView];
                                       
                                       //tag_label.frame=CGRectMake(7, 467, 305, 48);
                                           name_label.attributedText=[self GET_SHADOW_STRING:[[user_details_array objectAtIndex:0] objectForKey:@"search_user_name"]];
                                           place_label.attributedText=[self GET_SHADOW_STRING_FLASH:[[user_details_array objectAtIndex:0] objectForKey:@"search_user_location"]];
                                       
                                      
                                       if ([[[user_details_array objectAtIndex:0] objectForKey:@"search_user_tagline"] isEqualToString:@""])
                                       {
                                           tag_label.attributedText=[self GET_SHADOW_STRING_FLASH:@"Let's do it!!!"];
                                       }
                                       else
                                       {
                                           tag_label.attributedText=[self GET_SHADOW_STRING_FLASH:[[user_details_array objectAtIndex:0] objectForKey:@"search_user_tagline"]];
                                       }

                                       //tag_label.lineBreakMode = NSLineBreakByWordWrapping;
                                       tag_label.numberOfLines=0;
                                       [tag_label sizeToFit];
                                       if([UIScreen mainScreen].bounds.size.height==480)
                                       {
                                           NSLog(@"IN IPHONE 4");
                                            place_label.frame=CGRectMake(35, 430, 258, 21);
                                             tag_label.frame=CGRectMake(7, 430-tag_label.frame.size.height-10, 304, tag_label.frame.size.height);
                                            age_label.frame=CGRectMake(7, 428, 25, 25);
                                       }
                                       else
                                       {
                                       place_label.frame=CGRectMake(35, 521, 258, 21);
                                       tag_label.frame=CGRectMake(7, 520-tag_label.frame.size.height-10, 304, tag_label.frame.size.height);
                                            age_label.frame=CGRectMake(7, 518, 25, 25);
                                       }
                                       
                                     
                                       
                                       name_label.frame=CGRectMake(7, tag_label.frame.origin.y-34-6, 264, 34);
                                       
                                      
                                       
                                     //  place_label.frame=CGRectMake(35, tag_label.frame.size.height+tag_label.frame.origin.y+5, 258, 21);
                                       
                                           Chat_status_id=[NSString stringWithFormat:@"%@",[[user_details_array objectAtIndex:0] objectForKey:@"search_user_chat_status"]];
                                        if([[[user_details_array objectAtIndex:0]objectForKey:@"search_user_gender"] isEqualToString:@"Male"])
                                        {
//                                                age_label.text=@"M";
//                                                age_label.textColor=[style colorWithHexString:@"0C6DB4"];
                                            age_label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ml.png"]];
                                        }
                                        else
                                        {
//                                            age_label.text=@"F";
//                                            age_label.textColor=[style colorWithHexString:age_color];
                                             age_label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fl.png"]];
                                        }
                                       
                                           if ([[NSString stringWithFormat:@"%@",[[user_details_array objectAtIndex:0]objectForKey:@"search_user_propic"]] isEqualToString:@"0"])
                                           {
                                               public_prf_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
                                               like_button.hidden=YES;
                                               repoert_abuse_button.hidden=YES;
                                               
                                           }
                                           else
                                           {
                                               repoert_abuse_button.hidden=NO;
                                               
                                               NSString *url_str=[[user_details_array objectAtIndex:0]objectForKey:@"search_user_propic"];
                                               NSURL *image_url=[NSURL URLWithString:url_str];
                                               [public_prf_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"pro_pic_no_image.png"]];
                                               
                                               if ([[NSString stringWithFormat:@"%@",[[user_details_array objectAtIndex:0]objectForKey:@"search_user_propic_like_status"]] isEqualToString:@"liked"])
                                               {
                                                   
                                                   like_button.hidden=NO;
                                                   
                                               }
                                               else  if ([[NSString stringWithFormat:@"%@",[[user_details_array objectAtIndex:0]objectForKey:@"search_user_propic_like_status"]] isEqualToString:@"unliked"])
                                               {
                                                   
                                                   like_button.hidden=YES;
                                                   
                                               }
                                               
                                           }
                                           
                                           if ([[NSString stringWithFormat:@"%@",[[user_details_array objectAtIndex:0] objectForKey:@"search_user_propic"]] isEqualToString:@"0"])
                                           {
                                               public_prf_pic.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
                                               prof_pic_string=@"0";
                                           }
                                           else
                                           {
                                               NSString *url_str=[[user_details_array objectAtIndex:0] objectForKey:@"search_user_propic"];
                                               NSURL *image_url=[NSURL URLWithString:url_str];
                                               [public_prf_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"pro_pic_no_image.png"]];
                                               prof_pic_string=[[user_details_array objectAtIndex:0] objectForKey:@"search_user_propic"];
                                           }
                                           
                                           if([[[user_details_array objectAtIndex:0]objectForKey:@"search_user_follow_status"] isEqualToString:@"following"])
                                           {
                                               [eye_button setBackgroundImage:[UIImage imageNamed:@"b_follow-onclik@2x.png"] forState:UIControlStateNormal];
                                           }
                                           else if([[[user_details_array objectAtIndex:0]objectForKey:@"search_user_follow_status"] isEqualToString:@"Not following"])
                                           {
                                               
                                               [eye_button setBackgroundImage:[UIImage imageNamed:@"b_follow@2x.png"] forState:UIControlStateNormal];
                                           }
                                       
                                        NSLog(@"FFFFAVQW : %@",[[user_details_array objectAtIndex:0] objectForKey:@"search_user_sports"]);

                                           favourite_sports_array=[[user_details_array objectAtIndex:0] objectForKey:@"search_user_sports"];
                                           
                                    
                                       
                                   }
                                   else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                   {
                                       
                                           ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                           [self presentViewController:view_control animated:YES completion:nil];


                                   }


                               }
                               if (connectionError)
                               {
                                   
                                   NSLog(@"error detected:%@", connectionError.localizedDescription);
                                       [HUD hide:YES];
                                       [self stopSpin];
                                   
                               }
                               
                           }];
            
//             });
    }
    else
    {
        networkErrorView.hidden=NO;
    }
    

}
-(void)Clear
{

    [image_layer_down removeFromSuperlayer];
    [image_layer_up removeFromSuperlayer];
 
}


- (IBAction)BACK_ACTION:(id)sender
{
    [self.view removeFromSuperview];
    
    if (FEED_FLAG==2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:self];
    }
}

-(void)swipe_up:(UIView *)sender_view
{
    if ([prof_pic_string isEqualToString:@"0"])
    {
        
    }
    else
    {
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
   networkErrorView.hidden=YES;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:TOKEN forKey:@"token"];
    [param setObject:[NSNumber numberWithInt:USER_ID]forKey:@"user_id"];
    [param setObject:[NSNumber numberWithInteger:[TARGETED_USER_ID intValue]] forKey:@"like_user_id"];
    
    NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/profilephotolike?"];
    
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
                                   NSLog(@"STATUS ONE");
                                   
                                   NSMutableDictionary *dict_like=[json objectForKey:@"results"];
                                   NSLog(@"Ke:%@",dict_like);
                                   if ([[dict_like objectForKey:@"like_status"] isEqualToString:@"unliked"])
                                   {
                                       
                                       NSLog(@"STATUS UNLIKED ONE");
                                       LIKE_FLAG=2;
                                       NSLog(@"LIKE FLA:%ld",(long)LIKE_FLAG);
                                       flash_label.attributedText=[self GET_SHADOW_STRING_FLASH:@"You unliked this profile photo"];
                                       flash_view.hidden = NO;
                                       flash_view.alpha = 0.1;
                                       [UIView animateWithDuration:2 animations:^{
                                           flash_view.alpha = 0.50f;
                                       } completion:^(BOOL finished)
                                        {
                                            // do some
                                        }];
                                       
                                       
                                       [UIView animateWithDuration:2 animations:^{
                                           // flash_view.frame =  CGRectMake(130, 30, 0, 0);
                                           [flash_view setAlpha:0.1f];
                                       } completion:^(BOOL finished) {
                                           flash_view.hidden = YES;
                                       }];
                                       

                                       
                                       like_button.hidden=YES;
                                      
                                       [upMenuView removeFromSuperview];
                                       homeLabel = [self createHomeButtonView];
                                       homeLabel = [self createHomeButtonView];
                                       
                                       upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - homeLabel.frame.size.width - 10.f,
                                                                                                         self.view.frame.size.height - homeLabel.frame.size.height,
                                                                                                         50.0,
                                                                                                         50.0)
                                                                           expansionDirection:DirectionUp];
                                       upMenuView.homeButtonView = homeLabel;
                                       
                                       [upMenuView addButtons:[self createDemoButtonArray]];
                                       
                                       [self.view addSubview:upMenuView];

                                       
                                       
                                       
                                   }
                                   else if ([[dict_like objectForKey:@"like_status"] isEqualToString:@"liked"])
                                   {
                                       LIKE_FLAG=1;
                                       flash_label.attributedText=[self GET_SHADOW_STRING_FLASH:@"You liked this profile photo"];
                                       flash_view.hidden = NO;
                                       flash_view.alpha = 0.1;
                                       [UIView animateWithDuration:2 animations:^{
                                           flash_view.alpha = 0.50f;
                                       } completion:^(BOOL finished)
                                        {
                                            // do some
                                        }];
                                       
                                       
                                       [UIView animateWithDuration:2 animations:^{
                                           // flash_view.frame =  CGRectMake(130, 30, 0, 0);
                                           [flash_view setAlpha:0.1f];
                                       } completion:^(BOOL finished) {
                                           flash_view.hidden = YES;
                                       }];
                                       

                                       like_button.hidden=YES;
                                      
                                       
                                   }
                                   
                                   image_layer_up = [[CAShapeLayer alloc] init];
                                   image_layer_up.frame = public_prf_pic.bounds;
                                   image_layer_up.path = [self F_button_Corner:public_prf_pic].CGPath;
                                   image_layer_up.fillColor=[[[UIColor greenColor] colorWithAlphaComponent:0.1] CGColor];
                                   image_layer_up.shadowOpacity=0.0;
                                   [public_prf_pic.layer addSublayer:image_layer_up];
                                   CGRect frm_up = public_prf_pic.frame;
                                   frm_up.origin.y -=800;
                                   
                                   [UIView animateWithDuration:0.5
                                                         delay:0.5
                                                       options:UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseIn
                                                    animations:^{
                                                        sender_view.frame = frm_up;
                                                        
                                                    }
                                                    completion:NULL
                                    ];

                                   
                               }
                               else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                       [self presentViewController:view_control animated:YES completion:nil];
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
            networkErrorView.hidden=NO;
        }


       }
}

-(UIBezierPath *)F_button_Corner:(UIImageView *)button
{
    UIBezierPath *username_imageMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft)
                                                                                    cornerRadii:CGSizeMake(0.0, 0.0)];
    return username_imageMaskPathWithRadiusTop;
    
    
}

-(void)swipe_down:(UIView *)sender_view
{
    
    if (FEED_FLAG==2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:self];
    }

    image_layer_down = [[CAShapeLayer alloc] init];
    image_layer_down.frame = public_prf_pic.bounds;
    image_layer_down.path = [self F_button_Corner:public_prf_pic].CGPath;
    image_layer_down.fillColor=[[[UIColor redColor] colorWithAlphaComponent:0.1] CGColor];
    image_layer_down.shadowOpacity=0.0;
    [public_prf_pic.layer addSublayer:image_layer_down];
    LIKE_FLAG=0;
    CGRect frm_up = public_prf_pic.frame;
    frm_up.origin.y +=800;
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseIn
                     animations:^{
                         sender_view.frame = frm_up;
                         //[self.view removeFromSuperview];
                     }
                     completion:NULL
     
     ];
  
}
- (IBAction)CHAT_ACTION:(id)sender
{
   [self performSegueWithIdentifier:@"PUBLIC_CHAT" sender:nil];
}
- (IBAction)Fav_Sports_action:(id)sender
{
    
    backgroundview=[[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:backgroundview];
    [self.view addSubview:fav_sports_view];
    backgroundview.userInteractionEnabled=YES;
    fav_sports_view.hidden=NO;
    NSArray *comps = [name_label.text componentsSeparatedByString:@" "];
    
    NSString * first_word = [comps objectAtIndex:0];
    NSString *fav_sports=[first_word stringByAppendingString:@"'s Favourite Sports"];
    
    fav_sports_label.text=fav_sports;
    [sports_tbl reloadData];
    
    UITapGestureRecognizer *gestureView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HIDE_BLUR:)];
    [backgroundview addGestureRecognizer:gestureView];
    
}
-(void)HIDE_BLUR:(id)sender
{
    [backgroundview removeFromSuperview];
    fav_sports_view.hidden=YES;
    
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
-(void)HIDE_REPORT_ABUSE :(id)sender
{
    [backgroundview removeFromSuperview];
    report_abuse_view.hidden=YES;
}




-(void)doSomething
{
    [self performSegueWithIdentifier:@"PUBLIC_PROFILE_FOLLOW" sender:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"PUBLIC_PROFILE_FOLLOW"])
   
    {
        FollowerViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOKEN=TOKEN;
    }
    else if ([segue.identifier isEqualToString:@"PUBLIC_CHAT"])
    {
        ChatViewController *chatcontroller=segue.destinationViewController;
        chatcontroller.USER_ID=USER_ID;
        chatcontroller.TOKEN=TOKEN;
        chatcontroller.conversation_id=Chat_status_id;
        chatcontroller.RECEIVER_ID=TARGETED_USER_ID;
        chatcontroller.URL_STRING=prof_pic_string;
        chatcontroller.PUBLIC_PROFILE_FLAG=1;
    }

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
            networkErrorView.hidden=YES;
          
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:TOKEN forKey:@"token"];
        [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
       [param setObject:[NSNumber numberWithInteger:[TARGETED_USER_ID integerValue]]forKey:@"report_user_id"];
        [param setObject:[NSNumber numberWithInteger:[TARGETED_USER_ID integerValue]] forKey:@"subject_id"];
        [param setObject:@"user" forKey:@"subject_type"];
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
                                       
                                       [backgroundview removeFromSuperview];
                                       report_abuse_view.hidden=YES;
                                       
                                       flash_label.attributedText=[self GET_SHADOW_STRING_FLASH:@"User has been reported"];
                                       flash_view.hidden = NO;
                                       flash_view.alpha = 0.1;
                                       [UIView animateWithDuration:2 animations:^{
                                           flash_view.alpha = 0.50f;
                                       } completion:^(BOOL finished)
                                        {
                                            // do some
                                        }];
                                       
                                       
                                       [UIView animateWithDuration:2 animations:^{
                                           // flash_view.frame =  CGRectMake(130, 30, 0, 0);
                                           [flash_view setAlpha:0.1f];
                                       } completion:^(BOOL finished) {
                                           flash_view.hidden = YES;
                                       }];

                                       abuse_description=@"";
                                       [button_two setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
                                       [button_one setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
                                       [button_three setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
                                       [button_four setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
                                   }
                                   else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                           [self presentViewController:view_control animated:YES completion:nil];
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
            networkErrorView.hidden=NO;
        }
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

- (IBAction)FOLLOW_ACTION:(id)sender
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
    networkErrorView.hidden=YES;
    [self showPageLoader];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:TOKEN forKey:@"token"];
    [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
    [param setObject:[NSNumber numberWithInteger:[TARGETED_USER_ID intValue]] forKey:@"follow_user_id"];
        
     if([[[user_details_array objectAtIndex:0]objectForKey:@"search_user_follow_status"] isEqualToString:@"following"])
    {
        NSLog(@"FOLLOW");
        [param setObject:@"unfollow" forKey:@"type"];
    }
    else if([[[user_details_array objectAtIndex:0]objectForKey:@"search_user_follow_status"] isEqualToString:@"Not following"])
    {
        NSLog(@"UNFOLLOW");
        [param setObject:@"follow" forKey:@"type"];
    }
    [param setObject:@"IOS" forKey:@"OS"];
    NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/followunfollow?"];
    
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
                                   
                                       [HUD hide:YES];
                                       [self stopSpin];
                               }
                               else
                               {
                               
                               NSLog(@"FOLLOW RESPONSE :%@",response);
                               NSDictionary *json =
                               [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:nil];
                               NSLog(@"FOLLOW RESULT  is :%@",json);
                               
                               NSInteger status=[[json objectForKey:@"status"] intValue];
                               
                               if(status==1)
                               {
                                  
                                  
//                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if([[[user_details_array objectAtIndex:0]objectForKey:@"search_user_follow_status"] isEqualToString:@"following"])
                                       {
                                           if (FEED_FLAG==2)
                                           {
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"unfollow" object:self];
                                           }
                                           NSString *flash_string=@"You have stopped following ";
                                           flash_string=[flash_string stringByAppendingString:[[[user_details_array objectAtIndex:0] objectForKey:@"search_user_name"]capitalizedString]];
                                           flash_label.attributedText=[self GET_SHADOW_STRING_FLASH:flash_string];
                                           
                                           flash_view.hidden = NO;
                                           flash_view.alpha = 0.1;
                                           [UIView animateWithDuration:2 animations:^{
                                               flash_view.alpha = 0.5;
                                           } completion:^(BOOL finished) {
                                               // do some
                                           }];
                                           
                                           
                                           [UIView animateWithDuration:2 animations:^{
                                               // flash_view.frame =  CGRectMake(130, 30, 0, 0);
                                               [flash_view setAlpha:0.1f];
                                           } completion:^(BOOL finished) {
                                               flash_view.hidden = YES;
                                           }];

                                           
                                           NSLog(@"IN FOLLOW");
                                           UN_FOLLOW_FLAG=1;
                                           FOLLOW_FLAG=0;
                                           [eye_button setBackgroundImage:[UIImage imageNamed:@"b_follow.png"] forState:UIControlStateNormal];
                                           
                                           user_details_array=[user_details_array mutableCopy];
                                           NSMutableDictionary *entry = [[user_details_array objectAtIndex:0]mutableCopy];
                                           follow_status=@"Not following";
                                           [entry setObject:@"Not following" forKey:@"search_user_follow_status"];
                                           [entry mutableCopy];
                                           [user_details_array replaceObjectAtIndex:0 withObject:entry];
                                           
                                       }
                                       else if([[[user_details_array objectAtIndex:0]objectForKey:@"search_user_follow_status"] isEqualToString:@"Not following"])
                                       {
                                           
                                           if (FEED_FLAG==2)
                                           {
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"follow" object:self];
                                           }
                                           NSString *flash_string=@"You started following ";
                                           flash_string=[flash_string stringByAppendingString:[[[user_details_array objectAtIndex:0] objectForKey:@"search_user_name"]capitalizedString]];
                                           
                                           flash_label.attributedText=[self GET_SHADOW_STRING_FLASH:flash_string];
                                           flash_view.hidden = NO;
                                           flash_view.alpha = 0.1;
                                           [UIView animateWithDuration:2 animations:^{
                                               flash_view.alpha = 0.5;
                                           } completion:^(BOOL finished) {
                                               // do some
                                           }];
                                           
                                           
                                           [UIView animateWithDuration:2 animations:^{
                                               // flash_view.frame =  CGRectMake(130, 30, 0, 0);
                                               [flash_view setAlpha:0.1f];
                                           } completion:^(BOOL finished) {
                                               flash_view.hidden = YES;
                                           }];

                                           NSLog(@"IN NOT FOLLOW");
                                           UN_FOLLOW_FLAG=0;
                                           FOLLOW_FLAG=1;
                                           [eye_button setBackgroundImage:[UIImage imageNamed:@"b_follow-onclik.png"] forState:UIControlStateNormal];
                                           
                                           user_details_array=[user_details_array mutableCopy];
                                           NSMutableDictionary *entry = [[user_details_array objectAtIndex:0]mutableCopy];
                                           follow_status=@"following";
                                           [entry setObject:@"following" forKey:@"search_user_follow_status"];
                                           [entry mutableCopy];
                                           [user_details_array replaceObjectAtIndex:0 withObject:entry];

                                           
                                       }
                                       
                                       
                                       [HUD hide:YES];
                                       [self stopSpin];

//                                   });
                                   
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
                                       
//                                       dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                           [HUD hide:YES];
                                           [self stopSpin];
                                           
//                                       });

                                       
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
//             });
    }
    else
    {
        networkErrorView.hidden=NO;
    }
    
}

- (IBAction)LIKE_ACTION:(id)sender
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:TOKEN forKey:@"token"];
    [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
    [param setObject:[NSNumber numberWithInteger:[TARGETED_USER_ID intValue]] forKey:@"like_user_id"];
    
    NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/profilephotolike?"];
    
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
                                   NSLog(@"LIKE SUCCESS");
                                    NSMutableDictionary *dict_like=[json objectForKey:@"results"];
                                   if ([[dict_like objectForKey:@"like_status"] isEqualToString:@"unliked"])
                                   {
                                       
                                       flash_label.attributedText=[self GET_SHADOW_STRING_FLASH:@"You unliked this profile photo"];
                                       flash_view.hidden = NO;
                                       flash_view.alpha = 0.1;
                                       [UIView animateWithDuration:2 animations:^{
                                           flash_view.alpha = 0.50f;
                                       } completion:^(BOOL finished)
                                        {
                                            // do some
                                        }];
                                       
                                       
                                       [UIView animateWithDuration:2 animations:^{
                                           // flash_view.frame =  CGRectMake(130, 30, 0, 0);
                                           [flash_view setAlpha:0.1f];
                                       } completion:^(BOOL finished) {
                                           flash_view.hidden = YES;
                                       }];
                                       

                                       like_button.hidden=YES;
                                       user_details_array=[user_details_array mutableCopy];
                                       NSMutableDictionary *entry = [[user_details_array objectAtIndex:0]mutableCopy];
                                       [entry setObject:@"unliked" forKey:@"search_user_propic_like_status"];
                                       [entry mutableCopy];
                                       [user_details_array replaceObjectAtIndex:0 withObject:entry];
                                       NSLog(@"LIKEEE");
                                       [upMenuView removeFromSuperview];
                                       UILabel *homeLabel;
                                       homeLabel = [self createHomeButtonView];

                                       if ([UIScreen mainScreen].bounds.size.height==480)
                                       {
                                           upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(139,
                                                                                                             425,
                                                                                                             177,
                                                                                                             50.0)
                                                                               expansionDirection:DirectionUp];
                                       }
                                       else
                                       {
                                           [upMenuView removeFromSuperview];
                                           upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(139,
                                                                                                             self.view.frame.size.height - homeLabel.frame.size.height,
                                                                                                             177,
                                                                                                             50.0)
                                                                               expansionDirection:DirectionUp];
                                       }
                                      
                                       upMenuView.homeButtonView = homeLabel;
                                       
                                       [upMenuView addButtons:[self createDemoButtonArray]];
                                       
                                       [self.view addSubview:upMenuView];

                                   }
                                   else if ([[dict objectForKey:@"like_status"] isEqualToString:@"liked"])
                                   {
                                       flash_label.attributedText=[self GET_SHADOW_STRING_FLASH:@"You liked this profile photo"];
                                       flash_view.hidden = NO;
                                       flash_view.alpha = 0.1;
                                       [UIView animateWithDuration:2 animations:^{
                                           flash_view.alpha = 0.50f;
                                       } completion:^(BOOL finished)
                                        {
                                            // do some
                                        }];
                                       
                                       
                                       [UIView animateWithDuration:2 animations:^{
                                           // flash_view.frame =  CGRectMake(130, 30, 0, 0);
                                           [flash_view setAlpha:0.1f];
                                       } completion:^(BOOL finished) {
                                           flash_view.hidden = YES;
                                       }];
                                       

                                       like_button.hidden=NO;
                                       user_details_array=[user_details_array mutableCopy];
                                       NSMutableDictionary *entry = [[user_details_array objectAtIndex:0]mutableCopy];
                                       [entry setObject:@"liked" forKey:@"search_user_propic_like_status"];
                                       [entry mutableCopy];
                                       [user_details_array replaceObjectAtIndex:0 withObject:entry];
                                       
                                   }

                                   
                               }
                               else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                       [self presentViewController:view_control animated:YES completion:nil];
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
        networkErrorView.hidden=NO;
    }
    
}

#pragma TABLEVIEW SECTION

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return favourite_sports_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSString *CELLIDENTIFIER=@"CELL";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[favourite_sports_array objectAtIndex:indexPath.row]];
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
        return cell;
        
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];

    NSLog(@"CHAT BACK");
   
    if (CHAT_FLAG==1)
    {
        NSLog(@"CHAT FLAG ONE");
        if ([[UIScreen mainScreen]bounds].size.height !=568)
        {
            public_profile_view.frame=CGRectMake(0, 16, 320, 464);
        }
        else
        {
        public_profile_view.frame=CGRectMake(0, 36, 320, 552);
        }
    }
    [self GET_TARGET_USER_PROFILE];
    flash_view=[[UIView alloc]initWithFrame:CGRectMake(10, 280, 300, 50)];
    flash_view.layer.cornerRadius=8.0;
    flash_view.clipsToBounds=YES;
    flash_view.backgroundColor=[UIColor blackColor];
    flash_view.alpha=.3;
    flash_label =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 300, 40)];
    flash_label.textAlignment=NSTextAlignmentCenter;
    flash_label.numberOfLines=2.0;
    flash_label.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    //flash_label.text=@"You started following this person";
    flash_label.textColor=[UIColor whiteColor];
    [flash_view addSubview:flash_label];
    [self.view addSubview:flash_view];
    flash_view.hidden=YES;
    
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        public_profile_view.frame=CGRectMake(0, 16, 320, 464);
        public_prf_pic.frame=CGRectMake(0, 16, 320, 464);
        name_label.frame=CGRectMake(10, 380, 279, 34);
        age_label.frame=CGRectMake(10, 415, 25, 21);
        place_label.frame=CGRectMake(38, 415, 258, 21);
    }
    sports_tbl.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    
    
    
//    DWBubbleMenuButton *downMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(20.f,
//                                                                                              20.f,
//                                                                                              homeLabel.frame.size.width,
//                                                                                              homeLabel.frame.size.height)
//                                                                expansionDirection:DirectionDown];
//    downMenuButton.homeButtonView = homeLabel;
//    
//    [downMenuButton addButtons:[self createDemoButtonArray]];
//    
//    [self.view addSubview:downMenuButton];
//    
    // Create up menu button
    
    }

- (UILabel *)createHomeButtonView
{
    
    NSLog(@"YUIYIU");
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(125.f, 0.f, 50.f, 50.f)];

    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.layer.cornerRadius = label.frame.size.height / 2.f;
   // label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"b_view.png"]];
 
   label.clipsToBounds = YES;
    
    return label;
}

- (NSArray *)createDemoButtonArray
{
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    chat_button.hidden=NO;
    NSLog(@"Buttons:%@",chat_button);
     NSLog(@"Buttons1:%@",repoert_abuse_button);
     NSLog(@"Buttons2:%@",eye_button);
    
    
        if ([[NSString stringWithFormat:@"%@",[[user_details_array objectAtIndex:0]objectForKey:@"search_user_propic_like_status"]] isEqualToString:@"liked"])
        {
          //  buttonsMutable = [NSMutableArray arrayWithObjects:chat_button,eye_button,like_button, star_button, repoert_abuse_button , nil];
            buttonsMutable=[[NSMutableArray alloc]initWithObjects:chat_button,eye_button,like_button, star_button, repoert_abuse_button , nil];
            NSLog(@"INLIKE");
            
        }
        else  if ([[NSString stringWithFormat:@"%@",[[user_details_array objectAtIndex:0]objectForKey:@"search_user_propic_like_status"]] isEqualToString:@"unliked"])
        {
          //  buttonsMutable = [NSMutableArray arrayWithObjects:chat_button,eye_button, star_button, repoert_abuse_button , nil];
            NSLog(@"NOTLIKE");
             buttonsMutable=[[NSMutableArray alloc]initWithObjects:chat_button,eye_button, star_button, repoert_abuse_button , nil];
        }
        
    NSLog(@"button array count:%d",buttonsMutable.count);
      return [buttonsMutable copy];
}

- (void)test:(UIButton *)sender
{

}

- (UIButton *)createButtonWithName:(NSString *)imageName
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (BOOL)prefersStatusBarHidden
{
    return true;
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
       
    }
}
////////////// LODER//////////////////

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

-(NSAttributedString *)GET_SHADOW_STRING:(NSString *)string_value
{
    NSString *str = [string_value capitalizedString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    UIFont *font =[UIFont fontWithName:@"Roboto-Regular" size:25];
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


-(NSAttributedString *)GET_SHADOW_STRING_FLASH:(NSString *)string_value
{
    NSString *str = string_value;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    UIFont *font =[UIFont fontWithName:@"Roboto-Regular" size:16];
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


//////////////////// MENU ACCTION ///////////////////



@end
