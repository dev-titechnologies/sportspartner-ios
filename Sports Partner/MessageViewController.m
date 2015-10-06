//
//  MessageViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 07/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//
#import "SportsCell.h"
#import "MessageViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "MessageCell.h"
#import "ProfileViewController.h"
#import "ChatViewController.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "SVPullToRefresh.h"
@interface MessageViewController ()

@end

@implementation MessageViewController
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

    
    
    __weak MessageViewController *weakSelf = self;
    
    
    [message_table_view addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(insertRowAtBottom) withObject:nil afterDelay:1.0];
    }];
    
    page_number=0;

    
    
    cache = [[NSCache alloc]init];
    [cache setObject:@"Ardra" forKey:@"url"];
    NSLog(@"Cache %@",[cache objectForKey:@"url"]);
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MESSAGE_LISTING) name:@"pushmessage" object:nil];
    connectobj=[[connection alloc]init];
    
    
   // self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"follower_bg.png"]];
    message_table_view.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"follower_bg.png"]];
    
     //header_view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"320x60.png"]];
    header_label.font=[UIFont fontWithName:@"Roboto-Regular" size:23];
    header_label.textColor=[UIColor whiteColor];
    message_array=[[NSMutableArray alloc]init];
    
    
    
    UILongPressGestureRecognizer *longPressRecognizer =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 1;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:longPressRecognizer];
    no_msg_label.font=[UIFont fontWithName:@"Roboto-Regular" size:18];

}


- (void)insertRowAtBottom
{
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            
            if (total_row_count>message_array.count)
            {
                page_number=page_number+1;
                
                [self MESSAGE_LISTING_PAGINATION];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    NSLog(@" LESS THAN PAGINATIOn ");
                    [message_table_view.infiniteScrollingView stopAnimating];
                    
                });

            }
         
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
    });
    
    
}


-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:message_table_view];
    
    indexPath_longpress = [message_table_view indexPathForRowAtPoint:p];
    if(UIGestureRecognizerStateBegan == gestureRecognizer.state)
    {
        NSString *cancelTitle = @"Cancel";
        NSString *delete=@"Delete Message";
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:cancelTitle
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:delete, nil];
        actionSheet.delegate=self;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        [actionSheet showInView:self.view];

    }
    
    if(UIGestureRecognizerStateChanged == gestureRecognizer.state) {
        // Do repeated work here (repeats continuously) while finger is down
    }
    
    if(UIGestureRecognizerStateEnded == gestureRecognizer.state) {
        // Do end work here when finger is lifted
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if([buttonTitle isEqualToString:@"Delete Message"])
        {
            BOOL netStatus = [connectobj checkNetwork];
            if(netStatus == true)
            {
                NSLog(@"IN DELETE FUNCTION");
                networkErrorView.hidden=YES;
                [self showPageLoader];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[[[message_array objectAtIndex:indexPath_longpress.row]objectForKey:@"conversation_id"] integerValue]] forKey:@"conversation_id"];
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/deleteconversation?"];
                
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
                                               NSLog(@"RESPONSE DEL :%@",response);
                                               NSDictionary *json =
                                               [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
                                               NSLog(@"DIC DELETE IS :%@",json);
                                               
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               if(status==1)
                                               {
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   [self MESSAGE_LISTING];
                                                  
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
                                                     [self alertStatus:@"Error in network connection"];
                                                   return ;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"MESSAGE_TO_PROFILE"])
    {
        ProfileViewController *profile_control=segue.destinationViewController;
        profile_control.TOCKEN=TOKEN;
        profile_control.USER_ID=USER_ID;
    }
    else if ([segue.identifier isEqualToString:@"MESSAGE_CHAT"])
    {
        ChatViewController *chatcontroller=segue.destinationViewController;
        chatcontroller.USER_ID=USER_ID;
        chatcontroller.TOKEN=TOKEN;
        chatcontroller.conversation_id=conversation_id;
        chatcontroller.RECEIVER_ID=receiver_id;
        chatcontroller.URL_STRING=image_string;
    }
   
}

