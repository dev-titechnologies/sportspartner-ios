//
//  SearchViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 08/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "SearchViewController.h"
#import "SEARCH_Cell.h"
#import "SBJSON.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "ChatViewController.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "SVPullToRefresh.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize USER_ID,TOKEN,INTRO_FLAG,CHAT_FLAG,Index_did;
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
    
    //    UIImage *thumb = [UIImage imageNamed:@"Ellipse-2.png"];
    //    [slider setThumbImage:thumb forState:UIControlStateNormal];
    //    [slider setThumbImage:thumb forState:UIControlStateHighlighted];
    
    
    slider_label=[[UILabel alloc]initWithFrame:CGRectMake(35, 0, 30, 30)];
    
    slider_label.backgroundColor=[UIColor clearColor];
    
    slider_label.textColor=[UIColor whiteColor];
    
    slider_label.textAlignment=NSTextAlignmentCenter;
    
    slider_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    
    
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];
    
    header_view.backgroundColor=[style colorWithHexString:@"042e5f"];
    
    search_header_label.backgroundColor=[style colorWithHexString:@"042e5f"];
    
    
    
    __weak SearchViewController *weakSelf = self;
    [search_table addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(insertRowAtBottom) withObject:nil afterDelay:1.0];
    }];
    
    page_number=0;
    
    self.screenName=@"SP Search Screen";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(public_un_follow_reflection) name:@"unfollow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(public_follow_reflection) name:@"follow" object:nil];
    
    up_arrow.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:50];
    [up_arrow setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-angle-down"] forState:UIControlStateNormal];
    [up_arrow setTitleColor:[style colorWithHexString:age_color] forState:UIControlStateNormal];
    
    sqlfunction=[[SQLFunction alloc]init];
    slider_value=@"10";
    
    km_label.text=@"10 KMS";
    [slider setValue:10];
    // slider_label.text=@"10";
    
    
    
    GENDER_FLAG=0;
    connectobj=[[connection alloc]init];
    header_label.font=[UIFont fontWithName:@"Roboto-Regular" size:23];
    header_label.textColor=[UIColor whiteColor];
    l_segment_control.tintColor=[style colorWithHexString:terms_of_services_color];
    l_segment_control.selectedSegmentIndex=0;
    
    ///////////// TABBAR////////////////////////////
    
    
    CGSize tabBarSize = [tabbar frame].size;
    UIView	*tabBarFakeView = [[UIView alloc] initWithFrame:
                               CGRectMake(0,0,tabBarSize.width, tabBarSize.height)];
    [tabbar insertSubview:tabBarFakeView atIndex:0];
    
    [tabBarFakeView setBackgroundColor:[style colorWithHexString:@"f2e7ea"]];
    tabbar_border_label.backgroundColor=[style colorWithHexString:@"e80243"];
    
    tabbar.translucent=YES;
    
    [tabbar setSelectedItem:[tabbar.items objectAtIndex:2]];
    
    ////////////////// SERCH INTERFACE /////////////
    
    
    searching_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    searching_label.textColor=[style colorWithHexString:search_page_component_color];
    
    select_sports_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    select_sports_label.textColor=[style colorWithHexString:search_page_component_color];
    
    
    no_search_label.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
    no_search_label.textColor=[UIColor lightGrayColor];
    
    
    within_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    within_label.textColor=[style colorWithHexString:terms_of_services_color];
    
    IN_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    IN_label.textColor=[style colorWithHexString:terms_of_services_color];
    
    
    
    from_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    from_label.textColor=[style colorWithHexString:search_page_component_color];
    
    Place_field.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    Place_field.textColor=[style colorWithHexString:search_page_component_color];
    
    km_label.font=[UIFont fontWithName:@"Roboto-Regular" size:16];
    km_label.textColor=[style colorWithHexString:terms_of_services_color];
    
    line_view.backgroundColor=[style colorWithHexString:@"d1d1d1"];
    
    find_button.layer.cornerRadius=4.0;
    [find_button setTitleColor:[style colorWithHexString:search_page_component_color] forState:UIControlStateNormal];
    find_button.titleLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    find_button.layer.borderColor=[style colorWithHexString:@"5EB0F0"].CGColor;
    find_button.layer.borderWidth=1.0;
    
    //////////////// PUBLIC PROFILE ////////////////////
    public_profile_view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"settings-BG.png"]];
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    public_prf_pic.userInteractionEnabled=YES;
    [public_prf_pic addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer *recognizer_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer_down:)];
    recognizer_down.direction = UISwipeGestureRecognizerDirectionDown;
    recognizer_down.numberOfTouchesRequired = 1;
    recognizer_down.delegate = self;
    public_prf_pic.userInteractionEnabled=YES;
    [public_prf_pic addGestureRecognizer:recognizer_down];
    
    name_label.font=[UIFont fontWithName:@"Roboto-Bold" size:25];
    name_label.textColor=[UIColor whiteColor];
    place_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    place_label.textColor=[UIColor whiteColor];
    age_label.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    place_label.shadowColor=[style colorWithHexString:@"7F000000"];
    name_label.shadowColor=[style colorWithHexString:@"7F000000"];
    
    no_search_label.font=[UIFont fontWithName:@"Roboto-Regular" size:18];
    //////////// Cell Content ////////
    
    
    search_array=[[NSMutableArray alloc]init];
    
    
    ///////// FAVOURITE SPORTS //////////
    
    fav_sports_view.layer.borderColor=[UIColor whiteColor].CGColor;
    fav_sports_view.layer.borderWidth=2.0;
    fav_sports_view.layer.cornerRadius=4.0;
    fav_sports_view.layer.masksToBounds=YES;
    sports_tbl.backgroundColor=[UIColor clearColor];
    
    
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
    
    select_sports_done_button.layer.cornerRadius=2;
    select_sports_done_button.layer.borderColor=[UIColor whiteColor].CGColor;
    select_sports_done_button.layer.borderWidth=0.50;
    [select_sports_done_button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:17]];
    
    
    select_sports_cancel_button.layer.cornerRadius=2;
    select_sports_cancel_button.layer.borderColor=[UIColor whiteColor].CGColor;
    select_sports_cancel_button.layer.borderWidth=0.50;
    [select_sports_cancel_button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:17]];
    
    
    
    
    //////// lOGOUT BUTTON//////////
    
    logout_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:40];
    [logout_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-sign-out"] forState:UIControlStateNormal];
    logout_button.backgroundColor=[UIColor clearColor];
    [logout_button setTitleColor:[style colorWithHexString:terms_of_services_color] forState:UIControlStateNormal];
    
    //  [slider addTarget:self action:@selector(slidingStopped:)forControlEvents:UIControlEventTouchDragEnter];
    
    sports_tbl.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    [sqlfunction SP_ALL_SPORTS];
    
    
}

- (void)insertRowAtBottom
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            page_number=page_number+1;
            
            [self SEARCH_PAGINATION];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
    });
    
    
    
}


-(void)public_un_follow_reflection
{
    search_array=[search_array mutableCopy];
    if (search_array.count>0)
    {
        
        NSMutableDictionary *entry = [[search_array objectAtIndex:Index_did]mutableCopy];
        follow_status=@"Not following";
        [entry setObject:@"Not following" forKey:@"search_user_follow_status"];
        [entry mutableCopy];
        [search_array replaceObjectAtIndex:Index_did withObject:entry];
        [search_table reloadData];
    }
    
}

-(void)public_follow_reflection
{
    search_array=[search_array mutableCopy];
    if (search_array.count>0)
    {
        NSMutableDictionary *entry = [[search_array objectAtIndex:Index_did]mutableCopy];
        follow_status=@"following";
        [entry setObject:@"following" forKey:@"search_user_follow_status"];
        [entry mutableCopy];
        [search_array replaceObjectAtIndex:Index_did withObject:entry];
        [search_table reloadData];
    }
}

- (void) slidingStopped:(id)sender
{
    slider.userInteractionEnabled=NO;
}

-(void)SEARCH_FUNCTION
{
    [HUD hide:YES];
    [self stopSpin];
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        search_fav_sports_array=[[NSMutableArray alloc]init];
        networkErrorView.hidden=YES;
        [HUD setHidden:YES];
        [self stopSpin];
        if ( Public_search_flag==1)
        {
            [self showPageLoader_public];
            Public_search_flag=0;
        }
        else
        {
            [self showPageLoader];
        }
        search_array=[[NSMutableArray alloc]init];
        [search_table reloadData];
        [search_table setHidden:NO];
        timer = [NSTimer scheduledTimerWithTimeInterval: 6.0
                                                 target: self
                                               selector: @selector(cancelURLConnection:)
                                               userInfo: nil
                                                repeats: NO];
        
        id_string=[index_array componentsJoinedByString: @","];
        
        NSLog(@"IDSTR is :%@",id_string);
        if ([[NSString stringWithFormat:@"%@",longitude] isEqualToString:@""] || [[NSString stringWithFormat:@"%@",latitude] isEqualToString:@""] || id_string==NULL || [id_string isEqual:[NSNull null]] )
        {
            NSLog(@"Failed to fet your Location");
            // [self alertStatus:@"Error in network connection"];
            // return;
        }
        else
        {
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:GENDER_FLAG] forKey:@"gender"];
            [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:[slider_value intValue]] forKey:@"distance"];
            [param setObject:[NSNumber numberWithFloat:[longitude floatValue]] forKey:@"longitude"];
            [param setObject:[NSNumber numberWithFloat:[latitude floatValue]] forKey:@"latitude"];
            [param setObject:id_string forKey:@"sports"];
            [param setObject:[NSNumber numberWithInt:0] forKey:@"page"];
            [param setObject:search_type forKey:@"search_type"];
            [param setObject:search_name_textfield.text forKey:@"name"];
            
            NSLog(@"SEARCH PARAMS : %@",param);
            
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/searchpeople?"];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"URL STR FEED IS :%@",jsonString);
            
            
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
                                           
                                           
                                           NSLog(@"SEARCH RESULT :%@",json);
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           
                                           if(status==1)
                                           {
                                               
                                               search_array=[[json objectForKey:@"results"]mutableCopy];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   search_table_bg_view.hidden=NO;
                                                   [timer invalidate];
                                                   [search_table reloadData];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   no_search_label.hidden=YES;
                                                   
                                               });
                                               
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   
                                                   [timer invalidate];
                                                   no_search_label.hidden=NO;
                                                   search_table.hidden=YES;
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   flash_label.attributedText=[self GET_SHADOW_STRING_PLACE:@"No search results found!"];
                                                   
                                                   flash_view.hidden = NO;
                                                   flash_view.alpha = 0.2;
                                                   [UIView animateWithDuration:6 animations:^{
                                                       flash_view.alpha = 0.7;
                                                   } completion:^(BOOL finished) {
                                                       // do some
                                                   }];
                                                   
                                                   
                                                   [UIView animateWithDuration:4 animations:^{
                                                       // flash_view.frame =  CGRectMake(130, 30, 0, 0);
                                                       [flash_view setAlpha:0.3f];
                                                   } completion:^(BOOL finished) {
                                                       flash_view.hidden = YES;
                                                   }];
                                                   
                                                   
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
                                                   
                                                   [timer invalidate];
                                                   search_array=[[NSMutableArray alloc]init];
                                                   [search_table reloadData];
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
                                               // [self alertStatus:@"Error in network connection"];
                                               //return ;
                                           });
                                           
                                       }
                                   }];
        }
        
    }
    else
    {
        [HUD hide:YES];
        [self stopSpin];
        networkErrorView.hidden=NO;
    }
    
}


