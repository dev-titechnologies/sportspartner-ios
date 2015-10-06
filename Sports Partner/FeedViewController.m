//
//  FeedViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 08/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "FeedViewController.h"
#import "UIImage+PolygonMasking.h"
#import "UIBezierPath+ZEPolygon.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "AFTableViewCell.h"
#import "SettingViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "ProfileViewController.h"
#import "DetailFeedViewController.h"
#import "SBJSON.h"
#import "CTAssetsPickerController.h"
#import "CTAssetsPageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"
#import "SVPullToRefresh.h"
#import "Public_Profile_ViewController.h"

#import "GAITrackedViewController.h"
#import "MessageViewController.h"

#define INPUT_HEIGHT 40.0f
#define kFontSize 15.0 // fontsize
#define kTextViewWidth 310


@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize TOCKEN,USER_ID,DETAIL_FLAG,index_count,Feed_post_Flag,model,reported_feed_id;

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
   // [text_post_field sizeToFit];
   self.screenName = @"SP News Feed";
    post_button.hidden=YES;
    clarity_image_array=[[NSMutableArray alloc]init];
    SERVER_FLAG=1;
    DB_FLAG=0;
    imageCache=[[NSCache alloc]init];
    Comment_flag=0;
    __weak FeedViewController *weakSelf = self;
    
    [feed_table addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(insertRowAtBottom) withObject:nil afterDelay:1.0];
    }];
    
    [feed_table addPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(insertRowAtTop) withObject:nil afterDelay:1.0];
    }];
     feed_post_scroll.contentSize=CGSizeMake(320, 480);
    page_number=0;
    comment_list_array=[[NSMutableArray alloc]init];
    comment_bg_view.backgroundColor=[UIColor whiteColor];
    comment_bg_view.layer.cornerRadius=4.0;
    comment_bg_view.layer.masksToBounds=YES;
    comments_label.font=[UIFont fontWithName:@"Roboto-Bold" size:19];
    no_feed_label.font=[UIFont fontWithName:@"Roboto-Regular" size:18];
    done_button.titleLabel.font=[UIFont fontWithName:@"Roboto-Bold" size:18];
    comment_bg_view.hidden=YES;
      self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"follower_bg.png"]];
    image_array_1=[[NSMutableArray alloc]init];
    sqlfunction=[[SQLFunction alloc]init];
    IMAGE_DICT=[[NSMutableDictionary alloc]init];
    sub_image_array=[[NSMutableArray alloc]init];
    im_name=[[NSMutableArray alloc]init];
    connectobj=[[connection alloc]init];
    feed_array=[[NSMutableArray alloc]init];
    style=[[Styles alloc]init];
    
    
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];
    
    header_label.backgroundColor=[style colorWithHexString:@"042e5f"];
    

   
    CGSize tabBarSize = [tabbar frame].size;
    UIView	*tabBarFakeView = [[UIView alloc] initWithFrame:
                               CGRectMake(0,0,tabBarSize.width, tabBarSize.height)];
    [tabbar insertSubview:tabBarFakeView atIndex:0];
    
    
    [tabBarFakeView setBackgroundColor:[style colorWithHexString:@"f2e7ea"]];
     tabbar_border_label.backgroundColor=[style colorWithHexString:@"e80243"];
    
    
    
    tabbar.translucent=YES;
    
    [tabbar setSelectedItem:[tabbar.items objectAtIndex:0]];
    follow_friend.backgroundColor=[style colorWithHexString:terms_of_services_color];
    [follow_friend.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];

    UIImage *maskedImage = [[UIImage imageNamed:@"girl.png"] imageMaskedWithPolygonWithNumberOfSides:6];
    profile_pic.image=maskedImage;
    
    //////////// PROFILE DETAILS////////////
    
    name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
    name_label.shadowColor=[style colorWithHexString:@"7F000000"];
    age_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    age_label.textColor=[style colorWithHexString:age_color];
    place_label.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    place_label.shadowColor=[style colorWithHexString:@"7F000000"];
    
    ///////////// FEED POST //////////////////////////////////
    
    Australia_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    Australia_label.textColor=[style colorWithHexString:@"adb4c9"];
    view1.backgroundColor=[style colorWithHexString:@"d1d1d1"];
    view3.backgroundColor=[style colorWithHexString:@"d1d1d1"];
    view2.backgroundColor=[style colorWithHexString:@"d1d1d1"];
    
    post_button.layer.cornerRadius=4.0;
    post_button.layer.masksToBounds=YES;
    post_button.backgroundColor=[style colorWithHexString:age_color];
    
    feed_goes_here_button.layer.cornerRadius=4.0;
    feed_goes_here_button.layer.borderWidth=1.0;
    feed_goes_here_button.backgroundColor=[UIColor clearColor];
    feed_goes_here_button.layer.borderColor=[style colorWithHexString:@"d1d1d1"].CGColor;
    
   
    post_cancel_button.layer.cornerRadius=4.0;
    post_cancel_button.layer.masksToBounds=YES;
    post_cancel_button.backgroundColor=[style colorWithHexString:terms_of_services_color];
    
    ///////////// HEADER SECTION /////////////////
    logout_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:40];
    [logout_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-sign-out"] forState:UIControlStateNormal];
    logout_button.backgroundColor=[UIColor clearColor];
    [logout_button setTitleColor:[style colorWithHexString:terms_of_services_color] forState:UIControlStateNormal];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    progress_bar.popUpViewAnimatedColors = @[[style colorWithHexString:age_color], [style colorWithHexString:terms_of_services_color]];
    
    pro_pic_share.clipsToBounds=YES;
    name_label_share.font=[UIFont fontWithName:@"Roboto-Regular" size:16];
    name_label_share.textColor=[style colorWithHexString:terms_of_services_color];
    [sqlfunction loadUserDetailsTable];
    [sqlfunction LOAD_FEED_TABLE];
    [self FEED_FUNCTION];
    [self USER_DETAILS];
    
    
    
    
}



- (void)insertRowAtTop
{
    if (SERVER_FLAG==1)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            BOOL netStatus = [connectobj checkNetwork];
            if(netStatus == true){
                page_number=0;
                
                [self FEED_FUNCTION_PULL];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // [feed_table.infiniteScrollingView stopAnimating];
                
            });
        });
        
    }
    else
    {
        NSLog(@"FROM LOCAL DB");
    }
    
}


- (void)insertRowAtBottom
{
    if (SERVER_FLAG==1)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            BOOL netStatus = [connectobj checkNetwork];
            if(netStatus == true){
                page_number=page_number+1;
                
                [self FEED_FUNCTION_PAGINATION];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               
                
            });
        });
        
    }
    else
    {
        NSLog(@"FROM LOCAL DB");
    }
    
}

-(void)CHECK_DB
{
    if (![sqlfunction SEARCH_FEED_TABLE:USER_ID].count==0)
    {
        [self LOCAL_DB_FUNCTION];
        
    
    }
    else
    {
        SERVER_FLAG=1;
        DB_FLAG=0;
        [self FEED_FUNCTION];
    }
    
}

-(void)LOCAL_DB_FUNCTION
{
    DB_FLAG=1;
    SERVER_FLAG=0;
    feed_array=[[NSMutableArray alloc]init];
    feed_array=[sqlfunction SEARCH_FEED_TABLE:USER_ID];
    
    for (int i=0; i<feed_array.count; i++)
    {
        if ([[[feed_array objectAtIndex:i]objectForKey:@"type"] isEqualToString:@"image"])
        {
            for (int j=i+1; j<feed_array.count; j++)
            {
                
                if ([[[feed_array objectAtIndex:i]objectForKey:@"post_id"] isEqualToString:[[feed_array objectAtIndex:j]objectForKey:@"post_id"]])
                    
                {
                    NSArray *temp_array;
                    NSMutableDictionary *image_dict=[[feed_array objectAtIndex:i]mutableCopy];
                    image_array_1 =[image_dict objectForKey:@"image"];
                    temp_array=[[feed_array objectAtIndex:j]objectForKey:@"image"];
                    [image_array_1 addObjectsFromArray:temp_array];
                    [image_dict setObject:image_array_1 forKey:@"image"];
                    [feed_array mutableCopy];
                    [feed_array replaceObjectAtIndex:i withObject:image_dict];
                    [feed_array removeObjectAtIndex:j];
                    j=i;
                }
                
            }
            
        }
    }
    
    
    [feed_table reloadData];
  
}

-(void)FEED_FUNCTION

{
    [HUD hide:YES];
    [self stopSpin];

    [self showPageLoader];
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
    
        if ([connectobj string_check:TOCKEN]==true  &&[connectobj int_check:USER_ID]==true )
        {
            SERVER_FLAG=1;
            feed_temp_array=[[NSMutableArray alloc]init];
            timer = [NSTimer scheduledTimerWithTimeInterval:16.0
                                                     target: self
                                                   selector: @selector(cancelURLConnection:)
                                                   userInfo: nil
                                                    repeats: NO];
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            [param setObject:TOCKEN forKey:@"token"];
            
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:page_number] forKey:@"page"];
            
            NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/feedlist"];
            NSLog(@"URL NEW :%@",url_str);
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"URL STR IS :%@",jsonString);
            
            NSURL *url=[NSURL URLWithString:url_str];
            
            
            NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSLog(@"STEP1");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            NSLog(@"STEP2");
            queue = [[NSOperationQueue alloc] init];
            queue.maxConcurrentOperationCount=1;
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:queue
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *connectionError) {
                                       
                                       NSLog(@"STEP3 SEND REQUESt");
                                       
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
                                               
                                               feed_temp_array=[json objectForKey:@"feed_content"];
                                               feed_array=[[NSMutableArray alloc]init];

                                               [feed_array addObjectsFromArray:feed_temp_array];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   no_feed_view.hidden=YES;
                                                   feed_table.hidden=NO;
                                                   [timer invalidate];
                                                   [feed_table reloadData];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   
                                               });
                                               
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                           {
                                            
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                                   [self presentViewController:view_control animated:YES completion:nil];
                                               });
                                               
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"No data"])
                                           {
                                               if (page_number==0)
                                               {
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [timer invalidate];
                                                       no_feed_view.hidden=NO;
                                                       feed_table.hidden=YES;
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                   });
                                                   
                                                   
                                               }
                                               else
                                               {
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [timer invalidate];
                                                       [feed_table setHidden:NO];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                   });
                                                   
                                                   
                                               }
                                               
                                           }
                                           else
                                               
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [timer invalidate];
                                                   feed_table.hidden=YES;
                                                   feed_table.hidden=NO;
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
                                              // [self alertStatus:@"Error in network"];
                                              // return;
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
        if (![sqlfunction SEARCH_FEED_TABLE:USER_ID].count==0)
        {
            NSLog(@"IN LOCAL DB");
           // [self LOCAL_DB_FUNCTION];
            
        }
        [HUD hide:YES];
        [self stopSpin];
    }
    
}


-(void)FEED_FUNCTION_PAGINATION

{
  //  [self showPageLoader];
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
        if ([connectobj string_check:TOCKEN]==true  &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:page_number]==true)
        {
        SERVER_FLAG=1;
        feed_temp_array=[[NSMutableArray alloc]init];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        [param setObject:TOCKEN forKey:@"token"];
        
        [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
        [param setObject:[NSNumber numberWithInteger:page_number] forKey:@"page"];
        
        NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/feedlist"];
        NSLog(@"URL NEW :%@",url_str);
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
        
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"URL STR IS :%@",jsonString);
        
        NSURL *url=[NSURL URLWithString:url_str];
        
        
        NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSLog(@"STEP1");
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSLog(@"STEP2");
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount=1;
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *connectionError) {
                                   
                                   NSLog(@"STEP3 SEND REQUESt");
                                   
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
                                           
                                           feed_temp_array=[json objectForKey:@"feed_content"];
                                           [feed_array addObjectsFromArray:feed_temp_array];
                                           
                                           NSLog(@"FEED COUNT IS :%lu",(unsigned long)feed_array.count);
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               no_feed_view.hidden=YES;
                                               feed_table.hidden=NO;
                                               [feed_table reloadData];
                                                [feed_table.infiniteScrollingView stopAnimating];
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               
                                           });
                                           
                                       }
                                       else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                       {
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                               [self presentViewController:view_control animated:YES completion:nil];
                                           });
                                           
                                           
                                       }
                                       else if([[json objectForKey:@"message"] isEqualToString:@"No data"])
                                       {
                                            [feed_table.infiniteScrollingView stopAnimating];
                                           if (page_number==0)
                                           {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   no_feed_view.hidden=NO;
                                                   feed_table.hidden=YES;
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                               });
                                               
                                               
                                           }
                                           else
                                           {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [timer invalidate];
                                                   [feed_table setHidden:NO];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                               });
                                               
                                               
                                           }
                                           
                                       }
                                       else
                                           
                                       {
                                            [feed_table.infiniteScrollingView stopAnimating];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               feed_table.hidden=YES;
                                               feed_table.hidden=NO;
                                               [HUD hide:YES];
                                               [self stopSpin];
                                           });
                                           
                                           
                                       }
                                   }
                                   
                                   if (connectionError)
                                   {
                                        [feed_table.infiniteScrollingView stopAnimating];
                                       NSLog(@"error detected:%@", connectionError.localizedDescription);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [HUD hide:YES];
                                           [self stopSpin];
                                          // [self alertStatus:@"Error in network"];
                                           //return;
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

-(void)FEED_FUNCTION_PULL

{
    //  [self showPageLoader];
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        NSLog(@"PULL FUNCTION");
        if ([connectobj string_check:TOCKEN]==true  &&[connectobj int_check:USER_ID]==true)
        {
             NSLog(@"PULL FssUNCTION");
            
            SERVER_FLAG=1;
            feed_temp_array=[[NSMutableArray alloc]init];
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            [param setObject:TOCKEN forKey:@"token"];
            
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:0] forKey:@"page"];
            
            NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/feedlist"];
            NSLog(@"URL NEW :%@",url_str);
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"URL STR IS :%@",jsonString);
            
            NSURL *url=[NSURL URLWithString:url_str];
            
            
            NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSLog(@"STEP1");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            NSLog(@"STEP2");
            queue = [[NSOperationQueue alloc] init];
            queue.maxConcurrentOperationCount=1;
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:queue
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *connectionError) {
                                       
                                       NSLog(@"STEP3 SEND REQUESt");
                                       
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
                                               
                                               feed_temp_array=[json objectForKey:@"feed_content"];
                                               
                                               NSLog(@"FEED COUNT IS :%lu",(unsigned long)feed_array.count);
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   feed_array=[[NSMutableArray alloc]init];
                                                   [feed_array addObjectsFromArray:feed_temp_array];

                                                   no_feed_view.hidden=YES;
                                                   feed_table.hidden=NO;
                                                   [feed_table reloadData];
                                                   [feed_table.pullToRefreshView stopAnimating];
                                                   [feed_table setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   
                                               });
                                               
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                           {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                                   [self presentViewController:view_control animated:YES completion:nil];
                                               });
                                               
                                               
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"No data"])
                                           {
                                               if (page_number==0)
                                               {
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       no_feed_view.hidden=NO;
                                                       feed_table.hidden=YES;
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                   });
                                                   
                                                   
                                               }
                                               else
                                               {
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [timer invalidate];
                                                       [feed_table setHidden:NO];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                   });
                                                   
                                                   
                                               }
                                               
                                           }
                                           else
                                               
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   feed_table.hidden=YES;
                                                   feed_table.hidden=NO;
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
                                              // [self alertStatus:@"Error in network"];
                                              // return;
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



