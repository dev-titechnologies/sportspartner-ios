//
//  FollowerViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 08/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "FollowerViewController.h"
#import "MessageCell.h"
#import "AFNetworking.h"
#import "ChatViewController.h"
#import "Public_Profile_ViewController.h"
#import "ViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "ViewController.h"
#import "SVPullToRefresh.h"
@interface FollowerViewController ()

@end

@implementation FollowerViewController
@synthesize USER_ID,TOKEN,PROFILE_FLAG;
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
    self.screenName=@"SP Followers List";
    
    __weak FollowerViewController *weakSelf = self;
    [follower_table addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(insertRowAtBottom) withObject:nil afterDelay:1.0];
    }];
    
    page_number=0;
    
    connectobj=[[connection alloc]init];
    style=[[Styles alloc]init];
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];
    
    header_view.backgroundColor=[style colorWithHexString:@"042e5f"];
    
    sqlfunction=[[SQLFunction alloc]init];
    follow_list_array=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"follower_bg.png"]];
    follower_table.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"follower_bg.png"]];
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    public_profile_view.userInteractionEnabled=YES;
    [public_profile_view addGestureRecognizer:recognizer];
    follow_friends.backgroundColor=[style colorWithHexString:terms_of_services_color];
    
    UISwipeGestureRecognizer *recognizer_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer_down:)];
    recognizer_down.direction = UISwipeGestureRecognizerDirectionDown;
    recognizer_down.numberOfTouchesRequired = 1;
    recognizer_down.delegate = self;
    public_profile_view.userInteractionEnabled=YES;
    [public_profile_view addGestureRecognizer:recognizer_down];
    
    ///////////// HEADER SECTION /////////////////
    
//    header_view.backgroundColor=[UIColor clearColor];
//    header_view.alpha=.5;
    header_label.font=[UIFont fontWithName:@"Roboto-Regular" size:23];
    header_label.textColor=[UIColor whiteColor];
    
    logout_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:40];
    [logout_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-sign-out"] forState:UIControlStateNormal];
    logout_button.backgroundColor=[UIColor clearColor];
    [logout_button setTitleColor:[style colorWithHexString:terms_of_services_color] forState:UIControlStateNormal];
    
    /////////// TABBAR///////////////////////////
    
    CGSize tabBarSize = [tabbar frame].size;
    UIView	*tabBarFakeView = [[UIView alloc] initWithFrame:
                               CGRectMake(0,0,tabBarSize.width, tabBarSize.height)];
    [tabbar insertSubview:tabBarFakeView atIndex:0];
    
    [tabBarFakeView setBackgroundColor:[style colorWithHexString:@"f2e7ea"]];
    tabbar_border_label.backgroundColor=[style colorWithHexString:@"e80243"];
    
    tabbar.translucent=YES;
    
    
    [follow_friends.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    no_follower_label.font=[UIFont fontWithName:@"Roboto-Regular" size:18];
    if (PROFILE_FLAG==1)
    {
        Back_button.hidden=NO;
        header_label.text=@"I'm Following";
        
    }
    else
    {
        header_label.text=@"My Followers";
        Back_button.hidden=YES;
        [tabbar setSelectedItem:[tabbar.items objectAtIndex:3]];
    }
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FOLLOW_LISTING_PUSH) name:@"followlist" object:nil];
    

}

-(void)FOLLOW_LISTING_PUSH
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        if ([connectobj string_check:TOKEN]==true  &&[connectobj int_check:USER_ID]==true)
        {
            networkErrorView.hidden=YES;
            [self showPageLoader];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                header_label.text=@"My Followers";
                [param setObject:@"me" forKey:@"type"];
                [param setObject:[NSNumber numberWithInt:0] forKey:@"page"];
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/followlist"];
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
                                                   follow_list_array=[[NSMutableArray alloc]init];
                                                   follow_list_array=[[json objectForKey:@"result"]mutableCopy];
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [follower_table reloadData];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                       no_follow_view.hidden=YES;
                                                       [follower_table setHidden:NO];
                                                       page_number=0;
                                                   });
                                                   
                                               }
                                               else if([[json objectForKey:@"message"] isEqualToString:@"No followers for this user"])
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [timer invalidate];
                                                       no_follow_view.hidden=NO;
                                                       [follower_table setHidden:YES];
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
                                               
                                               else
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       follow_list_array=[[NSMutableArray alloc]init];
                                                       [follower_table reloadData];
                                                       [timer invalidate];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                       no_follow_view.hidden=YES;
                                                       [follower_table setHidden:NO];
                                                       
                                                   });
                                               }
                                           }
                                           
                                           if (connectionError)
                                           {
                                               
                                               NSLog(@"error detected:%@", connectionError.localizedDescription);
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   no_follow_view.hidden=YES;
                                                   [follower_table setHidden:NO];
                                               });
                                               
                                           }
                                           
                                           
                                           
                                       }];
                
            });
            
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
        networkErrorView.hidden=NO;
    }
    
    
}