-(void)SEARCH_PAGINATION
{
    [HUD hide:YES];
    [self stopSpin];
    
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            id_string=[index_array componentsJoinedByString: @","];
            
            if ([[NSString stringWithFormat:@"%@",longitude] isEqualToString:@""] || [[NSString stringWithFormat:@"%@",latitude] isEqualToString:@""] || id_string==NULL || [id_string isEqual:[NSNull null]] )
            {
                NSLog(@"Failed to fet your Location");
                // [self alertStatus:@"Error in network connection"];
                // return;
            }
            
            else
            {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:GENDER_FLAG] forKey:@"gender"];
                [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[slider_value intValue]] forKey:@"distance"];
                [param setObject:[NSNumber numberWithFloat:[longitude floatValue]] forKey:@"longitude"];
                [param setObject:[NSNumber numberWithFloat:[latitude floatValue]] forKey:@"latitude"];
                [param setObject:id_string forKey:@"sports"];
                [param setObject:[NSNumber numberWithInt:page_number] forKey:@"page"];
                [param setObject:search_type forKey:@"search_type"];
                [param setObject:search_name_textfield.text forKey:@"name"];
                
                
                NSLog(@"PARAMMM : %@",param);
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/searchpeople?"];
                
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
                NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"URL STR FEED IS :%@",jsonString);
                
                
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
                                               
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               if(status==1)
                                               {
                                                   
                                                   search_temp_array=[json objectForKey:@"results"];
                                                   [search_array addObjectsFromArray:search_temp_array];
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [search_table reloadData];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                       [search_table.infiniteScrollingView stopAnimating];
                                                       
                                                   });
                                                   
                                               }
                                               else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [search_table.infiniteScrollingView stopAnimating];
                                                       
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
                                                       
                                                       [timer invalidate];
                                                       search_array=[[NSMutableArray alloc]init];
                                                       [search_table reloadData];
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
                                                   // [self alertStatus:@"Error in network connection"];
                                                   //return ;
                                               });
                                               
                                           }
                                       }];
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




-(void)cancelURLConnection:(id)sender
{
    [queue cancelAllOperations];
    [HUD hide:YES];
    [self stopSpin];
    [timer invalidate];
    //  [self alertStatus:@"Network Error"];
    // return ;
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


- (void) SwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft ){
        
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight ){
        
        
    }
    if ( sender.direction== UISwipeGestureRecognizerDirectionUp )
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
                [self showPageLoader_public];
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[USER_PROFILE_ID intValue]] forKey:@"like_user_id"];
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/profilephotolike?"];
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
                                               NSLog(@"RESPONSE :%@",response);
                                               NSDictionary *json =
                                               [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               if(status==1)
                                               {
                                                   
                                                   NSMutableDictionary *dict=[json objectForKey:@"results"];
                                                   
                                                   if ([[dict objectForKey:@"like_status"] isEqualToString:@"unliked"])
                                                   {
                                                       
                                                       flash_label.attributedText=[self GET_SHADOW_STRING_FLASH:@"You unliked this profile photo"];
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
                                                       
                                                       
                                                       like_button.hidden=YES;
                                                       search_array=[search_array mutableCopy];
                                                       NSMutableDictionary *entry = [[search_array objectAtIndex:didselect_index.row]mutableCopy];
                                                       [entry setObject:@"unliked" forKey:@"search_user_propic_like_status"];
                                                       [entry mutableCopy];
                                                       [search_array replaceObjectAtIndex:didselect_index.row withObject:entry];
                                                       [search_table reloadData];
                                                       
                                                       
                                                   }
                                                   else if ([[dict objectForKey:@"like_status"] isEqualToString:@"liked"])
                                                   {
                                                       flash_label.attributedText=[self GET_SHADOW_STRING_FLASH:@"You liked this profile photo"];
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
                                                       
                                                       like_button.hidden=NO;
                                                       
                                                       search_array=[search_array mutableCopy];
                                                       NSMutableDictionary *entry = [[search_array objectAtIndex:didselect_index.row]mutableCopy];
                                                       [entry setObject:@"liked" forKey:@"search_user_propic_like_status"];
                                                       [entry mutableCopy];
                                                       [search_array replaceObjectAtIndex:didselect_index.row withObject:entry];
                                                       [search_table reloadData];
                                                       
                                                   }
                                                   
                                                   
                                                   NSLog(@"LIKE SUCCESS");
                                                   [HUD hide:YES];
                                                   [self stopSpin];
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
                
                image_layer_up = [[CAShapeLayer alloc] init];
                image_layer_up.frame = public_prf_pic.bounds;
                image_layer_up.path = [self F_button_Corner:public_prf_pic].CGPath;
                image_layer_up.fillColor=[[[UIColor greenColor] colorWithAlphaComponent:0.1] CGColor];
                image_layer_up.shadowOpacity=0.0;
                [public_prf_pic.layer addSublayer:image_layer_up];
                CGRect frm_up = public_prf_pic.frame;
                frm_up.origin.y -=550;
                
                [UIView animateWithDuration:0.5
                                      delay:0.5
                                    options:UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseIn
                                 animations:^{
                                     public_profile_view.frame = frm_up;
                                     
                                 }
                                 completion:NULL
                 ];
                
                
                //upMenuView.hidden=YES;
                [upMenuView removeFromSuperview];
            }
            else
            {
                networkErrorView.hidden=NO;
                [HUD hide:YES];
                [self stopSpin];
                
            }
            
        }
        //public_profile_view.hidden=YES;
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionDown ){
        
        
    }
}
-(UIBezierPath *)F_button_Corner:(UIImageView *)button
{
    UIBezierPath *username_imageMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft)
                                                                                    cornerRadii:CGSizeMake(0.0, 0.0)];
    return username_imageMaskPathWithRadiusTop;
    
    
}


- (void) SwipeRecognizer_down:(UISwipeGestureRecognizer *)sender {
    
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft ){
        
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight ){
        
        
    }
    if ( sender.direction== UISwipeGestureRecognizerDirectionUp )
    {
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionDown ){
        
        image_layer_down = [[CAShapeLayer alloc] init];
        image_layer_down.frame = public_prf_pic.bounds;
        image_layer_down.path = [self F_button_Corner:public_prf_pic].CGPath;
        image_layer_down.fillColor=[[[UIColor redColor] colorWithAlphaComponent:0.1] CGColor];
        image_layer_down.shadowOpacity=0.0;
        [public_prf_pic.layer addSublayer:image_layer_down];
        
        CGRect frm_up = public_prf_pic.frame;
        frm_up.origin.y +=800;
        
        [UIView animateWithDuration:0.5
                              delay:0.5
                            options:UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseIn
                         animations:^{
                             public_profile_view.frame = frm_up;
                             
                         }
                         completion:NULL
         ];
        // upMenuView.hidden=YES;
        [upMenuView removeFromSuperview];
        
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
    
    
    
    
    [circleView removeFromSuperview];
    circleView=nil;
    circle=nil;
    
    [self.mapView removeOverlay:circle];
    
    
    NSArray *overlayCountries = [self.mapView overlays];
    [self.mapView removeOverlays:overlayCountries];
    
    //  [self.mapView removeOverlay:circleView];
    
    if([segue.identifier isEqualToString:@"SEARCH_FEED"])
    {
        FeedViewController *feedcontrol=segue.destinationViewController;
        feedcontrol.TOCKEN=TOKEN;
        feedcontrol.USER_ID=USER_ID;
    }
    else if ([segue.identifier isEqualToString:@"SEARCH_PROFILE"])
    {
        ProfileViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOCKEN=TOKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"SEARCH_FOLLOWER"])
    {
        FollowerViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOKEN=TOKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"SEARCH_SETTINGS"])
    {
        SettingViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOCKEN=TOKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"SEARCH_TO_CHAT"])
    {
        [circleView removeFromSuperview];
        circleView=nil;
        circle=nil;
        
        [self.mapView removeOverlay:circle];
        
        
        NSArray *overlayCountries = [self.mapView overlays];
        [self.mapView removeOverlays:overlayCountries];
        
        
        ChatViewController *chatcontroller=segue.destinationViewController;
        chatcontroller.USER_ID=USER_ID;
        chatcontroller.TOKEN=TOKEN;
        chatcontroller.conversation_id=Chat_status_id;
        chatcontroller.RECEIVER_ID=USER_PROFILE_ID;
        chatcontroller.URL_STRING=prof_pic_string;
        NSLog(@"POB :%d",Public_search_flag);
        if (Public_search_flag==1)
        {
            chatcontroller.SEARCH_FLAG=1;
        }
        else
        {
            chatcontroller.SEARCH_FLAG=2;
        }
        
    }
    
}


#pragma TABBAR FUNCTION


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    if (queue_location) {
        NSLog(@"SUSPEND QUEUE");
        dispatch_suspend(queue_location);
    }
    
    switch (item.tag) {
        case 0:
            
            [self performSegueWithIdentifier:@"SEARCH_FEED" sender:self];
            
            break;
        case 1:
            [self performSegueWithIdentifier:@"SEARCH_PROFILE" sender:self];
            break;
        case 2:
            
            break;
        case 3:
            [self performSegueWithIdentifier:@"SEARCH_FOLLOWER" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"SEARCH_SETTINGS" sender:self];
            break;
            
        default:
            break;
    }
}

- (IBAction)FIND_ACTION:(id)sender
{
    page_number=0;
    [self CHECK_SEARCH];
}

- (IBAction)MALE_ACTION:(UIButton *)sender
{
    if(sender.tag==0 && F_FLAG==1)
    {
        
        [male_button setImage:[UIImage imageNamed:@"active.png"] forState:UIControlStateNormal];
        sender.tag=1;
        M_FLAG=1;
        GENDER_FLAG=0;
    }
    else if(sender.tag==0 && F_FLAG==0)
    {
        
        [male_button setImage:[UIImage imageNamed:@"active.png"] forState:UIControlStateNormal];
        sender.tag=1;
        M_FLAG=1;
        GENDER_FLAG=2;
    }
    
    else  if(sender.tag==1 && F_FLAG==0)
    {
        [male_button setImage:[UIImage imageNamed:@"not-selected.png"] forState:UIControlStateNormal];
        sender.tag=0;
        GENDER_FLAG=0;
        M_FLAG=0;
    }
    else  if(sender.tag==1 && F_FLAG==1)
    {
        [male_button setImage:[UIImage imageNamed:@"not-selected.png"] forState:UIControlStateNormal];
        sender.tag=0;
        GENDER_FLAG=3;
        M_FLAG=0;
    }
    
    
}