-(void)Save_to_local_db
{
    
    if (page_number==0)
        
        
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [sqlfunction DELETE_ALL_FEED_DATA];
            
            
            for (int i=0; i<feed_array.count; i++)
                
            {
                
                if ([[[feed_array objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"text"])
                    
                {
                    
                    NSString *image_url=[[feed_array objectAtIndex:i]objectForKey:@"poster_picture"];
                    
                    NSURL *url=[NSURL URLWithString:image_url];
                    
                    
                    NSData *image_data=[[NSData alloc] initWithContentsOfURL:url];
                    
                    
                    
                    [sqlfunction SAVE_TO_FEED:USER_ID image:NULL like_status:[[feed_array objectAtIndex:i]objectForKey:@"like_status"] location:[[feed_array objectAtIndex:i]objectForKey:@"location"] post_id:[[feed_array objectAtIndex:i]objectForKey:@"post_id"] post_total_comment_count:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"post_total_comment_count"]] integerValue] post_total_like_count:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"post_total_like_count"]] integerValue] poster_id:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"poster_id"]] integerValue] poster_name:[[feed_array objectAtIndex:i]objectForKey:@"poster_name"] poster_picture:image_data text_message:[[feed_array objectAtIndex:i]objectForKey:@"text_message"] time:[[feed_array objectAtIndex:i]objectForKey:@"time"] type:[[feed_array objectAtIndex:i]objectForKey:@"type"] video:@"" video_thumb_image:NULL];
                }
                
                else  if ([[[feed_array objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"image"])
                    
                {
                    
                    sql_image_array=[[NSMutableArray alloc]init];
                    
                    sql_image_array=[[feed_array objectAtIndex:i]objectForKey:@"image"];
                    
                    
                    for (int j=0; j<sql_image_array.count;j++)
                        
                    {
                        
                        
                        NSString *image_url=[[feed_array objectAtIndex:i]objectForKey:@"poster_picture"];
                        
                        NSURL *url=[NSURL URLWithString:image_url];
                        
                        NSData *image_data=[[NSData alloc] initWithContentsOfURL:url];
                        
                        
                        NSString *photo_url=[sql_image_array objectAtIndex:j];
                        
                        NSURL *url_photo=[NSURL URLWithString:photo_url];
                        
                        NSData *photo_data=[[NSData alloc] initWithContentsOfURL:url_photo];
                        
                        [sqlfunction SAVE_TO_FEED:USER_ID image:photo_data like_status:[[feed_array objectAtIndex:i]objectForKey:@"like_status"] location:[[feed_array objectAtIndex:i]objectForKey:@"location"] post_id:[[feed_array objectAtIndex:i]objectForKey:@"post_id"] post_total_comment_count:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"post_total_comment_count"]] integerValue] post_total_like_count:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"post_total_like_count"]] integerValue] poster_id:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"poster_id"]] integerValue] poster_name:[[feed_array objectAtIndex:i]objectForKey:@"poster_name"] poster_picture:image_data text_message:[[feed_array objectAtIndex:i]objectForKey:@"text_message"] time:[[feed_array objectAtIndex:i]objectForKey:@"time"] type:[[feed_array objectAtIndex:i]objectForKey:@"type"] video:@"" video_thumb_image:NULL];
                    }
                }
                
                else  if ([[[feed_array objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"video"])
                    
                {
                    
                    NSString *image_url=[[feed_array objectAtIndex:i]objectForKey:@"poster_picture"];
                    
                    NSURL *url=[NSURL URLWithString:image_url];
                    
                    NSData *image_data=[[NSData alloc] initWithContentsOfURL:url];
                    
                    
                    NSString *photo_url=[[feed_array objectAtIndex:i]objectForKey:@"video_thumb_image"];
                    
                    NSURL *url_photo=[NSURL URLWithString:photo_url];
                    
                    NSData *photo_data=[[NSData alloc] initWithContentsOfURL:url_photo];
                    
                    
                    
                    [sqlfunction SAVE_TO_FEED:USER_ID image:NULL like_status:[[feed_array objectAtIndex:i]objectForKey:@"like_status"] location:[[feed_array objectAtIndex:i]objectForKey:@"location"] post_id:[[feed_array objectAtIndex:i]objectForKey:@"post_id"] post_total_comment_count:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"post_total_comment_count"]] integerValue] post_total_like_count:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"post_total_like_count"]] integerValue] poster_id:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"poster_id"]] integerValue] poster_name:[[feed_array objectAtIndex:i]objectForKey:@"poster_name"] poster_picture:image_data text_message:[[feed_array objectAtIndex:i]objectForKey:@"text_message"] time:[[feed_array objectAtIndex:i]objectForKey:@"time"] type:[[feed_array objectAtIndex:i]objectForKey:@"type"] video:@"" video_thumb_image:photo_data];
                    
                }
                
                else  if ([[[feed_array objectAtIndex:i]objectForKey:@"type"]isEqualToString:@"profile_photo_update"])
                    
                {
                    
                    sql_image_array=[[feed_array objectAtIndex:i]objectForKey:@"image"];
                    
                    NSString *image_url=[[feed_array objectAtIndex:i]objectForKey:@"poster_picture"];
                    
                    NSURL *url=[NSURL URLWithString:image_url];
                    
                    NSData *image_data=[[NSData alloc] initWithContentsOfURL:url];
                    
                    
                    NSString *photo_url=[[feed_array objectAtIndex:i]objectForKey:@"image"];
                    
                    NSURL *url_photo=[NSURL URLWithString:photo_url];
                    
                    NSData *photo_data=[[NSData alloc] initWithContentsOfURL:url_photo];
                    
                    [sqlfunction SAVE_TO_FEED:USER_ID image:photo_data like_status:[[feed_array objectAtIndex:i]objectForKey:@"like_status"] location:[[feed_array objectAtIndex:i]objectForKey:@"location"] post_id:[[feed_array objectAtIndex:i]objectForKey:@"post_id"] post_total_comment_count:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"post_total_comment_count"]] integerValue] post_total_like_count:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"post_total_like_count"]] integerValue] poster_id:[[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:i]objectForKey:@"poster_id"]] integerValue] poster_name:[[feed_array objectAtIndex:i]objectForKey:@"poster_name"] poster_picture:image_data text_message:[[feed_array objectAtIndex:i]objectForKey:@"text_message"] time:[[feed_array objectAtIndex:i]objectForKey:@"time"] type:[[feed_array objectAtIndex:i]objectForKey:@"type"] video:@"" video_thumb_image:NULL];
                    
                }
                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
            });
            
        });
        
        
    }
    
}

-(void)cancelURLConnection:(id)sender
{
    NSLog(@"CANCEL URLCONNECTION");
    [queue cancelAllOperations];
    [HUD hide:YES];
    [self stopSpin];
    [timer invalidate];
    //[self alertStatus:@"Error in network.Please wait.."];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([[UIScreen mainScreen]bounds].size.height !=568)
    {
        cover_pic.frame=CGRectMake(0, 16, 320, 208);
        feed_table.frame=CGRectMake(0, 115, 320, 313);
        comment_bg_view.frame=CGRectMake(3, 25, 314, 450);
        image_comment_table.frame=CGRectMake(3, 59, 308, 335);
        no_feed_view.frame=CGRectMake(0, 110, 320, 318);
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"FEED_SETTINGS"])
    {
        SettingViewController *settings_controller=segue.destinationViewController;
        settings_controller.USER_ID=USER_ID;
        settings_controller.TOCKEN=TOCKEN;
    }
    else if([segue.identifier isEqualToString:@"FEED_PROFILE_ID"])
    {
        NSLog(@"TOKEnf :%@",TOCKEN);
        ProfileViewController *profile_controller=segue.destinationViewController;
        profile_controller.USER_ID=USER_ID;
        profile_controller.TOCKEN=TOCKEN;
    }
    else if([segue.identifier isEqualToString:@"FEED_SEARCH"])
    {
        NSLog(@"TOKEnf :%@",TOCKEN);
        SearchViewController *profile_controller=segue.destinationViewController;
        profile_controller.USER_ID=USER_ID;
        profile_controller.TOKEN=TOCKEN;
    }
    
    else if([segue.identifier isEqualToString:@"FEED_FOLLOWER"])
    {
        NSLog(@"TOKEnf :%@",TOCKEN);
        FollowerViewController *profile_controller=segue.destinationViewController;
        profile_controller.USER_ID=USER_ID;
        profile_controller.TOKEN=TOCKEN;
    }
    else if([segue.identifier isEqualToString:@"FEED_DETAIL"])
    {
        DetailFeedViewController *detail_controller=segue.destinationViewController;
        detail_controller.Post_id=[[[feed_array objectAtIndex:detail_feed_index.row]objectForKey:@"post_id"] integerValue];
        detail_controller.TOKEN=TOCKEN;
        detail_controller.USER_ID=USER_ID;
        detail_controller.index_count=detail_feed_index.row;
    }
    
    
}

#pragma TABBAR FUNCTION


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
            
            break;
        case 1:
            [self performSegueWithIdentifier:@"FEED_PROFILE_ID" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"FEED_SEARCH" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"FEED_FOLLOWER" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"FEED_SETTINGS" sender:self];
            break;
            
        default:
            break;
    }
}

- (IBAction)liked_user_cancel:(id)sender
{
    
    [backgroundview removeFromSuperview];
    likes_view.hidden=YES;
    liked_users=[[NSMutableArray alloc]init];
    [like_table reloadData];
   }

- (IBAction)collect_Done_action:(id)sender
{
    COMPOSE_FLAG=0;
    [collection_bg_view setHidden:YES];
}

- (IBAction)follow_friend:(id)sender
{
    [self performSegueWithIdentifier:@"FEED_SEARCH" sender:self];
}

- (IBAction)post_cancel_action:(id)sender
{
    COMPOSE_FLAG=0;
    post_bg_view.hidden=YES;
    post_button.hidden=YES;
    text_post_field.text=@"Tell your buddies what you're up to...";
    VIDEO_FLAG=0;
    self.assets=[[NSMutableArray alloc]init];
    [img_preview_collection reloadData];
    img_preview_collection.hidden=YES;
    [text_post_field resignFirstResponder];
}

- (IBAction)DONE_BUTTON_ACTION:(id)sender
{
    
    [backgroundview removeFromSuperview];
    comment_bg_view.hidden=YES;
    [textView resignFirstResponder];
}


