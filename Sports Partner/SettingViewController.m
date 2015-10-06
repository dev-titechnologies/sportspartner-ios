//
//  SettingViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 08/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "SettingViewController.h"
#import "ViewController.h"
#define SCROLLVIEW_CONTENT_HEIGHT 568
#define SCROLLVIEW_CONTENT_WIDTH  320

#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize TOCKEN,USER_ID;
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
    
    
    self.screenName=@"Sp Settings Screen";
    style=[[Styles alloc]init];
    connectobj=[[connection alloc]init];
    /////////// TABBAR///////////////////////////
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];
    
    header_bg_view.backgroundColor=[style colorWithHexString:@"042e5f"];
    
    
    CGSize tabBarSize = [tabbar frame].size;
    UIView	*tabBarFakeView = [[UIView alloc] initWithFrame:
                               CGRectMake(0,0,tabBarSize.width, tabBarSize.height)];
    [tabbar insertSubview:tabBarFakeView atIndex:0];
    
    [tabBarFakeView setBackgroundColor:[style colorWithHexString:@"f2e7ea"]];
    tabbar_border_label.backgroundColor=[style colorWithHexString:@"e80243"];
    
    tabbar.translucent=YES;
    
    [tabbar setSelectedItem:[tabbar.items objectAtIndex:4]];
 
    old_password_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Old Password" attributes:@{NSForegroundColorAttributeName: [style colorWithHexString:@"92BCD0"]}];
    old_password_field.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
    new_password_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    old_password_field.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
    confirm_password_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: [style colorWithHexString:@"92BCD0"]}];
    old_password_field.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
    view1.backgroundColor=[style colorWithHexString:settings_border_color];
   
    
 //   header_bg_view.backgroundColor=[style colorWithHexString:@"E0DFE0"];
    header_label.font=[UIFont fontWithName:@"Roboto-Regular" size:23];
    header_label.textColor=[UIColor whiteColor];
     [save_button setBackgroundImage:[UIImage imageNamed:@"save-hover - final@2x.png"] forState:UIControlStateHighlighted];
    [save_button setBackgroundImage:[UIImage imageNamed:@"save - final@2x.png"] forState:UIControlStateNormal];
    [self setupAlerts];
    
    /////////// LOCAL DB ////////////
    
    sqlfunction=[[SQLFunction alloc]init];
    [sqlfunction loadLoginSqlLiteDB];
    
    ///////////// HEADER SECTION /////////////////
    
    logout_button.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
    [logout_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [save_button addTarget:self action:@selector(TOUCH_INSIDE :) forControlEvents:UIControlEventTouchDown];
    [save_button addTarget:self action:@selector(TOUCH_REMOVE :) forControlEvents:UIControlEventTouchUpInside];
    
    [logout_button addTarget:self action:@selector(TOUCH_INSIDE_LOGOUT :) forControlEvents:UIControlEventTouchDown];
    [logout_button addTarget:self action:@selector(TOUCH_REMOVE_LOGOUT :) forControlEvents:UIControlEventTouchUpInside];
     [logout_button setBackgroundImage:[UIImage imageNamed:@"logout- final@2x.png"] forState:UIControlStateNormal];
     [logout_button setBackgroundImage:[UIImage imageNamed:@"logout-hover - final@2x.png"] forState:UIControlStateHighlighted];

}

-(void)TOUCH_INSIDE :(id)sender
{
    NSLog(@"TOUCH INSIDE");
    //save_button.frame=CGRectMake(0, 226, 330, 100);
}
-(void)TOUCH_REMOVE :(id)sender
{
    NSLog(@"TOUCH CANCEl");
   // save_button.frame=CGRectMake(25, 251, 270, 51);
}

-(void)TOUCH_INSIDE_LOGOUT :(id)sender
{
    NSLog(@"TOUCH INSIDE");
   // logout_button.frame=CGRectMake(-5, 288, 330, 100);
    
}
-(void)TOUCH_REMOVE_LOGOUT :(id)sender
{
    NSLog(@"TOUCH CANCEl");
     //logout_button.frame=CGRectMake(25, 314, 270, 51);
}