- (IBAction)FEMALE_ACTION:(UIButton *)sender
{
    if(sender.tag==0 && M_FLAG==1)
    {
        [female_button setImage:[UIImage imageNamed:@"active.png"] forState:UIControlStateNormal];
        sender.tag=1;
        F_FLAG=1;
        GENDER_FLAG=0;
    }
    else if(sender.tag==0 && M_FLAG==0)
    {
        [female_button setImage:[UIImage imageNamed:@"active.png"] forState:UIControlStateNormal];
        sender.tag=1;
        F_FLAG=1;
        GENDER_FLAG=3;
    }
    else  if(sender.tag==1 && M_FLAG==0)
    {
        [female_button setImage:[UIImage imageNamed:@"not-selected.png"] forState:UIControlStateNormal];
        sender.tag=0;
        F_FLAG=0;
        GENDER_FLAG=0;
    }
    
    else  if(sender.tag==1 && M_FLAG==1)
    {
        [female_button setImage:[UIImage imageNamed:@"not-selected.png"] forState:UIControlStateNormal];
        sender.tag=0;
        F_FLAG=0;
        GENDER_FLAG=2;
    }
    
    
}


- (IBAction)sliderValueChanged:(id)sender
{
    
    float sliderRange = slider.frame.size.width - 30;
    float sliderOrigin = slider.frame.origin.x + (30 / 2.0);
    
    float sliderValueToPixels = (((slider.value - slider.minimumValue)/(slider.maximumValue - slider.minimumValue)) * sliderRange) + sliderOrigin;
    
    slider_label.center = CGPointMake(sliderValueToPixels-35, 15);
    
    slider_value=[NSString stringWithFormat:@"%d",(int) slider.value];
    
    slider_label.text=slider_value;
    
    [slider addSubview:slider_label];
    
    slider_value=[slider_value stringByAppendingString:@"KMS"];
    
    km_label.text = slider_value;
    
    
    
    //    [circleView removeFromSuperview];
    //
    //    circle=nil;
    //
    //    circle = [MKCircle circleWithCenterCoordinate:touchMapCoordinate radius:500];
    //
    //    [self.mapView addOverlay:circle];
    //
    
}