- (IBAction)FEED_TEXT_BUTTON:(id)sender
{
    
   // text_post_field.text=@"";
    
    SELECT_VIDEO_FLAG=0;
    SELECT_PHOTO_FLAG=0;
    text_post_field.frame=CGRectMake(0, 51, 320, 51);
    text_post_field.text=@"Tell your buddies what you're up to...";
    COMPOSE_FLAG=1;
    post_bg_view.hidden=NO;
    [text_post_field becomeFirstResponder];
    
    Feed_post_Flag=1;
    
//    if([[UIScreen mainScreen]bounds].size.height !=568)
//    {
//        
//        feed_table.frame=CGRectMake(0, 185, 320, 257);
//        no_feed_view.frame=CGRectMake(0, 185, 320, 259);
//        
//        
//    }
//    else
//    {
//        feed_table.frame=CGRectMake(0, 203, 320, 359);
//        no_feed_view.frame=CGRectMake(0, 185, 320, 361);
//    }
    
    
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
        NSString *param8 = [NSString stringWithFormat:@"%@",text_post_field.text];
        NSString *rawString = [NSString stringWithFormat:@"%@",text_post_field.text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        if ([trimmed length] == 0 ||[[text_post_field.text stringByTrimmingCharactersInSet: set] length] == 0 || [text_post_field.text isEqualToString:@""] ||[text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."])
        {
            param8=@"";
            
        }
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
                                            
                                            [formData appendPartWithFormData:[[NSString stringWithString:param8] dataUsingEncoding:NSUTF8StringEncoding] name:@"text_message"];
                                            
                                            [formData appendPartWithFormData:[@"0" dataUsingEncoding:NSUTF8StringEncoding] name:@"video_id"];
                                            
                                            for(int i=0;i<self.assets.count;i++)
                                            {
                                                ALAsset *asset = [self.assets objectAtIndex:i];
                                                NSString *image_str=[@"image" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
                                                NSLog(@"ISTR :%@",image_str);
                                                [im_name addObject:image_str];
                                                NSData *imageData = UIImageJPEGRepresentation( [UIImage imageWithCGImage:asset.aspectRatioThumbnail], 50);
                                                NSLog(@"IMAGE height : %f",[UIImage imageWithCGImage:asset.aspectRatioThumbnail].size.height);
                                                NSLog(@"IMAGE WIDTH : %f",[UIImage imageWithCGImage:asset.aspectRatioThumbnail].size.width);
                                                [formData appendPartWithFileData:imageData name:image_str fileName:@"image.png" mimeType:@"image/png"];
                                            }
                                            
                                            NSString *new_string=[im_name componentsJoinedByString:@","];
                                            NSString *param9 = [NSString stringWithFormat:@"%@",new_string];
                                            
                                            [formData appendPartWithFormData:[[NSString stringWithString:param9] dataUsingEncoding:NSUTF8StringEncoding] name:@"image_file"];
                                            
                                            
                                        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
         
         {
           //  NSLog(@"UPLOSSS:");
             
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
                 NSLog(@"ARDRA %@",json);
                 
                 if ([[json objectForKey:@"status"] integerValue]==1)
                     
                 {
                     

                     progress_view.hidden=YES;
                     progress_bar.progress=0.0;

                     self.assets=[[NSMutableArray alloc]init];
                     
                     [img_preview_collection reloadData];
                     
                     img_preview_collection.hidden=YES;
                     
                     text_post_field.text=@"Tell your buddies what you're up to...";
                     
                     post_bg_view.hidden=YES;
                     
                     [HUD hide:YES];
                     
                     [self stopSpin];
                     
                     page_number=0;
                     
                     feed_array=[[NSMutableArray alloc]init];
                     
                     post_button.hidden=YES;
                     COMPOSE_FLAG=0;
                     
                     [self FEED_FUNCTION];
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
             
              NSLog(@"upload_error: %@",  operation.responseString);
             
             [self alertStatus:operation.responseString];
             
             return ;
             
         }
         ];
        
        [operation start];
        
    }
    else
    {
        
    }
    
}
- (IBAction)POST_BUTTON:(id)sender
{
   
    [text_post_field resignFirstResponder];
    if (self.assets.count==0 && ![text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."] && VIDEO_FLAG==0 && ![text_post_field.text isEqualToString:@""])
    {
        post_bg_view.hidden=YES;
        COMPOSE_FLAG=0;
        [self TEXT_POST];
    }
    else if (self.assets.count!=0 && VIDEO_FLAG==0)
    {
        post_bg_view.hidden=YES;
        COMPOSE_FLAG=0;
        [self image_upload];
    }
    else  if (VIDEO_FLAG==1 && self.assets.count==0 && ![text_post_field.text isEqualToString:@""])
    {
        NSLog(@"Video Upload");
        post_bg_view.hidden=YES;
        COMPOSE_FLAG=0;
        self.assets=[[NSMutableArray alloc]init];
        VIDEO_FLAG=0;
        [img_preview_collection reloadData];
        img_preview_collection.hidden=YES;
        [self Video_upload:moviePath];
    }
    header_view.frame = CGRectMake(0, 17, 320, 95);
    if ([UIScreen mainScreen].bounds.size.height !=568)
    {
        feed_table.frame=CGRectMake(0, 115, 320, 313);
    }
    else
    {
        feed_table.frame=CGRectMake(0, 115, 320, 405);
    }

}

-(void)TEXT_POST
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
 
    NSString *rawString = [text_post_field text];
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0 || [[text_post_field.text stringByTrimmingCharactersInSet: set] length] == 0 || [text_post_field.text isEqualToString:@""] || [text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."]|| [location_string isEqualToString:@""])
    {
        [self alertStatus:@"Message content cannot be empty"];
        return;
        NSLog(@"ONLY WHITE SPACE");
        
    }
    else
    {
        [self showPageLoader];
        NSString *urlString = [[connectobj value]stringByAppendingString:@"apiservices/feedpost?"];
        NSURL* url = [NSURL URLWithString:urlString];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                        {
                                            NSLog(@"OOPOPOP");
                                            
                                            NSString *param3 = [NSString stringWithFormat:@"%@",TOCKEN];
                                            [formData appendPartWithFormData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
                                            
                                            NSString *param4 = [NSString stringWithFormat:@"%d",USER_ID];
                                            [formData appendPartWithFormData:[[NSString stringWithString:param4] dataUsingEncoding:NSUTF8StringEncoding] name:@"user_id"];
                                            
                                            NSString *param5 = [NSString stringWithFormat:@"text"];
                                            [formData appendPartWithFormData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
                                            [formData appendPartWithFormData:[@"dddd" dataUsingEncoding:NSUTF8StringEncoding] name:@"location"];
                                            [formData appendPartWithFormData:[text_post_field.text dataUsingEncoding:NSUTF8StringEncoding] name:@"text_message"];
                                            [formData appendPartWithFormData:[@"0" dataUsingEncoding:NSUTF8StringEncoding] name:@"video_id"];
                                            
                                        }];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
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
                     
                     text_post_field.text=@"Tell your buddies what you're up to...";
                     progress_view.hidden=YES;
                     progress_bar.progress=0.0;
                     page_number=0;
                     feed_array=[[NSMutableArray alloc]init];
                     post_button.hidden=YES;
                     [HUD hide:YES];
                     [self stopSpin];
                     
                     [self FEED_FUNCTION];
                     
                 }
                 
                 else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"
                          
                          ])
                     
                 {
                     [HUD hide:YES];
                     [self stopSpin];
                     progress_view.hidden=YES;
                     progress_bar.progress=0.0;
                     ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                     [self presentViewController:view_control animated:YES completion:nil];
                 }
                 
                 else
                     
                 {
                     [HUD hide:YES];
                     [self stopSpin];
                     progress_view.hidden=YES;
                     progress_bar.progress=0.0;
                     [self alertStatus:[json objectForKey:@"message"]];
                     return ;
                 }
             }
         }
         
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [HUD hide:YES];
             [self stopSpin];
             progress_view.hidden=YES;
             
             progress_bar.progress=0.0;
             
             [self alertStatus:operation.responseString];
             
             return ;
         }
         
         ];
        
        [operation start];

        
    }
    }
    post_bg_view.hidden=YES;
    [text_post_field resignFirstResponder];
    
}
- (IBAction)SELECT_VIDEO:(id)sender
{
  //  [self upload_video];
    SELECT_VIDEO_FLAG=1;
    post_button.hidden=NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    [self presentViewController:picker animated:YES completion:NULL];
   
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"VIDEO SELECT");
   
    img_preview_collection.hidden=NO;
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        moviePath = [videoUrl path];
        NSLog(@"Video path is :%@",moviePath);
        
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
        [player setShouldAutoplay:NO];
       thumbnail_video = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        VIDEO_FLAG=1;
        text_post_field.frame = CGRectMake(0, 50, kTextViewWidth, height);
        
        if ([text_post_field.text isEqualToString:@""])
        {
            text_post_field.text=@"Tell your buddies what you're up to...";
            text_post_field.frame=CGRectMake(0, 50, 320, 50);
        }
        else if ([text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."])
        {
            text_post_field.text=@"Tell your buddies what you're up to...";
            text_post_field.frame=CGRectMake(0, 50, 320, 50);
        }
        post_bg_view.hidden=NO;
        img_preview_collection.frame=CGRectMake(0, text_post_field.frame.origin.y+text_post_field.frame.size.height+10, 320, 80);
        [img_preview_collection reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
        ////////////////// VIdeo upload ////////////////////////
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        }
    }
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"CANCEL Video");
    SELECT_VIDEO_FLAG=0;
    NSString *rawString = [text_post_field text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."] ||[text_post_field.text isEqualToString:@""] ||[trimmed length] == 0 )
    {
        post_button.hidden=YES;
        
    }
    else
    {
        post_button.hidden=NO;
    }
[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)Video_upload:(NSString *)moviepath
{
    NSLog(@"MOVIEPATH :%@",moviepath);
    
 
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            
            NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath: moviepath]];
            if (videoData!=NULL || ![videoData isEqual:[NSNull null]])
            {
                 NSLog(@"File SIZE: %d",videoData.length);
                if (videoData.length > 25000000)
                {
                    [self alertStatus:@"Please upload a video with file size less than 25 MB"];
                    return;
                }
                else
                {
                    
                    NSString *urlString = [[connectobj value]stringByAppendingString:@"apiservices/feedpost?"];
                    NSURL* url = [NSURL URLWithString:urlString];
                    NSString *param8 = [NSString stringWithFormat:@"%@",text_post_field.text];
                    NSString *rawString = [NSString stringWithFormat:@"%@",text_post_field.text];
                    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
                    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
                    if ([trimmed length] == 0 ||[[text_post_field.text stringByTrimmingCharactersInSet: set] length] == 0 || [text_post_field.text isEqualToString:@""] ||[text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."])
                    {
                        param8=@"";
                        
                    }
                    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
                    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                                    {
                                                        
                                                        NSString *param3 = [NSString stringWithFormat:@"%@",TOCKEN];
                                                        
                                                        [formData appendPartWithFormData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
                                                        
                                                        
                                                        NSString *param4 = [NSString stringWithFormat:@"%d",USER_ID];
                                                        
                                                        [formData appendPartWithFormData:[[NSString stringWithString:param4] dataUsingEncoding:NSUTF8StringEncoding] name:@"user_id"];
                                                        
                                                        
                                                        NSString *param5 = [NSString stringWithFormat:@"video"];
                                                        
                                                        [formData appendPartWithFormData:[[NSString stringWithString:param5] dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
                                                        
                                                        [formData appendPartWithFormData:[@"dddd" dataUsingEncoding:NSUTF8StringEncoding] name:@"location"];
                                                        
                                                        [formData appendPartWithFormData:[[NSString stringWithString:param8] dataUsingEncoding:NSUTF8StringEncoding] name:@"text_message"];
                                                        
                                                        [formData appendPartWithFormData:[@"0" dataUsingEncoding:NSUTF8StringEncoding] name:@"video_id"];
                                                        
                                                        [formData appendPartWithFileData:videoData name:@"video" fileName:@"video.mov" mimeType:@"video/quicktime"];
                                                        
                                                    }];
                    
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    
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
                                 
                                 text_post_field.text=@"Tell your buddies what you're up to...";
                                 progress_view.hidden=YES;
                                 progress_bar.progress=0.0;
                                 page_number=0;
                                 feed_array=[[NSMutableArray alloc]init];
                                 post_button.hidden=YES;
                                 [self FEED_FUNCTION];
                                 
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
            }
       
        }
    else
    {
        
    }

}

-(void)cancelURLConnection_video:(id)sender
{
    [HUD hide:YES];
    [self stopSpin];
    [video_timer invalidate];
    [video_queue cancelAllOperations];
    [self alertStatus:@"Network Error Occured while uploading video. Please try again."];
    return ;
}

- (IBAction)SELECT_PHOTO:(id)sender
{
    SELECT_PHOTO_FLAG=1;
    img_preview_collection.hidden=NO;
    post_button.hidden=NO;
    text_post_field.frame = CGRectMake(0, 50, kTextViewWidth, height);
    
    if ([text_post_field.text isEqualToString:@""])
    {
        text_post_field.text=@"Tell your buddies what you're up to...";
        text_post_field.frame=CGRectMake(0, 50, 320, 50);
    }
    else if ([text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."])
    {
        text_post_field.text=@"Tell your buddies what you're up to...";
        text_post_field.frame=CGRectMake(0, 50, 320, 50);
    }
    
    img_preview_collection.frame=CGRectMake(0, text_post_field.frame.origin.y+text_post_field.frame.size.height+10, 320, 80);
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
        post_bg_view.hidden=YES;
        [text_post_field resignFirstResponder];

        if([[UIScreen mainScreen]bounds].size.height !=568)
        {
            
            feed_table.frame=CGRectMake(0, 110, 320, 319);
            no_feed_view.frame=CGRectMake(0, 110, 320, 319);
            
            
        }
        else
        {
           // no_feed_view.frame=CGRectMake(0, 110, 320, 409);
           // feed_table.frame=CGRectMake(0, 110, 320, 409);
        }
        

        [self presentViewController:picker animated:YES completion:nil];
    }
    
}
- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
   
    NSLog(@"DISSMISS");
    SELECT_PHOTO_FLAG=0;
    NSString *rawString = [text_post_field text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."] ||[text_post_field.text isEqualToString:@""] ||[trimmed length] == 0 )
    {
        post_button.hidden=YES;
        
    }
    else
    {
        post_button.hidden=NO;
    }

    post_bg_view.hidden=NO;
    header_view.frame = CGRectMake(0, 17, 320, 95);
    if ([UIScreen mainScreen].bounds.size.height !=568)
    {
        feed_table.frame=CGRectMake(0, 115, 320, 313);
    }
    else
    {
        feed_table.frame=CGRectMake(0, 115, 320, 405);
    }

   // self.assets=[[NSMutableArray alloc]init];
    //[img_preview_collection reloadData];
}


#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"CANCRL IMAGE PICKER");
    if (self.popover != nil)
        [self.popover dismissPopoverAnimated:YES];
    else
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.assets = [NSMutableArray arrayWithArray:assets];
    
    [img_preview_collection reloadData];
     post_bg_view.hidden=NO;
    header_view.frame = CGRectMake(0, 17, 320, 95);
    if ([UIScreen mainScreen].bounds.size.height !=568)
    {
        feed_table.frame=CGRectMake(0, 115, 320, 313);
    }
    else
    {
        feed_table.frame=CGRectMake(0, 115, 320, 405);
    }

  //  [self image_upload];
//    post_bg_view.hidden=YES;
//    [text_post_field resignFirstResponder];
//    
//    if([[UIScreen mainScreen]bounds].size.height !=568)
//    {
//        
//        feed_table.frame=CGRectMake(0, 110, 320, 319);
//        no_feed_view.frame=CGRectMake(0, 110, 320, 319);
//        
//        
//    }
//    else
//    {
//        no_feed_view.frame=CGRectMake(0, 110, 320, 409);
//        feed_table.frame=CGRectMake(0, 110, 320, 409);
//    }
    
    
    
}

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

-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldDeselectAsset:(ALAsset *)asset
{
    NSLog(@"CANCEL");
    return YES;
}
/*
 - (BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
 NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
 if ([text length] == 1 && resultRange.location != NSNotFound) {
 [textView1 resignFirstResponder];
 post_bg_view.hidden=YES;
 
 if([[UIScreen mainScreen]bounds].size.height !=568)
 {
 
 feed_table.frame=CGRectMake(0, 101, 320, 328);
 
 
 }
 else
 {
 feed_table.frame=CGRectMake(0, 101, 320, 418);
 }
 
 return NO;
 }
 
 return YES;
 }
 
 
 */
#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==image_comment_table)
    {
        return comment_list_array.count;
    }
    else if (tableView==feed_table)
    {
        return feed_array.count;
    }
    else
    {
        NSLog(@"LLLLLLLLI");
        return liked_users.count;
    }
    
  
}
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode imageToScale:(UIImage*)imageToScale bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality {
    //Get the size we want to scale it to
    CGFloat horizontalRatio = bounds.width / imageToScale.size.width;
    CGFloat verticalRatio = bounds.height / imageToScale.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
    
    //...and here it is
    CGSize newSize = CGSizeMake(imageToScale.size.width * ratio, imageToScale.size.height * ratio);
    
    
    //start scaling it
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = imageToScale.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==image_comment_table)
        
    {
        UILabel *lbel_msg;
        NSString *CELLIDENTIFIER=@"CELL";
        MessageCell *message_cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        message_cell.backgroundColor=[UIColor clearColor];
        message_cell.selectionStyle=UITableViewCellSelectionStyleNone;
        message_cell.Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
        message_cell.profile_pic.contentMode=UIViewContentModeScaleAspectFill;
         message_cell.profile_pic.clipsToBounds=YES;
        message_cell.profile_pic.layer.cornerRadius=25.0;
        message_cell.profile_pic.layer.masksToBounds=YES;
        message_cell.Name_label.textColor=[style colorWithHexString:terms_of_services_color];
        message_cell.time_label.font=[UIFont fontWithName:@"Roboto-Thin" size:12];
        message_cell.time_label.textColor=[style colorWithHexString:terms_of_services_color];
        message_cell.Message_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
        message_cell.like_count.textColor=[style colorWithHexString:terms_of_services_color];
        message_cell.like_count.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
//        message_cell.like_btn.layer.cornerRadius=3.0;
//        message_cell.like_btn.layer.masksToBounds=YES;
//        message_cell.like_btn.layer.borderWidth=1.0;
//        message_cell.like_btn.layer.borderColor=[UIColor grayColor].CGColor;
        message_cell.like_btn.backgroundColor=[UIColor clearColor];
        message_cell.like_btn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
        [message_cell.like_btn setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-heart"] forState:UIControlStateNormal];
        [message_cell.like_btn setTitleColor:[style colorWithHexString:@"8e949b"] forState:UIControlStateNormal];
        
        message_cell.profile_pic.userInteractionEnabled=YES;
        message_cell.profile_pic.tag = indexPath.row;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_thumbnail_touch:)];
        [message_cell.profile_pic addGestureRecognizer:gesture];
        
        UITapGestureRecognizer *gesture_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_label_touch:)];
        message_cell.Name_label.userInteractionEnabled=YES;
        message_cell.Name_label.tag=indexPath.row;
        [message_cell.Name_label addGestureRecognizer:gesture_label];
        
        message_cell.like_btn.tag=indexPath.row;
        [message_cell.like_btn addTarget:self action:@selector(comment_like_btn_action:) forControlEvents:UIControlEventTouchUpInside];
        
        message_cell.like_background_button.tag=indexPath.row;
        [message_cell.like_background_button addTarget:self action:@selector(comment_like_btn_action:) forControlEvents:UIControlEventTouchUpInside];
        
        //////////// Cell Content ////////
        if ([[NSString stringWithFormat:@"%@",[[comment_list_array objectAtIndex:indexPath.row]objectForKey:@"like_status"]] isEqualToString:@"0"])
            
        {
            
            [message_cell.like_btn setTitleColor:[style colorWithHexString:@"8e949b"] forState:UIControlStateNormal];
        }
        else if (![[NSString stringWithFormat:@"%@",[[comment_list_array objectAtIndex:indexPath.row]objectForKey:@"like_status"]] isEqualToString:@"0"])
            
            
        {
            [message_cell.like_btn setTitleColor:[style colorWithHexString:blueButton] forState:UIControlStateNormal];
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
   else  if (tableView==like_table)
    {
        NSLog(@"LIKE TABLE");
        NSString *CELLIDENTIFIER=@"CELL";
        MessageCell *message_cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        message_cell.backgroundColor=[UIColor clearColor];
        message_cell.selectionStyle=UITableViewCellSelectionStyleNone;
        message_cell.Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
        message_cell.profile_pic.contentMode=UIViewContentModeScaleAspectFill;
        message_cell.profile_pic.clipsToBounds=YES;
        message_cell.profile_pic.layer.cornerRadius=23.0;
        message_cell.profile_pic.layer.masksToBounds=YES;
        message_cell.Name_label.textColor=[style colorWithHexString:terms_of_services_color];
        
        message_cell.profile_pic.userInteractionEnabled=YES;
        message_cell.profile_pic.tag = indexPath.row;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likes_thumbnail_touch:)];
        [message_cell.profile_pic addGestureRecognizer:gesture];
        
        UITapGestureRecognizer *gesture_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likes_label_touch:)];
        message_cell.Name_label.userInteractionEnabled=YES;
        message_cell.Name_label.tag=indexPath.row;
        [message_cell.Name_label addGestureRecognizer:gesture_label];
        
        if ([[NSString stringWithFormat:@"%@",[[liked_users objectAtIndex:indexPath.row]objectForKey:@"user_pic"]] isEqualToString:@"0"])
            
            
        {
            message_cell.profile_pic.image=[UIImage imageNamed:@"noimage.png"];
        }
        else
        {
                NSString *url_str=[[liked_users objectAtIndex:indexPath.row]objectForKey:@"user_pic"];
                NSURL *image_url=[NSURL URLWithString:url_str];
                [message_cell.profile_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
        }

        message_cell.Name_label.text=[[[liked_users objectAtIndex:indexPath.row]objectForKey:@"name"] capitalizedString];
        
        return message_cell;
    }
    else
    {
        NSLog(@"fEED_TABLE");
        if([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"profile_photo_update"] || [[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"])
        {
            
            static NSString *CellIdentifier = @"CellIdentifier";
            
            AFTableViewCell   *image_cell = (AFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (image_cell==nil)
            {
                image_cell = [[AFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
            }
            
            image_cell.report_image.userInteractionEnabled=YES;
            image_cell.report_image.tag = indexPath.row;
            UITapGestureRecognizer *gesture_report=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(REPORT_FEED:)];
            [image_cell.report_image addGestureRecognizer:gesture_report];
            
            image_cell.prof_bg_view.backgroundColor=[style colorWithHexString:@"F0F2F1"];
            image_cell.prof_pic.contentMode=UIViewContentModeScaleAspectFill;
            image_cell.prof_pic.clipsToBounds=YES;

            image_cell.prof_pic.userInteractionEnabled=YES;
            image_cell.prof_pic.tag = indexPath.row;
            UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feed_thumbnail_touch:)];
            [image_cell.prof_pic addGestureRecognizer:gesture];
            
            UITapGestureRecognizer *gesture_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feed_label_touch:)];
            image_cell.name_label.userInteractionEnabled=YES;
            image_cell.name_label.tag=indexPath.row;
            [image_cell.name_label addGestureRecognizer:gesture_label];
            
            
            if ([[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_picture"]] isEqualToString:@"0"])
                
            {
                image_cell.prof_pic.image=[UIImage imageNamed:@"noimage.png"];
            }
            else
            {
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData =[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_picture"];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.prof_pic setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                    
                }
                else
                {
                    NSString *url_str=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_picture"];
                    NSURL *image_url=[NSURL URLWithString:url_str];
                    [image_cell.prof_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
                }
            }
            if ([[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"like_status"]] isEqualToString:@"liked"])
                
            {
                [image_cell.like_button setTitleColor:[style colorWithHexString:blueButton] forState:UIControlStateNormal];
            }
            else
            {
                [image_cell.like_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            if([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"profile_photo_update"])
            {
                image_cell.photo_label.hidden=YES;
                 image_cell.name_label.frame=CGRectMake(60, 10, 252, 20);
                image_cell.time_label.frame=CGRectMake(60, 33, 200, 20);
                images_array=[[NSMutableArray alloc]init];
                NSString *url_str_profile=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
                [images_array addObject:url_str_profile];
            }
            else if([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"])
            {
                 image_cell.photo_label.hidden=NO;
                image_cell.name_label.frame=CGRectMake(60, 5, 252, 20);
                image_cell.photo_label.frame=CGRectMake(60, 23, 200, 20);
                 image_cell.time_label.frame=CGRectMake(60, 40, 200, 20);
               
                images_array=[[NSMutableArray alloc]init];
                images_array=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
            }
            
            if ([images_array count]==1)
            {
                
                [image_cell.imageView1 setHidden:NO];
                [image_cell.imageView2 setHidden:YES];
                [image_cell.imageView3 setHidden:YES];
                [image_cell.imageView4 setHidden:YES];
                [image_cell.imageView5 setHidden:YES];
                [image_cell.imageView6 setHidden:YES];
                [image_cell.imageView7 setHidden:YES];
                [image_cell.imageView8 setHidden:YES];
                [image_cell.imageView9 setHidden:YES];
                [image_cell.imageView10 setHidden:YES];
                image_cell.scrollview.hidden=YES;
                image_cell.scrollview1.hidden=YES;
                image_cell.scrollview2.hidden=YES;
                image_cell.scrollview3.hidden=YES;
                [image_cell.imageView01 setHidden:YES];
                [image_cell.imageView02 setHidden:YES];
                [image_cell.imageView03 setHidden:YES];
                [image_cell.imageView04 setHidden:YES];
                [image_cell.imageView05 setHidden:YES];
                
                if (DB_FLAG==1)
                {
                    
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:0];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView1 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                }
                else
                {
                    if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]isEqualToString:@""])
                    {
                        
                        image_cell.imageView1.frame = CGRectMake(10, 70, 300, 300);
                    }
                    else
                    {
                        
                        image_cell.imageView1.frame = CGRectMake(10, 100, 300, 300);
                        
                    }

                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:0];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView1 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                            
//                            UIImage *new_image=[self resizeImage:image_cell.imageView1.image newSize:CGSizeMake(310, 300)];
                            image_cell.imageView1.image=[self resizedImageWithContentMode:UIViewContentModeScaleAspectFill imageToScale:image_cell.imageView1.image bounds:CGSizeMake(310, 300) interpolationQuality:kCGInterpolationHigh];
                            //image_cell.imageView1.contentMode=UIViewContentModeScaleAspectFill;
                            
                        });
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_one_click:)];
                    image_cell.imageView1.userInteractionEnabled=YES;
                    image_cell.imageView1.tag=indexPath.row;
                    [image_cell.imageView1 addGestureRecognizer:gesture_follow];
                }
                
               image_cell.line_view.frame=CGRectMake(5, image_cell.imageView1.frame.origin.y+image_cell.imageView1.bounds.size.height+6, 310, .5);
                image_cell.background_view.frame=CGRectMake(0, image_cell.imageView1.frame.origin.y+image_cell.imageView1.bounds.size.height+2, 320, 40);
                
                
            }
            else if ([images_array count]==2)
            {
               
                if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]isEqualToString:@""])
                {
                    
                    image_cell.scrollview.frame = CGRectMake(0, 70, 320, 300);
                }
                else
                {
                    
                    image_cell.scrollview.frame = CGRectMake(0, 100, 320, 300);
                    
                }

                [image_cell.imageView1 setHidden:YES];
                [image_cell.imageView2 setHidden:NO];
                [image_cell.imageView3 setHidden:NO];
                [image_cell.imageView4 setHidden:YES];
                [image_cell.imageView5 setHidden:YES];
                [image_cell.imageView6 setHidden:YES];
                [image_cell.imageView7 setHidden:YES];
                [image_cell.imageView8 setHidden:YES];
                [image_cell.imageView9 setHidden:YES];
                [image_cell.imageView10 setHidden:YES];
                image_cell.scrollview.hidden=NO;
                image_cell.scrollview1.hidden=YES;
                image_cell.scrollview2.hidden=YES;
                
                image_cell.scrollview3.hidden=YES;
                [image_cell.imageView01 setHidden:YES];
                [image_cell.imageView02 setHidden:YES];
                [image_cell.imageView03 setHidden:YES];
                [image_cell.imageView04 setHidden:YES];
                [image_cell.imageView05 setHidden:YES];

                
                
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:0];
                        
                        if (imageData)
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView2 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                    
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:0];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView2 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                        
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_one_click:)];
                    image_cell.imageView2.userInteractionEnabled=YES;
                    image_cell.imageView2.tag=indexPath.row;
                    [image_cell.imageView2 addGestureRecognizer:gesture_follow];
                }
                
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:1];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView3 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                }
                else
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:1];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView3 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                        
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_two_click:)];
                    image_cell.imageView3.userInteractionEnabled=YES;
                    image_cell.imageView3.tag=indexPath.row;
                    [image_cell.imageView3 addGestureRecognizer:gesture_follow];

                    
                    
                }
               // image_cell.background_view.frame=CGRectMake(0, 415, 320, 40);
               
                image_cell.background_view.frame=CGRectMake(0, image_cell.scrollview.frame.origin.y+image_cell.scrollview.bounds.size.height+2, 320, 40);
                
            }
            else if ([images_array count]==3)
            {
                
                if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]isEqualToString:@""])
                {
                    
                    image_cell.scrollview1.frame = CGRectMake(0, 70, 320, 300);
                }
                else
                {
                    
                    image_cell.scrollview1.frame = CGRectMake(0, 100, 320, 300);
                    
                }

               image_cell.background_view.frame=CGRectMake(0, 415, 320, 40);
                [image_cell.imageView1 setHidden:YES];
                [image_cell.imageView2 setHidden:YES];
                [image_cell.imageView3 setHidden:YES];
                [image_cell.imageView4 setHidden:NO];
                [image_cell.imageView5 setHidden:NO];
                [image_cell.imageView6 setHidden:YES];
                [image_cell.imageView7 setHidden:YES];
                [image_cell.imageView8 setHidden:NO];
                [image_cell.imageView9 setHidden:YES];
                [image_cell.imageView10 setHidden:YES];
                
                image_cell.scrollview.hidden=YES;
                image_cell.scrollview1.hidden=NO;
                image_cell.scrollview2.hidden=YES;
                
                image_cell.scrollview3.hidden=YES;
                [image_cell.imageView01 setHidden:YES];
                [image_cell.imageView02 setHidden:YES];
                [image_cell.imageView03 setHidden:YES];
                [image_cell.imageView04 setHidden:YES];
                [image_cell.imageView05 setHidden:YES];


                
                
                if (DB_FLAG==1)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:0];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView8 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                }
                else
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:0];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView8 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                        
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_one_click:)];
                    image_cell.imageView8.userInteractionEnabled=YES;
                    image_cell.imageView8.tag=indexPath.row;
                    [image_cell.imageView8 addGestureRecognizer:gesture_follow];

                    
                }
                
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:1];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView4 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                }
                else
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:1];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView4 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                    });
                    
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_two_click:)];
                    image_cell.imageView4.userInteractionEnabled=YES;
                    image_cell.imageView4.tag=indexPath.row;
                    [image_cell.imageView4 addGestureRecognizer:gesture_follow];

                    
                }
                
                
                
                
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:2];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView5 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                    
                }
                else
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        NSString *url_str=[images_array objectAtIndex:2];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView5 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                    });
                    
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_three_click:)];
                    image_cell.imageView5.userInteractionEnabled=YES;
                    image_cell.imageView5.tag=indexPath.row;
                    [image_cell.imageView5 addGestureRecognizer:gesture_follow];

                    
                }
                
                image_cell.line_view.frame=CGRectMake(5, image_cell.scrollview1.frame.origin.y+image_cell.scrollview1.bounds.size.height+9, 310, .5);
                image_cell.background_view.frame=CGRectMake(0, image_cell.scrollview1.frame.origin.y+image_cell.scrollview1.bounds.size.height+3, 320, 40);
            }
            else if ([images_array count]==4)
            {
                if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]isEqualToString:@""])
                {
                    
                    image_cell.scrollview2.frame = CGRectMake(0, 70, 320, 300);
                }
                else
                {
                    
                    image_cell.scrollview2.frame = CGRectMake(0, 100, 320, 300);
                    
                }

                image_cell.background_view.frame=CGRectMake(0, 415, 320, 40);
                [image_cell.imageView1 setHidden:YES];
                [image_cell.imageView2 setHidden:YES];
                [image_cell.imageView3 setHidden:YES];
                [image_cell.imageView4 setHidden:YES];
                [image_cell.imageView5 setHidden:YES];
                [image_cell.imageView6 setHidden:NO];
                [image_cell.imageView7 setHidden:NO];
                [image_cell.imageView8 setHidden:YES];
                [image_cell.imageView9 setHidden:NO];
                [image_cell.imageView10 setHidden:NO];
                image_cell.scrollview.hidden=YES;
                image_cell.scrollview1.hidden=YES;
                image_cell.scrollview2.hidden=NO;
                
                image_cell.scrollview3.hidden=YES;
                [image_cell.imageView01 setHidden:YES];
                [image_cell.imageView02 setHidden:YES];
                [image_cell.imageView03 setHidden:YES];
                [image_cell.imageView04 setHidden:YES];
                [image_cell.imageView05 setHidden:YES];
                
                
                if (DB_FLAG==1)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:0];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView6 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                }
                else
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:0];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView6 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_one_click:)];
                    image_cell.imageView6.userInteractionEnabled=YES;
                    image_cell.imageView6.tag=indexPath.row;
                    [image_cell.imageView6 addGestureRecognizer:gesture_follow];
                    
                }
                
                if (DB_FLAG==1)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:1];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView7 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                    
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:1];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView7 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                        
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_two_click:)];
                    image_cell.imageView7.userInteractionEnabled=YES;
                    image_cell.imageView7.tag=indexPath.row;
                    [image_cell.imageView7 addGestureRecognizer:gesture_follow];

                    
                    
                }
                
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:2];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView9 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                    
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:2];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView9 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                    });
                    
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_three_click:)];
                    image_cell.imageView9.userInteractionEnabled=YES;
                    image_cell.imageView9.tag=indexPath.row;
                    [image_cell.imageView9 addGestureRecognizer:gesture_follow];
                    
                }
                
                if (DB_FLAG==1)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:3];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView10 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                }
                else
                {
                   
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:3];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView10 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                    });
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_four_click:)];
                    image_cell.imageView10.userInteractionEnabled=YES;
                    image_cell.imageView10.tag=indexPath.row;
                    [image_cell.imageView10 addGestureRecognizer:gesture_follow];
                    
                    image_cell.line_view.frame=CGRectMake(5, image_cell.scrollview2.frame.origin.y+image_cell.scrollview2.bounds.size.height+9, 310, .5);
                    image_cell.background_view.frame=CGRectMake(0, image_cell.scrollview2.frame.origin.y+image_cell.scrollview2.bounds.size.height+3, 320, 40);
                }
            }
            else if (images_array.count>=5)
            {
                if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]isEqualToString:@""])
                {
                    
                    image_cell.scrollview3.frame = CGRectMake(0, 70, 320, 300);
                }
                else
                {
                    
                    image_cell.scrollview3.frame = CGRectMake(0, 100, 320, 300);
                    
                }

                image_cell.background_view.frame=CGRectMake(0, 415, 320, 40);
                [image_cell.imageView1 setHidden:YES];
                [image_cell.imageView2 setHidden:YES];
                [image_cell.imageView3 setHidden:YES];
                [image_cell.imageView4 setHidden:YES];
                [image_cell.imageView5 setHidden:YES];
                [image_cell.imageView6 setHidden:YES];
                [image_cell.imageView7 setHidden:YES];
                [image_cell.imageView8 setHidden:YES];
                [image_cell.imageView9 setHidden:YES];
                [image_cell.imageView10 setHidden:YES];
                image_cell.scrollview.hidden=YES;
                image_cell.scrollview1.hidden=YES;
                image_cell.scrollview2.hidden=YES;
                image_cell.scrollview3.hidden=NO;
                [image_cell.imageView01 setHidden:NO];
                [image_cell.imageView02 setHidden:NO];
                [image_cell.imageView03 setHidden:NO];
                [image_cell.imageView04 setHidden:NO];
                [image_cell.imageView05 setHidden:NO];
                
                
                
                if (DB_FLAG==1)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:0];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView01 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                }
                else
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:0];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView01 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_one_click:)];
                    image_cell.imageView01.userInteractionEnabled=YES;
                    image_cell.imageView01.tag=indexPath.row;
                    [image_cell.imageView01 addGestureRecognizer:gesture_follow];
                    
                }
                
                if (DB_FLAG==1)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:1];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView02 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                    
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:1];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView02 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                        
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_two_click:)];
                    image_cell.imageView02.userInteractionEnabled=YES;
                    image_cell.imageView02.tag=indexPath.row;
                    [image_cell.imageView02 addGestureRecognizer:gesture_follow];
                    
                    
                    
                }
                
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:2];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView03 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                    
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:2];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView03 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                    });
                    
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_three_click:)];
                    image_cell.imageView03.userInteractionEnabled=YES;
                    image_cell.imageView03.tag=indexPath.row;
                    [image_cell.imageView03 addGestureRecognizer:gesture_follow];
                    
                }
                
                if (DB_FLAG==1)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:3];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView04 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:3];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView04 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_four_click:)];
                    image_cell.imageView04.userInteractionEnabled=YES;
                    image_cell.imageView04.tag=indexPath.row;
                    [image_cell.imageView04 addGestureRecognizer:gesture_follow];
                }
                if (DB_FLAG==1)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData = [images_array objectAtIndex:4];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [image_cell.imageView05 setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSString *url_str=[images_array objectAtIndex:4];
                        NSURL *image_url=[NSURL URLWithString:url_str];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [image_cell.imageView05 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                        });
                    });
                    
                    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_five_click:)];
                    image_cell.imageView05.userInteractionEnabled=YES;
                    image_cell.imageView05.tag=indexPath.row;
                    [image_cell.imageView05 addGestureRecognizer:gesture_follow];
                }
                image_cell.line_view.frame=CGRectMake(5, image_cell.scrollview3.frame.origin.y+image_cell.scrollview3.bounds.size.height+9, 310, .5);
                image_cell.background_view.frame=CGRectMake(0, image_cell.scrollview3.frame.origin.y+image_cell.scrollview3.bounds.size.height+3, 320, 40);
            }
            
            image_indexpath=indexPath;
            image_cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
            image_cell.time_label.text=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"time"];
            NSString *text_string=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"];
            text_string=[text_string stringByReplacingOccurrencesOfString:@"{item:$subject}" withString:@""];
            image_cell.feed_text.text=text_string;
            if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"])
            {
                
              //  UIFont *myFont = [UIFont fontWithName:@"Roboto-Regular" size:19];
                // Get the width of a string ...
//                CGSize size = [[[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_name"] capitalizedString] sizeWithFont:myFont];
//                
//               image_cell.photo_label.frame=CGRectMake(size.width+65, 10, 140, 20);
                
                NSLog(@"IN IMAGE TYPE");
                NSString *image_array_count_str=[NSString stringWithFormat:@"%lu",(unsigned long)images_array.count];

                NSString *final_name;
                if (images_array.count==1)
                {
                    final_name=@"has added a photo";
                    NSLog(@"FNSAME :%@",final_name);
                }
                else if(images_array.count>1)
                {
                    
                    final_name=[@"has added" stringByAppendingString:@" "];
                    final_name=[final_name stringByAppendingString:image_array_count_str];
                    final_name=[final_name stringByAppendingString:@" photos"];
                     NSLog(@"FFFFNSAME :%@",final_name);
                }
                
                image_cell.photo_label.text=final_name;
                
            }
            
            image_cell.name_label.text=[[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_name"] capitalizedString];
            image_cell.like_count_label.text=[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"post_total_like_count"]];
            image_cell.comment_count_label.text=[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"post_total_comment_count"]];
            
            
            image_cell.count_label.userInteractionEnabled=YES;
            image_cell.count_label.tag = indexPath.row;
            UITapGestureRecognizer *gesture_comment=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_label_action:)];
            [image_cell.count_label addGestureRecognizer:gesture_comment];
            
            image_cell.comment_count_label.userInteractionEnabled=YES;
            image_cell.comment_count_label.tag = indexPath.row;
            UITapGestureRecognizer *gesture_comment_count=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_label_action:)];
            [image_cell.comment_count_label addGestureRecognizer:gesture_comment_count];

            
            image_cell.like_button.tag=indexPath.row;
            [image_cell.like_button addTarget:self action:@selector(like_btn_action:) forControlEvents:UIControlEventTouchUpInside];
            
            image_cell.comment_button.tag=indexPath.row;
            [image_cell.comment_button addTarget:self action:@selector(comment_button_action:) forControlEvents:UIControlEventTouchUpInside];
            
            
            image_cell.like_count_label.userInteractionEnabled=YES;
            image_cell.like_count_label.tag = indexPath.row;
            UITapGestureRecognizer *gesture_like=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like_touch:)];
            [image_cell.like_count_label addGestureRecognizer:gesture_like];
            UITapGestureRecognizer *gesture_like_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like_touch:)];
            image_cell.like_label.userInteractionEnabled=YES;
            image_cell.like_label.tag=indexPath.row;
            [image_cell.like_label addGestureRecognizer:gesture_like_label];
            
            return image_cell;
        }
        else   if([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"video"])
        {
            static NSString *CellIdentifier = @"VIDEO_CELL";
            
            Video_Cell = (Video_Table_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            
            Video_Cell.report_image.userInteractionEnabled=YES;
            Video_Cell.report_image.tag = indexPath.row;
            UITapGestureRecognizer *gesture_report=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(REPORT_FEED:)];
            [Video_Cell.report_image addGestureRecognizer:gesture_report];
            
            Video_Cell.prof_pic.userInteractionEnabled=YES;
            Video_Cell.prof_pic.tag = indexPath.row;
            UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feed_thumbnail_touch:)];
            [Video_Cell.prof_pic addGestureRecognizer:gesture];
            UITapGestureRecognizer *gesture_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feed_label_touch:)];
            Video_Cell.name_label.userInteractionEnabled=YES;
            Video_Cell.name_label.tag=indexPath.row;
            [Video_Cell.name_label addGestureRecognizer:gesture_label];
            Video_Cell.header_bg_view.backgroundColor=[style colorWithHexString:@"F0F2F1"];
            Video_Cell.header_bg_view.frame=CGRectMake(0, 0, 320, 60);
            [Video_Cell.contentView addSubview:Video_Cell.header_bg_view];
            Video_Cell.prof_pic.frame=CGRectMake(4, 5, 50, 50);
            Video_Cell.name_label.frame=CGRectMake(62, 4, 252, 21);
            Video_Cell.has_added_label.frame=CGRectMake(62, 22
                                                        , 252, 21);
            Video_Cell.time_label_text.frame=CGRectMake(62, 37, 252, 21);
            Video_Cell.has_added_label.font=[UIFont fontWithName:@"Roboto-Regular" size:12];
            Video_Cell.has_added_label.textColor=[style colorWithHexString:terms_of_services_color];
            
            Video_Cell.prof_pic.layer.cornerRadius=6.0;
            Video_Cell.prof_pic.layer.masksToBounds=YES;
            
            
            
            Video_Cell.name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
            Video_Cell.name_label.textColor=[style colorWithHexString:terms_of_services_color];
            
            
            Video_Cell.time_label_text.font=[UIFont fontWithName:@"Roboto-Thin" size:13];
            Video_Cell.time_label_text.textColor=[style colorWithHexString:terms_of_services_color];
            Video_Cell.time_label_text.highlightedTextColor=[UIColor blackColor];
            
            
            Video_Cell.feed_post.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
            Video_Cell.feed_post.textColor=[UIColor grayColor];
            
            Video_Cell.prof_pic.contentMode=UIViewContentModeScaleAspectFill;
          //  Video_Cell.video_image.contentMode=UIViewContentModeScaleAspectFill;
          //  Video_Cell.video_image.clipsToBounds=YES;
            
            Video_Cell.feed_post.hidden=NO;
            
            if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]isEqualToString:@""])
            {
                
                Video_Cell.video_image.frame = CGRectMake(38, 72, 240, 128);
                Video_Cell.video_play_button.frame= CGRectMake(143, 120, 37, 37);
                Video_Cell.like_count_label.frame= CGRectMake(-1, 215, 25, 30);
                Video_Cell.like_label.frame = CGRectMake(34, 215, 38, 30);
                Video_Cell.comment_count_label.frame = CGRectMake(69, 215, 25, 30);
                Video_Cell.count_label.frame = CGRectMake(104, 215, 75, 30);
                Video_Cell.like_button.frame = CGRectMake(230, 212, 28, 28);
                Video_Cell.comment_button.frame = CGRectMake(275, 212, 70,40);
                 Video_Cell.comment_button.contentEdgeInsets=UIEdgeInsetsMake(-14.0, -42.0, 0.0, 0.0);
                Video_Cell.feed_post.hidden=YES;
            }
            else
            {
                Video_Cell.feed_post.frame=CGRectMake(2, 64, 312, 33);
                Video_Cell.video_image.frame = CGRectMake(38, 105, 240, 128);
                Video_Cell.video_play_button.frame= CGRectMake(143, 152, 37, 37);
                Video_Cell.like_count_label.frame= CGRectMake(-1, 252, 25, 30);
                Video_Cell.like_label.frame = CGRectMake(34, 252, 38, 30);
                Video_Cell.comment_count_label.frame = CGRectMake(69, 252, 25, 30);
                Video_Cell.count_label.frame = CGRectMake(104, 252, 75, 30);
                Video_Cell.like_button.frame = CGRectMake(230, 249, 28, 28);
                Video_Cell.comment_button.frame = CGRectMake(275, 249, 70,40);
                Video_Cell.comment_button.contentEdgeInsets=UIEdgeInsetsMake(-14.0, -42.0, 0.0, 0.0);
                Video_Cell.feed_post.hidden=NO;

            }
            
            if ([[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_picture"]] isEqualToString:@"0"])
                
                
                
            {
                Video_Cell.prof_pic.image=[UIImage imageNamed:@"noimage.png"];
            }
            else
            {
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData =[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_picture"];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [Video_Cell.prof_pic setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                    
                    
                }
                else
                {
                    NSString *url_str=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_picture"];
                    NSURL *image_url=[NSURL URLWithString:url_str];
                    [Video_Cell.prof_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
                }
            }
            
            if ([[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"video_thumb_image"]] isEqualToString:@"0"])
                
            {
                Video_Cell.video_image.image=[UIImage imageNamed:@"noimage.png"];
            }
            else
            {
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData =[[feed_array objectAtIndex:indexPath.row]objectForKey:@"video_thumb_image"];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [Video_Cell.video_image setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                    
                }
                else
                {
                    NSString *url_str=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"video_thumb_image"];
                    NSURL *image_url=[NSURL URLWithString:url_str];
                    [Video_Cell.video_image setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no-video"]];
                
                }
            }
            
            
            Video_Cell.time_label_text.text=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"time"];
            Video_Cell.name_label.text=[[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_name"] capitalizedString];
            Video_Cell.feed_post.text=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"];
            Video_Cell.like_count_label.text=[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"post_total_like_count"]];
            Video_Cell.comment_count_label.text=[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"post_total_comment_count"]];
            
            if ([[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"like_status"]] isEqualToString:@"liked"])
                
            {
                [Video_Cell.like_button setTitleColor:[style colorWithHexString:blueButton] forState:UIControlStateNormal];
            }
            else
            {
                [Video_Cell.like_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            
            Video_Cell.selectionStyle=UITableViewCellSelectionStyleNone;
            Video_Cell.line_view.backgroundColor=[UIColor lightGrayColor];
            Video_Cell. video_play_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:38];
            [Video_Cell.video_play_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-play-circle"] forState:UIControlStateNormal];
            [Video_Cell.video_play_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            Video_Cell.video_play_button.tag=indexPath.row;
            [Video_Cell.video_play_button addTarget:self action:@selector(video_play_action:) forControlEvents:UIControlEventTouchUpInside];
            
            
            Video_Cell.like_count_label.textColor=[style colorWithHexString:terms_of_services_color];
            Video_Cell.like_count_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
            
            
            
            
            Video_Cell.like_label.text=@"Likes";
            Video_Cell.like_label.textColor=[style colorWithHexString:terms_of_services_color];
            Video_Cell.like_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
            
            
            
            Video_Cell.comment_count_label.textColor=[style colorWithHexString:terms_of_services_color];
            Video_Cell.comment_count_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
            
            
            
            
            Video_Cell. count_label.text=@"Comments";
            Video_Cell.count_label.textColor=[style colorWithHexString:terms_of_services_color];
            Video_Cell.count_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
            
            
            
            
            Video_Cell.like_button.titleLabel.textAlignment=NSTextAlignmentCenter;
//            Video_Cell.like_button.layer.cornerRadius=3.0;
//            Video_Cell.like_button.layer.masksToBounds=YES;
//            Video_Cell.like_button.layer.borderWidth=0.50;
//            Video_Cell.like_button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            Video_Cell.like_button.backgroundColor=[UIColor clearColor];
            Video_Cell. like_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
            [Video_Cell.like_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-heart"] forState:UIControlStateNormal];
            
            
            
//            Video_Cell.comment_button.layer.cornerRadius=3.0;
//            Video_Cell.comment_button.layer.masksToBounds=YES;
//            Video_Cell.comment_button.layer.borderWidth=0.50;
//            Video_Cell. comment_button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            Video_Cell. comment_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
            [Video_Cell.comment_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-comment"] forState:UIControlStateNormal];
            Video_Cell.comment_button.backgroundColor=[UIColor clearColor];
            [Video_Cell.comment_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            Video_Cell.like_button.tag=indexPath.row;
            [Video_Cell.like_button addTarget:self action:@selector(like_btn_action:) forControlEvents:UIControlEventTouchUpInside];
            
            //  Video_Cell.backgroundColor=[style colorWithHexString:@"F0F2F1"];
            
            Video_Cell.comment_button.tag=indexPath.row;
            [Video_Cell.comment_button addTarget:self action:@selector(comment_button_action:) forControlEvents:UIControlEventTouchUpInside];
            
            Video_Cell.like_count_label.userInteractionEnabled=YES;
            Video_Cell.like_count_label.tag = indexPath.row;
            UITapGestureRecognizer *gesture_like=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like_touch:)];
            [Video_Cell.like_count_label addGestureRecognizer:gesture_like];
            UITapGestureRecognizer *gesture_like_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like_touch:)];
            Video_Cell.like_label.userInteractionEnabled=YES;
            Video_Cell.like_label.tag=indexPath.row;
            [Video_Cell.like_label addGestureRecognizer:gesture_like_label];
            
            
            Video_Cell.count_label.userInteractionEnabled=YES;
            Video_Cell.count_label.tag = indexPath.row;
            UITapGestureRecognizer *gesture_comment=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_label_action:)];
            [Video_Cell.count_label addGestureRecognizer:gesture_comment];
            
            Video_Cell.comment_count_label.userInteractionEnabled=YES;
            Video_Cell.comment_count_label.tag = indexPath.row;
            UITapGestureRecognizer *gesture_comment_count=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_label_action:)];
            [Video_Cell.comment_count_label addGestureRecognizer:gesture_comment_count];
            
            
            return Video_Cell;
        }
        
        
        else
        {
            static NSString *CellIdentifier = @"TEXT_CELL";
            
            t_cell = (Text_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            /* if (!t_cell)
             {
             t_cell = [[Text_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             }
            
             */
            t_cell.report_image.userInteractionEnabled=YES;
            t_cell.report_image.tag = indexPath.row;
            UITapGestureRecognizer *gesture_report=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(REPORT_FEED:)];
            [t_cell.report_image addGestureRecognizer:gesture_report];
            
            t_cell.prof_pic.userInteractionEnabled=YES;
            t_cell.prof_pic.tag = indexPath.row;
            UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feed_thumbnail_touch:)];
            [t_cell.prof_pic addGestureRecognizer:gesture];
            UITapGestureRecognizer *gesture_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feed_label_touch:)];
            t_cell.name_label.userInteractionEnabled=YES;
            t_cell.name_label.tag=indexPath.row;
            [t_cell.name_label addGestureRecognizer:gesture_label];

            t_cell.header_bg_view.frame=CGRectMake(0, 0, 320, 60);
           // t_cell.prof_pic.frame=CGRectMake(4, 5, 50, 50);
           // t_cell.name_label.frame=CGRectMake(62, 5, 252, 21);
          //  t_cell.header_bg_view.frame=CGRectMake(63, 28, 252, 21);
           t_cell.header_bg_view.backgroundColor=[style colorWithHexString:@"F0F2F1"];;
            
            
            
          //  t_cell.prof_pic.image=[UIImage imageNamed:@"girl.png"];
            t_cell.prof_pic.contentMode=UIViewContentModeScaleAspectFill;
            t_cell.prof_pic.clipsToBounds=YES;
            t_cell.prof_pic.layer.cornerRadius=6.0;
            t_cell.prof_pic.layer.masksToBounds=YES;
            
            
            t_cell.name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
            t_cell.name_label.textColor=[style colorWithHexString:terms_of_services_color];
            
            
            t_cell.time_label_text.font=[UIFont fontWithName:@"Roboto-Thin" size:13];
            t_cell.time_label_text.textColor=[style colorWithHexString:terms_of_services_color];

            t_cell.time_label_text.highlightedTextColor=[UIColor blackColor];
            
           
            t_cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
            t_cell.line_view.backgroundColor=[UIColor lightGrayColor];
            
            
            
            t_cell.like_count_label.textColor=[style colorWithHexString:terms_of_services_color];
            t_cell.like_count_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
            
            
            
            t_cell.like_label.text=@"Likes";
            t_cell.like_label.textColor=[style colorWithHexString:terms_of_services_color];
            t_cell.like_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
            
            
            
            t_cell.comment_count_label.textColor=[style colorWithHexString:terms_of_services_color];
            t_cell.comment_count_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
            
            
            t_cell. count_label.text=@"Comments";
            t_cell.count_label.textColor=[style colorWithHexString:terms_of_services_color];
            t_cell.count_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
            
            
            t_cell.like_button.titleLabel.textAlignment=NSTextAlignmentCenter;