- (void) SwipeRecognizer:(UISwipeGestureRecognizer *)sender
{
    
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE LEFT ***");
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE RIGHT ***");
        
    }
    if ( sender.direction== UISwipeGestureRecognizerDirectionUp )
    {
        NSLog(@"SWIPE UP");
        PUBLIC_FLAG=0;
        tabbar.hidden=NO;
        follower_table.userInteractionEnabled=YES;
        [obj swipe_up:public_profile_view];
        NSLog(@"LIKE_FLAG:%ld",(long)obj.LIKE_FLAG);
        if(obj.LIKE_FLAG==2)
        {
            NSLog(@"UNLIKE FLAG");
            tabbar.hidden=NO;
            flash_label.attributedText=[self GET_SHADOW_STRING_PLACE:@"You unliked this profile photo"];
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
            } completion:^(BOOL finished) {
                flash_view.hidden = YES;
            }];

        }
         if(obj.LIKE_FLAG==1)
        {
             NSLog(@"LIKE FLAG");
            flash_label.attributedText=[self GET_SHADOW_STRING_PLACE:@"You liked this profile photo"];
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
            } completion:^(BOOL finished) {
                flash_view.hidden = YES;
            }];
 
        }
        if (PROFILE_FLAG==1)
        {
            if (obj.UN_FOLLOW_FLAG==1)
            {
                [follow_list_array removeObjectAtIndex:didselect_indexpath.row];
                [follower_table reloadData];
            }

        }
        else if(PROFILE_FLAG !=1)
        {
            if (obj.UN_FOLLOW_FLAG==1)
            {
                follow_list_array=[follow_list_array mutableCopy];
                NSMutableDictionary *entry = [[follow_list_array objectAtIndex:didselect_indexpath.row]mutableCopy];
                [entry setObject:@"0" forKey:@"follow_status"];
                [entry mutableCopy];
                [follow_list_array replaceObjectAtIndex:didselect_indexpath.row withObject:entry];
                [follower_table reloadData];

            }

            
            if (obj.FOLLOW_FLAG==1)
            {
                follow_list_array=[follow_list_array mutableCopy];
                NSMutableDictionary *entry = [[follow_list_array objectAtIndex:didselect_indexpath.row]mutableCopy];
                [entry setObject:@"1" forKey:@"follow_status"];
                [entry mutableCopy];
                [follow_list_array replaceObjectAtIndex:didselect_indexpath.row withObject:entry];
                [follower_table reloadData];
            }

        }
        
        NSLog(@"UNFOLLOW_FLAG :%d",obj.UN_FOLLOW_FLAG);
        
        
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
        tabbar.hidden=NO;
        PUBLIC_FLAG=0;
        follower_table.userInteractionEnabled=YES;
        [obj swipe_down:public_profile_view];
        if (PROFILE_FLAG==1)
        {
            if (obj.UN_FOLLOW_FLAG==1)
            {
                [follow_list_array removeObjectAtIndex:didselect_indexpath.row];
                [follower_table reloadData];
            }
            
        }
        else if(PROFILE_FLAG !=1)
        {
            if (obj.UN_FOLLOW_FLAG==1)
            {
                follow_list_array=[follow_list_array mutableCopy];
                NSMutableDictionary *entry = [[follow_list_array objectAtIndex:didselect_indexpath.row]mutableCopy];
                [entry setObject:@"0" forKey:@"follow_status"];
                [entry mutableCopy];
                [follow_list_array replaceObjectAtIndex:didselect_indexpath.row withObject:entry];
                [follower_table reloadData];
                
            }
            
            
            if (obj.FOLLOW_FLAG==1)
            {
                follow_list_array=[follow_list_array mutableCopy];
                NSMutableDictionary *entry = [[follow_list_array objectAtIndex:didselect_indexpath.row]mutableCopy];
                [entry setObject:@"1" forKey:@"follow_status"];
                [entry mutableCopy];
                [follow_list_array replaceObjectAtIndex:didselect_indexpath.row withObject:entry];
                [follower_table reloadData];
            }
            
        }


        
    }
}