#pragma TABLEVIEW SECTION

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==search_table)
    {
        return search_array.count;
    }
    else
        return filteredTableData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==search_table)
    {
        
        NSString *CELLIDENTIFIER=@"F_CELL";
        SEARCH_Cell *s_cell=(SEARCH_Cell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        s_cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
        /////// CELL DESIGN ///////
        s_cell.backgroundColor=[UIColor clearColor];
        s_cell.name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
        s_cell.profile_pic.contentMode=UIViewContentModeScaleAspectFill;
        s_cell.clipsToBounds=YES;
        s_cell.profile_pic.layer.cornerRadius=15.0;
        s_cell.profile_pic.layer.masksToBounds=YES;
        s_cell.name_label.textColor=[style colorWithHexString:terms_of_services_color];
        s_cell.place_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
        s_cell.place_label.textColor=[UIColor grayColor];
        
        if ([[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_gender"]isEqualToString:@"Female"])
        {
            //s_cell.age_label.text=@"F♀";
            //s_cell.age_label.textColor=[style colorWithHexString:age_color];
            s_cell.age_label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fs.png"]];
        }
        else
        {
            // s_cell.age_label.text=@"M♂";
            //s_cell.age_label.textColor=[style colorWithHexString:@"0C6DB4"];
            s_cell.age_label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ms.png"]];
        }
        s_cell.age_label.font=[UIFont fontWithName:@"Roboto-Regular" size:16];
        
        //////////// Cell Content ////////
        
        
        if ([[NSString stringWithFormat:@"%@",[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_propic"]] isEqualToString:@"0"])
        {
            
            s_cell.profile_pic.image=[UIImage imageNamed:@"noimage.png"];
        }
        else
        {
            
            NSURL *image_url=[NSURL URLWithString:[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_propic"]];
            [s_cell.profile_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
        }
        
        s_cell.name_label.text=[[NSString stringWithFormat:@"%@",[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_name"]] capitalizedString];
        s_cell.place_label.text=[NSString stringWithFormat:@"%@",[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_location"]];
        //  s_cell.age_label.text=[NSString stringWithFormat:@"%@",[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_age"]];
        s_cell.contentView.backgroundColor=[UIColor whiteColor];
        s_cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //  s_cell. eye_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:37];
        //  [s_cell.eye_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-eye"] forState:UIControlStateNormal];
        
        
        if ([[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_follow_status"] isEqualToString:@"Not following"])
        {
            [s_cell.eye_button setImage:[UIImage imageNamed:@"kannu.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            [s_cell.eye_button setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
        }
        
        UITapGestureRecognizer *gesture_chat=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(search_chat_click:)];
        s_cell.chat_button.userInteractionEnabled=YES;
        s_cell.chat_button.tag=indexPath.row;
        [s_cell.chat_button addGestureRecognizer:gesture_chat];
        
        
        
        UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(search_eye_click:)];
        s_cell.eye_button.userInteractionEnabled=YES;
        s_cell.eye_button.tag=indexPath.row;
        [s_cell.eye_button addGestureRecognizer:gesture_follow];
        
        
        
        
        UITapGestureRecognizer *gesture_chat_background=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(search_chat_click:)];
        s_cell.chat_background_button.userInteractionEnabled=YES;
        s_cell.chat_background_button.tag=indexPath.row;
        [s_cell.chat_background_button addGestureRecognizer:gesture_chat_background];
        
        
        
        UITapGestureRecognizer *gesture_follow_background=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(search_eye_click:)];
        s_cell.eye_bacground_button.userInteractionEnabled=YES;
        s_cell.eye_bacground_button.tag=indexPath.row;
        [s_cell.eye_bacground_button addGestureRecognizer:gesture_follow_background];
        
        return s_cell;
        
        
    }
    
    else
    {
        
        
        
        NSString *CELLIDENTIFIER=@"CELL";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[[[filteredTableData objectAtIndex:indexPath.row] objectForKey:@"displayname"] capitalizedString]];
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.backgroundColor=[UIColor whiteColor];
        cell.textLabel.textColor=[style colorWithHexString:terms_of_services_color];
        cell.textLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    Index_did=indexPath.row;
    Public_Profile_ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
    view_control.TOKEN=TOKEN;
    view_control.USER_ID=USER_ID;
    view_control.FEED_FLAG=2;
    if (tableView==search_table)
    {
        view_control.TARGETED_USER_ID=[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_id"];
        
    }
    else
    {
        view_control.TARGETED_USER_ID=[[filteredTableData objectAtIndex:indexPath.row]objectForKey:@"user_id"];
        
        [search_name_textfield resignFirstResponder];
        
        search_name_textfield.text=@"";
        
        search_name_textfield.placeholder=@"Name";
        
        search_name_table.hidden=YES;
        
    }
    [self.view addSubview:view_control.view];
    
    
    
    
}

-(void)search_chat_click:(id)sender
{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
        USER_PROFILE_ID=[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_id"];
        Chat_status_id=[NSString stringWithFormat:@"%@",[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_chat_status"]];
        prof_pic_string=[NSString stringWithFormat:@"%@",[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_propic"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self performSegueWithIdentifier:@"SEARCH_TO_CHAT" sender:self];
            
        });
        
    });
    
    
    
    
}
-(void)search_eye_click:(id)sender
{
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        [self showPageLoader_public];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
            follow_status=[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_follow_status"];
            
            NSLog(@"FOLLOW STATUS :%@",follow_status);
            USER_PROFILE_ID=[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_id"];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:[USER_PROFILE_ID intValue]] forKey:@"follow_user_id"];
            
            if([follow_status isEqualToString:@"following"])
            {
                [param setObject:@"unfollow" forKey:@"type"];
            }
            else if([follow_status isEqualToString:@"Not following"])
            {
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
                     
                     NSLog(@"FOLLOW RESPONSE :%@",json);
                     NSInteger status=[[json objectForKey:@"status"] intValue];
                     
                     
                     
                     if(status==1)
                     {
                         
                         SEARCH_Cell *cell_p = (SEARCH_Cell*)[search_table cellForRowAtIndexPath:indexPath];
                         if([follow_status isEqualToString:@"following"])
                         {
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 NSString *flash_string=@"You have stopped following ";
                                 NSLog(@"Flash label   :%@",flash_string);
                                 flash_string=[flash_string stringByAppendingString:[[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_name"] capitalizedString]];
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
                                 
                                 search_array=[search_array mutableCopy];
                                 
                                 NSMutableDictionary *entry = [[search_array objectAtIndex:indexPath.row]mutableCopy];
                                 
                                 [entry setObject:@"Not following" forKey:@"search_user_follow_status"];
                                 [entry mutableCopy];
                                 [search_array replaceObjectAtIndex:indexPath.row withObject:entry];
                                 
                                 
                                 
                                 [cell_p.eye_button setImage:[UIImage imageNamed:@"kannu.png"] forState:UIControlStateNormal];
                                 [HUD hide:YES];
                                 [self stopSpin];
                                 [search_table reloadData];
                                 
                             });
                             
                         }
                         else if([follow_status isEqualToString:@"Not following"])
                         {
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 
                                 NSString *flash_string=@"You started following ";
                                 
                                 NSLog(@"Flash label   :%@",flash_string);
                                 flash_string=[flash_string stringByAppendingString:[[[search_array objectAtIndex:indexPath.row]objectForKey:@"search_user_name"] capitalizedString]];
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
                                 
                                 search_array=[search_array mutableCopy];
                                 
                                 NSMutableDictionary *entry = [[search_array objectAtIndex:indexPath.row]mutableCopy];
                                 
                                 [entry setObject:@"following" forKey:@"search_user_follow_status"];
                                 [entry mutableCopy];
                                 [search_array replaceObjectAtIndex:indexPath.row withObject:entry];
                                 NSLog(@"NOT FOLLOWING");
                                 
                                 
                                 
                                 [cell_p.eye_button setImage:[UIImage imageNamed:@"followed.png"] forState:UIControlStateNormal];
                                 [HUD hide:YES];
                                 [self stopSpin];
                                 [search_table reloadData];
                             });
                             
                             
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
                         [self alertStatus:@"Error in network connection"];
                         return ;
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

-(NSString *)removeStartSpaceFrom:(NSString *)strtoremove
{
    NSUInteger location = strtoremove.length;
    unichar charBuffer[[strtoremove length]];
    [strtoremove getCharacters:charBuffer];
    int i = 0;
    for ( i = 0; i < [strtoremove length]; i++){
        if (![[NSCharacterSet whitespaceCharacterSet] characterIsMember:charBuffer[i]]){
            break;
        }
    }
    return  [strtoremove substringWithRange:NSMakeRange(i, location-i)];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"INLOCATION MANAGER");
    NSLog(@"didFailWithError: %@", error);
    if(![CLLocationManager locationServicesEnabled])
    {
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                            message:@"To enable, please go to Settings and turn on Location Service for this app."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings",nil];
            [alert show];
        }
        
    }
    
    
}

//- (void)moveMapToAnnotation:(MKPointAnnotation*)annotation
//{
//    CGFloat fractionLatLon = self.mapView.region.span.latitudeDelta / self.mapView.region.span.longitudeDelta;
//    CGFloat newLatDelta = 0.6f;
//    CGFloat newLonDelta = newLatDelta * fractionLatLon;
//    MKCoordinateRegion region = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(newLatDelta, newLonDelta));
//    [self.mapView setRegion:region animated:YES];
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(MKUserLocation *)oldLocation
{
    
    
    
    //
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 800, 800);
    //    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    current_longitude = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.longitude];
    
    NSLog(@"CURRENT LONGITUDE: %@",current_longitude);
    
    current_latitude = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.latitude];
    
    NSLog(@"CURRENT LATITUDE: %@",current_latitude);
    
    
    
//    MKCoordinateRegion mapRegion;
//    mapRegion.center = newLocation.coordinate;
//    mapRegion.span = MKCoordinateSpanMake(0.09, 0.09);
//    [self.mapView setRegion:mapRegion animated: YES];
//    
    
    //
    //    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.mapView.userLocation.coordinate radius:1000];
    //
    //    [self.mapView addOverlay:circle];
    //
    
    //    CLLocationCoordinate2D zoomLocation;
    //    zoomLocation.latitude = 39.281516; // your latitude value
    //    zoomLocation.longitude= -76.580806; // your longitude value
    //    MKCoordinateRegion region;
    //    MKCoordinateSpan span;
    //    span.latitudeDelta=0.18; // change as per your zoom level
    //    span.longitudeDelta=0.18;
    //    region.span=span;
    //    region.center= zoomLocation;
    //    [self.mapView setRegion:region animated:TRUE];
    //    [self.mapView regionThatFits:region];
    
    
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        
        CLLocation *currentLocation = newLocation;
        
        if (currentLocation != nil)
        {
            
            
            queue_location = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(queue_location, ^{
                
                
                current_longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
                
                NSLog(@"CURRENT LONGITUDE: %@",current_longitude);
                
                current_latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
                
                NSLog(@"CURRENT LATITUDE: %@",current_latitude);
                
                
                NSString *urlpath=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng="];
                urlpath = [urlpath stringByAppendingString:current_latitude];
                urlpath = [urlpath stringByAppendingString:@","];
                urlpath = [urlpath stringByAppendingString:current_longitude];
                urlpath = [urlpath stringByAppendingString:@"&sensor=false"];
                NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlpath]];
                NSData *response = [NSURLConnection sendSynchronousRequest:request  returningResponse:nil error:nil];
                
                if (response!=nil || ![response isEqual:[NSNull null]])
                {
                    
                    NSLog(@"DATA NOT NULLLLL");
                    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    SBJSON *parser=[[SBJSON alloc]init];
                    NSDictionary *results=[parser objectWithString:json_string error:nil];
                    NSMutableArray *result_array=[results objectForKey:@"results"];
                    
                    if (result_array.count>0)
                    {
                        location_view.hidden=YES;
                        NSDictionary *sublocation=[result_array objectAtIndex:0];
                        NSMutableArray *Address_Dictionary=[sublocation objectForKey:@"address_components"];
                        NSMutableDictionary *final_dict=[Address_Dictionary objectAtIndex:0];
                        current_location=[final_dict objectForKey:@"long_name"];
                        
                        if (INTRO_FLAG==1)
                        {
                            
                            [self update_user_location];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                          
                            
                            [circleView removeFromSuperview];
                            
                            circle=nil;
                            
                            circle = [MKCircle circleWithCenterCoordinate:currentLocation.coordinate radius:10];
                            
                            [self.mapView addOverlay:circle];
                            
                            
                            [pinView removeFromSuperview];
                            MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
                            pa.coordinate = currentLocation.coordinate;
                            //    pa.title = @"Hello";
                            [self.mapView addAnnotation:pa];
                            
                              location_name_label.text=current_location;
                            
                            NSLog(@"PIIIIIIIINNNNN");
                            
                            [HUD hide:YES];
                            [self stopSpin];
                            CURRENT_LOCATION_FLAG=CURRENT_LOCATION_FLAG+1;
                            latitude=current_latitude;
                            longitude=current_longitude;
                            location_string=current_location;
                            from_label.text=location_string;
                            from_label.textAlignment=NSTextAlignmentLeft;
                            [locationManager stopUpdatingLocation];
                            locationManager.delegate=nil;
                            NSLog(@"PRINT :%d",CURRENT_LOCATION_FLAG);
                            
                        });
                    }
                    
                }
                else
                {
                    NSLog(@"DATA NULLLLLLLLLL");
                }
                
            });
        }
        
    }
    
}

-(void)LIKE_UNLIKE_FUNCTION
{
    
}

- (IBAction)SEARCH_VIEW_BACK:(id)sender
{
    search_table_bg_view.hidden=YES;
    search_name_textfield.text=@"";
    search_name_textfield.placeholder=@"Name";
}

- (IBAction)MAP_UP_ACTION:(UIButton *)sender
{
    
    if (sender.tag==0)
    {
        if ([[UIScreen mainScreen]bounds].size.height ==480)
        {
            
            self.mapView.frame=CGRectMake(0, 20, 320, 407);
            
        }
        else
        {
            self.mapView.frame=CGRectMake(0, 20, 320, 497);
        }
        
        sender.tag=1;
        
        [sender setImage:[UIImage imageNamed:@"collapes.png"] forState:UIControlStateNormal];
    }
    else
    {
        if ([[UIScreen mainScreen]bounds].size.height ==480)
        {
            
            self.mapView.frame=CGRectMake(0, 291, 320, 138);
            
        }
        else
        {
            self.mapView.frame=CGRectMake(0, 291, 320, 226);
        }
        
        sender.tag=0;
        
        [sender setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)EDIT_ACTION:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Current Location",@"My Location",nil] ;
    alertView.tag = 2;
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[UIColor redColor]];
    [alertView show];
    
}

- (IBAction)SELECT_SPORTS:(id)sender
{
    temp_index_array=[[NSMutableArray alloc]init];
    [temp_index_array addObjectsFromArray:index_array];
    backgroundview=[[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:backgroundview];
    [self.view addSubview:select_sports_bg_view];
    select_sports_bg_view.hidden=NO;
    backgroundview.userInteractionEnabled=YES;
    UITapGestureRecognizer *gestureView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HIDE_SELECT_SPORTS:)];
    [backgroundview addGestureRecognizer:gestureView];
    
    
    [sqlfunction SP_ALL_SPORTS];
    NSString *sports_string=[sqlfunction SEARCH_ALL_SPORTS];
    
    if ([sports_string isEqualToString:@""] || [sports_string isEqual:[NSNull null]] || sports_string==NULL || sports_string==nil)
    {
        NSLog(@"LOCAL NULL");
        [self GET_COMPLETE_SPORTS_LIST];
    }
    else
    {
        
        NSLog(@"LOCAL NOT NULL");
        NSData* statData = [sports_string dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary   *json_db =
        [NSJSONSerialization JSONObjectWithData:statData
                                        options:kNilOptions
                                          error:nil];
        complete_sports_list=[[json_db objectForKey:@"result"]mutableCopy];
        [self CHECK_SPORTS];
    }
}


-(void)HIDE_SELECT_SPORTS :(id)sender
{
    index_array=[[NSMutableArray alloc]init];
    [index_array addObjectsFromArray:temp_index_array];
    
    [backgroundview removeFromSuperview];
    select_sports_bg_view.hidden=YES;
}


- (IBAction)select_sports_done:(id)sender
{
    if(index_array.count==0)
    {
        [self alertStatus:@"Please select at least one sports"];
        return;
    }
    else
    {
        [backgroundview removeFromSuperview];
        select_sports_bg_view.hidden=YES;
        // [self SEARCH_FUNCTION];
    }
}

- (IBAction)UP_arrow:(id)sender
{
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         search_view.frame = CGRectMake(0, 0, 320, 237);
                         if ([UIScreen mainScreen].bounds.size.height !=568)
                         {
                             search_table.frame=CGRectMake(0, 238, 320, 242);
                         }
                         else
                         {
                             search_table.frame=CGRectMake(0, 238, 320, 330);
                         }
                         header_view.frame = CGRectMake(0, 16, 320, 45);
                     }
                     completion:^(BOOL finished){
                     }];
    
    
}

- (IBAction)select_sports_cancel:(id)sender
{
    
    [backgroundview removeFromSuperview];
    
    select_sports_bg_view.hidden=YES;
}

- (IBAction)BACK:(id)sender
{
    public_profile_view.hidden=YES;
    [upMenuView removeFromSuperview];
}

- (IBAction)FOLLOW_ACTION:(id)sender
{
    NSLog(@"FOLLOW CLICK");
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
        networkErrorView.hidden=YES;
        [self showPageLoader_public];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:[USER_PROFILE_ID intValue]] forKey:@"follow_user_id"];
            
            
            if([follow_status isEqualToString:@"following"])
            {
                [param setObject:@"unfollow" forKey:@"type"];
            }
            
            else if([follow_status isEqualToString:@"Not following"])
                
            {
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
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [HUD hide:YES];
                                               [self stopSpin];
                                           });
                                       }
                                       else
                                       {
                                           NSLog(@"FOLLOW RESPONSE :%@",response);
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           
                                           if(status==1)
                                           {
                                               
                                               
                                               if([follow_status isEqualToString:@"following"])
                                               {
                                                   
                                                   search_array=[search_array mutableCopy];
                                                   NSMutableDictionary *entry = [[search_array objectAtIndex:didselect_index.row]mutableCopy];
                                                   follow_status=@"Not following";
                                                   [entry setObject:@"Not following" forKey:@"search_user_follow_status"];
                                                   [entry mutableCopy];
                                                   [search_array replaceObjectAtIndex:didselect_index.row withObject:entry];
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       
                                                       NSString *flash_string=@"You have stopped following ";
                                                       flash_string=[flash_string stringByAppendingString:[[[search_array objectAtIndex:didselect_index.row]objectForKey:@"search_user_name"] capitalizedString]];
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
                                                       
                                                       [eye_button setBackgroundImage:[UIImage imageNamed:@"b_follow.png"] forState:UIControlStateNormal];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                       [search_table reloadData];
                                                       
                                                   });
                                                   
                                                   
                                               }
                                               else if([follow_status isEqualToString:@"Not following"])
                                               {
                                                   search_array=[search_array mutableCopy];
                                                   NSMutableDictionary *entry = [[search_array objectAtIndex:didselect_index.row]mutableCopy];
                                                   follow_status=@"following";
                                                   [entry setObject:@"following" forKey:@"search_user_follow_status"];
                                                   [entry mutableCopy];
                                                   [search_array replaceObjectAtIndex:didselect_index.row withObject:entry];
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       
                                                       NSString *flash_string=@"You started following ";
                                                       flash_string=[flash_string stringByAppendingString:[[[search_array objectAtIndex:didselect_index.row]objectForKey:@"search_user_name"] capitalizedString]];
                                                       flash_label.attributedText=[self GET_SHADOW_STRING_PLACE:flash_string];
                                                       
                                                       flash_view.hidden = NO;
                                                       flash_view.alpha = 0.1;
                                                       [UIView animateWithDuration:2 animations:^{
                                                           flash_view.alpha = 0.5f;
                                                       } completion:^(BOOL finished) {
                                                           // do some
                                                       }];
                                                       
                                                       
                                                       [UIView animateWithDuration:2 animations:^{
                                                           // flash_view.frame =  CGRectMake(130, 30, 0, 0);
                                                           [flash_view setAlpha:0.1f];
                                                       } completion:^(BOOL finished) {
                                                           flash_view.hidden = YES;
                                                       }];
                                                       
                                                       
                                                       [eye_button setBackgroundImage:[UIImage imageNamed:@"b_follow-onclik@2x.png"] forState:UIControlStateNormal];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                       [search_table reloadData]; [search_table reloadData];
                                                       
                                                   });
                                                   
                                                   
                                                   
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
        });
    }
    else
    {
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
        
    }
    
}
- (IBAction)REPORT_SUBMIT:(id)sender
{
    
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
            [self showPageLoader_public];
            
            
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:[USER_PROFILE_ID integerValue]]forKey:@"report_user_id"];
            [param setObject:[NSNumber numberWithInteger:[post_id intValue]] forKey:@"subject_id"];
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
                                           
                                           [HUD hide:YES];
                                           [self stopSpin];
                                       }
                                       else
                                       {
                                           NSLog(@"REPORT RESPONSE :%@",response);
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               [backgroundview removeFromSuperview];
                                               report_abuse_view.hidden=YES;
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               
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
        }
        
        
        else
        {
            [HUD hide:YES];
            [self stopSpin];
            networkErrorView.hidden=NO;
        }
    }
    
    
    
}

- (IBAction)LIKE_ACTION:(id)sender
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        [self showPageLoader_public];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:[USER_PROFILE_ID intValue]] forKey:@"like_user_id"];
            
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
                                           
                                           NSLog(@"LIKE RESULT IS : %@",json);
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if(status==1)
                                               {
                                                   
                                                   NSMutableDictionary *dict=[json objectForKey:@"results"];
                                                   
                                                   if ([[dict objectForKey:@"like_status"] isEqualToString:@"unliked"])
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
                                                       
                                                       search_array=[search_array mutableCopy];
                                                       NSMutableDictionary *entry = [[search_array objectAtIndex:didselect_index.row]mutableCopy];
                                                       [entry setObject:@"unliked" forKey:@"search_user_propic_like_status"];
                                                       [entry mutableCopy];
                                                       [search_array replaceObjectAtIndex:didselect_index.row withObject:entry];
                                                       [search_table reloadData];
                                                       
                                                       [upMenuView removeFromSuperview];
                                                       homeLabel = [self createHomeButtonView];
                                                       homeLabel = [self createHomeButtonView];
                                                       upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - homeLabel.frame.size.width - 10.f,
                                                                                                                         self.view.frame.size.height - homeLabel.frame.size.height - 10.f,
                                                                                                                         50.0,
                                                                                                                         50.0)
                                                                                           expansionDirection:DirectionUp];
                                                       upMenuView.homeButtonView = homeLabel;
                                                       
                                                       [upMenuView addButtons:[self createDemoButtonArray:didselect_index.row]];
                                                       
                                                       [self.view addSubview:upMenuView];
                                                       
                                                       
                                                   }
                                                   else if ([[dict objectForKey:@"like_status"] isEqualToString:@"unliked"])
                                                   {
                                                       like_button.hidden=NO;
                                                       
                                                       search_array=[search_array mutableCopy];
                                                       NSMutableDictionary *entry = [[search_array objectAtIndex:didselect_index.row]mutableCopy];
                                                       [entry setObject:@"liked" forKey:@"search_user_propic_like_status"];
                                                       [entry mutableCopy];
                                                       [search_array replaceObjectAtIndex:didselect_index.row withObject:entry];
                                                       [search_table reloadData];
                                                   }
                                                   
                                                   NSLog(@"LIKE SUCCESS");
                                                   [HUD hide:YES];
                                                   [self stopSpin];
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
                                               
                                           });
                                           
                                           
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
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
        
    }
    
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


