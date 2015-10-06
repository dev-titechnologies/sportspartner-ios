//
//  NotificationViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 07/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "NotificationViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "MessageCell.h"
#import "ProfileViewController.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "SVPullToRefresh.h"
@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize USER_ID,TOKEN;
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
    
    __weak NotificationViewController *weakSelf = self;
    
    
    [notif_table_view addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(insertRowAtBottom) withObject:nil afterDelay:1.0];
    }];
    
    page_number=0;
    

    
    connectobj=[[connection alloc]init];
    notification_array=[[NSMutableArray alloc]init];
    
    
   // header_view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"320x60.png"]];
    
    header_label.font=[UIFont fontWithName:@"Roboto-Regular" size:23];
    header_label.textColor=[UIColor whiteColor];
    
    ///////// TABLEVIEW DESIGN///////////
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"settings-BG.png"]];
    notif_table_view.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settings-BG.png"]];
    user_names_table.backgroundColor=[UIColor whiteColor];
    
///////////// PUBLIC PROFILE VIEW ////////////////////////
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    public_profile_view.userInteractionEnabled=YES;
    [public_profile_view addGestureRecognizer:recognizer];
    
    
    UISwipeGestureRecognizer *recognizer_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer_down:)];
    recognizer_down.direction = UISwipeGestureRecognizerDirectionDown;
    recognizer_down.numberOfTouchesRequired = 1;
    recognizer_down.delegate = self;
    public_profile_view.userInteractionEnabled=YES;
    [public_profile_view addGestureRecognizer:recognizer_down];
    
   
   
}

- (void)insertRowAtBottom
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            if (total_row_count>notification_array.count)
            {
               
                page_number=page_number+1;
                
                [self NOTIFICATION_FUNCTION_PAGINATION];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"LSS THAN row count");
                    [notif_table_view.infiniteScrollingView stopAnimating];
                    
                });
                
            }
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
    });
    
    
    
}