- (void)insertRowAtBottom
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            if (total_row_count>follow_list_array.count)
            {
                page_number=page_number+1;
                
                [self MESSAGE_PAGINATION];

            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"FOLLOOOOW  NNNIIIII");
                    [follower_table.infiniteScrollingView stopAnimating];
                    
                });
               
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
    });
    
    
    
}

-(void)MESSAGE_PAGINATION
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([connectobj string_check:TOKEN]==true  &&[connectobj int_check:USER_ID]==true)
        {
            networkErrorView.hidden=YES;
            [HUD hide:YES];
            [self stopSpin];
            [self showPageLoader];
            timer = [NSTimer scheduledTimerWithTimeInterval: 7.0
                                                     target: self
                                                   selector: @selector(cancelURLConnection:)
                                                   userInfo: nil
                                                    repeats: NO];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInt:page_number] forKey:@"page"];
            if (PROFILE_FLAG==1)
            {
                header_label.text=@"I'm Following";
                [param setObject:@"notme" forKey:@"type"];
            }
            else if(PROFILE_FLAG!=1)
            {
                header_label.text=@"My Followers";
                [param setObject:@"me" forKey:@"type"];
            }
            
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/followlist"];
            
            NSLog(@"FOLLOW URL: %@",url_str);
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
                                               
                                               temp_follow_list_array=[[json objectForKey:@"result"]mutableCopy];
                                               [follow_list_array addObjectsFromArray:temp_follow_list_array];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                   [follower_table reloadData];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   no_follow_view.hidden=YES;
                                                   [follower_table setHidden:NO];
                                                   [follower_table.infiniteScrollingView stopAnimating];
                                               });
                                               
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"No followers for this user"])
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                  [follower_table.infiniteScrollingView stopAnimating];
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
                                           
                                           else
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   no_follow_view.hidden=YES;
                                                   [follower_table setHidden:NO];
                                                   [follower_table.infiniteScrollingView stopAnimating];
                                                   
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
           
        }
            
        });
    }
    else
    {
        [HUD hide:YES];
        [self stopSpin];
        networkErrorView.hidden=NO;
    }
    
    
}


-(void)MESSAGE_LISTING
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        if ([connectobj string_check:TOKEN]==true  &&[connectobj int_check:USER_ID]==true)
        {
            networkErrorView.hidden=YES;
            [HUD hide:YES];
            [self stopSpin];
            [self showPageLoader];
            timer = [NSTimer scheduledTimerWithTimeInterval: 7.0
                                                     target: self
                                                   selector: @selector(cancelURLConnection:)
                                                   userInfo: nil
                                                    repeats: NO];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInt:0] forKey:@"page"];
            if (PROFILE_FLAG==1)
            {
                header_label.text=@"I'm Following";
                [param setObject:@"notme" forKey:@"type"];
            }
            else if(PROFILE_FLAG!=1)
            {
                header_label.text=@"My Followers";
                [param setObject:@"me" forKey:@"type"];
            }
            
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/followlist"];
            
            NSLog(@"FOLLOW URL: %@",url_str);
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
                                           
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           
                                           
                                           
                                           NSLog(@"RESPFOLL :%@",json);
                                           
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               
                                               total_row_count=[[json objectForKey:@"total_row_count"]integerValue];
                                               follow_list_array=[[json objectForKey:@"result"]mutableCopy];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                   [timer invalidate];
                                                   [follower_table reloadData];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   no_follow_view.hidden=YES;
                                                   [follower_table setHidden:NO];
                                               });
                                               
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"No followers for this user"])
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [timer invalidate];
                                                   no_follow_view.hidden=NO;
                                                   [follower_table setHidden:YES];
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
                                           
                                           else
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   follow_list_array=[[NSMutableArray alloc]init];
                                                   [follower_table reloadData];
                                                   [timer invalidate];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   no_follow_view.hidden=YES;
                                                   [follower_table setHidden:NO];
                                                   
                                               });
                                           }
                                       }
                                       
                                       if (connectionError)
                                       {
                                           
                                           NSLog(@"error detected:%@", connectionError.localizedDescription);
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               no_follow_view.hidden=YES;
                                               [follower_table setHidden:NO];
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
        networkErrorView.hidden=NO;
    }
    
    
}


