//
//  ViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 04/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "ViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "Public_Profile_ViewController.h"
#import "Sign_Up_ViewController.h"
#import "FeedViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName=@"Initial View";
    style=[[Styles alloc]init];
    connectobj_1=[[connection alloc]init];
    sqlfunction_1=[[SQLFunction alloc]init];
    
       //////////// FaceBook Sign In Button /////////
    UIFont *custom_font=[UIFont fontWithName:@"Roboto-Thin" size:12];
    copyright.font=custom_font;
    sign_in_mask = [[CAShapeLayer alloc] init];
    sign_in_mask.frame = sign_in_button.bounds;
    sign_in_mask.path = [self UIBUTTON_Corner:sign_in_button].CGPath;
    sign_in_mask.fillColor=[style colorWithHexString:sign_in_selected_color].CGColor;
    sign_in_mask.shadowOpacity=0.0;
    [sign_in_button.layer addSublayer:sign_in_mask];
    [sign_in_button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    
    
    sign_in_f_mask = [[CAShapeLayer alloc] init];
    sign_in_f_mask.frame = sign_in_facebook_button.bounds;
    sign_in_f_mask.path = [self F_button_Corner:sign_in_facebook_button].CGPath;
    sign_in_f_mask.fillColor=[style colorWithHexString:sign_in_selected_color].CGColor;
    sign_in_f_mask.shadowOpacity=0.0;
    [sign_in_facebook_button.layer addSublayer:sign_in_f_mask];
    [sign_in_facebook_button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
   
   
    
    
    ///////// SIGN_UP//////////////


    sign_up_mask = [[CAShapeLayer alloc] init];
    sign_up_mask.frame = sign_in_button.bounds;
    sign_up_mask.path = [self UIBUTTON_Corner:sign_up_button].CGPath;
    sign_up_mask.fillColor=[style colorWithHexString:sign_in_selected_color].CGColor;
    sign_up_mask.shadowOpacity=0.0;
    [sign_up_button.layer addSublayer:sign_up_mask];
    [sign_up_button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    
    
    sign_up_f_mask = [[CAShapeLayer alloc] init];
    sign_up_f_mask.frame = sign_in_facebook_button.bounds;
    sign_up_f_mask.path = [self F_button_Corner:sign_up_f_button].CGPath;
    sign_up_f_mask.fillColor=[style colorWithHexString:sign_in_selected_color].CGColor;
    sign_up_f_mask.shadowOpacity=0.0;
    [sign_up_f_button.layer addSublayer:sign_up_f_mask];
    [sign_up_f_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sign_up_f_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    [sign_up_f_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-facebook"] forState:UIControlStateNormal];
   
///////// TERMS_OF_SERVICE////////////////
    
    
    [terms_of_service setTitleColor:[style colorWithHexString:terms_of_services_color] forState:UIControlStateNormal];
    terms_view.backgroundColor=[style colorWithHexString:terms_of_services_color];
    
    terms_bg_view.layer.cornerRadius=4.0;
    terms_bg_view.layer.masksToBounds=YES;
    terms_text_view.font=[UIFont fontWithName:@"Roboto-Thin" size:12];
    terms_label.font=[UIFont fontWithName:@"Roboto-Regular" size:18];
    FB_FLAG_1 = 0;
    [sqlfunction_1 loadLoginSqlLiteDB];
    
    
}

#pragma CAShapeLayer FUNCTIONS

-(UIBezierPath *)UIBUTTON_Corner:(UIButton*)button
{
    UIBezierPath *usernameMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                                        byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight)
                                                                              cornerRadii:CGSizeMake(5.0, 5.0)];
    return usernameMaskPathWithRadiusTop;
}

-(UIBezierPath *)F_button_Corner:(UIButton *)button
{
    UIBezierPath *username_imageMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft)
                                                                                    cornerRadii:CGSizeMake(5.0, 5.0)];
    return username_imageMaskPathWithRadiusTop;
    
    
}

	
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close_button:(id)sender
{
    terms_bg_view.hidden=YES;
}

- (IBAction)Sign_in_action:(id)sender
{
    /*[sign_in_button setTitle:@"Sign In" forState:UIControlStateReserved];
    [sign_in_button setTitleColor:[UIColor redColor
                                   ] forState:UIControlStateReserved];
    [sign_in_mask removeFromSuperlayer];
    sign_in_mask.fillColor=[style colorWithHexString:sign_in_deselected_color].CGColor;
    [sign_in_button.layer addSublayer:sign_in_mask];
    
    
   */
   [self performSegueWithIdentifier:@"SIGNIN_ID" sender:self];
}

- (IBAction)TERMS_ACTION:(id)sender
{
    
    
    terms_bg_view.hidden=NO;
    
}
- (IBAction)Sign_up_action:(id)sender
{
    
   /* [sign_in_f_mask removeFromSuperlayer];
    sign_in_f_mask.fillColor=[style colorWithHexString:sign_in_deselected_color].CGColor;
    [sign_in_facebook_button.layer addSublayer:sign_in_f_mask];
    */
    [self performSegueWithIdentifier:@"SIGN_UP_ID" sender:self];
}