-(void)READ_STATUS_FUNCTION
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
       
        if ([connectobj string_check:TOKEN]==true  &&[connectobj int_check:USER_ID]==true)
        {
            networkErrorView.hidden=YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:notification_id forKey:@"notification_id"];
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/ReadNotification"];
                
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
                                               
                                               NSLog(@"READE STA :%@",json);
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               if(status==1)
                                               {
                                                   
                                                   
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
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                });
                
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
    if (tableView==notif_table_view)
    {
         return [notification_array count];
    }
    else
     return  user_name_array.count;
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==notif_table_view)
    {
        NSString *CELLIDENTIFIER=@"CELL";
        MessageCell *message_cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        message_cell.selectionStyle=UITableViewCellSelectionStyleNone;
        message_cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        /////// CELL DESIGN ///////
        
        message_cell.Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
        message_cell.profile_pic.layer.cornerRadius=30.0;
        message_cell.profile_pic.contentMode=UIViewContentModeScaleAspectFill;
        message_cell.profile_pic.clipsToBounds=YES;
        message_cell.profile_pic.layer.masksToBounds=YES;
        message_cell.Name_label.textColor=[style colorWithHexString:message_view_display_name_color];
        message_cell.time_label.font=[UIFont fontWithName:@"Roboto-Regular" size:12];
        message_cell.Message_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
        notif_table_view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"search.png"]];
        
        user_name_array=[[notification_array objectAtIndex:indexPath.row]objectForKey:@"usernames"];
        
        
        //////////// Cell Content ////////
        if ([[NSString stringWithFormat:@"%@",[[notification_array objectAtIndex:indexPath.row]objectForKey:@"read"]] isEqualToString:@"0"])
        {
             message_cell.backgroundColor=[style colorWithHexString:@"D1EEFC"];
        }
        else if ([[NSString stringWithFormat:@"%@",[[notification_array objectAtIndex:indexPath.row]objectForKey:@"read"]] isEqualToString:@"1"])
        {
            message_cell.backgroundColor=[UIColor clearColor];
        }
        if ([[[user_name_array objectAtIndex:0]objectForKey:@"storage_path"] isEqualToString:@"0"])
        {
            message_cell.profile_pic.image=[UIImage imageNamed:@"noimage.png"];
        }
        else
        {
            NSString *url_str=[[user_name_array objectAtIndex:0]objectForKey:@"storage_path"];
            NSURL *image_url=[NSURL URLWithString:url_str];
            [message_cell.profile_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
        }
        if (user_name_array.count>1)
        {
            NSString *name_string=[NSString stringWithFormat:@"%@",[[user_name_array objectAtIndex:0]objectForKey:@"user_name"]];
            NSString *count_string=[NSString stringWithFormat:@"%d",user_name_array.count-1];
            name_string=[name_string stringByAppendingString:@" & "];
            name_string=[name_string stringByAppendingString:count_string];
            name_string=[name_string stringByAppendingString:@" others"];
            message_cell.Name_label.text=[name_string capitalizedString];
            message_cell.Name_label.userInteractionEnabled=YES;
            message_cell.Name_label.tag=indexPath.row;
        }
        else
        {
        message_cell.Name_label.text=[[NSString stringWithFormat:@"%@",[[user_name_array objectAtIndex:0]objectForKey:@"user_name"]] capitalizedString];
        }
        
        if ([[[notification_array objectAtIndex:indexPath.row] objectForKey:@"text"]isEqualToString:@"commented on your post"] && [[[notification_array objectAtIndex:indexPath.row]objectForKey:@"activity_count"]integerValue]>1)
        {
            NSString *text_string=[[notification_array objectAtIndex:indexPath.row]objectForKey:@"text"];
            text_string=[text_string stringByAppendingString:@"  ("];
            text_string=[text_string stringByAppendingString:[NSString stringWithFormat:@"%@",[[notification_array objectAtIndex:indexPath.row]objectForKey:@"activity_count"]]];
            text_string=[text_string stringByAppendingString:@")"];
            message_cell.Message_label.text=text_string;
            
        }
        else
        {
        message_cell.Message_label.text=[NSString stringWithFormat:@"%@",[[notification_array objectAtIndex:indexPath.row]objectForKey:@"text"]];
        }
      
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(user_names_touch:)];
        message_cell.Name_label.userInteractionEnabled=YES;
        message_cell.Name_label.tag=indexPath.row;
        [message_cell.Name_label addGestureRecognizer:gesture];
        
        UITapGestureRecognizer *gesture_image=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(user_names_touch_image:)];
        message_cell.profile_pic.userInteractionEnabled=YES;
        message_cell.profile_pic.tag=indexPath.row;
        [message_cell.profile_pic addGestureRecognizer:gesture_image];
        
        return message_cell;

    }
    else
    {
        NSString *CELLIDENTIFIER=@"CELL";
        MessageCell *message_cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        
        /////// CELL DESIGN ///////
        message_cell.backgroundColor=[UIColor clearColor];
        message_cell.Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
        message_cell.profile_pic.layer.cornerRadius=23.0;
        message_cell.profile_pic.layer.masksToBounds=YES;
        message_cell.profile_pic.contentMode=UIViewContentModeScaleAspectFill;
        message_cell.profile_pic.clipsToBounds=YES;
        message_cell.Name_label.textColor=[style colorWithHexString:message_view_display_name_color];
        message_cell.time_label.font=[UIFont fontWithName:@"Roboto-Regular" size:12];
        message_cell.Message_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
        notif_table_view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"search.png"]];
        
        //////////// Cell Content ////////
        
        if ([[[user_name_array objectAtIndex:indexPath.row]objectForKey:@"storage_path"] isEqualToString:@"0"])
        {
            message_cell.profile_pic.image=[UIImage imageNamed:@"noimage.png"];
        }
        else
        {
            NSString *url_str=[[user_name_array objectAtIndex:indexPath.row]objectForKey:@"storage_path"];
            NSURL *image_url=[NSURL URLWithString:url_str];
            [message_cell.profile_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
        }
        message_cell.Name_label.text=[NSString stringWithFormat:@"%@",[[user_name_array objectAtIndex:indexPath.row]objectForKey:@"user_name"]];
        return message_cell;

    }
   }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==notif_table_view)
    {
      
        if([[[notification_array objectAtIndex:indexPath.row]objectForKey:@"text"]isEqualToString:@"has started following you"])
        {
            notif_table_view.userInteractionEnabled=NO;
            user_name_array=[[notification_array objectAtIndex:indexPath.row]objectForKey:@"usernames"];
            obj =[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
            TARGET_USER_ID=[[user_name_array objectAtIndex:0]objectForKey:@"user_id"];
            [obj Clear];
          //  public_profile_view.frame = CGRectMake(0, 18, 320, 500);
            public_profile_view.hidden=NO;
            obj.USER_ID=USER_ID;
            obj.TOKEN=TOKEN;
            obj.TARGETED_USER_ID=TARGET_USER_ID;
            [public_profile_view addSubview:obj.view];
            public_profile_view.frame = CGRectMake(0, 0, 320, 548);
            obj.public_profile_view.frame=CGRectMake(0,0, 320, 568);
             [obj.view addSubview:bacl_button];
            public_profile_view.hidden=NO;
        }
        else
        {
            NSLog(@"NOT FOLLOW");
            NSString *post_id=[[notification_array objectAtIndex:indexPath.row]objectForKey:@"action_id"];
            POST_ID=[post_id integerValue];
            NSLog(@"POST ID :%d",POST_ID);
            [self performSegueWithIdentifier:@"NOTIF_DETAIL" sender:self];
           
        }
        
        notification_id=[NSString stringWithFormat:@"%@",[[notification_array objectAtIndex:indexPath.row]objectForKey:@"notification_id"]];
        [self READ_STATUS_FUNCTION];

    }
    else if (tableView==user_names_table)
    {
       // user_name_array=[[NSMutableArray alloc]init];
       // user_name_array=[[notification_array objectAtIndex:indexPath.row]objectForKey:@"usernames"];
        
         notif_table_view.userInteractionEnabled=NO;
        [self HIDE_USER_NAMES:nil];
        obj =[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
        TARGET_USER_ID=[[user_name_array objectAtIndex:indexPath.row]objectForKey:@"user_id"];
        [obj Clear];
      //  public_profile_view.frame = CGRectMake(0, 18, 320, 500);
        public_profile_view.hidden=NO;
        obj.USER_ID=USER_ID;
        obj.TOKEN=TOKEN;
        obj.TARGETED_USER_ID=TARGET_USER_ID;
        [public_profile_view addSubview:obj.view];
        public_profile_view.frame = CGRectMake(0, 0, 320, 548);
        obj.public_profile_view.frame=CGRectMake(0,0, 320, 568);
        [obj.view addSubview:bacl_button];
        public_profile_view.hidden=NO;
    }
    
}
-(void)user_names_touch_image:(id)sender
{
    
    
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    
    notif_table_view.userInteractionEnabled=NO;
    user_name_array=[[notification_array objectAtIndex:indexPath.row]objectForKey:@"usernames"];
    obj =[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
    TARGET_USER_ID=[[user_name_array objectAtIndex:0]objectForKey:@"user_id"];
    [obj Clear];
 //   public_profile_view.frame = CGRectMake(0, 18, 320, 500);
    public_profile_view.hidden=NO;
    obj.USER_ID=USER_ID;
    obj.TOKEN=TOKEN;
    obj.TARGETED_USER_ID=TARGET_USER_ID;
    [public_profile_view addSubview:obj.view];
   
    public_profile_view.frame = CGRectMake(0, 0, 320, 548);
    obj.public_profile_view.frame=CGRectMake(0,0, 320, 568);
     [obj.view addSubview:bacl_button];
    public_profile_view.hidden=NO;
    
    
    
}
-(void)user_names_touch:(id)sender
{
    UITapGestureRecognizer *gesture1 = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:gesture1.view.tag inSection:0];
    user_name_array=[[notification_array objectAtIndex:indexPath.row]objectForKey:@"usernames"];
    if (user_name_array.count>1)
    {
        [user_names_table reloadData];
        
        backgroundview=[[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        [self.view addSubview:backgroundview];
        [self.view addSubview:user_name_bg_view];
        backgroundview.userInteractionEnabled=YES;
        user_name_bg_view.hidden=NO;
        UITapGestureRecognizer *gestureView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HIDE_USER_NAMES:)];
        [backgroundview addGestureRecognizer:gestureView];
    }
    else
    {
        notif_table_view.userInteractionEnabled=NO;
        [self HIDE_USER_NAMES:nil];
        obj =[self.storyboard instantiateViewControllerWithIdentifier:@"InitialView1"];
        TARGET_USER_ID=[[user_name_array objectAtIndex:0]objectForKey:@"user_id"];
        [obj Clear];
       // public_profile_view.frame = CGRectMake(0, 18, 320, 500);
        public_profile_view.hidden=NO;
        obj.USER_ID=USER_ID;
        obj.TOKEN=TOKEN;
        obj.TARGETED_USER_ID=TARGET_USER_ID;
        [public_profile_view addSubview:obj.view];
        public_profile_view.frame = CGRectMake(0, 0, 320, 548);
        obj.public_profile_view.frame=CGRectMake(0,0, 320, 568);
        [obj.view addSubview:bacl_button];
        public_profile_view.hidden=NO;
    }
    
}
-(void)HIDE_USER_NAMES :(id)sender
{
    [backgroundview removeFromSuperview];
    
    user_name_bg_view.hidden=YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NOTIFICATION_PROFILE"]) {
        ProfileViewController *control=segue.destinationViewController;
        control.TOCKEN=TOKEN;
        control.USER_ID=USER_ID;
        control.NOTIF_RESET_FLAG=1;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"RESET" forKey:@"notif"];
        [defaults synchronize];
    }
    else if ([segue.identifier isEqualToString:@"NOTIF_DETAIL"]) {
        DetailFeedViewController *control=segue.destinationViewController;
        control.TOKEN=TOKEN;
        control.USER_ID=USER_ID;
        control.Post_id=POST_ID;
        control.NOTIF_FLAG=1;
    }
}