-(void)cancelURLConnection:(id)sender
{
    [queue cancelAllOperations];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"FOLLOWER_FEED"])
    {
        FeedViewController *feedcontrol=segue.destinationViewController;
        feedcontrol.TOCKEN=TOKEN;
        feedcontrol.USER_ID=USER_ID;
    }
    else if ([segue.identifier isEqualToString:@"FOLLOWER_PROFILE"])
    {
        ProfileViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOCKEN=TOKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"FOLLOWER_SETTINGS"])
    {
        SettingViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOCKEN=TOKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"FOLLOWER_SEARCH"])
    {
        SearchViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOKEN=TOKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"FOLLOWER_CHAT"])
    {
        ChatViewController *chatcontroller=segue.destinationViewController;
        chatcontroller.USER_ID=USER_ID;
        chatcontroller.TOKEN=TOKEN;
        chatcontroller.conversation_id=conversation_id;
        chatcontroller.RECEIVER_ID=Receiver_id;
        chatcontroller.URL_STRING=image_string;
    }


    
//    else if ([segue.identifier isEqualToString:@"FOLLOWER_PUBLIC_PROFILE"])
//    {
//        Public_Profile_ViewController *public_prof_control=segue.destinationViewController;
//        public_prof_control.USER_ID=USER_ID;
//        public_prof_control.TOKEN=TOKEN;
//        public_prof_control.TARGETED_USER_ID=TARGET_USER_ID;
//       
//    }

    
}


#pragma TABBAR FUNCTION


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
            [self performSegueWithIdentifier:@"FOLLOWER_FEED" sender:self];
            
            break;
        case 1:
            [self performSegueWithIdentifier:@"FOLLOWER_PROFILE" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"FOLLOWER_SEARCH" sender:self];
            break;
        case 3:
        {
            PROFILE_FLAG=0;
            Back_button.hidden=YES;
            [self MESSAGE_LISTING];
        }
            break;
        case 4:
            [self performSegueWithIdentifier:@"FOLLOWER_SETTINGS" sender:self];
            break;
            
        default:
            break;
    }
}