- (IBAction)Fav_Sports_action:(id)sender
{
    
    backgroundview=[[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:backgroundview];
    [self.view addSubview:fav_sports_view];
    backgroundview.userInteractionEnabled=YES;
    fav_sports_view.hidden=NO;
    [sports_tbl reloadData];
    
    UITapGestureRecognizer *gestureView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HIDE_BLUR:)];
    [backgroundview addGestureRecognizer:gestureView];
    
}
-(void)HIDE_BLUR:(id)sender
{
    [backgroundview removeFromSuperview];
    fav_sports_view.hidden=YES;
    
}
- (IBAction)CHAT_ACTION:(id)sender
{
    
    Public_search_flag=1;
    [self performSegueWithIdentifier:@"SEARCH_TO_CHAT" sender:self];
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
    
    imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(110, 209, 100, 100) ];
    
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


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ////////////////////////////////////////////////// START MKMAPVIEW ///////////////////////////////////////////////////
    
    //  [circleView removeFromSuperview];
    //  circleView=nil;
    circle=nil;
    [self.mapView removeOverlay:circle];
    [pinView removeFromSuperview];
    
    [male_button setImage:[UIImage imageNamed:@"active.png"] forState:UIControlStateNormal];
    [female_button setImage:[UIImage imageNamed:@"active.png"] forState:UIControlStateNormal];
    M_FLAG=1;
    F_FLAG=1;
    male_button.tag=1;
    female_button.tag=1;
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=0.5;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.0];
    [map_up_button.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    
    UITapGestureRecognizer *gesture_remove_keyboard=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(KEY_BOARD_REMOVE)];
    [self.view addGestureRecognizer:gesture_remove_keyboard];
    gesture_remove_keyboard.cancelsTouchesInView = NO;
    
    
    search_type=@"";
    search_name_textfield.textColor=[style colorWithHexString: terms_of_services_color];
    search_name_table.layer.cornerRadius=4.0;
    search_name_table.layer.borderColor=[UIColor lightGrayColor].CGColor;
    search_name_table.layer.borderWidth=1.0;
    
    float sliderRange = slider.frame.size.width - 30;
    float sliderOrigin = slider.frame.origin.x + (30 / 2.0);
    
    float sliderValueToPixels = (((slider.value - slider.minimumValue)/(slider.maximumValue - slider.minimumValue)) * sliderRange) + sliderOrigin;
    
    slider_label.center = CGPointMake(sliderValueToPixels-35, 15);
    
    
    slider_value=[NSString stringWithFormat:@"%d",(int) slider.value];
    
    slider_label.text=slider_value;
    
    [slider addSubview:slider_label];
    
    select_sp_collectionview.backgroundColor=[style colorWithHexString:terms_of_services_color];
    select_sp_collectionview.layer.cornerRadius=4.0;
    
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    pinView = nil;
    
    
    
    self.mapView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(handleGesture:)];
    
    [self.mapView addGestureRecognizer:tapGesture];
    
    
    
    //    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleGesture:)];
    //    doubleTap.numberOfTapsRequired = 1;
    //    doubleTap.delegate=self;
    //    doubleTap.numberOfTouchesRequired = 1;
    //    [self.mapView addGestureRecognizer:doubleTap];
    
    search=[UIButton buttonWithType:UIButtonTypeCustom];
    search.titleLabel.text=@"";
    
    search.frame=CGRectMake(200, 0, 50, 55);
    search.showsTouchWhenHighlighted=YES;
    search.backgroundColor=[style colorWithHexString:@"E60044"];
    [search setImage:[UIImage imageNamed:@"Search-white.png"] forState:UIControlStateNormal];
    
    [search addTarget:self action:@selector(BUTTON_ACTION:) forControlEvents:UIControlEventTouchUpInside];
    
    //  search.backgroundColor=[UIColor purpleColor];
    
    location_name_label=[[UILabel alloc]initWithFrame:CGRectMake(5, 2, 197, 50)];
    location_name_label.backgroundColor=[UIColor clearColor];
    
    location_name_label.textColor=[UIColor whiteColor];
    location_name_label.textAlignment=NSTextAlignmentLeft;
    location_name_label.numberOfLines=2;
    
    self.mapView.zoomEnabled=YES;
    
    
    ///////////////////////////////////////////////////////// END OF MKMAPVIEW ////////////////////////////////////////////////////////////
    
    
    
    CORELOCATION_FLAG=0;
    
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
    style=[[Styles alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(STOP_LOCATION_UPDATE) name:@"BACKGROUNDTIMER" object:nil];
    
    NSLog(@"qweu:%d",Public_search_flag);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"user_accept"] isEqualToString:@"YES"])
    {
        NSLog(@"ACCEPTED USER");
        [self startlocation];
    }
    else
    {
        NSLog(@"NOT ACCEPTED USER");
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Allow “Sports Partners” to access your current location while you use the app?" message:@"This will be used to find your nearby sports partners." delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"Allow", nil];
        
        
        [errorAlert show];
        
    }
    
    
    //    if (INTRO_FLAG==1)
    //
    //    {
    //
    //        [sqlfunction load_sports_list];
    //        index_array=[[NSMutableArray alloc]init];
    //        [sqlfunction search_sports_list_Feed:USER_ID];
    //
    //        for (int i=0; i<sqlfunction.sports_array.count; i++)
    //        {
    //            [index_array addObject:[[sqlfunction.sports_array objectAtIndex:i]objectForKey:@"id"]];
    //        }
    //
    //    }
    //    else
    //    {
    NSLog(@"NOT FROM INTRO");
    [sqlfunction SP_ALL_SPORTS];
    NSString *sports_string=[sqlfunction SEARCH_ALL_SPORTS];
    
    if ([sports_string isEqualToString:@""] || [sports_string isEqual:[NSNull null]] || sports_string==NULL || sports_string==nil)
    {
        NSLog(@"LOCAL NULL");
        [self GET_COMPLETE_SPORTS_LIST];
    }
    else
    {
        
        NSLog(@"LOCAL NOT NULL");
        NSData* statData = [sports_string dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary   *json_db =
        [NSJSONSerialization JSONObjectWithData:statData
                                        options:kNilOptions
                                          error:nil];
        complete_sports_list=[[json_db objectForKey:@"result"]mutableCopy];
        
        [self CHECK_SPORTS];
    }
    
    // }
    
    if ([[UIScreen mainScreen]bounds].size.height ==480)
    {
        msg_bubble_view.frame=CGRectMake(260, 368, 59, 61);
        public_profile_view.frame=CGRectMake(0, 16, 320, 464);
        public_prf_pic.frame=CGRectMake(0, 16, 320, 464);
        name_label.frame=CGRectMake(10, 400, 279, 34);
        age_label.frame=CGRectMake(10, 440, 25, 21);
        place_label.frame=CGRectMake(38, 440, 258, 21);
        tabbar_border_label.frame=CGRectMake(0, 430, 320,1);
        self.mapView.frame=CGRectMake(0, 291, 320, 138);
        map_up_button.frame=CGRectMake(260, 370, 50, 50);
        search_name_table.frame=CGRectMake(6, 109, 306, 120);
        
        
    }
    
    UITapGestureRecognizer *gesture_follow=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MESSAGE_ACTION)];
    msg_bubble_view.userInteractionEnabled=YES;
    
    [msg_bubble_view addGestureRecognizer:gesture_follow];
    
    UITapGestureRecognizer *gesture_message=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MESSAGE_ACTION)];
    msg_bubble_view.userInteractionEnabled=YES;
    [msg_bubble_view addGestureRecognizer:gesture_message];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MESSAGE_BUBBLE_ACTION) name:@"UNREADMESSAGE" object:nil];
    thread_count=0;
    
    ////////////////// FLASH MESSAGE ////////////////
    
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
    
    
    NSUserDefaults *defaults_users=[NSUserDefaults standardUserDefaults];
    
    NSString *user_string=[defaults_users objectForKey:@"users"];
    
    if (![user_string isEqualToString:@""])
    {
        
        NSData* statData = [user_string dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary   *json_db =
        [NSJSONSerialization JSONObjectWithData:statData
                                        options:kNilOptions
                                          error:nil];
        search_name_arry=[[json_db objectForKey:@"result"]mutableCopy];
        
    }
    
    //
    
}