- (IBAction)BACK_ACTION:(id)sender
{
    [self performSegueWithIdentifier:@"NOTIFICATION_PROFILE" sender:self];
}

- (IBAction)public_prof_back:(id)sender
{
    public_profile_view.hidden=YES;
    
    notif_table_view.userInteractionEnabled=YES;
    
    [self NOTIFICATION_FUNCTION];
}


-(void)NOTIFICATION_FUNCTION
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        if ([connectobj string_check:TOKEN]==true  &&[connectobj int_check:USER_ID]==true)
        {
            
            networkErrorView.hidden=YES;
            [self showPageLoader];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                                     target: self
                                                   selector: @selector(cancelURLConnection:)
                                                   userInfo: nil
                                                    repeats: NO];
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInt:0] forKey:@"page"];
            NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/notifications"];
            
            
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
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           NSLog(@"NOTIFICAT : %@",json);
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               
                                               total_row_count=[[json objectForKey:@"new_notification_count"]integerValue];
                                               notification_array=[json objectForKey:@"result"];
                                               NSLog(@"NOTIFICATIONS :%@",notification_array);
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [notif_table_view reloadData];
                                                 //  [self READ_STATUS_FUNCTION];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   no_notif_view.hidden=YES;
                                                   [notif_table_view setHidden:NO];
                                                   
                                                   
                                               });
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [timer invalidate];
                                                   no_notif_view.hidden=NO;
                                                   [notif_table_view setHidden:YES];
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
                                                   no_notif_view.hidden=YES;
                                                   [notif_table_view setHidden:NO];
                                                   
                                               });
                                               
                                               
                                           }
                                       }
                                       if (connectionError)
                                       {
                                           
                                           NSLog(@"error detected:%@", connectionError.localizedDescription);
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               no_notif_view.hidden=YES;
                                               [notif_table_view setHidden:NO];
                                              // [self alertStatus:@"Error in network connection"];
                                              // return ;
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
    }
}