#pragma TABLEVIEW SECTION

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return follow_list_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CELLIDENTIFIER=@"CELL";
    MessageCell *message_cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    /////// CELL DESIGN ///////
    message_cell.backgroundColor=[UIColor clearColor];
    message_cell.Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    message_cell.Name_label.textColor=[style colorWithHexString:terms_of_services_color];
    message_cell.place_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    message_cell.place_label.textColor=[style colorWithHexString:@"777777"];
    message_cell.age_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    message_cell.side_view.backgroundColor=[style colorWithHexString:favourite_sports_selected_color];
    message_cell.profile_pic.contentMode=UIViewContentModeScaleAspectFill;
     message_cell.profile_pic.clipsToBounds=YES;
    //////////// Cell Content ////////
    
    message_cell.profile_pic.layer.borderColor=[UIColor clearColor].CGColor;
    message_cell.profile_pic.layer.cornerRadius=14.0;
    message_cell.profile_pic.layer.borderWidth=2.0;
    
    if ([[NSString stringWithFormat:@"%@",[[follow_list_array objectAtIndex:indexPath.row]objectForKey:@"gender"]] isEqualToString:@"3"])
        
    {
//       message_cell.age_label.text=@"F";
//       message_cell.age_label.textColor=[style colorWithHexString:age_color];
        message_cell.age_label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fs.png"]];
    }
    else if ([[NSString stringWithFormat:@"%@",[[follow_list_array objectAtIndex:indexPath.row]objectForKey:@"gender"]] isEqualToString:@"2"])
        
    {
        message_cell.age_label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ms.png"]];
//          message_cell.age_label.text=@"M";
//        message_cell.age_label.textColor=[style colorWithHexString:@"0C6DB4"];
    }
    
    if ([[NSString stringWithFormat:@"%@",[[follow_list_array objectAtIndex:indexPath.row]objectForKey:@"profile_pic"]] isEqualToString:@"0"])
        
    {
        message_cell.profile_pic.image=[UIImage imageNamed:@"noimage.png"];
    }
    else
    {
        NSString *url_str=[[follow_list_array objectAtIndex:indexPath.row]objectForKey:@"profile_pic"];
        NSURL *image_url=[NSURL URLWithString:url_str];
        [message_cell.profile_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
    }
    if (PROFILE_FLAG !=1)
    {
        
        if ([[NSString stringWithFormat:@"%@",[[follow_list_array objectAtIndex:indexPath.row]objectForKey:@"follow_status"]] isEqualToString:@"0"])
        {
                message_cell.follow_green_tick.hidden=YES;
             [message_cell.follow_button setImage:[UIImage imageNamed:@"kannu.png"] forState:UIControlStateNormal];
        }
        else
        {
           message_cell.follow_green_tick.hidden=NO;
         [message_cell.follow_button setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
        }
    }
    else if(PROFILE_FLAG==1)
    {
        
        message_cell.follow_green_tick.hidden=YES;
        [message_cell.follow_button setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
    }

    message_cell.selectionStyle=UITableViewCellSelectionStyleNone;
  //  message_cell.profile_pic.image=[[follow_list_array objectAtIndex:indexPath.row]objectForKey:@""];
    message_cell.Name_label.text=[[[follow_list_array objectAtIndex:indexPath.row]objectForKey:@"name"] capitalizedString];
    message_cell.place_label.text=[[follow_list_array objectAtIndex:indexPath.row]objectForKey:@"place"];
  
    
    message_cell.chat_button.userInteractionEnabled=YES;
    message_cell.chat_button.tag=indexPath.row;
    [message_cell.chat_button addTarget:self action:@selector(CHAT_ACTION_FOLLOW:) forControlEvents:UIControlEventTouchUpInside];
    
    message_cell.follow_button.userInteractionEnabled=YES;
    message_cell.follow_button.tag=indexPath.row;
    [message_cell.follow_button addTarget:self action:@selector(FOLLOW_ACTION_FOLLOW:) forControlEvents:UIControlEventTouchUpInside];
    
    return message_cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PUBLIC_FLAG=1;
    NSLog(@"AT FOLLOWER DIDSELECT");
    msg_bubble_view.hidden=YES;
    obj =[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
    didselect_indexpath=indexPath;
    TARGET_USER_ID=[[follow_list_array objectAtIndex:indexPath.row]objectForKey:@"user_id_follower"];
    [obj Clear];
    public_profile_view.hidden=NO;
    obj.USER_ID=USER_ID;
    obj.TOKEN=TOKEN;
    obj.TARGETED_USER_ID=TARGET_USER_ID;
    [obj.view removeFromSuperview];
    [public_profile_view addSubview:obj.view];
    public_profile_view.frame = CGRectMake(0, 0, 320, 548);
    obj.public_profile_view.frame=CGRectMake(0,0, 320, 568);
    [obj.view addSubview:back_button];
    public_profile_view.hidden=NO;
    tabbar.hidden=YES;
    follower_table.userInteractionEnabled=NO;
    
  //  [self performSegueWithIdentifier:@"FOLLOWER_PUBLIC_PROFILE" sender:self];
}

-(void)CHAT_ACTION_FOLLOW:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        conversation_id=[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"conversation_id"];
        Receiver_id=[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"user_id_follower"];
        image_string=[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"profile_pic"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
          [self performSegueWithIdentifier:@"FOLLOWER_CHAT" sender:self];
            
        });
        
    });

    
   
}

-(NSAttributedString *)GET_SHADOW_STRING_PLACE:(NSString *)string_value
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