-(void)MESSAGE_LISTING
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
       
        if ([connectobj string_check:TOKEN]==true &&[connectobj int_check:USER_ID]==true)
        {
            message_array=[[NSMutableArray alloc]init];
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
            [param setObject:[NSNumber numberWithInt:0] forKey:@"limit"];
            
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/messagelist?"];
            
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
                                           
                                           NSLog(@"MESSAGE LIST : %@",json);
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               
                                               message_array=[json objectForKey:@"results"];
                                               total_row_count=[[json objectForKey:@"total_row_count"]integerValue];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   [message_table_view reloadData];
                                                   no_message_view.hidden=YES;
                                                   [message_table_view setHidden:NO];
                                                   
                                               });
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [timer invalidate];
                                                   no_message_view.hidden=NO;
                                                   [message_table_view setHidden:YES];
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
                                                   no_message_view.hidden=YES;
                                                   [message_table_view setHidden:NO];
                                                   [message_table_view reloadData];
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
                                             //  return ;
                                               
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

-(void)MESSAGE_LISTING_PAGINATION
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
        if ([connectobj string_check:TOKEN]==true &&[connectobj int_check:USER_ID]==true)
        {
            
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInt:page_number] forKey:@"limit"];
            
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/messagelist?"];
            
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
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               
                                               message_temp_array=[json objectForKey:@"results"];
                                               [message_array addObjectsFromArray:message_temp_array];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   [message_table_view reloadData];
                                                   no_message_view.hidden=YES;
                                                   [message_table_view setHidden:NO];
                                               });
                                           }
                                           else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   
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

#pragma TABLEVIEW SECTION

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return message_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CELLIDENTIFIER=@"CELL";
    MessageCell *message_cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
   /////// CELL DESIGN ///////
    
 //   message_cell.backgroundColor=[UIColor clearColor];
    message_cell.Name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    message_cell.profile_pic.contentMode=UIViewContentModeScaleAspectFill;
    message_cell.profile_pic.clipsToBounds=YES;

    message_cell.profile_pic.layer.cornerRadius=35.0;
    message_cell.profile_pic.layer.masksToBounds=YES;
    message_cell.Name_label.textColor=[style colorWithHexString:message_view_display_name_color];
    message_cell.Message_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    message_cell.time_label.font=[UIFont fontWithName:@"Roboto-Regular" size:11];
    message_cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //////////// Cell Content ////////
    
    
    message_cell.time_label.text=[[message_array objectAtIndex:indexPath.row]objectForKey:@"time"];
    message_cell.Name_label.text=[[[message_array objectAtIndex:indexPath.row]objectForKey:@"name"] capitalizedString];
    message_cell.Message_label.text=[[message_array objectAtIndex:indexPath.row]objectForKey:@"message_text"];
    
    if ([[NSString stringWithFormat:@"%@",[[message_array objectAtIndex:indexPath.row]objectForKey:@"inbox_read"]] isEqualToString:@"0"])
    {
        message_cell.backgroundColor=[style colorWithHexString:@"D1EEFC"];
    }
    else if ([[NSString stringWithFormat:@"%@",[[message_array objectAtIndex:indexPath.row]objectForKey:@"inbox_read"]] isEqualToString:@"1"])
    {
        message_cell.backgroundColor=[UIColor clearColor];
    }

    
    if ([[NSString stringWithFormat:@"%@",[[message_array objectAtIndex:indexPath.row]objectForKey:@"prof_pic"]] isEqualToString:@"0"])
    {
          message_cell.profile_pic.image=[UIImage imageNamed:@"noimage.png"];
    }
    else
    {
        image_url=[NSURL URLWithString:[[message_array objectAtIndex:indexPath.row]objectForKey:@"prof_pic"]];
        [message_cell.profile_pic setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"noimage"]];
    }
    
    return message_cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    image_string=[[message_array objectAtIndex:indexPath.row]objectForKey:@"prof_pic"];
    conversation_id=[[message_array objectAtIndex:indexPath.row]objectForKey:@"conversation_id"];
    receiver_id=[[message_array objectAtIndex:indexPath.row]objectForKey:@"user_id_sender"];
    [self performSegueWithIdentifier:@"MESSAGE_CHAT" sender:self];
}

- (IBAction)BACK_ACTION:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
   // [self performSegueWithIdentifier:@"MESSAGE_TO_PROFILE" sender:self];
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
    NSLog(@"ViewDIDAPPEAR MESSAGE");
    
     NSLog(@"Cache %@",[cache objectForKey:@"url"]);
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
    
    [self MESSAGE_LISTING];
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



@end
