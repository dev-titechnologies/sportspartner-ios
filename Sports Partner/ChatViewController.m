//
//  ChatViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 13/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "ChatViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "ViewController.h"
#import "ViewController.h"
#import "Public_Profile_ViewController.h"
#import "SearchViewController.h"
#import "SVPullToRefresh.h"
@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize USER_ID,TOKEN,RECEIVER_ID,conversation_id,URL_STRING,PUBLIC_PROFILE_FLAG,SEARCH_FLAG;
#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    style=[[Styles alloc]init];
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];
    
    header_view.backgroundColor=[style colorWithHexString:@"042e5f"];
    
    NSLog(@"Chat page");
    
    page_number=0;
    __weak ChatViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(insertRowAtTop) withObject:nil afterDelay:1.0];
    }];
    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"follower_bg.png"]];
   
    no_msg_label.font=[UIFont fontWithName:@"Roboto-Regular" size:18];
    
    connectobj=[[connection alloc]init];
    sqlfunction=[[SQLFunction alloc]init];
    self.delegate = self;
    self.dataSource = self;
    _message_array=[[NSMutableArray alloc]init];
    self.title = @"Messages";
    self.messages=[[NSMutableArray alloc]init];
    self.timestamps=[[NSMutableArray alloc]init];
    [self.view addSubview:header_view];
    header_label.font=[UIFont fontWithName:@"Roboto-Regular" size:23];
    header_label.textColor=[UIColor whiteColor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
       
        style=[[Styles alloc]init];
        [sqlfunction loadUserDetailsTable];
        NSMutableDictionary *dict_user=[sqlfunction searchUserDetailsTable:USER_ID];
        receiver_image=[UIImage imageWithData:[dict_user objectForKey:@"image_data"]];
        });
    
  [self MESSAGE_LISTING];
    
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MESSAGE_LISTING_PUSH) name:@"pushchatmessage" object:nil];


}
- (void)insertRowAtTop
{
   
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            BOOL netStatus = [connectobj checkNetwork];
            if(netStatus == true)
            {
                page_number=page_number+1;
                
                [self MESSAGE_LISTING_PAGINATION];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
              
                
            });
        });
    
}


-(void)MESSAGE_LISTING
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
    networkErrorView.hidden=YES;
    [HUD hide:YES];
    [self stopSpin];
    [self showPageLoader];
        
          if ([connectobj string_check:TOKEN]==true &&[connectobj string_check:RECEIVER_ID]==true && [connectobj string_check:conversation_id]==true &&[connectobj int_check:USER_ID]==true)
        {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                self.messages=[[NSMutableArray alloc]init];
                timer = [NSTimer scheduledTimerWithTimeInterval: 7.0
                                                         target: self
                                                       selector: @selector(cancelURLConnection:)
                                                       userInfo: nil
                                                        repeats: NO];
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[RECEIVER_ID integerValue]] forKey:@"receiver_id"];
                [param setObject:[NSNumber numberWithInteger:[conversation_id integerValue]] forKey:@"conversation_id"];
                [param setObject:[NSNumber numberWithInt:0] forKey:@"page"];
                [param setObject:@"IOS" forKey:@"OS"];
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/messagedetails?"];
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
                                               
                                               
                                               NSLog(@"CHAT ARRAY IS : %@",json);
                                               
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               if(status==1)
                                               {
                                                   
                                                  total_row_count=[[json objectForKey:@"total_row_count"]integerValue];
                                                   
                                                   NSLog(@"URL STRING IS: %@", URL_STRING);
                                                   
                                                   if ([[NSString stringWithFormat:@"%@",URL_STRING] isEqualToString:@""])
                                                   {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           
                                                           sender_image=[UIImage imageNamed:@"noimage.png"];
                                                       });
                                                       
                                                   }
                                                   else
                                                   {
                                                       NSURL *image_url=[NSURL URLWithString:URL_STRING];
                                                       image_data=[NSData dataWithContentsOfURL:image_url];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           
                                                           sender_image=[UIImage imageWithData:image_data];
                                                           
                                                           
                                                       });
                                                   }
                                                   
                                                   _message_array=[[json objectForKey:@"results"]mutableCopy];
                                                    _message_array = [[[_message_array reverseObjectEnumerator] allObjects]mutableCopy];
                                                   for (int i=0; i<_message_array.count; i++)
                                                   {
                                                       [self.messages addObject:[[_message_array objectAtIndex:i]objectForKey:@"body"]];
                                                       
                                                       [self.timestamps addObject:[[_message_array objectAtIndex:i]objectForKey:@"time"]];
                                                   }
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       
                                                       [timer invalidate];
                                                       
                                                       
                                                       [self.tableView setHidden:NO];
                                                       [self.tableView reloadData];
                                                       NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
                                                       [self.tableView selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                       no_chat_view.hidden=YES;
                                                       
                                                   });
                                                   
                                                   
                                               }
                                               else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                                       [self presentViewController:view_control animated:YES completion:nil];
                                                   });
                                                   
                                               }
                                               else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [timer invalidate];
                                                       no_chat_view.hidden=NO;
                                                       [self.tableView setHidden:YES];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                   });
                                               }
                                               else
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [timer invalidate];
                                                       [self.tableView setHidden:NO];
                                                       no_chat_view.hidden=YES;
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
        [HUD hide:YES];
        [self stopSpin];

    }
}