-(void)FOLLOW_ACTION_FOLLOW:(UIButton *)sender
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        NSString *follow_user_id=[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"user_id_follower"];

        if ([connectobj string_check:TOKEN]==true  &&[connectobj int_check:USER_ID]==true &&[connectobj int_check:[follow_user_id intValue]]==true)
        {
            networkErrorView.hidden=YES;
            [self showPageLoader];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInt:USER_ID]forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[follow_user_id intValue]] forKey:@"follow_user_id"];
                
                if (PROFILE_FLAG==1)
                {
                    [param setObject:@"unfollow" forKey:@"type"];
                }
                else if(PROFILE_FLAG!=1)
                {
                    if([[NSString stringWithFormat:@"%@",[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"follow_status"]] isEqualToString:@"1"])
                    {
                        [param setObject:@"unfollow" forKey:@"type"];
                    }
                    else   if([[NSString stringWithFormat:@"%@",[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"follow_status"]] isEqualToString:@"0"])
                    {
                        [param setObject:@"follow" forKey:@"type"];
                    }
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
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                               });
                                           }
                                           else
                                           {
                                               
                                               NSLog(@"RESPONSE CODE : %@",response);
                                               NSDictionary *json =
                                               [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
                                                NSLog(@"FOLLOW RESPONSE :%@",json);
                                               
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               if(status==1)
                                               {
                                                   NSLog(@"FOLLOW SUCCESS");
                                                   if (PROFILE_FLAG==1)
                                                   {
                                                       NSString *flash_string=@"You have stopped following ";
                                                       flash_string=[flash_string stringByAppendingString:[[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"name"] capitalizedString]];
                                                       flash_label.attributedText=[self GET_SHADOW_STRING_PLACE:flash_string];
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
                                                       
                                                       [follow_list_array mutableCopy];
                                                       [follow_list_array removeObjectAtIndex:sender.tag];
                                                   }
                                                   else if (PROFILE_FLAG !=1)
                                                   {
                                                       
                                                       if([[NSString stringWithFormat:@"%@",[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"follow_status"]] isEqualToString:@"1"])
                                                       {
                                                           
                                                           NSString *flash_string=@"You have stopped following ";
                                                           flash_string=[flash_string stringByAppendingString:[[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"name"] capitalizedString]];
                                                           flash_label.attributedText=[self GET_SHADOW_STRING_PLACE:flash_string];
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
                                                           
                                                           follow_list_array=[follow_list_array mutableCopy];
                                                           NSMutableDictionary *entry = [[follow_list_array objectAtIndex:sender.tag]mutableCopy];
                                                           [entry setObject:@"0" forKey:@"follow_status"];
                                                           [entry mutableCopy];
                                                           [follow_list_array replaceObjectAtIndex:sender.tag withObject:entry];
                                                           [follower_table reloadData];
                                                       }
                                                       else   if([[NSString stringWithFormat:@"%@",[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"follow_status"]] isEqualToString:@"0"])
                                                       {
                                                           NSString *flash_string=@"You started following ";
                                                           flash_string=[flash_string stringByAppendingString:[[[follow_list_array objectAtIndex:sender.tag]objectForKey:@"name"] capitalizedString]];
                                                           
                                                           flash_label.attributedText=[self GET_SHADOW_STRING_PLACE:flash_string];
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
                                                           
                                                           follow_list_array=[follow_list_array mutableCopy];
                                                           NSMutableDictionary *entry = [[follow_list_array objectAtIndex:sender.tag]mutableCopy];
                                                           [entry setObject:@"1" forKey:@"follow_status"];
                                                           [entry mutableCopy];
                                                           [follow_list_array replaceObjectAtIndex:sender.tag withObject:entry];
                                                           [follower_table reloadData];
                                                       }
                                                   }
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [follower_table reloadData];
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
            [HUD hide:YES];
            [self stopSpin];
            [self alertStatus:@"Server Error"];
            return;
        }

           }
    else
    {
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
        
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 60, 320, 370)];
    }
    else
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 60, 320, 458)];
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
    
    if ([UIScreen mainScreen].bounds.size.height==480)
    {
         msg_bubble_view.frame=CGRectMake(260, 368, 59, 61);
        tabbar_border_label.frame=CGRectMake(0, 430, 320, 1);
    }
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
    NSLog(@"ViewDIDAppp");
    [self MESSAGE_LISTING];
    
    flash_view=[[UIView alloc]initWithFrame:CGRectMake(10, 280, 300, 50)];
    flash_view.layer.cornerRadius=8.0;
    flash_view.clipsToBounds=YES;
    flash_view.backgroundColor=[UIColor blackColor];
    flash_view.alpha=.3;
    flash_label =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 300, 40)];
    flash_label.numberOfLines=2;
    flash_label.textAlignment=NSTextAlignmentCenter;
    flash_label.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    flash_label.textColor=[UIColor whiteColor];
    [flash_view addSubview:flash_label];
    [self.view addSubview:flash_view];
    flash_view.hidden=YES;
     msg_bubble_view.hidden=YES;
    
    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MESSAGE_ACTION)];
    msg_bubble_view.userInteractionEnabled=YES;
    [msg_bubble_view addGestureRecognizer:gesture_follow];
    
    UITapGestureRecognizer *gesture_message=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MESSAGE_ACTION)];
    msg_bubble_view.userInteractionEnabled=YES;
    [msg_bubble_view addGestureRecognizer:gesture_message];
    
    thread_count=0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MESSAGE_BUBBLE_ACTION) name:@"UNREADMESSAGE" object:nil];
    
    
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