-(void)setupAlerts
{
    
    [old_password_field addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [new_password_field addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [confirm_password_field addConfirmValidationTo:new_password_field withMsg:@"Confirm password didn't match."];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SETTINGS_FEED"])
    {
        FeedViewController *feedcontrol=segue.destinationViewController;
        feedcontrol.TOCKEN=TOCKEN;
        feedcontrol.USER_ID=USER_ID;
    }
    else if ([segue.identifier isEqualToString:@"SETTINGS_PROFILE"])
    {
        ProfileViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOCKEN=TOCKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"SETTINGS_FOLLOWER"])
    {
        FollowerViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOKEN=TOCKEN;
        
    }
    else if ([segue.identifier isEqualToString:@"SETTINGS_SEARCH"])
    {
        SearchViewController *msgcontrol=segue.destinationViewController;
        msgcontrol.USER_ID=USER_ID;
        msgcontrol.TOKEN=TOCKEN;
    }

}


#pragma TABBAR FUNCTION


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag)
    {
        case 0:
            [self performSegueWithIdentifier:@"SETTINGS_FEED" sender:self];
            
            break;
        case 1:
             [self performSegueWithIdentifier:@"SETTINGS_PROFILE" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"SETTINGS_SEARCH" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"SETTINGS_FOLLOWER" sender:self];
            break;
        case 4:
            break;
            
        default:
            break;
    }
}

- (IBAction)SAVE_BUTTON_ACTION:(id)sender
{
    
    
    if (![new_password_field validate])
    {
        new_password_field.text=@"";
//        save_button.frame=CGRectMake(25, 251, 270, 51);
//        [save_button setBackgroundImage:[UIImage imageNamed:@"normal_save.png"] forState:UIControlStateNormal];

        
    }
    if([new_password_field validate])
    {
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            networkErrorView.hidden=YES;
            [self showPageLoader];

            timer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                                     target: self
                                                   selector: @selector(cancelURLConnection:)
                                                   userInfo: nil
                                                    repeats: NO];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:TOCKEN forKey:@"token"];
        [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
        [param setObject:[new_password_field text] forKey:@"new_pass"];
        
        NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/changepassword?"];
        
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
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           
                                           [save_button setBackgroundImage:[UIImage imageNamed:@"save - final@2x.png"] forState:UIControlStateNormal];
                                           
                                           [HUD hide:YES];
                                           [self stopSpin];
                                          
                                           [old_password_field resignFirstResponder];
                                           [new_password_field resignFirstResponder];
                                           [confirm_password_field resignFirstResponder];
                                            new_password_field.text=@"";
                                           [self alertStatus:@"Your Password has been changed successfully"];
                                           return ;
                                       });
                                       
                                   }
                                   else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                           [self presentViewController:view_control animated:YES completion:nil];
                                       });

                                   }
                                   else if([[json objectForKey:@"message"] isEqualToString:@"Password mismatch"])
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           
                                           
                                           old_password_field.text=@"";
                                           [old_password_field resignFirstResponder];
                                           [new_password_field resignFirstResponder];
                                           [confirm_password_field resignFirstResponder];
                                           [HUD hide:YES];
                                           [self stopSpin];
                                           [self alertStatus:@"Incorrect password"];
                                           return ;
                                           
                                       });
                                                                              
                                   }

                                   else
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           
                                           [HUD hide:YES];
                                           [self stopSpin];
                                           [old_password_field resignFirstResponder];
                                           [new_password_field resignFirstResponder];
                                           [confirm_password_field resignFirstResponder];
                                           
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
                                   if (connectionError)
                                   {
                                       
                                       NSLog(@"error detected:%@", connectionError.localizedDescription);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [HUD hide:YES];
                                           [self stopSpin];
//                                           [self alertStatus:@"Error in network connection"];
//                                           return ;

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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Go to Settings"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    else if([title isEqualToString:@"Ok"])
    {
        
    }
    
    
    // do whatever you want to do with this UITextField.
}