//            t_cell.like_button.layer.cornerRadius=3.0;
//            t_cell.like_button.layer.masksToBounds=YES;
//            t_cell.like_button.layer.borderWidth=0.50;
//            t_cell.like_button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            t_cell.like_button.backgroundColor=[UIColor clearColor];
            t_cell. like_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
            [t_cell.like_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-heart"] forState:UIControlStateNormal];
            
//            t_cell.comment_button.layer.cornerRadius=3.0;
//            t_cell.comment_button.layer.masksToBounds=YES;
//            t_cell.comment_button.layer.borderWidth=0.50;
//            t_cell. comment_button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            t_cell. comment_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
            [t_cell.comment_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-comment"] forState:UIControlStateNormal];
            t_cell.comment_button.backgroundColor=[UIColor clearColor];
            [t_cell.comment_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-comment"] forState:UIControlStateNormal];
            [t_cell.comment_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            t_cell.like_button.tag=indexPath.row;
            [t_cell.like_button addTarget:self action:@selector(like_btn_action:) forControlEvents:UIControlEventTouchUpInside];
            // t_cell.backgroundColor=[style colorWithHexString:@"F0F2F1"];
            
            t_cell.comment_button.tag=indexPath.row;
            [t_cell.comment_button addTarget:self action:@selector(comment_button_action:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_picture"]] isEqualToString:@"0"])
                
            {
                t_cell.prof_pic.image=[UIImage imageNamed:@"noimage.png"];
            }
            else
            {
                if (DB_FLAG==1)
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imageData =[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_picture"];
                        if (imageData)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [t_cell.prof_pic setImage:[UIImage imageWithData:imageData]];
                            });
                        }
                    });
                    
                }
                else
                {
                    NSString *url_str=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_picture"];
                    NSURL *image_url=[NSURL URLWithString:url_str];
                    [t_cell.prof_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
                }
            }
            
            
            t_cell.time_label_text.text=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"time"];
            t_cell.name_label.text=[[[feed_array objectAtIndex:indexPath.row]objectForKey:@"poster_name"] capitalizedString];
         
            
            if ([[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"like_status"]] isEqualToString:@"liked"])
                
            {
                [t_cell.like_button setTitleColor:[style colorWithHexString:blueButton] forState:UIControlStateNormal];
            }
            else
            {
                [t_cell.like_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            
            
           // t_cell.feed_post.text=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"];
            
            t_cell.like_count_label.text=[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"post_total_like_count"]];
            t_cell.comment_count_label.text=[NSString stringWithFormat:@"%@",[[feed_array objectAtIndex:indexPath.row]objectForKey:@"post_total_comment_count"]];
            
            
           // t_cell.feed_post.numberOfLines=0;
          //  [t_cell.feed_post sizeToFit];
            
            UILabel   *lbel_msg=[[UILabel alloc]initWithFrame:CGRectMake(5, 68, 315, 70)];
            lbel_msg.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
            lbel_msg.textColor=[UIColor grayColor];
            lbel_msg.tag = 1001;
            lbel_msg.numberOfLines=0;
            lbel_msg.text=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"];
            [lbel_msg sizeToFit];
            
            if (([t_cell.contentView viewWithTag:1001]))
            {
                [[t_cell.contentView viewWithTag:1001]removeFromSuperview];
                
            }
            
            [t_cell.contentView addSubview:lbel_msg];
            

            
          //  t_cell.line_view.frame=CGRectMake(5, lbel_msg.frame.size.height+lbel_msg.frame.origin.y+10, 310, .5);
            
            t_cell.like_count_label.frame=CGRectMake(-1, lbel_msg.frame.size.height+lbel_msg.frame.origin.y+15, 25, 30);
            t_cell.like_count_label.textAlignment=NSTextAlignmentRight;
            
             t_cell.like_label.frame=CGRectMake(31, lbel_msg.frame.size.height+lbel_msg.frame.origin.y+15, 38, 30);
            t_cell.like_label.textAlignment=NSTextAlignmentLeft;
            t_cell.comment_count_label.frame=CGRectMake(69, lbel_msg.frame.size.height+lbel_msg.frame.origin.y+15, 25, 30);
            
            t_cell.comment_count_label.textAlignment=NSTextAlignmentRight;
            t_cell.count_label.frame=CGRectMake(104, lbel_msg.frame.size.height+lbel_msg.frame.origin.y+15, 75, 30);
            t_cell.count_label.textAlignment=NSTextAlignmentLeft;
            
             t_cell.like_button.frame=CGRectMake(230, lbel_msg.frame.size.height+lbel_msg.frame.origin.y+12, 40, 28);
            
             t_cell.comment_button.frame=CGRectMake(275, lbel_msg.frame.size.height+lbel_msg.frame.origin.y+12, 70, 40);
         //   t_cell.comment_button.backgroundColor=[UIColor redColor];
            t_cell.comment_button.contentEdgeInsets=UIEdgeInsetsMake(-14.0, -42.0, 0.0, 0.0);
            
            t_cell.like_count_label.userInteractionEnabled=YES;
            t_cell.like_count_label.tag = indexPath.row;
            UITapGestureRecognizer *gesture_like=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like_touch:)];
            [t_cell.like_count_label addGestureRecognizer:gesture_like];
            UITapGestureRecognizer *gesture_like_label=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like_touch:)];
            t_cell.like_label.userInteractionEnabled=YES;
            t_cell.like_label.tag=indexPath.row;
            [t_cell.like_label addGestureRecognizer:gesture_like_label];
            
            t_cell.count_label.userInteractionEnabled=YES;
            t_cell.count_label.tag = indexPath.row;
            UITapGestureRecognizer *gesture_comment=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_label_action:)];
            [t_cell.count_label addGestureRecognizer:gesture_comment];
            
            t_cell.comment_count_label.userInteractionEnabled=YES;
            t_cell.comment_count_label.tag = indexPath.row;
            UITapGestureRecognizer *gesture_comment_count=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comment_label_action:)];
            [t_cell.comment_count_label addGestureRecognizer:gesture_comment_count];
            
            return t_cell;
        }
    }
    
}