-(void)MESSAGE_LISTING_PAGINATION
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
       
        networkErrorView.hidden=YES;
        [HUD hide:YES];
        [self stopSpin];
        
        
        if ([connectobj string_check:TOKEN]==true &&[connectobj string_check:RECEIVER_ID]==true && [connectobj string_check:conversation_id]==true &&[connectobj int_check:USER_ID]==true)
        {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
              //  _message_array=[[NSMutableArray alloc]init];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[RECEIVER_ID integerValue]] forKey:@"receiver_id"];
                [param setObject:[NSNumber numberWithInteger:[conversation_id integerValue]] forKey:@"conversation_id"];
                [param setObject:[NSNumber numberWithInt:page_number] forKey:@"page"];
                 [param setObject:@"IOS" forKey:@"OS"];
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/messagedetails?"];
                
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
                                                   
                                                   
                                                   if ([[NSString stringWithFormat:@"%@",URL_STRING] isEqualToString:@"0"])
                                                   {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           
                                                           sender_image=[UIImage imageNamed:@"noimage.png"];
                                                           
                                                           
                                                           // [self MESSAGE_LISTING];
                                                           
                                                       });
                                                       
                                                   }
                                                   else
                                                   {
                                                       //  [self showPageLoader];
                                                       NSURL *image_url=[NSURL URLWithString:URL_STRING];
                                                       image_data=[NSData dataWithContentsOfURL:image_url];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           
                                                           sender_image=[UIImage imageWithData:image_data];
                                                           
                                                           //[self MESSAGE_LISTING];
                                                           
                                                       });
                                                   }
                                                   message_temp_array=[[json objectForKey:@"results"]mutableCopy];
                                                   
                                                   _message_array = [[[_message_array reverseObjectEnumerator] allObjects]mutableCopy];
                                                   
                                                   [_message_array addObjectsFromArray:message_temp_array];
                                                   
                                                   self.messages = [[[self.messages reverseObjectEnumerator] allObjects]mutableCopy];
                                                   self.timestamps = [[[self.timestamps reverseObjectEnumerator] allObjects]mutableCopy];
                                                   
                                                   for (int i=0; i<message_temp_array.count; i++) {
                                                       [self.messages addObject:[[message_temp_array objectAtIndex:i]objectForKey:@"body"]];
                                                       
                                                       [self.timestamps addObject:[[message_temp_array objectAtIndex:i]objectForKey:@"time"]];
                                                   }
                                                   _message_array = [[[_message_array reverseObjectEnumerator] allObjects]mutableCopy];
                                                   self.messages = [[[self.messages reverseObjectEnumerator] allObjects]mutableCopy];
                                                   self.timestamps = [[[self.timestamps reverseObjectEnumerator] allObjects]mutableCopy];

                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       
                                                       [self.tableView setHidden:NO];
                                                       [self.tableView reloadData];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                       no_chat_view.hidden=YES;
                                                       [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                                                       [self.tableView.pullToRefreshView stopAnimating];
                                                       
                                                   });
                                                   
                                                   
                                               }
                                               else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                                       [self presentViewController:view_control animated:YES completion:nil];
                                                   });
                                                   
                                               }
                                               else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                        [self.tableView.pullToRefreshView stopAnimating];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                   });
                                                   
                                               }
                                               else
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [self.tableView.pullToRefreshView stopAnimating];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                   });
                                               }
                                           }
                                           if (connectionError)
                                           {
                                               
                                               NSLog(@"error detected:%@", connectionError.localizedDescription);
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                  [self.tableView.pullToRefreshView stopAnimating];
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
        [HUD hide:YES];
        [self stopSpin];
        
    }
}