- (IBAction)fb_connect_action:(id)sender
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        // [FBSession.activeSession closeAndClearTokenInformation];
        NSLog(@"SESSION IN (M");
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_birthday",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             [self sessionStateChanged:session state:state error:error];
         }];
        
        
        // If the session state is not any of the two "open" states when the button is clicked
    }
    else {
        NSLog(@"SESSION OPOP (M");
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_birthday",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             [self sessionStateChanged:session state:state error:error];
         }];
        
        
    }


}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        
            [FBRequestConnection startWithGraphPath:@"/me"
                                         parameters:nil
                                         HTTPMethod:@"GET"
                                  completionHandler:^(
                                                      FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error
                                                      ) {
                                      /* handle the result */
                                      if (![result isEqual:[NSNull null]])
                                      {
                                    
                                          
                                              BOOL netStatus = [connectobj_1 checkNetwork];
                                              if(netStatus == true)
                                              {
                                                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                  
                                                  NSString *device_token = [defaults objectForKey:@"devicetoken"];
                                                  NSLog(@"DEVT:%@",device_token);
                                                  networkErrorView_1.hidden=YES;
                                                  [self showPageLoader];
                                                  if ([[result objectForKey:@"email"] isEqualToString:@""]|| [[result objectForKey:@"email"] isEqual:[NSNull null]] || [result objectForKey:@"email"]==NULL)
                                                  {
                                                      NSLog(@"EMAIL IS NIL");
                                                      [HUD_1 hide:YES];
                                                      [self stopSpin];
                                                      [self alertStatus:@"Failed to get your email id"];
                                                      return ;
                                                  }
                                                  else
                                                  {
                                                      
                                                      if ([device_token isEqualToString:@""] || device_token==nil || [device_token isEqual:[NSNull null]])
                                                      {
                                                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please turn on your Push Notifications to allow Sports Partners find people near you for sports and fitness" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Go to Settings", nil];
                                                          [alert show];
                                                          return;
                                                      }
                                                      else
                                                      
                                            {
                                                
                                                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                                                  [param setObject:[result objectForKey:@"email"] forKey:@"email"];
                                                  [param setObject:[NSNumber numberWithInteger:1] forKey:@"fblogin"];
                                                  [param setObject:@"" forKey:@"password"];
                                                  [param setObject:device_token forKey:@"deviceID"];
                                                  [param setObject:@"IOS" forKey:@"deviceOS"];
                                                  
                                                  NSString *url_str=[ [connectobj_1 value] stringByAppendingString:@"apiservices/login?"];
                                                  
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
                                                                                 [HUD_1 hide:YES];
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
                                                                                     [FBSession.activeSession closeAndClearTokenInformation];
                                                                                     USER_ID_1=[[json objectForKey:@"user_id"]intValue];
                                                                                     TOCKEN_1=[json objectForKey:@"token"];
                                                                                     NSLog(@"TOKEnlooo :%@",TOCKEN_1);
                                                                                       [sqlfunction_1 SaveToLogintable:[[json objectForKey:@"user_id"]intValue] tokenValue:[json objectForKey:@"token"] tokenStatus:[json objectForKey:@"status"] user_name:[result objectForKey:@"email"] password:@""];
                                                                                     [HUD_1 hide:YES];
                                                                                     [self stopSpin];
                                                                                     [self performSegueWithIdentifier:@"VIEWCONTROLL_FEED" sender:self];
                                                                                 }
                                                                                 else if ([[json objectForKey:@"message"] isEqualToString:@"Failed.Check the email entered"])
                                                                                 {
                                                                                     NSLog(@"NOT REGISTER");
                                                                                     FB_FLAG_1=1;
                                                                                     [self performSegueWithIdentifier:@"SIGN_UP_ID" sender:self];
                                                                                     [HUD_1 hide:YES];
                                                                                     [self stopSpin];
                                                                                 }
                                                                                 
                                                                                 else
                                                                                 {
                                                                                     [HUD_1 hide:YES];
                                                                                     [self stopSpin];
                                                                                     FB_FLAG_1=1;
                                                                                     [self performSegueWithIdentifier:@"SIGN_UP_ID" sender:self];
                                                                                     [self alertStatus:[json objectForKey:@"message"]];
                                                                                     return ;
                                                                                 }
                                                                             }
                                                                             if (connectionError)
                                                                             {
                                                                                 
                                                                                 NSLog(@"error detected:%@", connectionError.localizedDescription);
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                                     [HUD_1 hide:YES];
                                                                                     [self stopSpin];
                                                                                 });
                                                                                 
                                                                             }
                                                                         }];
                                                  }
                                                  }
                                                  
                                              }
                                              else
                                              {
                                                  NSLog(@"NONET");
                                                  networkErrorView_1.hidden=NO;
                                                  [HUD_1 hide:YES];
                                                  [self stopSpin];
                                                  
                                              }
                                          
                                      }
                                      
                                  }];
 
            
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
//            alertTitle = @"Something went wrong";
//            alertText = [FBErrorUtility userMessageForError:error];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
//                alertTitle = @"Session Error";
//                alertText = @"Your current session is no longer valid. Please log in again.";
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
//                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
//                alertTitle = @"Something went wrong";
//                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    NSLog(@"LOGGED IN");
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    NSLog(@"LOGGED OUT");
    
    
    // [self presentViewController:obj animated:YES completion:Nil];
    
}