- (void)REPORT_FEED:(id)sender
{
    
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    reported_feed_id=[[feed_array objectAtIndex:indexPath1.row]objectForKey:@"post_id"];
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
            [param setObject:TOCKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:[reported_feed_id intValue]] forKey:@"subject_id"];
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
                                               
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [self stopSpin];
                                                   [backgroundview removeFromSuperview];
                                                   report_abuse_view.hidden=YES;
                                                   
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


-(void)feed_thumbnail_touch:(id)sender
{
    
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    [self cell_touch_image:[[feed_array objectAtIndex:indexPath1.row]objectForKey:@"poster_id"]];
    
}

-(void)feed_label_touch:(id)sender
{
    
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    Text_Cell *p_cell = (Text_Cell*)[feed_table cellForRowAtIndexPath:indexPath1];
    
    [UIView animateWithDuration:0.2
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         p_cell.name_label.alpha=0.5;
                         p_cell.name_label.textColor = [style colorWithHexString:@"4CA5E0"];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2 animations:^{
                             p_cell.name_label.alpha=1.0;
                             p_cell.name_label.textColor = [style colorWithHexString:terms_of_services_color];
                             @try
                             {
                                 
                                 if (USER_ID==[[[feed_array objectAtIndex:indexPath1.row]objectForKey:@"poster_id"] integerValue])
                                 {
                                     [self performSegueWithIdentifier:@"FEED_PROFILE_ID" sender:self];
                                 }
                                 else
                                 {
                                     
                                     Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
                                     view_control.TOKEN=TOCKEN;
                                     view_control.USER_ID=USER_ID;
                                     view_control.FEED_FLAG=1;
                                     view_control.TARGETED_USER_ID=[[feed_array objectAtIndex:indexPath1.row]objectForKey:@"poster_id"];
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
    NSLog(@"LABEL TOUCH");
    
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    MessageCell *p_cell = (MessageCell*)[image_comment_table cellForRowAtIndexPath:indexPath1];
    
    [UIView animateWithDuration:0.2
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         p_cell.Name_label.alpha=0.5;
                         p_cell.Name_label.textColor = [style colorWithHexString:@"4CA5E0"];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2 animations:^{
                             p_cell.Name_label.alpha=1.0;
                             p_cell.Name_label.textColor = [style colorWithHexString:terms_of_services_color];
                             @try
                             {
                                 
                                 if (USER_ID==[[[comment_list_array objectAtIndex:indexPath1.row]objectForKey:@"comment_poster_id"] integerValue])
                                 {
                                     [self performSegueWithIdentifier:@"FEED_PROFILE_ID" sender:self];
                                 }
                                 else
                                 {
                                     
                                     Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
                                     view_control.TOKEN=TOCKEN;
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
    [self cell_touch_image:[[comment_list_array objectAtIndex:indexPath1.row]objectForKey:@"comment_poster_id"]];

}



-(void)likes_label_touch:(id)sender
{
    
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    MessageCell *p_cell = (MessageCell*)[like_table cellForRowAtIndexPath:indexPath1];
    
    [UIView animateWithDuration:0.2
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         p_cell.Name_label.alpha=0.5;
                         p_cell.Name_label.textColor = [style colorWithHexString:@"4CA5E0"];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2 animations:^{
                             p_cell.Name_label.alpha=1.0;
                             p_cell.Name_label.textColor = [style colorWithHexString:terms_of_services_color];
                             @try
                             {
                                 
                                 if (USER_ID==[[[liked_users objectAtIndex:indexPath1.row]objectForKey:@"user_id"] integerValue])
                                 {
                                     [self performSegueWithIdentifier:@"FEED_PROFILE_ID" sender:self];
                                 }
                                 else
                                 {
                                     
                                     Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
                                     view_control.TOKEN=TOCKEN;
                                     view_control.USER_ID=USER_ID;
                                     view_control.FEED_FLAG=1;
                                     view_control.TARGETED_USER_ID=[[liked_users objectAtIndex:indexPath1.row]objectForKey:@"user_id"];
                                     [self.view addSubview:view_control.view];
                                     
                                 }
                                 
                             }
                             @catch(NSException *theException){
                                 
                             }
                             
                         }];
                     }];
    
    
}

-(void)likes_thumbnail_touch:(id)sender
{
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    [self cell_touch_image:[[liked_users objectAtIndex:indexPath1.row]objectForKey:@"user_id"]];
    
}


-(void)like_touch:(id)sender
{
    liked_users=[[NSMutableArray alloc]init];
    NSLog(@"LIKE TOUCH");
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    //  NSIndexPath index=sender.view.tag;
        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    
    if ([[[feed_array objectAtIndex:indexPath1.row] objectForKey:@"post_total_like_count"] integerValue]>0)
    {
        backgroundview=[[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        [self.view addSubview:backgroundview];
        [self.view addSubview:likes_view];
        likes_view.hidden=NO;
        
        
        
        
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            
            
            if ([connectobj string_check:TOCKEN]==true  &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:[[[feed_array objectAtIndex:indexPath1.row]objectForKey:@"post_id"] integerValue]]==true)
            {
                [self showPageLoader_public];
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                
                [param setObject:TOCKEN forKey:@"token"];
                
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[[[feed_array objectAtIndex:indexPath1.row]objectForKey:@"post_id"] integerValue]] forKey:@"post_id"];
                
                NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/activitylikelist?"];
                
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
                
                NSOperationQueue *comment_list_queue = [[NSOperationQueue alloc] init];
                comment_list_queue.maxConcurrentOperationCount=1;
                
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:comment_list_queue
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
                                               NSLog(@"RESPONSE :%@",response);
                                               NSDictionary *json =
                                               [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
                                               
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               if(status==1)
                                               {
                                                   
                                                   liked_users=[json objectForKey:@"result"];
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [HUD setHidden:YES];
                                                       [self stopSpin];
                                                       [like_table reloadData];
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
    
}



- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)image_one_click:(id)sender
{
     COMPOSE_FLAG=1;
    UIPanGestureRecognizer *gesture1 = (UIPanGestureRecognizer *) sender;
    
    CGPoint p = [gesture1 locationInView:feed_table];
    
    NSIndexPath *indexPath = [feed_table indexPathForRowAtPoint:p];
    sub_image_array=[[NSMutableArray alloc]init];
    if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"]) {
        sub_image_array=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
    }
    else
    {
        [ sub_image_array addObject :[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"] ];
    }
    
    [collection_view reloadData];
      NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
     [collection_view scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    collection_bg_view.hidden=NO;
}
-(void)image_close_click:(id)sender
{
   
    if (VIDEO_FLAG==1)
    {
        SELECT_VIDEO_FLAG=0;
        NSString *rawString = [text_post_field text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
        
        if ([text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."] ||[text_post_field.text isEqualToString:@""] ||[trimmed length] == 0 )
        {
            post_button.hidden=YES;
            
        }
        else
        {
            post_button.hidden=NO;
        }

        VIDEO_FLAG=0;
        self.assets=[[NSMutableArray alloc]init];
        [img_preview_collection reloadData];
        img_preview_collection.hidden=YES;
        
    }
    else
    {
    UIPanGestureRecognizer *gesture1 = (UIPanGestureRecognizer *) sender;
    
    CGPoint p = [gesture1 locationInView:img_preview_collection];
    
    NSIndexPath *indexPath = [img_preview_collection indexPathForItemAtPoint:p];
        if (indexPath.row==0)
        {
            SELECT_PHOTO_FLAG=0;
            NSString *rawString = [text_post_field text];
            NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
           
            if ([text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."] ||[text_post_field.text isEqualToString:@""] ||[trimmed length] == 0 )
            {
                post_button.hidden=YES;
                
            }
            else
            {
                post_button.hidden=NO;
            }

            
        }
    
    NSLog(@"ASSETS COUNT :%lu",(unsigned long)self.assets.count);
    NSLog(@"INDEX PATH COUNT :%lu",indexPath.row);
    [self.assets mutableCopy];
    if ( [self.assets isKindOfClass: [NSMutableArray class]] )
    {
        NSLog(@"MUTABLE ARRAY");
    }
    [self.assets removeObjectAtIndex:indexPath.row];
    [img_preview_collection reloadData];
    }

    
}


-(void)image_two_click:(id)sender
{
    COMPOSE_FLAG=1;
    UIPanGestureRecognizer *gesture1 = (UIPanGestureRecognizer *) sender;
    
    CGPoint p = [gesture1 locationInView:feed_table];
    
    NSIndexPath *indexPath = [feed_table indexPathForRowAtPoint:p];
    sub_image_array=[[NSMutableArray alloc]init];
    if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"]) {
        sub_image_array=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
    }
    else
    {
        [ sub_image_array addObject :[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"] ];
    }
    
   NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    
    [collection_view reloadData];
    [collection_view scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    collection_bg_view.hidden=NO;
    
}

-(void)image_three_click:(id)sender
{
    COMPOSE_FLAG=1;
    UIPanGestureRecognizer *gesture1 = (UIPanGestureRecognizer *) sender;
    
    CGPoint p = [gesture1 locationInView:feed_table];
    
    NSIndexPath *indexPath = [feed_table indexPathForRowAtPoint:p];
    sub_image_array=[[NSMutableArray alloc]init];
    if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"]) {
        sub_image_array=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
    }
    else
    {
        [ sub_image_array addObject :[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"] ];
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    
    [collection_view reloadData];
    [collection_view scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    collection_bg_view.hidden=NO;
    
}

-(void)image_four_click:(id)sender
{
    COMPOSE_FLAG=1;
    UIPanGestureRecognizer *gesture1 = (UIPanGestureRecognizer *) sender;
    
    CGPoint p = [gesture1 locationInView:feed_table];
    
    NSIndexPath *indexPath = [feed_table indexPathForRowAtPoint:p];
    sub_image_array=[[NSMutableArray alloc]init];
    if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"]) {
        sub_image_array=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
    }
    else
    {
        [ sub_image_array addObject :[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"] ];
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
    [collection_view reloadData];
    [collection_view scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    collection_bg_view.hidden=NO;
    
}

-(void)image_five_click:(id)sender
{
    COMPOSE_FLAG=1;
    UIPanGestureRecognizer *gesture1 = (UIPanGestureRecognizer *) sender;
    
    CGPoint p = [gesture1 locationInView:feed_table];
    
    NSIndexPath *indexPath = [feed_table indexPathForRowAtPoint:p];
    sub_image_array=[[NSMutableArray alloc]init];
    if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"]) {
        sub_image_array=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
    }
    else
    {
        [ sub_image_array addObject :[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"] ];
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];
    [collection_view reloadData];
    [collection_view scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    collection_bg_view.hidden=NO;
    
}


-(void)image_cell_touch:(id)sender
{
    COMPOSE_FLAG=1;
    UIPanGestureRecognizer *gesture1 = (UIPanGestureRecognizer *) sender;
    
    CGPoint p = [gesture1 locationInView:feed_table];
    
    NSIndexPath *indexPath = [feed_table indexPathForRowAtPoint:p];
    sub_image_array=[[NSMutableArray alloc]init];
    if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"]) {
        sub_image_array=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
    }
    else
    {
        [ sub_image_array addObject :[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"] ];
    }
    
}



#pragma mark - UITableViewDelegate Methods

-(void)image_size:(NSIndexPath *)indexpath

{
    
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
    
    
        imageView1.contentMode=UIViewContentModeScaleAspectFit;
    
        imageView1.clipsToBounds=YES;
        imageView1.hidden=YES;
        clarity_image_array=[[NSMutableArray alloc]init];
        NSString *url_str_profile=[[feed_array objectAtIndex:indexpath.row]objectForKey:@"image"];
        [clarity_image_array addObject:url_str_profile];
        NSString *url_str=[clarity_image_array objectAtIndex:0];
        NSURL *image_url=[NSURL URLWithString:url_str];
        [imageView1 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
      //  CGSize image_size=imageView1.frame.size;
    

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==feed_table)
    {
        detail_feed_index=indexPath;
        [self performSegueWithIdentifier:@"FEED_DETAIL" sender:self];
        
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==image_comment_table)
    {
        
        CGSize size = [[[comment_list_array objectAtIndex:indexPath.row] objectForKey:@"comment_body"]
                       sizeWithFont:[UIFont systemFontOfSize:14]
                       constrainedToSize:CGSizeMake(230, CGFLOAT_MAX)];
        return size.height+80;
    }
    else if (tableView==like_table)
    {
        return 60;
    }
    else
        
    {
        if([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"profile_photo_update"])
            
        {
           
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
            imageView1.contentMode=UIViewContentModeScaleAspectFit;
            imageView1.clipsToBounds=YES;
            imageView1.hidden=YES;
            clarity_image_array=[[NSMutableArray alloc]init];
            NSString *url_str_profile=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
            [clarity_image_array addObject:url_str_profile];
            NSString *url_str=[clarity_image_array objectAtIndex:0];
            NSURL *image_url=[NSURL URLWithString:url_str];
            [imageView1 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
            CGSize image_size=imageView1.frame.size;
            return image_size.height+145;
            
            
        }
        else if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"image"])
        {
            image_feed_array=[[NSMutableArray alloc]init];
            image_feed_array=[[feed_array objectAtIndex:indexPath.row]objectForKey:@"image"];
            
            if (image_feed_array.count==1)
            {
                UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
                imageView1.contentMode=UIViewContentModeScaleAspectFit;
                imageView1.clipsToBounds=YES;
                imageView1.hidden=YES;
                clarity_image_array=[[NSMutableArray alloc]init];
                NSString *url_str=[image_feed_array objectAtIndex:0];
                NSURL *image_url=[NSURL URLWithString:url_str];
                [imageView1 setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
                CGSize image_size=imageView1.frame.size;
              
                if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]isEqualToString:@""])
                {
                    return image_size.height+115;
                }
                else
                {
                   
                    return image_size.height+146;
 
                }
            }
            else if (image_feed_array.count>1)
            {
                if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]isEqualToString:@""])
                {
                    NSLog(@"NO TEXT CONDITIOn");
                    return 418;
                }
                else
                {
                    NSLog(@"TEXT PRESENT CONDTion");
                    
                    return 448;
                    
                }
 
            }
            return 470;

        }
        else if([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"video"])
        {
            if ([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]isEqualToString:@""])
            {
                NSLog(@"VIDEO TEXT MESSAGe");
                return 250;
            }
            else
            {
            return 292;
            }
        }
        else if([[[feed_array objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"text"])
        {
            NSLog(@"INNNTEXt");
            CGSize size = [[[feed_array objectAtIndex:indexPath.row]objectForKey:@"text_message"]
                           sizeWithFont:[UIFont fontWithName:@"Roboto-Regular" size:15]
                           constrainedToSize:CGSizeMake(310, CGFLOAT_MAX)];
            
            NSLog(@"Height :%i",size.height+100);
            return size.height+120;
        }
        else
        {
            return 200;
        }
    }
    return 0;
}



-(void)video_play_action:(UIButton *)sender
{
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    Video_Table_Cell *cell_p = (Video_Table_Cell*)[feed_table cellForRowAtIndexPath:indexPath1];
    cell_p.video_play_button.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell_p.video_play_button.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
    }];
    
    NSString *url_str=[[feed_array objectAtIndex:indexPath1.row]objectForKey:@"video"];
    
//    NSURL *url = [NSURL URLWithString:url_str];
//    
//    
//    MPMoviePlayerViewController * controller = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    [controller.moviePlayer prepareToPlay];
//    controller.moviePlayer.fullscreen=YES;
//    
//    [controller.moviePlayer play];
//    
//    // and present it
//    [self presentMoviePlayerViewControllerAnimated:controller];
//    
    
    
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
-(void)comment_button_action:(UIButton *)sender
{
    
    indexPath_comment=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    Text_Cell *cell_p = (Text_Cell*)[feed_table cellForRowAtIndexPath:indexPath_comment];
    cell_p.comment_button.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell_p.comment_button.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
    }];
    POST_ID_FEED=[[[feed_array objectAtIndex:indexPath_comment.row]objectForKey:@"post_id"] integerValue];
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, comment_bg_view.frame.size.height - 50, comment_bg_view.frame.size.width, 50)];
    containerView.backgroundColor=[style colorWithHexString:text_bg_color];
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
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
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
    comment_list_array=[[NSMutableArray alloc]init];
    [image_comment_table reloadData];
    [self Comment_list_image];
    
    
}

-(void)comment_label_action:(id)sender
{
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    //  NSIndexPath index=sender.view.tag;
    indexPath_comment=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    
    Text_Cell *cell_p = (Text_Cell*)[feed_table cellForRowAtIndexPath:indexPath_comment];
    
    
    
    
    
    [UIView animateWithDuration:0.2
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell_p.count_label.alpha=0.5;
                         cell_p.count_label.textColor = [style colorWithHexString:@"4CA5E0"];
                         
                         cell_p.comment_count_label.alpha=0.5;
                         cell_p.comment_count_label.textColor = [style colorWithHexString:@"4CA5E0"];

                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2 animations:^{
                             
                             cell_p.count_label.alpha=1.0;
                             cell_p.count_label.textColor = [style colorWithHexString:terms_of_services_color];
                             
                             cell_p.comment_count_label.alpha=1.0;
                             cell_p.comment_count_label.textColor = [style colorWithHexString:terms_of_services_color];

                             
                             POST_ID_FEED=[[[feed_array objectAtIndex:indexPath_comment.row]objectForKey:@"post_id"] integerValue];
                             containerView = [[UIView alloc] initWithFrame:CGRectMake(0, comment_bg_view.frame.size.height - 50, comment_bg_view.frame.size.width, 50)];
                             containerView.backgroundColor=[style colorWithHexString:text_bg_color];
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
                             textView.returnKeyType = UIReturnKeyDefault; //just as an example
                             textView.font = [UIFont systemFontOfSize:15.0f];
                             textView.delegate = self;
                             textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
                             textView.backgroundColor = [UIColor whiteColor];
                             textView.placeholder = @"Type your comments....";
                             
                             [self.view addSubview:containerView];
                             
                             textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                             
                             [containerView addSubview:textView];
                             
                             UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                             doneBtn.frame = CGRectMake(containerView.frame.size.width - 57, 6, 35, 35);
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
                             comment_list_array=[[NSMutableArray alloc]init];
                             [image_comment_table reloadData];
                             [self Comment_list_image];
                             
                         }];
                     }];

    
    
}

-(void)like_btn_action:(UIButton *)sender
{
    @try {
        
        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        Text_Cell *cell_p = (Text_Cell*)[feed_table cellForRowAtIndexPath:indexPath1];
        cell_p.like_button.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            cell_p.like_button.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished)
        {
        }];
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
         
            if ([connectobj string_check:TOCKEN]==true &&[connectobj int_check:USER_ID]==true  &&[connectobj int_check:[[[feed_array objectAtIndex:indexPath1.row] objectForKey:@"post_id"]integerValue]]==true  &&[connectobj int_check:[[[feed_array objectAtIndex:indexPath1.row] objectForKey:@"poster_id"]integerValue]]==true)
                
            {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOCKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[[[feed_array objectAtIndex:indexPath1.row] objectForKey:@"post_id"]integerValue]] forKey:@"post_id"];
                [param setObject:[NSNumber numberWithInteger:[[[feed_array objectAtIndex:indexPath1.row] objectForKey:@"poster_id"]integerValue]] forKey:@"poster_id"];
                
                
                NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/feedlikeunlike"];
                
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
                
                NSOperationQueue  *like_queue = [[NSOperationQueue alloc] init];
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
                                               NSDictionary *json =
                                               [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   if(status==1)
                                                   {
                                                       if ([[json objectForKey:@"type"] isEqualToString:@"like"])
                                                       {
                                                           [cell_p.like_button setTitleColor:[style colorWithHexString:blueButton] forState:UIControlStateNormal];
                                                           
                                                           feed_array=[feed_array mutableCopy];
                                                           cell_p.like_count_label.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"post_total_like_count"]];
                                                           NSMutableDictionary *entry = [[feed_array objectAtIndex:indexPath1.row]mutableCopy];
                                                           [entry setObject:@"liked" forKey:@"like_status"];
                                                           [entry setObject:[json objectForKey:@"post_total_like_count"] forKey:@"post_total_like_count"];
                                                           [entry mutableCopy];
                                                           [feed_array replaceObjectAtIndex:indexPath1.row withObject:entry];
                                                           
                                                       }
                                                       else  if ([[json objectForKey:@"type"] isEqualToString:@"unlike"])
                                                       {
                                                           [cell_p.like_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                                                           feed_array=[feed_array mutableCopy];
                                                           cell_p.like_count_label.text=[NSString stringWithFormat:@"%@",[json objectForKey:@"post_total_like_count"]];
                                                           NSMutableDictionary *entry = [[feed_array objectAtIndex:indexPath1.row]mutableCopy];
                                                           [entry setObject:@"unliked" forKey:@"like_status"];
                                                           [entry setObject:[json objectForKey:@"post_total_like_count"] forKey:@"post_total_like_count"];
                                                           [entry mutableCopy];
                                                           [feed_array replaceObjectAtIndex:indexPath1.row withObject:entry];
                                                       }
                                                       
                                                       
                                                       
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
                                                   
                                               });
                                           }
                                           
                                           if (connectionError)
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   NSLog(@"error detected:%@", connectionError.localizedDescription);
//                                                   [self alertStatus:@"Network Error"];
//                                                   return ;
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


#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==img_preview_collection)
    {
        NSLog(@"IN IMAGE COLLECTION :%lu",(unsigned long)self.assets.count);

        if (VIDEO_FLAG==1)
        {
            return 1;
        }
        if (self.assets.count==5) {
            return 5;
        }
        if (self.assets.count==4) {
            return 5;
        }

        if (self.assets.count==3) {
            return 4;
        }
        if (self.assets.count==2) {
            return 3;
        }
        if (self.assets.count==1) {
            return 2;
        }
        return self.assets.count;
    }
    else
    return sub_image_array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==img_preview_collection)
    {
        static NSString  *identifier = @"CELL";
        SportsCell *cell = (SportsCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        if (VIDEO_FLAG==1)
        {
            cell.sport_image.image=thumbnail_video;
            cell.prof_images.hidden=NO;
        }

        if (self.assets.count==5)
        {
            ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
             cell.sport_image.image=[UIImage imageWithCGImage:asset.aspectRatioThumbnail];
            cell.prof_images.hidden=NO;
        }
        else  if (self.assets.count==4)
        {
            ALAsset *asset ;
            if (indexPath.row<4)
            {
                asset = [self.assets objectAtIndex:indexPath.row];
                cell.sport_image.image=[UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                cell.prof_images.hidden=NO;
            }
            else
            {
            if (indexPath.row==4)
            {
                 cell.sport_image.image=[UIImage imageNamed:@"plus.png"];
                cell.prof_images.hidden=YES;
            }
            }
        }
        else  if (self.assets.count==3)
        {
            ALAsset *asset;
            if (indexPath.row<3)
            {
                asset = [self.assets objectAtIndex:indexPath.row];
                cell.sport_image.image=[UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                cell.prof_images.hidden=NO;
            }
            else
            {
                if (indexPath.row==3)
                {
                    cell.sport_image.image=[UIImage imageNamed:@"plus.png"];
                    cell.prof_images.hidden=YES;
                }
            }
        }
        else  if (self.assets.count==2)
        {
            ALAsset *asset ;
            if (indexPath.row<2)
            {
                asset = [self.assets objectAtIndex:indexPath.row];
                cell.sport_image.image=[UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                cell.prof_images.hidden=NO;
            }
            else
            {
                if (indexPath.row==2)
                {
                    cell.sport_image.image=[UIImage imageNamed:@"plus.png"];
                    cell.prof_images.hidden=YES;
                }
            }
        }
        else  if (self.assets.count==1)
        {
            ALAsset *asset ;
            if (indexPath.row<1)
            {
                asset = [self.assets objectAtIndex:indexPath.row];
                cell.sport_image.image=[UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                cell.prof_images.hidden=NO;
            }
            else
            {
                if (indexPath.row==1)
                {
                    cell.sport_image.image=[UIImage imageNamed:@"plus.png"];
                    cell.prof_images.hidden=YES;
                }
            }
        }
       
        cell.sport_image.contentMode = UIViewContentModeScaleAspectFit;
        cell.sport_image.clipsToBounds = YES;
        
        UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image_close_click:)];
        cell.prof_images.userInteractionEnabled=YES;
        cell.prof_images.tag=indexPath.row;
        [cell.prof_images addGestureRecognizer:gesture_follow];
        return cell;

    }
    else
    {
        static NSString  *identifier = @"CELL";
        SportsCell *cell = (SportsCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if ([[UIScreen mainScreen]bounds].size.height !=568)
        {
          
            cell.scrollview.frame=CGRectMake(0, 10, 340, 420);
            cell.sport_image.frame=CGRectMake(0, 10, 340, 420);
            
        }
        NSString *url_str=[sub_image_array objectAtIndex:indexPath.row];
        NSURL *image_url=[NSURL URLWithString:url_str];
        [cell.sport_image setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"no_im_feed"]];
        cell.sport_image.contentMode = UIViewContentModeScaleAspectFit;
        cell.sport_image.clipsToBounds = YES;
        cell.sport_image.frame = cell.scrollview.bounds;
        cell.scrollview.contentSize = CGSizeMake( cell.sport_image.frame.size.width,  cell.sport_image.frame.size.height);
        cell.scrollview.maximumZoomScale = 4.0;
        cell.scrollview.minimumZoomScale = 1.0;
        cell.scrollview.delegate = self;
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"DIIIID");
    
    if (collectionView==img_preview_collection)
    {
        NSLog(@"DID SELECT");
          if (self.assets.count==4)
        {
                if (indexPath.row==4)
                {
                   [self more_photo_select];
                }
            }
        }
         if (self.assets.count==3)
        {
                if (indexPath.row==3)
                {
                   [self more_photo_select];
                }
        }
         if (self.assets.count==2)
        {
            if (indexPath.row==2)
                {
                   [self more_photo_select];
                }
          
        }
          if (self.assets.count==1)
        {
            NSLog(@"IN COUNT 1");
            if (indexPath.row==1)
                {
                    [self more_photo_select];
                }
        }
    
}

-(void)more_photo_select
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allPhotos];
    picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    picker.delegate             = self;
    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
    
    [self presentViewController:picker animated:YES completion:nil];
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

-(void)viewDidAppear:(BOOL)animated{
   
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(STOP_TIMER) name:@"BACKGROUNDTIMER" object:nil];
    
    msg_bubble_view.hidden=YES;
    cv=0;
    NSLog(@"VIEWDIDAPPEAR");
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
       // page_number=0;
    
   location_string=@"location";

    if ([[UIScreen mainScreen]bounds].size.height ==480)
    {
        msg_bubble_view.frame=CGRectMake(260, 368, 59, 61);
        post_bg_view.frame=CGRectMake(0, 20, 320, 460);
        feed_post_scroll.frame=CGRectMake(0, 55, 320, 400);
        feed_post_footer.frame=CGRectMake(0, 405, 320, 60);
        collection_bg_view.frame=CGRectMake(0, 20, 320, 460);
        collection_view.frame=CGRectMake(0, 42, 320, 420);
        progress_view.frame=CGRectMake(0, 0, 320, 432);
        pgress_bg.frame=CGRectMake(17,170,287,113);
        report_abuse_view.frame=CGRectMake(8, 70, 304, 364);
        tabbar_border_label.frame=CGRectMake(0, 430, 320, 1);
    }
    
    
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

    
    
    text_post_field.frame=CGRectMake(0, 51, 320, 61);
    
    
    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MESSAGE_ACTION)];
    msg_bubble_view.userInteractionEnabled=YES;
    [msg_bubble_view addGestureRecognizer:gesture_follow];
    
    UITapGestureRecognizer *gesture_message=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MESSAGE_ACTION)];
    msg_bubble_view.userInteractionEnabled=YES;
    [msg_bubble_view addGestureRecognizer:gesture_message];

  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MESSAGE_BUBBLE_ACTION) name:@"UNREADMESSAGE" object:nil];
    
   timer_feed=[NSTimer scheduledTimerWithTimeInterval:3.0 target: self selector: @selector(GET_USER_DATA_NEW) userInfo: nil repeats: YES];
    
    thread_count=0;
    
    
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

-(void)STOP_TIMER
{
    [timer_feed invalidate];
    timer_feed=nil;
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

-(void)MESSAGE_ACTION
{
    msg_bubble_view.hidden=YES;
    sqlfunction=[[SQLFunction alloc]init];
    [sqlfunction loadLoginSqlLiteDB];
    
    [sqlfunction SearchFromLoginTable];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *controller = [sb instantiateViewControllerWithIdentifier:@"MESSAGE"];
    controller.USER_ID= [[NSString stringWithFormat:@"%d",sqlfunction.userID] integerValue];
    controller.TOKEN=sqlfunction.userToken;
    [self presentViewController:controller animated:YES completion:nil];
}



-(void)showPageLoader_public
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


-(void) refreshNetworkStatus:(NSTimer*)time
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        netwok_error_view.hidden=YES;
        SERVER_FLAG=1;
        DB_FLAG=0;
    }
    else
    {
        SERVER_FLAG=0;
        netwok_error_view.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
        NSLog(@"NONET");
    }
}


////////////// commment BOX ///////

-(void)Comment_list_image
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
        
        if ([connectobj string_check:TOCKEN]==true  &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:POST_ID_FEED]==true)
        {
            [HUD hide:YES];
            [self stopSpin];
            [self showPageLoader_public];
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            [param setObject:TOCKEN forKey:@"token"];
            
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:POST_ID_FEED] forKey:@"post_id"];
            
            NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/listfeedcomments?"];
            
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
            
            NSOperationQueue *comment_list_queue = [[NSOperationQueue alloc] init];
            comment_list_queue.maxConcurrentOperationCount=1;
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:comment_list_queue
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
                                                   [image_comment_table reloadData];
                                                   NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:comment_list_array.count-1 inSection:0];
                                                   [image_comment_table selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                                                   if (Comment_flag==1)
                                                   {
                                                       
                                                       Text_Cell *cell_p = (Text_Cell*)[feed_table cellForRowAtIndexPath:indexPath_comment];
                                                       cell_p.comment_count_label.text=[NSString stringWithFormat:@"%d",comment_list_array.count];
                                                       
                                                       feed_array=[feed_array mutableCopy];
                                                       
                                                       NSMutableDictionary *entry = [[feed_array objectAtIndex:indexPath_comment.row]mutableCopy];
                                                       
                                                       [entry setObject:[NSString stringWithFormat:@"%d",comment_list_array.count] forKey:@"post_total_comment_count"];
                                                       [entry mutableCopy];
                                                       [feed_array replaceObjectAtIndex:indexPath_comment.row withObject:entry];
                                                       
                                                       Comment_flag=0;
                                                       
                                                       
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
    Comment_flag=1;
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        if ([connectobj string_check:TOCKEN]==true &&[connectobj string_check:textView.text]==true &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:POST_ID_FEED]==true)
        {
            [self showPageLoader_public];
            netwok_error_view.hidden=YES;
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            
            [param setObject:TOCKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:POST_ID_FEED] forKey:@"post_id"];
            [param setObject:textView.text forKey:@"comment"];
            NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/postcomment?"];
            
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
            
            NSOperationQueue *comment_queue = [[NSOperationQueue alloc] init];
            comment_queue.maxConcurrentOperationCount=1;
            
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:comment_queue
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
                                                   [self Comment_list_image];
                                                   
                                                   
                                               });
                                               
                                               
                                               
                                               
                                               //  NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:[comment_list_array count]-1 inSection:0];
                                               // [tableview scrollToRowAtIndexPath:indexPath1 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                               //[scrollview scrollRectToVisible:<#(CGRect)#> animated:<#(BOOL)#>];
                                               
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
//                                               [self alertStatus:@"Network Error"];
//                                               return ;
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
        netwok_error_view.hidden=NO;
    }
    
    
}