-(void)KEY_BOARD_REMOVE
{
    NSLog(@"KEYBOARDDDDDDD");
    name_search_close_button.hidden=YES;
    [search_name_textfield resignFirstResponder];
}

-(void)GET_ALL_USERS
{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSLog(@"SEARCH NAMES");
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:TOKEN forKey:@"token"];
        [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
        [param setObject:@"0" forKey:@"last_user_id"];
        
        NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/GetUsers"];
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"READ URL STR IS :%@",jsonString);
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
                                   if (data==nil || ![data isEqual:[NSNull null]])
                                   {
                                       [HUD hide:YES];
                                       [self stopSpin];
                                       
                                   }
                                   else
                                   {
                                       
                                       NSString *str_users = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       
                                       NSDictionary *json =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                       
                                       //NSLog(@"ALL_USERS_ :%@",str_users);
                                       
                                       
                                       NSInteger status=[[json objectForKey:@"status"] intValue];
                                       
                                       if(status==1)
                                       {
                                           
                                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                           
                                           [defaults setObject:str_users forKey:@"users"];
                                           
                                           [defaults synchronize];
                                           
                                           
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
                               }];
        
        
    });
    
}

#pragma mapview functions

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    
    NSLog(@"GESTURE HANDLE");
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    
//    MKCoordinateRegion mapRegion;
//    mapRegion.center = touchMapCoordinate;
//    mapRegion.span = MKCoordinateSpanMake(0.1, 0.1);
//    [self.mapView setRegion:mapRegion animated: YES];
    
    latitude=[NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
    longitude=[NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
    
    
    NSLog(@"TOUCH LATITUDE : %@",latitude);
    
    NSLog(@"TOUCH longitude : %@",longitude);
    
    
    
    //    [circleView removeFromSuperview];
    //
    //    circle=nil;
    //
    //    NSArray *overlayCountries = [self.mapView overlays];
    //    [self.mapView removeOverlays:overlayCountries];
    //
    //
    //
    //    circle = [MKCircle circleWithCenterCoordinate:touchMapCoordinate radius:10];
    //
    //    [self.mapView addOverlay:circle];
    //
    
    
    //     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(touchMapCoordinate, 8000, 8000);
    //     [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlpath=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng="];
        urlpath = [urlpath stringByAppendingString:[NSString stringWithFormat:@"%f",touchMapCoordinate.latitude]];
        urlpath = [urlpath stringByAppendingString:@","];
        urlpath = [urlpath stringByAppendingString:[NSString stringWithFormat:@"%f",touchMapCoordinate.longitude]];
        urlpath = [urlpath stringByAppendingString:@"&sensor=false"];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlpath]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request  returningResponse:nil error:nil];
        
        //-- JSON Parsing
        
        if (response!=nil || [response isEqual:[NSNull null]])
        {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *result_array=[results objectForKey:@"results"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result_array.count>0)
                {
                    NSDictionary *sublocation=[result_array objectAtIndex:0];
                    NSMutableArray *Address_Dictionary=[sublocation objectForKey:@"address_components"];
                    NSMutableDictionary *final_dict=[Address_Dictionary objectAtIndex:0];
                    location_name_label.text=[final_dict objectForKey:@"long_name"];
                    
                    [pinView removeFromSuperview];
                    pinView=nil;
                    NSArray *array=self.mapView.annotations;
                   // [self.mapView removeAnnotations:array];
                    
                    MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
                    pa.coordinate = touchMapCoordinate;
                    //    pa.title = @"Hello";
                    [self.mapView addAnnotation:pa];
                }
                
            });
        }
        
    });
    
}


//-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
//{
//  //  [pinView removeFromSuperview];
//    // If it's the user location, just return nil.
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//    {
//        return nil;
//    }
//    // Handle any custom annotations.
//    if ([annotation isKindOfClass:[MKPointAnnotation class]])
//    {
//        // Try to dequeue an existing pin view first.
//        pinView = (MKAnnotationView*)[mV dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
//        if (!pinView)
//        {
//            // If an existing pin view was not available, create one.
//            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
//            //pinView.animatesDrop = YES;
//            pinView.canShowCallout = YES;
//            pinView.image = [UIImage imageNamed:@"blue-area-height.png"];
//            pinView.calloutOffset = CGPointMake(0, 32);
//        } else
//        {
//            pinView.annotation = annotation;
//        }
//        return pinView;
//    }
//    return nil;
//}
//

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    //pinView = nil;
    NSLog(@"UIUIUIUIUIUIU");
   
   // [pinView removeFromSuperview];
    
    if(annotation != self.mapView.userLocation)
    {
        
        NSLog(@"MAPVIEW>USERLOCATION");
      //
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
        {
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        [pinView addSubview:location_name_label];
        [pinView addSubview:search];
        pinView.canShowCallout = NO;
        pinView.centerOffset = CGPointMake(0, -20);
        pinView.image = [UIImage imageNamed:@"blue-area-height.png"];
        }
        else
        {
            NSLog(@"no annnnoooooo");
           // pinView.annotation=annotation;
        }
        
    }
    else
    {
        
        NSLog(@"eeeeeerrrr");
        // [self.mapView.userLocation setTitle:@"I am here"];
    }
    
//    MKCoordinateRegion mapRegion;
//    mapRegion.center = touchMapCoordinate;
//   // mapRegion.span = MKCoordinateSpanMake(0.9, 0.9);
//    [self.mapView setRegion:mapRegion animated: YES];
    
    NSLog(@"crasssshhhhhh");
    return pinView;
    
    
}


- (void)handleGesture_l:(UIGestureRecognizer *)gestureRecognizer
{
    
    NSLog(@"GESTURE LABELLLLL");
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - MKMapViewDelegate

//- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
//{
//
//    NSLog(@"MAP_OVERLAY");
//
//    [circleView removeFromSuperview];
//
//    if (circleView==nil)
//    {
//        circleView = [[MKCircleView alloc] initWithOverlay:overlay];
//        circleView.strokeColor = [UIColor redColor];
//       // circleView.lineWidth = 2.0;
//    }
//
//    return circleView;
//}

-(void)BUTTON_ACTION:(id)sender
{
    NSLog(@" BUUUUUUUUUUTTTT");
    search_type=@"";
    search_name_textfield.text=@"";
    [self SEARCH_FUNCTION];
}

////////////////////////////////////////// END MAP VIEW FUNCTIONALITIES //////////////////////////////


-(void)STOP_LOCATION_UPDATE
{
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
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


- (UILabel *)createHomeButtonView {
    
    NSLog(@"YUIYIU");
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110.f, 0.f, 50.f, 50.f)];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.layer.cornerRadius = label.frame.size.height / 2.f;
    // label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"b_view.png"]];
    
    label.clipsToBounds = YES;
    
    return label;
}

- (NSMutableArray *)createDemoButtonArray :(NSInteger)index

{
    
    chat_button.hidden=YES;
    eye_button.hidden=YES;
    star_button.hidden=YES;
    repoert_abuse_button.hidden=YES;
    like_button.hidden=YES;
    
    NSLog(@"INDEX IS :%@",[[search_array objectAtIndex:index]objectForKey:@"search_user_propic_like_status"]);
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    
    if ([[NSString stringWithFormat:@"%@",[[search_array objectAtIndex:index]objectForKey:@"search_user_propic_like_status"]] isEqualToString:@"liked"])
    {
        NSLog(@"IN LIKED");
        buttonsMutable = [NSMutableArray arrayWithObjects:chat_button,eye_button, star_button, repoert_abuse_button ,like_button,nil];
        NSLog(@"BTNCN:%d",buttonsMutable.count);
        
    }
    else if ([[NSString stringWithFormat:@"%@",[[search_array objectAtIndex:index]objectForKey:@"search_user_propic_like_status"]] isEqualToString:@"unliked"])
    {
        NSLog(@"INNOT");
        buttonsMutable = [NSMutableArray arrayWithObjects:chat_button,eye_button, star_button, repoert_abuse_button, nil];
        
    }
    NSLog(@"MUT :%@",buttonsMutable);
    
    return [buttonsMutable copy];
}

- (void)test:(UIButton *)sender
{
    NSLog(@"Button tapped, tag: %ld", (long)sender.tag);
}

- (UIButton *)createButtonWithName:(NSString *)imageName
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

//- (BOOL)prefersStatusBarHidden
//{
//    return true;
//}


-(void) refreshNetworkStatus:(NSTimer*)time
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
    }
    else
    {
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
    }
}

-(IBAction)segmentedControlIndexChanged:(id)sender
{
    switch (l_segment_control.selectedSegmentIndex)
    {
        case 0:
        {
            CORELOCATION_FLAG ++;
            
            if (CORELOCATION_FLAG ==1)
            {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Allow “Sports Partners” to access your current location while you use the app?" message:@"This will be used to find your nearby sports partners." delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"Allow", nil];
                [errorAlert show];
                
            }
            else
            {
                latitude=current_latitude;
                longitude=current_longitude;
                location_string=current_location;
            }
            
        }
            break;
        case 1:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Your Postcode" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil] ;
            alertView.tag = 2;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
            
            latitude=user_latitude;
            longitude=user_longitude;
            location_string=user_location;
            NSLog(@"USER Latitude :%@",latitude);
        }
            break;
        default:
            break;
    }
}
-(void)USER_DETAILS
{
    NSLog(@"USERDB");
    [sqlfunction load_sports_list];
    [sqlfunction search_sports_list_Feed:USER_ID];
    NSMutableDictionary *dict=[sqlfunction searchUserDetailsTable:USER_ID];
    if (dict==NULL || dict.count==0 || [dict isEqual:[NSNull null]] || sqlfunction.sports_array.count==0)
    {
        NSLog(@"LOCAL IS NULL");
        [self GET_PROFILE_DETAILS];
    }
    else
    {
        NSLog(@"LOCAL NOT NULL :%@",[dict objectForKey:@"lat"]);
        //        user_latitude=[dict objectForKey:@"lat"];
        //        user_longitude=[dict objectForKey:@"long"];
        //        [l_segment_control setTitle:[dict objectForKey:@"place"] forSegmentAtIndex:1];
        //        latitude=user_latitude;
        //        longitude=user_longitude;
        //        location_string=user_location;
        //        l_segment_control.selectedSegmentIndex=1;
        index_array=[[NSMutableArray alloc]init];
        [sqlfunction load_sports_list];
        [sqlfunction search_sports_list_Feed:USER_ID];
        for (int i=0; i<sqlfunction.sports_array.count; i++)
        {
            [index_array addObject:[[sqlfunction.sports_array objectAtIndex:i]objectForKey:@"id"]];
        }
        
    }
}