-(void)MESSAGE_LISTING_PUSH
{
    NSLog(@"Message PUSH");
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        
        networkErrorView.hidden=YES;
        if ([connectobj string_check:TOKEN]==true &&[connectobj string_check:RECEIVER_ID]==true && [connectobj string_check:conversation_id]==true &&[connectobj int_check:USER_ID]==true)
        {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                [param setObject:[NSNumber numberWithInteger:[RECEIVER_ID integerValue]] forKey:@"receiver_id"];
                [param setObject:[NSNumber numberWithInteger:[conversation_id integerValue]] forKey:@"conversation_id"];
                [param setObject:[NSNumber numberWithInt:0] forKey:@"page"];
                [param setObject:@"IOS" forKey:@"OS"];
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/messagedetails?"];
                
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
                                                   
                                                   
                                                   if ([[NSString stringWithFormat:@"%@",URL_STRING] isEqualToString:@"0"])
                                                   {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           
                                                           sender_image=[UIImage imageNamed:@"noimage.png"];
                                                           
                                                           
                                                           // [self MESSAGE_LISTING];
                                                           
                                                       });
                                                       
                                                   }
                                                   else
                                                   {
                                                       //  [self showPageLoader];
                                                       NSURL *image_url=[NSURL URLWithString:URL_STRING];
                                                       image_data=[NSData dataWithContentsOfURL:image_url];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           
                                                           sender_image=[UIImage imageWithData:image_data];
                                                           
                                                           //[self MESSAGE_LISTING];
                                                           
                                                       });
                                                   }
                                                   
                                                   
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   [self showPageLoader];
                                                   
                                                   message_push_array=[[json objectForKey:@"results"]mutableCopy];
                                                   
                                                   [_message_array addObject:[message_push_array objectAtIndex:0]];
                                                   
                                                   if (message_push_array.count>0)
                                                   {
                                                       [self.messages addObject:[[message_push_array objectAtIndex:0]objectForKey:@"body"]];
                                                       
                                                       [self.timestamps addObject:[[message_push_array objectAtIndex:0]objectForKey:@"time"]];

                                                   }
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                       
                                                       [timer invalidate];
                                                       [self.tableView setHidden:NO];
                                                       [self.tableView reloadData];
                                                        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
                                                       [self.tableView selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                       no_chat_view.hidden=YES;
                                                   });
                                                   
                                               }
                                               else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                                       [self presentViewController:view_control animated:YES completion:nil];
                                                   });
                                                   
                                               }
                                               else if([[json objectForKey:@"message"] isEqualToString:@"No results"])
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [timer invalidate];
                                                       no_chat_view.hidden=NO;
                                                       [self.tableView setHidden:YES];
                                                       [HUD hide:YES];
                                                       [self stopSpin];
                                                   });
                                                   
                                               }
                                               else
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [timer invalidate];
                                                       [self.tableView setHidden:NO];
                                                       no_chat_view.hidden=YES;
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
                                                  // return ;
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
        [HUD hide:YES];
        [self stopSpin];
        
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



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"COUNT :%d",self.messages.count);
    return self.messages.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {

        networkErrorView.hidden=YES;
        if ([connectobj string_check:text]==false)
        {
            [self alertStatus:@"Please enter your message"];
            return;
        }
        
      else if ([connectobj string_check:TOKEN]==true &&[connectobj string_check:RECEIVER_ID]==true && [connectobj string_check:conversation_id]==true &&[connectobj int_check:USER_ID]==true)
            
        {
            [self showPageLoader];
            send_timer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                                          target: self
                                                        selector: @selector(cancelURLConnection_send:)
                                                        userInfo: nil
                                                         repeats: NO];
            
            
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:TOKEN forKey:@"token"];
            [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
            [param setObject:[NSNumber numberWithInteger:[RECEIVER_ID integerValue]] forKey:@"receiver_id"];
            [param setObject:[NSNumber numberWithInteger:[conversation_id integerValue]] forKey:@"conversation_id"];
            [param setObject:text forKey:@"message"];
            [param setObject:@"text" forKey:@"type"];
            [param setObject:@"IOS" forKey:@"OS"];
            NSLog(@"DIction :%@",param);
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/postmessage?"];
            
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
            
            send_queue = [[NSOperationQueue alloc] init];
            send_queue.maxConcurrentOperationCount=1;
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *connectionError) {
                                       
                                       NSLog(@"RESPONSE CHAT :%@",response);
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
                                           NSLog(@"CHAT SEND RESP:%@",json);
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               
                                               dict=[[NSMutableDictionary alloc]init];
                                               [dict setObject:text forKey:@"body"];
                                               [dict setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                                               [dict setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"receiver_id"];
                                               [dict mutableCopy];
                                               [_message_array mutableCopy];
                                               [_message_array addObject:dict];
                                               [self.messages addObject:text];
                                               NSDate *current_time = [NSDate date];
                                               NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                               [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
                                               [dateFormat setDateFormat:@"MMMM dd h:mm a"];
                                               [self.timestamps addObject:@"1 second ago"];
                                               
                                               if((self.messages.count - 1) % 2)
                                                   [JSMessageSoundEffect playMessageSentSound];
                                               else
                                                   [JSMessageSoundEffect playMessageReceivedSound];
                                               [self finishSend];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   CGRect tableFrame;
                                                   tableFrame = CGRectMake(0.0f, 0.0f, 320, 520);
                                                   if ([UIScreen mainScreen].bounds.size.height !=568)
                                                   {
                                                       tableFrame = CGRectMake(0.0f, 0.0f, 320, 440);
                                                   }

                                                   
                                                   self.tableView.frame = tableFrame;
                                                   self.tableView.contentInset=UIEdgeInsetsMake(60,0.0,0,0.0);
                                                   
                                                   [self.tableView setHidden:NO];
                                                   no_chat_view.hidden=YES;
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

-(void)cancelURLConnection_send:(id)sender
{
    [send_queue cancelAllOperations];
    [HUD hide:YES];
    [self stopSpin];
    [timer invalidate];
}


- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([[[_message_array objectAtIndex:indexPath.row]objectForKey:@"user_id"] intValue]==[[[_message_array objectAtIndex:indexPath.row]objectForKey:@"receiver_id"] intValue])
  {
       return  JSBubbleMessageTypeOutgoing;
    
  }
  else   {
    
        return JSBubbleMessageTypeIncoming;
  }
    return NO;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyAll;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleSquare;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

- (UIImage *)avatarImageForIncomingMessage
{
   
    return sender_image;
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return receiver_image;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CHAT_PUBLIC"])
    {
        Public_Profile_ViewController *controller=segue.destinationViewController;
        controller.CHAT_FLAG=1;
    }
    if ([segue.identifier isEqualToString:@"CHAT_SEARCH"])
    {
        NSLog(@"CHAT_SEARCH");
        SearchViewController *search_controller=segue.destinationViewController;
        search_controller.CHAT_FLAG=SEARCH_FLAG;
        search_controller.USER_ID=USER_ID;
        search_controller.TOKEN=TOKEN;
    }
    
}


- (IBAction)BACK_ACTION:(id)sender
{
    if (PUBLIC_PROFILE_FLAG==1)
    {
        [self performSegueWithIdentifier:@"CHAT_PUBLIC" sender:self];
    }
    else if (SEARCH_FLAG==1 || SEARCH_FLAG==2)
    {
         [self performSegueWithIdentifier:@"CHAT_SEARCH" sender:self];
    }
    else
    {
     [self performSegueWithIdentifier:@"CHAT_MESSAGE" sender:self];
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
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