-(void)resignTextView
{
    if ( [textView.text isEqualToString:@"Type your comments...."] || [textView.text isEqualToString:@""] )
    {
        [textView resignFirstResponder];
        [self alertStatus:@"Please enter your comment"];
        return;
    }
    else
    {
    [self SEND:nil];
    textView.text=@"";
    [textView resignFirstResponder];
    containerView.hidden=NO;
    }
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note
{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration1 = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve1 = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    if (Feed_post_Flag==1)
    {
        if ([[UIScreen mainScreen]bounds].size.height !=568)
        {
            NSLog(@"In FEED FLAG 4");
            text_post_field.frame=CGRectMake(0, 51, 320, 100);
            text_post_field.contentSize=CGSizeMake(310, height+10);
            feed_post_footer.frame=CGRectMake(0,405-keyboardBounds.size.height, 320, 60);
            img_preview_collection.frame=CGRectMake(0, text_post_field.frame.origin.y+text_post_field.frame.size.height+10, 320, 80);
        }
        else
        {
        NSLog(@"In FEED FLAG");
        text_post_field.frame=CGRectMake(0, 51, 320, 100);
        text_post_field.contentSize=CGSizeMake(310, height+10);
        feed_post_footer.frame=CGRectMake(0,500-keyboardBounds.size.height, 320, 59);
        img_preview_collection.frame=CGRectMake(0, text_post_field.frame.origin.y+text_post_field.frame.size.height+10, 320, 80);
        }
    }
    NSLog(@"TEXT START");
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)-35;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration1 doubleValue]];
    [UIView setAnimationCurve:[curve1 intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        NSLog(@"In FEED FLAG 4");
        feed_post_footer.frame=CGRectMake(0, 405, 320, 50);

    }
    else
    {
        feed_post_footer.frame=CGRectMake(0, 489, 320, 59);

    }

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
    
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        containerView.frame = CGRectMake(0, 400, comment_bg_view.frame.size.width, 50);
    }
    else
    {
    containerView.frame = CGRectMake(0, comment_bg_view.frame.size.height - 50, comment_bg_view.frame.size.width, 50);
    }
    
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