-(void)MESSAGE_BUBBLE_ACTION
{
    if (PUBLIC_FLAG!=1)
    {
        NSUserDefaults *message_defaults = [NSUserDefaults standardUserDefaults];
        
        NSInteger msg_cout = [[message_defaults objectForKey:@"message_count"]integerValue];
        
        if (msg_cout>0)
        {
            
            if (thread_count==0)
            {
                msg_bubble_view.hidden=NO;
                [connectobj messagesound];
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
                thread_count++;
            }
//            else if([[message_defaults objectForKey:@"status"] isEqualToString:@"GREATER"])
//            {
//                NSLog(@"Greater count");
//                msg_bubble_view.hidden=NO;
//                [connectobj messagesound];
//            }
            else
            {
                msg_bubble_view.hidden=NO;
            }
            
            
            msg_bubble_count.text=[message_defaults objectForKey:@"message_count"];
        }
        else
        {
            msg_bubble_view.hidden=YES;
        }

    }
    else
    {
        msg_bubble_view.hidden=YES;
        NSLog(@"PUBLIC FLLLAAAG");
        
    }
    
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


- (IBAction)BACK_BUTTON:(id)sender
{
   [self performSegueWithIdentifier:@"FOLLOWER_PROFILE" sender:self];
}


- (IBAction)PUBLIC_VIEW_BACK:(id)sender
{
    PUBLIC_FLAG=0;
    NSLog(@"PUBLIC VIEW BACK");
    if (PROFILE_FLAG==1)
    {
        if (obj.UN_FOLLOW_FLAG==1)
        {
            [follow_list_array removeObjectAtIndex:didselect_indexpath.row];
            [follower_table reloadData];
        }
        
    }
    else if(PROFILE_FLAG !=1)
    {
        if (obj.UN_FOLLOW_FLAG==1)
        {
            follow_list_array=[follow_list_array mutableCopy];
            NSMutableDictionary *entry = [[follow_list_array objectAtIndex:didselect_indexpath.row]mutableCopy];
            [entry setObject:@"0" forKey:@"follow_status"];
            [entry mutableCopy];
            [follow_list_array replaceObjectAtIndex:didselect_indexpath.row withObject:entry];
            [follower_table reloadData];
            
        }
        
        if (obj.FOLLOW_FLAG==1)
        {
            follow_list_array=[follow_list_array mutableCopy];
            NSMutableDictionary *entry = [[follow_list_array objectAtIndex:didselect_indexpath.row]mutableCopy];
            [entry setObject:@"1" forKey:@"follow_status"];
            [entry mutableCopy];
            [follow_list_array replaceObjectAtIndex:didselect_indexpath.row withObject:entry];
            [follower_table reloadData];
        }
        
    }
    follower_table.userInteractionEnabled=YES;
     tabbar.hidden=NO;
    public_profile_view.hidden=YES;
}

- (IBAction)follow_friends:(id)sender
{
    [self performSegueWithIdentifier:@"FOLLOWER_SEARCH" sender:self];
}
    @end