-(void)GET_PROFILE_DETAILS
{
    NSLog(@"GET_PROFILE_DETAILS");
    [sqlfunction loadUserDetailsTable];
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        
        //  [self showPageLoader];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithInt:USER_ID] forKey:@"user_id"];
        [param setObject:TOKEN forKey:@"token"];
        
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
                     
                     dispatch_async(dispatch_get_global_queue(0, 0), ^{
                         
                         NSData *imd_data;
                         
                         //                         user_location=[json objectForKey:@"user_place"];
                         //
                         //                         user_latitude=[json objectForKey:@"latitude"];
                         //                         user_longitude=[json objectForKey:@"longitude"];
                         
                         if([[json objectForKey:@"user_profile"]isEqualToString:@""])
                         {
                             
                             imd_data=UIImageJPEGRepresentation([UIImage imageNamed:@"noimage.png"], 90);
                         }
                         else
                         {
                             NSString *image_url=[json objectForKey:@"user_profile"];
                             NSURL *url=[NSURL URLWithString:image_url];
                             imd_data=[[NSData alloc] initWithContentsOfURL:url];
                             
                         }
                         
                         [sqlfunction saveToUserDetailsTable:USER_ID name:[json objectForKey:@"user_name"] age:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_age"]] place:[json objectForKey:@"user_place"] profile_pic:imd_data like_count:[[json objectForKey:@"user_total_like_count"]intValue ] msg_count:[[json objectForKey:@"user_unread_message_count"] intValue] notif_ccount:[[json objectForKey:@"user_new_notification_count"]intValue] follower_count:[[json objectForKey:@"user_total_followers_count"] intValue] latitude:[NSString stringWithFormat:@"%@",[json objectForKey:@"latitude"]] longitude:[NSString stringWithFormat:@"%@",[json objectForKey:@"longitude"]]gender:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_gender"]] tag_line:[NSString stringWithFormat:@"%@",[json objectForKey:@"tagline"]]];
                         
                         
                         [sqlfunction delete_sports_list_Feed:USER_ID];
                         NSMutableArray *user_selected_sports=[json objectForKey:@"user_selected_sports"];
                         NSLog(@"USER SP: %@",user_selected_sports);
                         
                         for (int i=0; i<user_selected_sports.count; i++)
                         {
                             [sqlfunction saves_sports_list:USER_ID spots_name:[[user_selected_sports objectAtIndex:i] objectForKey:@"name"] sports_id:[[[user_selected_sports objectAtIndex:i] objectForKey:@"id"] intValue]];
                         }
                         
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             NSMutableArray *user_selected_sports_array=[json objectForKey:@"user_selected_sports"];
                             NSLog(@"server user details");
                             // [l_segment_control setTitle:user_location forSegmentAtIndex:1];
                             //  latitude=user_latitude;
                             // longitude=user_longitude;
                             // location_string=user_location;
                             index_array=[[NSMutableArray alloc]init];
                             for (int i=0; i<user_selected_sports_array.count; i++)
                             {
                                 [index_array addObject:[[user_selected_sports_array objectAtIndex:i]objectForKey:@"id"]];
                             }
                             NSLog(@"FFAV SP IN PROFILE DETAILS:%@",index_array);
                             
                             //   [self SEARCH_FUNCTION];
                             //l_segment_control.selectedSegmentIndex=1;
                             
                             
                         });
                         
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
    }
    else
    {
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
    }
}

-(NSAttributedString *)GET_SHADOW_STRING:(NSString *)string_value
{
    NSString *str = [[NSString stringWithFormat:@"%@",string_value] capitalizedString];
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


-(NSAttributedString *)GET_SHADOW_STRING_PLACE:(NSString *)string_value
{
    NSString *str = [string_value capitalizedString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    UIFont *font =[UIFont fontWithName:@"Roboto-Regular" size:17];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return complete_sports_list.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath  *)indexPath{
    
    static NSString  *identifier = @"CELL";
    SportsCell *cell = (SportsCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //    cell.layer.borderWidth=1.0;
    //    cell.layer.borderColor=[UIColor whiteColor].CGColor;
    //    cell.backgroundColor=[UIColor clearColor];
    cell.prof_images.hidden=YES;
    
    NSString *image_url=[connectobj image_value];
    image_url=[image_url stringByAppendingString:[[complete_sports_list objectAtIndex:indexPath.row]objectForKey:@"image"]];
    NSURL *url=[NSURL URLWithString:image_url];
    [cell.sport_image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"no_im_feed.png"]];
    
    cell.sports_name_label.text=[[complete_sports_list objectAtIndex:indexPath.row]objectForKey:@"name"];
    
    if ([[[complete_sports_list objectAtIndex:indexPath.row]objectForKey:@"flag"]isEqualToString:@"1"])
    {
        cell.backgroundColor = [style colorWithHexString: favourite_sports_selected_color];
        cell.prof_images.hidden=NO;
    }
    else
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.prof_images.hidden=YES;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSLog(@"Collectionview sports touch");
    SportsCell *cell = (SportsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor=[style colorWithHexString:favourite_sports_selected_color];
    cell.prof_images.hidden=NO;
    NSString *selected_index=[[complete_sports_list objectAtIndex:indexPath.row]objectForKey:@"id"];;
    if(index_array.count>0)
    {
        if([index_array containsObject:selected_index])
        {
            cell.backgroundColor=[style colorWithHexString:terms_of_services_color];
            cell.prof_images.hidden=YES;
            [index_array removeObject:selected_index];
            
            [complete_sports_list mutableCopy];
            NSMutableDictionary *dict_raw=[[NSMutableDictionary alloc]init];
            dict_raw=[[complete_sports_list objectAtIndex:indexPath.row]mutableCopy];
            [dict_raw setObject:@"0" forKey:@"flag"];
            [complete_sports_list replaceObjectAtIndex:indexPath.row withObject:dict_raw];
            
            //[selected_sports_array removeObject:[complete_sports_list objectAtIndex:indexPath.row]];
        }
        else
        {
            cell.backgroundColor=[style colorWithHexString:favourite_sports_selected_color];
            cell.prof_images.hidden=NO;
            [index_array addObject:selected_index];
            
            [complete_sports_list mutableCopy];
            NSMutableDictionary *dict_raw=[[NSMutableDictionary alloc]init];
            dict_raw=[[complete_sports_list objectAtIndex:indexPath.row]mutableCopy];
            [dict_raw setObject:@"1" forKey:@"flag"];
            [complete_sports_list replaceObjectAtIndex:indexPath.row withObject:dict_raw];
            
            //[selected_sports_array addObject:[complete_sports_list objectAtIndex:indexPath.row]];
        }
    }
    else
    {
        
        [index_array addObject:selected_index];
        
        [complete_sports_list mutableCopy];
        NSMutableDictionary *dict_raw=[[NSMutableDictionary alloc]init];
        dict_raw=[[complete_sports_list objectAtIndex:indexPath.row]mutableCopy];
        [dict_raw setObject:@"1" forKey:@"flag"];
        [complete_sports_list replaceObjectAtIndex:indexPath.row withObject:dict_raw];
        // [selected_sports_array addObject:[complete_sports_list objectAtIndex:indexPath.row]];
        
    }
    
    
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    if(scrollView==search_table)
//    {
//
//    if ([scrollView.panGestureRecognizer translationInView:scrollView].y > 0)
//    {
//
//
//    }
//    else
//    {
//
//        [UIView animateWithDuration:0.5
//                              delay:0.1
//                            options: UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             search_view.frame = CGRectMake(0, -237, 320, 237);
//                             if ([UIScreen mainScreen].bounds.size.height !=568)
//                             {
//                                 search_table.frame=CGRectMake(0, 47, 320, 433);
//                             }
//                             else
//                             {
//                                 search_table.frame=CGRectMake(0, 47, 320, 520);
//                             }
//                             header_view.frame = CGRectMake(0, -45, 320, 45);
//                         }
//                         completion:^(BOOL finished){
//                         }];
//
//
//    }
//    }
//
//}
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
//                 willDecelerate:(BOOL)decelerate{
//   }

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"AlERT FUNCTION");
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Allow"])
    {
        NSLog(@"ALLOW");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"YES" forKey:@"user_accept"];
        [defaults synchronize];
        
        [self startlocation];
    }
    else if([title isEqualToString:@"Don't Allow"])
    {
        NSLog(@"Don't Allow");
    }
    else  if([title isEqualToString:@"Current Location"])
    {
        [self startlocation];
        
    }
    
    else if([title isEqualToString:@"My Location"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Your Postcode" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil] ;
        alertView.tag = 2;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
        NSUserDefaults *defaults_zip=[NSUserDefaults standardUserDefaults];
        NSString *zip=[defaults_zip objectForKey:@"zip"];
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        alertTextField.text=zip;
        
    }
    else if([title isEqualToString:@"Submit"])
    {
        
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        NSLog(@"alerttextfiled - %@",alertTextField.text);
        if ([alertTextField.text isEqualToString:@""])
        {
            NSLog(@"PIN NIL");
            [alertTextField becomeFirstResponder];
            [self alertStatus:@"Please Enter Your Postcode"];
            return;
        }
        else
        {
            NSUserDefaults *defaults_zip = [NSUserDefaults standardUserDefaults];
            [defaults_zip setObject:alertTextField.text forKey:@"zip"];
            [defaults_zip synchronize];
            [self validate_zip_code:alertTextField.text];
        }
    }
    else if([title isEqualToString:@"Settings"])
    {
        NSLog(@"SETTINGSSSS");
        BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
        if (canOpenSettings) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}
-(void)startlocation
{
    locationManager=[[CLLocationManager alloc]init];
    
    geocoder = [[CLGeocoder alloc] init];
    
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CURRENT_LOCATION_FLAG=0;
    
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    
    //In ViewDidLoad
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

-(void)validate_zip_code :(NSString *)string
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        [self showPageLoader];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:string forKey:@"zip_code"];
        
        NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/validatezipcode"];
        
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
                                   NSLog(@"RESPONSE :%@",response);
                                   if (data==nil || [data isEqual:[NSNull null]])
                                   {
                                       [HUD hide:YES];
                                       [self stopSpin];
                                   }
                                   else
                                   {
                                       
                                       NSDictionary *json1 =
                                       [NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions
                                                                         error:nil];
                                       NSLog(@"DIC is :%@",json1);
                                       
                                       NSInteger status=[[json1 objectForKey:@"status"] intValue];
                                       
                                       if(status==1)
                                       {
                                           latitude=[json1 objectForKey:@"lat"];
                                           longitude=[json1 objectForKey:@"lng"];
                                           NSString *urlpath=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng="];
                                           NSLog(@"Url path is :%@",urlpath);
                                           urlpath = [urlpath stringByAppendingString:[NSString stringWithFormat:@"%@",latitude]];
                                           urlpath = [urlpath stringByAppendingString:@","];
                                           urlpath = [urlpath stringByAppendingString:[NSString stringWithFormat:@"%@",longitude]];
                                           urlpath = [urlpath stringByAppendingString:@"&sensor=false"];
                                           NSLog(@"Url path is :%@",urlpath);
                                           
                                           NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlpath]];
                                           
                                           NSData *response = [NSURLConnection sendSynchronousRequest:request  returningResponse:nil error:nil];
                                           
                                           NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                                           SBJSON *parser=[[SBJSON alloc]init];
                                           NSDictionary *results=[parser objectWithString:json_string error:nil];
                                           
                                           NSMutableArray *result_array=[results objectForKey:@"results"];
                                           if (result_array.count>0)
                                           {
                                               NSDictionary *sublocation=[result_array objectAtIndex:0];
                                               NSMutableArray *Address_Dictionary=[sublocation objectForKey:@"address_components"];
                                               NSMutableDictionary *final_dict=[Address_Dictionary objectAtIndex:2];
                                               location_string=[final_dict objectForKey:@"long_name"];
                                               // location_string=@"kaloor";
                                               if (![location_string isEqualToString:@""])
                                               {
                                                   
                                                   from_label.text=location_string;
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   
                                                   
                                               }
                                               
                                           }
                                           else
                                               
                                           {
                                               
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               [self alertStatus:@"Failed to get your location"];
                                               return ;
                                           }
                                           //
                                       }
                                       else
                                       {
                                           [HUD hide:YES];
                                           [self stopSpin];
                                           [self alertStatus:@"Enter a valid zip code"];
                                           return ;
                                       }
                                       if (connectionError)
                                       {
                                           
                                           NSLog(@"error detected:%@", connectionError.localizedDescription);
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [HUD hide:YES];
                                               [self stopSpin];
                                           });
                                           
                                       }
                                   }
                               }];
    }
    else
    {
        networkErrorView.hidden=NO;
        [HUD hide:YES];
        [self stopSpin];
    }
}