////////// BUTTON TOUCH FUNCTIONS ///////////

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

- (void) alertStatus:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if([[UIScreen mainScreen]bounds].size.height !=568)
    {
        NSLog(@"IN 3.5");
        copyright.frame=CGRectMake(60, 450, 260, 21);
        terms_bg_view.frame=CGRectMake(10, 30, 300, 440);
        terms_text_view.frame=CGRectMake(6, 141, 289, 280);
        
    }
   
	}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SIGN_UP_ID"])
    {
        Sign_Up_ViewController *sign_view_controll=segue.destinationViewController;
        sign_view_controll.FB_FLAG=FB_FLAG_1;
    }
    else if([segue.identifier isEqualToString:@"VIEWCONTROLL_FEED"])
    {
        FeedViewController *control=segue.destinationViewController;
        control.USER_ID=USER_ID_1;
        control.TOCKEN=TOCKEN_1;
    }
}


/////////////// PAGE LOADING /////////////////

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         imageView_1.transform = CGAffineTransformRotate(imageView_1.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating_1) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}
//- (void) startSpin {
//    if (!animating_1) {
//        animating_1 = YES;
//        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
//    }
//}
//- (void) stopSpin {
//    // set the flag to stop spinning after one last 90 degree increment
//    animating_1 = NO;
//}
//
//-(void)showPageLoader
//{
//    HUD_1 = [[MBProgressHUD alloc] initWithView:self.view];
//    HUD_1.color = [UIColor clearColor];
//    HUD_1.dimBackground = YES;
//    HUD_1.delegate = self;
//    UIImage *image = [UIImage imageNamed:@"ball.png"];
//    imageView_1 = [ [ UIImageView alloc ] initWithFrame:CGRectMake(145.0, 270.0, 30, 30) ];
//    imageView_1.image = image;
//    [HUD_1 addSubview:imageView_1];
//    [self startSpin];
//    [self.view addSubview:HUD_1];
//    [HUD_1 show:TRUE];
//    
//}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    FB_FLAG_1 = 0;
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
}


-(void) refreshNetworkStatus:(NSTimer*)time
{
    BOOL netStatus = [connectobj_1 checkNetwork];
    if(netStatus == true)
    {
        networkErrorView_1.hidden=YES;
    }
    else
    {
        NSLog(@"NONET");
        networkErrorView_1.hidden=NO;
        [HUD_1 hide:YES];
        [self stopSpin];
    }
}

- (void) stopSpin
{
    [animation_main_view removeFromSuperview];
    [animation_sub_view removeFromSuperview];
    [anim_imageView removeFromSuperview];
    [anim_imageView stopAnimating];
}

-(void)showPageLoader
{
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        animation_main_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    else
    {
        animation_main_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }
    animation_main_view.backgroundColor=[UIColor blackColor];
    animation_main_view.alpha=.2;
    animation_main_view.hidden=NO;
    [self.view addSubview:animation_main_view];
    
    animation_sub_view=[[UIView alloc]initWithFrame:CGRectMake(110, 209, 100, 100)];
    animation_sub_view.layer.cornerRadius=4.0;
    animation_sub_view.clipsToBounds=YES;
    animation_sub_view.backgroundColor=[UIColor blackColor];
    animation_sub_view.alpha=.4;
    [self.view addSubview:animation_sub_view];
    
    anim_imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(110, 209, 100, 100) ];
    [self.view addSubview:anim_imageView];
    anim_imageView.animationImages = [[NSArray alloc] initWithObjects:
                                 [UIImage imageNamed:@"1.png"],
                                 [UIImage imageNamed:@"2.png"],
                                 [UIImage imageNamed:@"3.png"],
                                 [UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"5.png"],[UIImage imageNamed:@"6.png"],[UIImage imageNamed:@"7.png"],[UIImage imageNamed:@"8.png"],[UIImage imageNamed:@"9.png"],[UIImage imageNamed:@"10.png"],[UIImage imageNamed:@"11.png"],[UIImage imageNamed:@"12.png"],[UIImage imageNamed:@"13.png"],[UIImage imageNamed:@"14.png"],[UIImage imageNamed:@"15.png"],[UIImage imageNamed:@"16.png"],[UIImage imageNamed:@"17.png"],[UIImage imageNamed:@"18.png"],[UIImage imageNamed:@"19.png"],
                                 nil];
    anim_imageView.animationDuration=5;
    [anim_imageView startAnimating];
    
    
}


@end