- (IBAction)LOGOUT:(id)sender
{
   
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
     
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *device_token = [defaults objectForKey:@"devicetoken"];

        
        if ([device_token isEqualToString:@""] || device_token==nil || [device_token isEqual:[NSNull null]])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please turn on your Push Notifications to allow Sports Partners find people near you for sports and fitness" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Go to Settings", nil];
            [alert show];
            return;
        }
        else
        {
        [self showPageLoader];
        
        NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
        
        [param setObject:device_token forKey:@"deviceID"];
        NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/logout?"];
        
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
                                       [HUD setHidden:YES];
                                       [self stopSpin];
                                   }
                                   else
                                   {
                                       NSLog(@"RESPONSE :%@",response);
                                       NSDictionary *json =
                                       [NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions
                                                                         error:nil];
                                       NSLog(@"DIC is :%@",json);
                                       
                                       NSInteger status=[[json objectForKey:@"status"] intValue];
                                       
                                       if(status==1)
                                       {
                                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                           [defaults setObject:@"NO" forKey:@"user_accept"];
                                           [defaults synchronize];
                                           
                                           NSUserDefaults *defaults_zip = [NSUserDefaults standardUserDefaults];
                                           [defaults_zip setObject:@"" forKey:@"zip"];
                                           [defaults_zip synchronize];
                                           
                                               ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                               [self presentViewController:view_control animated:YES completion:nil];
                                               [sqlfunction loadLoginSqlLiteDB];
                                               [sqlfunction DELETE_ALL_LOGIN_DATA];
                                               [HUD hide:YES];
                                               [self stopSpin];
                                           
                                          
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
                                           

                                   }
                               }];
        }
    }
    else
    {
        [HUD hide:YES];
        [self stopSpin];
    }
    
}

-(void)cancelURLConnection_logout:(id)sender
{
    [logout_queue cancelAllOperations];
    [HUD hide:YES];
    [self stopSpin];
    [timer invalidate];
}



- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    
	NSLog(@"Registering for keyboard events");
	
	// Register for the events
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector (keyboardDidShow:)
	 name: UIKeyboardDidShowNotification
	 object:nil];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector (keyboardDidHide:)
	 name: UIKeyboardDidHideNotification
	 object:nil];
	
	scrollview.contentSize = CGSizeMake(320,499);
	keyboardVisible = NO;
    
    if([[UIScreen mainScreen]bounds].size.height ==480)
    {
        NSLog(@"IN SI 3.5");
        scrollview.frame = CGRectMake(0, 20, 320, 410);
        scrollview.contentSize = CGSizeMake(320,410);
        tabbar_border_label.frame=CGRectMake(0, 430, 320,1);
        
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
	NSLog (@"Unregister for keyboard events");
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self];
}

-(void) keyboardDidShow: (NSNotification *)notif {
	NSLog(@"Keyboard is visible");
	// If keyboard is visible, return
	if (keyboardVisible) {
		NSLog(@"Keyboard is already visible. Ignore notification.");
		return;
	}
	
	// Get the size of the keyboard.
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	// Save the current location so we can restore
	// when keyboard is dismissed
	offset = scrollview.contentOffset;
	
	// Resize the scroll view to make room for the keyboard
	CGRect viewFrame = scrollview.frame;
	
	
    
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        backview.frame=CGRectMake(0, 40, 320, 500);
        viewFrame.size.height -= keyboardSize.height-160;
    }
    else
    {
        backview.frame=CGRectMake(0, 46, 320, 570);
        viewFrame.size.height -= keyboardSize.height-130;
    }
    scrollview.frame = viewFrame;
    [scrollview addSubview:backview];
	CGRect textFieldRect = [activeField frame];
	textFieldRect.origin.y += 130;
    NSLog(@"size :%f",textFieldRect.origin.y);
	[scrollview scrollRectToVisible:textFieldRect animated:YES];
//    scrollview.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH,
//                                        SCROLLVIEW_CONTENT_HEIGHT);

    if([[UIScreen mainScreen]bounds].size.height !=568)
    {
        NSLog(@"IN SI 3.5");
        scrollview.contentSize = CGSizeMake(320,
                                            450);
    }
    
	NSLog(@"ao fim");
	// Keyboard is now visible
	keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
	// Is the keyboard already shown
	if (!keyboardVisible) {
		NSLog(@"Keyboard is already hidden. Ignore notification.");
		return;
	}
	
	scrollview.frame = CGRectMake(0, 20, 320, 499);
     backview.frame=CGRectMake(0, 46, 320, 460);
    scrollview.contentSize = CGSizeMake(320,499);
    scrollview.contentOffset = offset;
    if([[UIScreen mainScreen]bounds].size.height !=568)
    {
        NSLog(@"IN SI 3.5");
        scrollview.frame = CGRectMake(0, 20, 320, 410);
        scrollview.contentSize = CGSizeMake(320,410);
    }
	
	// Reset the scrollview to previous location
	
	
	// Keyboard is no longer visible
	keyboardVisible = NO;
	
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField
{
  //
    //save_button.frame=CGRectMake(25, 251, 270, 51);
   // [save_button setBackgroundImage:[UIImage imageNamed:@"normal_save.png"] forState:UIControlStateNormal];
    activeField = textField;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
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