-(void)GET_COMPLETE_SPORTS_LIST
{
    index_array=[[NSMutableArray alloc]init];
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        [self showPageLoader_public];
        
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
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopSpin];
                        [self CHECK_SPORTS];
                        
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




-(void)CHECK_SEARCH
{
    NSLog(@"IN CHEKKKKKKKKKKKKKK");
    if (index_array.count==0)
    {
        [sqlfunction load_sports_list];
        [sqlfunction search_sports_list_Feed:USER_ID];
        if (sqlfunction.sports_array.count==0)
        {
            [sqlfunction loadUserDetailsTable];
            BOOL netStatus = [connectobj checkNetwork];
            if(netStatus == true)
            {
                networkErrorView.hidden=YES;
                //  [self showPageLoader];
                
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:[NSNumber numberWithInt:USER_ID] forKey:@"user_id"];
                [param setObject:TOKEN forKey:@"token"];
                
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
                             
                             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                 
                                 
                                 [sqlfunction delete_sports_list_Feed:USER_ID];
                                 NSMutableArray *user_selected_sports=[json objectForKey:@"user_selected_sports"];
                                 for (int i=0; i<user_selected_sports.count; i++)
                                 {
                                     [sqlfunction saves_sports_list:USER_ID spots_name:[[user_selected_sports objectAtIndex:i] objectForKey:@"name"] sports_id:[[[user_selected_sports objectAtIndex:i] objectForKey:@"id"] intValue]];
                                 }
                                 
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     NSMutableArray *user_selected_sports_array=[json objectForKey:@"user_selected_sports"];
                                     NSLog(@"server user details");
                                     
                                     index_array=[[NSMutableArray alloc]init];
                                     for (int i=0; i<user_selected_sports_array.count; i++)
                                     {
                                         [index_array addObject:[[user_selected_sports_array objectAtIndex:i]objectForKey:@"id"]];
                                     }
                                     [self SEARCH_FUNCTION];
                                     NSLog(@"FFAV SP IN CHECK SEARCH:%@",index_array);
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
            }
            else
            {
                networkErrorView.hidden=NO;
                [HUD hide:YES];
                [self stopSpin];
            }
            
        }
        
        else
        {
            index_array=[[NSMutableArray alloc]init];
            [sqlfunction load_sports_list];
            [sqlfunction search_sports_list_Feed:USER_ID];
            for (int i=0; i<sqlfunction.sports_array.count; i++)
            {
                [index_array addObject:[[sqlfunction.sports_array objectAtIndex:i]objectForKey:@"id"]];
            }
            [self SEARCH_FUNCTION];
        }
        
    }
    else
    {
        [self SEARCH_FUNCTION];
    }
    
}

-(void)CHECK_SPORTS
{
    [sqlfunction load_sports_list];
    [sqlfunction search_sports_list_Feed:USER_ID];
    
    
    if (sqlfunction.sports_array.count==0)
    {
        
        
        NSLog(@"FAV SP NULLLLL");
        [sqlfunction loadUserDetailsTable];
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            networkErrorView.hidden=YES;
            [self showPageLoader_public];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[NSNumber numberWithInt:USER_ID] forKey:@"user_id"];
            [param setObject:TOKEN forKey:@"token"];
            
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
                         
                         dispatch_async(dispatch_get_global_queue(0, 0), ^{
                             
                             
                             [sqlfunction delete_sports_list_Feed:USER_ID];
                             NSMutableArray *user_selected_sports=[json objectForKey:@"user_selected_sports"];
                             
                             if (user_selected_sports.count>0)
                             {
                                 for (int i=0; i<user_selected_sports.count; i++)
                                 {
                                     [sqlfunction saves_sports_list:USER_ID spots_name:[[user_selected_sports objectAtIndex:i] objectForKey:@"name"] sports_id:[[[user_selected_sports objectAtIndex:i] objectForKey:@"id"] intValue]];
                                 }
                                 
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     NSMutableArray *user_selected_sports_array=[json objectForKey:@"user_selected_sports"];
                                     NSLog(@"server user details");
                                     
                                     index_array=[[NSMutableArray alloc]init];
                                     for (int i=0; i<user_selected_sports_array.count; i++)
                                     {
                                         [index_array addObject:[[user_selected_sports_array objectAtIndex:i]objectForKey:@"id"]];
                                     }
                                     [HUD hide:YES];
                                     [self stopSpin];
                                     
                                     [complete_sports_list mutableCopy];
                                     for (int j=0; j<complete_sports_list.count; j++)
                                     {
                                         NSMutableDictionary *dict_b=[[NSMutableDictionary alloc]init];
                                         dict_b=[[complete_sports_list objectAtIndex:j]mutableCopy];
                                         [dict_b setObject:@"0" forKey:@"flag"];
                                         [complete_sports_list replaceObjectAtIndex:j withObject:dict_b];
                                     }
                                     
                                     
                                     for (int i=0; i<index_array.count; i++)
                                     {
                                         for (int j=0; j<complete_sports_list.count; j++)
                                         {
                                             
                                             if ([[[complete_sports_list objectAtIndex:j]objectForKey:@"id"]isEqualToString:[index_array objectAtIndex:i]])
                                             {
                                                 NSMutableDictionary *dict_b=[[NSMutableDictionary alloc]init];
                                                 dict_b=[[complete_sports_list objectAtIndex:j]mutableCopy];
                                                 [dict_b setObject:@"1" forKey:@"flag"];
                                                 [complete_sports_list replaceObjectAtIndex:j withObject:dict_b];
                                                 
                                             }
                                         }
                                     }
                                     
                                     
                                     [select_sp_collectionview reloadData];
                                     NSLog(@"FFAV SP FROM SERVER :%@",index_array);
                                 });
                                 
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
        }
        else
        {
            networkErrorView.hidden=NO;
            [HUD hide:YES];
            [self stopSpin];
        }
        
    }
    
    else
    {
        index_array=[[NSMutableArray alloc]init];
        
        for (int i=0; i<sqlfunction.sports_array.count; i++)
        {
            [index_array addObject:[[sqlfunction.sports_array objectAtIndex:i]objectForKey:@"id"]];
        }
        
        [complete_sports_list mutableCopy];
        for (int j=0; j<complete_sports_list.count; j++)
        {
            NSMutableDictionary *dict_b=[[NSMutableDictionary alloc]init];
            dict_b=[[complete_sports_list objectAtIndex:j]mutableCopy];
            [dict_b setObject:@"0" forKey:@"flag"];
            [complete_sports_list replaceObjectAtIndex:j withObject:dict_b];
        }
        
        
        for (int i=0; i<index_array.count; i++)
        {
            for (int j=0; j<complete_sports_list.count; j++)
            {
                
                if ([[[complete_sports_list objectAtIndex:j]objectForKey:@"id"]isEqualToString:[index_array objectAtIndex:i]])
                {
                    NSMutableDictionary *dict_b=[[NSMutableDictionary alloc]init];
                    dict_b=[[complete_sports_list objectAtIndex:j]mutableCopy];
                    [dict_b setObject:@"1" forKey:@"flag"];
                    [complete_sports_list replaceObjectAtIndex:j withObject:dict_b];
                    
                }
            }
        }
        [select_sp_collectionview reloadData];
        
    }
    
    
}


-(void)update_user_location
{
    NSLog(@"START UPDATION");
    BOOL netStatus = [connectobj checkNetwork];
    
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        // [self showPageLoader];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:TOKEN forKey:@"token"];
        [param setObject:[NSNumber numberWithInteger:USER_ID]forKey:@"user_id"];
        [param setObject:current_location forKey:@"location"];
        [param setObject:[NSNumber numberWithFloat:[current_longitude floatValue]] forKey:@"longitude"];
        [param setObject:[NSNumber numberWithFloat:[current_latitude floatValue]] forKey:@"latitude"];
        NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/updateuserextrafields"];
        
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
                                   NSLog(@"RESPONSE :%@",response);
                                   if (data==nil || [data isEqual:[NSNull null]])
                                   {
                                       [HUD hide:YES];
                                       [self stopSpin];
                                   }
                                   else
                                   {
                                       
                                       NSDictionary *json1 =
                                       [NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions
                                                                         error:nil];
                                       NSLog(@"DIC_UPDATION is :%@",json1);
                                       
                                       NSInteger status=[[json1 objectForKey:@"status"] intValue];
                                       
                                       if(status==1)
                                       {
                                           
                                       }
                                       else
                                       {
                                           
                                           
                                           
                                       }
                                       if (connectionError)
                                       {
                                           
                                           NSLog(@"error detected:%@", connectionError.localizedDescription);
                                           
                                       }
                                   }
                               }];
    }
    else
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            networkErrorView.hidden=NO;
            [HUD hide:YES];
            [self stopSpin];
        });
        
        
    }
}


#pragma Name search


- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    
    
    filteredTableData=[[NSMutableArray alloc]init];
    
    for(int i=0;i<search_name_arry.count;i++)
    {
        NSRange substringRange = [[[search_name_arry objectAtIndex:i]objectForKey:@"displayname"] rangeOfString:substring];
        if (substringRange.location != NSNotFound)
        {
            [filteredTableData addObject:[search_name_arry objectAtIndex:i]];
        }
    }
    
    // NSLog(@"FILER ARRAY : %@", filteredTableData);
    
    if (filteredTableData.count!=0)
    {
        search_name_table.hidden=NO;
        [search_name_table reloadData];
    }
    else
    {
        search_name_table.hidden=YES;
        [search_name_table reloadData];
    }
}


#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    name_search_close_button.hidden=NO;
    
    NSLog(@"SEARCH TABLE TEXT SEARCH :%lu",(unsigned long)textField.text.length);
    
    search_name_table.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    NSLog(@"SUB STR : %@",substring);
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    search_name_table.hidden=YES;
    search_type=@"name";
    [self SEARCH_FUNCTION];
    return YES;
}

- (IBAction)NAME_SEARCH_CLOSE_ACTION:(id)sender
{
    name_search_close_button.hidden=YES;
    search_name_table.hidden=YES;
    search_name_textfield.text=@"";
    [search_name_textfield resignFirstResponder];
    
}

@end