-(void)comment_like_btn_action:(UIButton *)sender
{
    @try {
        
        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        MessageCell *cell_p = (MessageCell*)[image_comment_table cellForRowAtIndexPath:indexPath1];
        
        cell_p.like_btn.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            cell_p.like_btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
        }];
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            
            
            if ([connectobj string_check:TOCKEN]==true &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:POST_ID_FEED]==true &&[connectobj int_check:[[[comment_list_array objectAtIndex:indexPath1.row] objectForKey:@"comment_poster_id"]integerValue]]==true &&[connectobj int_check:[[[comment_list_array objectAtIndex:indexPath1.row] objectForKey:@"comment_id"]integerValue]]==true)
            {
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOCKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:POST_ID_FEED] forKey:@"post_id"];
                [param setObject:[NSNumber numberWithInteger:[[[comment_list_array objectAtIndex:indexPath1.row] objectForKey:@"comment_poster_id"]integerValue]] forKey:@"poster_id"];
                [param setObject:[NSNumber numberWithInteger:[[[comment_list_array objectAtIndex:indexPath1.row] objectForKey:@"comment_id"]integerValue]] forKey:@"comment_id"];
                
                
                
                NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/commentlikeunlike?"];
                
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
                NSOperationQueue *comment_like_queue = [[NSOperationQueue alloc] init];
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
                                               NSLog(@"RESPONSE :%@",response);
                                               NSDictionary *json =
                                               [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
                                               
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   if(status==1)
                                                   {
                                                       if ([[json objectForKey:@"type"] isEqualToString:@"like"])
                                                       {
                                                           [cell_p.like_btn setTitleColor:[style colorWithHexString:blueButton] forState:UIControlStateNormal];
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
                                                           [cell_p.like_btn setTitleColor:[style colorWithHexString:@"8e949b"] forState:UIControlStateNormal];
                                                           cell_p.like_count.text=[json objectForKey:@"comment_total_like_count"];
                                                           
                                                           comment_list_array=[comment_list_array mutableCopy];
                                                           NSMutableDictionary *entry = [[comment_list_array objectAtIndex:indexPath1.row]mutableCopy];
                                                           [entry setObject:@"0" forKey:@"like_status"];
                                                           [entry setObject:[json objectForKey:@"comment_total_like_count"] forKey:@"comment_total_likes"];
                                                           [entry mutableCopy];
                                                           [comment_list_array replaceObjectAtIndex:indexPath1.row withObject:entry];
                                                       }
                                                       
                                                       
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
                                                   
                                               });
                                               
                                               
                                           }
                                           if (connectionError)
                                           {
                                               
                                               NSLog(@"error detected:%@", connectionError.localizedDescription);
                                               dispatch_async(dispatch_get_main_queue(), ^{
//                                                   [self alertStatus:@"Network Error"];
//                                                   return ;
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

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{   NSLog(@"%i",
          scrollView.subviews.count);
    for (UIView *v in scrollView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            return v;
        }
    }
    return NO;
}


- (CGFloat)heightForTextView:(UITextView*)textView1 containingString:(NSString*)string
{
    float horizontalPadding = 18;
    float verticalPadding = 20;
    float widthOfTextView = textView1.contentSize.width - horizontalPadding;
    float height1 = [string sizeWithFont:[UIFont systemFontOfSize:kFontSize] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height1;
    
}
//- (void) textViewDidChange:(UITextView *)textView
//{
//    self.model = text_post_field.text;
//    NSLog(@"0000000%f",[self heightForTextView:text_post_field containingString:self.model]);
//    if ([self heightForTextView:text_post_field containingString:self.model]<100) {
//        
//        
//        float height = [self heightForTextView:text_post_field containingString:self.model];
//        
//        CGRect textViewRect = CGRectMake(0, 5, kTextViewWidth,height+20 );
//        
//        text_post_field.frame = textViewRect;
//        
//        text_post_field.contentSize = CGSizeMake(kTextViewWidth, [self heightForTextView:text_post_field containingString:self.model]);
//        text_height=[self heightForTextView:text_post_field containingString:self.model];
//        NSLog(@"TEXT HEIGHT :%f",text_height);
//        if ([[UIScreen mainScreen]bounds].size.height !=568)
//        {
////            text_bg_view.frame =CGRectMake(0,470-[self heightForTextView:post_textview containingString:self.model],320,[self heightForTextView:post_textview containingString:self.model]+40);
//            
//        }
//        else
//        {
//            
////            text_bg_view.frame =CGRectMake(0,530-[self heightForTextView:post_textview containingString:self.model],320,[self heightForTextView:post_textview containingString:self.model]+40);
////            
////            send_button.frame=CGRectMake(277,text_bg_view.frame.size.height-50, 40, 40);
//        }
//        
//        
//        text_post_field.text = self.model;
//    }
//    
//    
//}

- (void) textViewDidBeginEditing:(UITextView *)textView1

{
    NSLog(@"edit start");
    if ([textView1.text isEqualToString:@"Tell your buddies what you're up to..."])
    {
        textView1.text=@"";
    }
//    text_post_field.scrollEnabled=YES;
    textView1.tintColor=[UIColor blackColor];
    
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    //  [textView resignFirstResponder];
    //  post_bg_view.hidden=YES;
    
}


- (void)textViewDidChange:(UITextView *)txtView_post
{
    
    NSString *rawString = [txtView_post text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([txtView_post.text isEqualToString:@"Tell your buddies what you're up to..."] ||[txtView_post.text isEqualToString:@""] ||[trimmed length] == 0 )
    {
        post_button.hidden=YES;
    }
       else
    {
        post_button.hidden=NO;
        
    }
    if (SELECT_PHOTO_FLAG==1 || SELECT_VIDEO_FLAG==1)
    {
        post_button.hidden=NO;
    }
    
    
        self.model = text_post_field.text;
    
        NSLog(@"text change 0000000%f",[self heightForTextView:text_post_field containingString:self.model]);
    
        height = [self heightForTextView:text_post_field containingString:self.model];
    
    if (height>150)
    {
                    NSLog(@"Size is greater 200 :%f",text_post_field.frame.size.height);
                    
                   //text_post_field.scrollEnabled=YES;
                    text_post_field.contentSize=CGSizeMake(310, height-10);
    }
    else
    {
        NSLog(@"LESS THAN 200");
        text_post_field.frame=CGRectMake(0, 50, 320, height-10);
        img_preview_collection.frame=CGRectMake(0, text_post_field.frame.origin.y+text_post_field.frame.size.height+10, 320, 80);
    }

    
//    if (txtView_post==text_post_field)
//    {
//        float height = txtView_post.contentSize.height;
//        [UITextView beginAnimations:nil context:nil];
//        [UITextView setAnimationDuration:0.5];
//        
//        if (txtView_post.frame.size.height>200)
//        {
//            NSLog(@"Size is greater 200");
//            CGRect frame = txtView_post.frame;
//            frame.origin.y = frame.origin.y - 3.0;
//            frame.size.height = height + 10.0;//Give it some padding
//            txtView_post.frame = frame;
//        }
//        else
//        {
//            CGRect frame = txtView_post.frame;
//            frame.size.height = height + 10.0; //Give it some padding
//            txtView_post.frame = frame;
//        }
//       
//        
//       
//        
//        [UITextView commitAnimations];
//        
//        
//    }
   
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did end decelerating");
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==feed_table)
    {
        if ([scrollView.panGestureRecognizer translationInView:scrollView].y > 0)
        {
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options: UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 
                                 header_view.frame = CGRectMake(0, 20, 320, 104);
                                 if ([UIScreen mainScreen].bounds.size.height ==480)
                                 {
                                     feed_table.frame=CGRectMake(0, 128, 320, 306);
                                 }
                                 else
                                 {
                                     feed_table.frame=CGRectMake(0, 128, 320, 400);
                                 }
                                 
                             }
                             completion:^(BOOL finished){
                             }];
            
        }
        else
        {
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options: UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 header_view.frame = CGRectMake(0, -104, 320, 104);
                                 if ([UIScreen mainScreen].bounds.size.height ==480)
                                 {
                                     feed_table.frame=CGRectMake(0, 20, 320, 410);
                                 }
                                 else
                                 {
                                     feed_table.frame=CGRectMake(0, 20, 320, 503);
                                 }
                                 
                             }
                             completion:^(BOOL finished){
                             }];
            
            
            
        }

    }
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
   
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   
    [text_post_field resignFirstResponder];
  //  text_post_field.scrollEnabled=NO;
    text_post_field.frame = CGRectMake(0, 50, 320, height+25);
    if ([text_post_field.text isEqualToString:@""])
    {
        
        text_post_field.text=@"Tell your buddies what you're up to...";
        text_post_field.frame=CGRectMake(0, 50, 320, 51);
    }
    else if ([text_post_field.text isEqualToString:@"Tell your buddies what you're up to..."])
    {
        text_post_field.text=@"Tell your buddies what you're up to...";
        text_post_field.frame=CGRectMake(0, 50, 320, 51);
    }

     img_preview_collection.frame=CGRectMake(0, text_post_field.frame.origin.y+text_post_field.frame.size.height+15, 320, 80);
    feed_post_scroll.contentSize=CGSizeMake(320, img_preview_collection.frame.origin.y+img_preview_collection.frame.size.height+10);
    
}