-(void)NOTIFICATION_FUNCTION_PAGINATION
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        if ([connectobj string_check:TOKEN]==true  &&[connectobj int_check:USER_ID]==true)
        {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            
            networkErrorView.hidden=YES;
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInt:page_number] forKey:@"page"];
            NSString *url_str=[[connectobj value] stringByAppendingString:@"apiservices/notifications"];
            
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
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               
                                               notif_temp_array=[json objectForKey:@"result"];
                                               
                                               [notification_array addObjectsFromArray:notif_temp_array];
                                               
                                               //     NSLog(@"NOTIFICATIONS :%@",notification_array);
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [notif_table_view reloadData];
                                                   [self READ_STATUS_FUNCTION];
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   no_notif_view.hidden=YES;
                                                   [notif_table_view setHidden:NO];
                                                   [notif_table_view.infiniteScrollingView stopAnimating];
                                                   
                                                   
                                               });
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                 
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   [notif_table_view.infiniteScrollingView stopAnimating];
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
                                                   [notif_table_view.infiniteScrollingView stopAnimating];
                                                   
                                                   
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


- (void) alertStatus:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}


-(void)cancelURLConnection:(id)sender
{
    [queue cancelAllOperations];
    [HUD hide:YES];
    [self stopSpin];
    [timer invalidate];
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
- (void) startSpin
{
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
    
    if ([UIScreen mainScreen].bounds.size.height !=568)
    {
        user_name_bg_view.frame=CGRectMake(16, 40, 290, 400);
        user_names_table.frame=CGRectMake(14, 10, 262, 380);
    }
     [self NOTIFICATION_FUNCTION];
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
        notif_table_view.userInteractionEnabled=YES;
        [obj swipe_up:public_profile_view];
        
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
        notif_table_view.userInteractionEnabled=YES;
        [obj swipe_down:public_profile_view];
        
    }
}

@end