#pragma Collection View Functions

-(void)USER_DETAILS
{
    [sqlfunction loadUserDetailsTable];
    NSMutableDictionary *dict=[sqlfunction searchUserDetailsTable:USER_ID];
    if (dict==NULL || dict.count==0 || [dict isEqual:[NSNull null]])
    {
        NSLog(@"LOCAL IS NULL");
        [self GET_PROFILE_DETAILS];
    }
    else
    {
        NSLog(@"PROFILE SHARE IMG NOT NULL");
        
        name_label_share.text=[[dict objectForKey:@"name"] capitalizedString];
        if([dict objectForKey:@"image_data"]==NULL)
        {
            NSLog(@"IMAGE NULL");
            pro_pic_share.image=[UIImage imageNamed:@"pro_pic_no_image.png"];
        }
        else
        {
            pro_pic_share.image=[UIImage imageWithData:[dict objectForKey:@"image_data"]];
        }

    }
}

-(void)GET_PROFILE_DETAILS
{
    [sqlfunction loadUserDetailsTable];
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        netwok_error_view.hidden=YES;
        //  [self showPageLoader];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithInt:USER_ID] forKey:@"user_id"];
        [param setObject:TOCKEN forKey:@"token"];
        
        NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/profiledetails?"];
        
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            name_label_share.text=[[json objectForKey:@"user_name"]capitalizedString];
                            
                            if([[json objectForKey:@"user_profile"]isEqualToString:@""])
                            {
                                pro_pic_share.image=[UIImage imageNamed:@"noimage.png"];
                            }
                            else
                            {
                                NSString *image_url=[json objectForKey:@"user_profile"];
                                NSURL *url=[NSURL URLWithString:image_url];
                                [pro_pic_share setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noimage.png"]];
                                
                            }

                         });
                         
                    
                     
                     
                     // [HUD hide:YES];
                     // [self stopSpin];
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
             });
    }
    else
    {
        netwok_error_view.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
    }
}

-(void)upload_video
{
    NSLog(@"UPLOAD VIDEO");
     NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/feedpost?"];
    NSString *new =[NSString stringWithFormat:@"token=%@&user_id=%d&type=video&location=kaloor&video_id=0&text_message=hii",TOCKEN,USER_ID];
        url_str=[url_str stringByAppendingString:new];
        NSLog(@"VIDEO URL :%@",url_str);
        NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"9c8cf_cc4b" ofType:@"mp4"];
        NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
    
        NSURL *irl=[NSURL URLWithString:url_str];
    NSLog(@"uuuu :%@",irl);
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:irl];

        NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:@"ggg" parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                      {
                                          [formData appendPartWithFileData:videoData name:@"file" fileName:@"filename.mov" mimeType:@"video/quicktime"];
                                      }];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
     {
         
       //  NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
         
     }];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {NSLog(@"Success");}
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {NSLog(@"error: %@",  operation.responseString);}];
    [operation start];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}


-(void)cell_touch_image :(NSString *)user_id
{
  
    
    if (USER_ID==[user_id integerValue])
    {
        [self performSegueWithIdentifier:@"FEED_PROFILE_ID" sender:self];
    }
    else
    {
        
        Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
        view_control.TOKEN=TOCKEN;
        view_control.USER_ID=USER_ID;
        view_control.FEED_FLAG=1;
        view_control.TARGETED_USER_ID=user_id;
        [self.view addSubview:view_control.view];
        
    }
 
}
-(void)cell_touch_label:(NSString *)user_id cell:(Text_Cell*)cell
{
    
    [UIView animateWithDuration:0.2
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell.name_label.alpha=0.5;
                         cell.name_label.textColor = [style colorWithHexString:@"4CA5E0"];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2 animations:^{
                             cell.name_label.alpha=1.0;
                             cell.name_label.textColor = [style colorWithHexString:terms_of_services_color];
                             @try
                             {
                                 
                                 if (USER_ID==[user_id integerValue])
                                 {
                                     [self performSegueWithIdentifier:@"FEED_PROFILE_ID" sender:self];
                                 }
                                 else
                                 {
                                     
                                     Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
                                     view_control.TOKEN=TOCKEN;
                                     view_control.USER_ID=USER_ID;
                                     view_control.FEED_FLAG=1;
                                     view_control.TARGETED_USER_ID=user_id;
                                     [self.view addSubview:view_control.view];
                                     
                                 }
                                 
                                 
                             }
                             @catch(NSException *theException){
                                 
                             }
                             
                         }];
                     }];

}

-(void)GET_USER_DATA_NEW
{
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
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
                             
                             
                            if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]] integerValue]>0)
                             {
                                
                                 
                                 NSUserDefaults *message_defaults = [NSUserDefaults standardUserDefaults];
                                 
                                 NSInteger msg_cout = [[message_defaults objectForKey:@"message_count"]integerValue];
                                 

                                 
                                 if (COMPOSE_FLAG !=1)
                                 {
                                     if (thread_count==0)
                                     {
                                         
                                         NSLog(@"THread Zero");
                                         [connectobj messagesound];
                                         msg_bubble_view.hidden=NO;
                                         CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
                                         animation.duration=0.4;
                                         animation.values= @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                                             [NSValue valueWithCATransform3D:CATransform3DIdentity]];
                                         
                                         animation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
                                         animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                                         [msg_bubble_view.layer addAnimation:animation forKey:nil];
                                         [self.view addSubview:msg_bubble_view];
                                         
                                         NSUserDefaults *message_defaults = [NSUserDefaults standardUserDefaults];
                                         [message_defaults setObject:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]] forKey:@"message_count"];
                                         [message_defaults setObject:@"EQUAL" forKey:@"status"];
                                          [message_defaults synchronize];
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UNREADMESSAGE" object:self];

                                         
                                         thread_count ++;
                                     }
                                     
                                     
                                    else if ([[json objectForKey:@"user_unread_message_count"]integerValue]>msg_cout)
                                     {
                                         [connectobj messagesound];
                                         msg_bubble_view.hidden=NO;

                                         NSUserDefaults *message_defaults = [NSUserDefaults standardUserDefaults];
                                         [message_defaults setObject:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]] forKey:@"message_count"];
                                         [message_defaults setObject:@"GREATER" forKey:@"status"];
                                         [message_defaults synchronize];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UNREADMESSAGE" object:self];

                                     }

                                     else
                                     {
                                         NSUserDefaults *message_defaults = [NSUserDefaults standardUserDefaults];
                                         [message_defaults setObject:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]] forKey:@"message_count"];
                                         [message_defaults setObject:@"EQUAL" forKey:@"status"];
                                         [message_defaults synchronize];
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UNREADMESSAGE" object:self];
                                         msg_bubble_view.hidden=NO;
                                     }
                                     
                                     msg_bubble_count.text=[message_defaults objectForKey:@"message_count"];
                                 }
                                 else
                                 {
                                     msg_bubble_view.hidden=YES;
                                 }
                             }
                             else if([[NSString stringWithFormat:@"%@",[json objectForKey:@"user_unread_message_count"]] integerValue]==0)
                             {
                                 NSUserDefaults *message_defaults = [NSUserDefaults standardUserDefaults];
                                 [message_defaults setObject:[NSString stringWithFormat:@"%@",@"0"] forKey:@"message_count"];
                                 [message_defaults synchronize];
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
        [HUD hide:YES];
        [self stopSpin];
    }
    
    
}






@end
