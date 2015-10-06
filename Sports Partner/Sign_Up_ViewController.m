//
//  Sign_Up_ViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 04/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "Sign_Up_ViewController.h"
#import "SBJSON.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "TextFieldFormElement.h"
#import <CoreLocation/CoreLocation.h>
#import "Favourite_Sports_ViewController.h"
#import "IntroViewController.h"
#define SCROLLVIEW_CONTENT_HEIGHT 568
#define SCROLLVIEW_CONTENT_WIDTH  320

#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[a-zA-z]+[ '-][a-zA-Z ]+"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{2,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"^[\\S]*$"
#define REGEX_PHONE_DEFAULT @"^[\\S]*$";

@interface Sign_Up_ViewController ()

@end

@implementation Sign_Up_ViewController
@synthesize FB_FLAG;
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
    
    //////////// BACK BUTTON/////////////
    
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];

    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"ardrr" forKey:@"name"];
    [dict setObject:@"34" forKey:@"age"];
    
    
    NSMutableDictionary *dict1=[[NSMutableDictionary alloc]init];
    [dict1 setObject:@"achhh" forKey:@"name"];
    [dict1 setObject:@"34" forKey:@"age"];
    
    
    NSMutableArray *array=[[NSMutableArray alloc]initWithObjects:dict,dict1, nil];
    
    NSLog(@"ARRRAY IS : %@",array);
    
    
    [array removeObject:dict1];
    
      NSLog(@"ARRRAY2 IS : %@",array);

    
    
     styles=[[Styles alloc]init];
    
    /////////////// status bar and header design ////////////////////////////////
    
    
    
    self.screenName=@"Sign Up Screen";
    connectobj=[[connection alloc]init];
    self.formItems = [[NSMutableArray alloc] initWithObjects:NameField,EmailField,PasswordField, nil];
   
    self.enhancedKeyboard = [[KSEnhancedKeyboard alloc] init];
    self.enhancedKeyboard.delegate = self;
   
    segmented_control.tintColor=[styles colorWithHexString:terms_of_services_color];
    sign_up_button_1.backgroundColor=[styles colorWithHexString:terms_of_services_color];
    sign_up_button_1.layer.cornerRadius=4.0;
    sign_up_button_1.layer.masksToBounds=YES;
    
     NameField.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
     EmailField.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
     PasswordField.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
     country_field.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
     PIN.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
     gender_label.font=[UIFont fontWithName:@"Roboto-Regular" size:20];
    [sign_up_button_1.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    ///////// DOB ///////////
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *string_date=[dateFormatter stringFromDate:[NSDate date]];
    NSDate *endDate = [dateFormatter dateFromString:string_date];
    NSLog(@"END DATE :%@",endDate);

    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self setupAlerts];
    
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: -13];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear: -100];
    NSDate * minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    NSLog(@"DDDE: %@",minDate);
    [datePicker setMinimumDate:minDate];
    [datePicker setMaximumDate:maxDate];
    
    [scrollview addSubview:back_view];
    
    ///////////// LOCATION MANAGER /////////////
    
    gender_string=@"";
    
    
    ///////////// LOCAL DB ///////////
    
    sqlfunction=[[SQLFunction alloc]init];
    [sqlfunction loadLoginSqlLiteDB];
    
    if (FB_FLAG==1) {
        [FBRequestConnection startWithGraphPath:@"/me"
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  /* handle the result */
                                  //
                                  first_name=[result objectForKey:@"name"];
                                  gender=[result objectForKey:@"gender"];
                                  email=[result objectForKey:@"email"];
                                  birthday=[result objectForKey:@"birthday"];
                                  NSLog(@"B'day is :%@",birthday);
                                  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                  [dateFormat setDateFormat:@"MM-dd-yyyy"];
                                  [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                                  NSDate *date = [dateFormat dateFromString:birthday];
                                  NSLog(@"Date is :%@",date);
                                  [dateFormat setDateFormat:@"MM"];
                                  month = [dateFormat stringFromDate:date];
                                  [dateFormat setDateFormat:@"dd"];
                                  day = [dateFormat stringFromDate:date];
                                  [dateFormat setDateFormat:@"yyyy"];
                                  year = [dateFormat stringFromDate:date];
                                  NSLog(@"Month is :%@",month);
                                  
                                  NameField.text=first_name;
                                  EmailField.text=email;
                                  if ([gender isEqualToString:@"male"])
                                  {
                                      gender_string=@"male";
                                      segmented_control.selectedSegmentIndex=0;
                                  }
                                  else  if ([gender isEqualToString:@"female"])
                                  {
                                      segmented_control.selectedSegmentIndex=1;
                                      gender_string=@"female";
                                  }
                                  
                                  
                              }];
        

    }
    
    
    



}
-(NSString *)removeStartSpaceFrom:(NSString *)strtoremove{
    NSUInteger location1 = strtoremove.length;
    unichar charBuffer[[strtoremove length]];
    [strtoremove getCharacters:charBuffer];
    int i = 0;
    for ( i = 0; i < [strtoremove length]; i++){
        if (![[NSCharacterSet whitespaceCharacterSet] characterIsMember:charBuffer[i]]){
            break;
        }
    }
    return  [strtoremove substringWithRange:NSMakeRange(i, location1-i)];
}
-(void)setupAlerts
{
    
    [EmailField addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    [PasswordField addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [PasswordField addRegx:REGEX_PASSWORD withMsg:@"Enter a Valid String"];
    [NameField addRegx:REGEX_USER_NAME withMsg:@"Please Enter your full name"];
    
}

-(void)updateTextField:(UIDatePicker *)datePicker
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    date_string =[df stringFromDate:datePicker.date];
    NSLog(@"Date isss :%@",date_string);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Sign_Up_Action:(id)sender
{
    if (![PasswordField validate])
    {
        PasswordField.text=@"";
    }
    
  
    if([NameField validate1] & [EmailField validate] & [PasswordField validate3])
    {
        
        if (![gender_string isEqualToString:@""]) {
            BOOL netStatus = [connectobj checkNetwork];
            if(netStatus == true)
            {
                networkErrorView.hidden=YES;
                [self showPageLoader];
                
                NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObject:EmailField.text forKey:@"email"];
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/validateemail?"];
                
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
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           NSLog(@"DIC is :%@",json);
                                           
                                           NSInteger status=[[json objectForKey:@"status"]intValue];                                           
                                           
                                           if(status==1)
                                           {
                                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                               NSString *device_token = [defaults objectForKey:@"devicetoken"];
                                               NSLog(@"DEVTtttt:%@",device_token);
                                               
                                               if ([[NSString stringWithFormat:@"%@",device_token] isEqualToString:@""] || device_token==nil || [device_token isEqual:[NSNull null]])
                                               {
                                                   UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please turn on your Push Notifications to allow Sports Partners find people near you for sports and fitness" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Go to Settings", nil];
                                                   [alert show];
                                                   return;
                                               }
                                               
                                              else if (![[NSString stringWithFormat:@"%@",gender_string] isEqualToString:@""])
                                               {
                                                   NSMutableDictionary *param = [NSMutableDictionary dictionary];
                                                   [param setObject:NameField.text forKey:@"name"];
                                                   [param setObject:EmailField.text forKey:@"email"];
                                                   [param setObject:PasswordField.text forKey:@"password"];
                                                   [param setObject:@"" forKey:@"postcode"];
                                                   [param setObject:@"" forKey:@"dob"];
                                                   [param setObject:@"Australia" forKey:@"country"];
                                                   [param setObject:gender_string forKey:@"gender"];
                                                   [param setObject:@""  forKey:@"location"];
                                                   [param setObject:@"" forKey:@"lat"];
                                                   [param setObject:@"" forKey:@"long"];
                                                   [param setObject:@"0" forKey:@"profile"];
                                                   [param setObject:device_token forKey:@"deviceID"];
                                                   [param setObject:@"IOS" forKey:@"deviceOS"];
                                                   
                                                   NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/registration?"];
                                                   
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
                                                                                  NSDictionary *json =
                                                                                  [NSJSONSerialization JSONObjectWithData:data
                                                                                                                  options:kNilOptions
                                                                                                                    error:nil];
                                                                                  NSLog(@"DIC is :%@",json);
                                                                                  
                                                                                  NSInteger status=[[json objectForKey:@"status"] intValue];
                                                                                  
                                                                                  if(status==1)
                                                                                  {
                                                                                      
                                                                                      USER_ID=[[json objectForKey:@"user_id"]intValue];
                                                                                      TOCKEN=[json objectForKey:@"token"];
                                                                                      [sqlfunction SaveToLogintable:[[json objectForKey:@"user_id"]intValue] tokenValue:[json objectForKey:@"token"] tokenStatus:[json objectForKey:@"status"] user_name:EmailField.text password:PasswordField.text];
                                                                                      [HUD hide:YES];
                                                                                      [self stopSpin];
                                                                                      [self performSegueWithIdentifier:@"SIGN_UP_SPORTS" sender:self];
                                                                                      
                                                                                      
                                                                                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                              
                                                                                              NSMutableDictionary *param = [NSMutableDictionary dictionary];
                                                                                              [param setObject:TOCKEN forKey:@"token"];
                                                                                              [param setObject:[NSNumber numberWithInteger:USER_ID] forKey:@"user_id"];
                                                                                              [param setObject:@"last_user_id" forKey:@"0"];
                                                                                              
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
                                                                                          
                                                                                      
                                                                                      [sqlfunction SearchFromLoginTable];
                                                                                  }
                                                                                  else if (connectionError)
                                                                                  {
                                                                                      
                                                                                      NSLog(@"error detected:%@", connectionError.localizedDescription);
                                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                                          [HUD hide:YES];
                                                                                          [self stopSpin];
                                                                                      });
                                                                                      
                                                                                  }
                                                                                  else
                                                                                      
                                                                                  {
                                                                                      [HUD hide:YES];
                                                                                      [self stopSpin];
                                                                                      [self alertStatus:@"Error"];
                                                                                      return ;
                                                                                      
                                                                                  }
                                                                                  
                                                                                  
                                                                                  
                                                                              }
                                                                          }];
                                                   
                                               }
                                               else
                                               {
                                                   [HUD hide:YES];
                                                   [self stopSpin];
                                                   [self alertStatus:@"Server Error"];
                                                   return ;
                                               }

                                               
                                           }
                                           else
                                           {
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               [self alertStatus:@"Email already exist"];
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
            }
        }
        else
        {
            [self alertStatus:@"Select gender"];
            return ;
        }
        
        ////////////// EMAIL VALIDATION//////////////////
      
       
    }
  
 
 
   
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

- (void) alertStatus:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}


- (IBAction)Back:(id)sender
{
    [self performSegueWithIdentifier:@"SIGN_UP_BACK_ID" sender:self];
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
	
	scrollview.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH,
										SCROLLVIEW_CONTENT_HEIGHT);
    
	
	//Initially the keyboard is hidden
	keyboardVisible = NO;
    
    if([[UIScreen mainScreen]bounds].size.height ==480)
    {
        NSLog(@"IN SI 3.5");
        scrollview.frame = CGRectMake(0, 20, 320, 480);
        
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
    viewFrame.size.height -= keyboardSize.height;
    NSLog(@"VIEW FRAME HEIGHT :%f",viewFrame.size.height);
    scrollview.frame=viewFrame;
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        back_view.frame=CGRectMake(0, 40, 322, 480);
    }
    else
    {
        back_view.frame=CGRectMake(0, 40, 322, 513);
    }
    [scrollview addSubview:back_view];
    
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 230;
    NSLog(@"size :%f",textFieldRect.origin.y);
    [scrollview scrollRectToVisible:textFieldRect animated:YES];
    // scrollview.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH,
    //		SCROLLVIEW_CONTENT_HEIGHT);
    
    NSLog(@"ao fim");
    // Keyboard is now visible
    keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif
{
	// Is the keyboard already shown
	if (!keyboardVisible) {
		NSLog(@"Keyboard is already hidden. Ignore notification.");
		return;
	}
	
	// Reset the frame scroll view to its original value
	scrollview.frame = CGRectMake(0, 20, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
	
	// Reset the scrollview to previous location
	scrollview.contentOffset = offset;
	
	// Keyboard is no longer visible
	keyboardVisible = NO;
	
}
-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
    activeField = textField;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   // activeField=textField;
    [textField setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:YES]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    scrollview.frame = CGRectMake(0, 20, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
	[textField resignFirstResponder];
	return YES;
}

-(IBAction)segmentedControlIndexChanged:(id)sender
{
    switch (segmented_control.selectedSegmentIndex)
    {
        case 0:
            NSLog(@"MALE");
            gender_string=@"male";
          
            break;
        case 1:
            NSLog(@"FEMALE");
            
            gender_string=@"female";
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SIGN_UP_SPORTS"])
    {
        Favourite_Sports_ViewController *sports_controller=segue.destinationViewController;
        sports_controller.USER_ID=USER_ID;
        sports_controller.TOCKEN=TOCKEN;
    }
    
}

// --------------------------------------------------------------------
#pragma mark - KSEnhancedKeyboardDelegate Protocol

- (void)nextDidTouchDown
{
    for (int i=0; i<[self.formItems count]; i++)
    {
        if ([[self.formItems objectAtIndex:i] isEditing] && i!=[self.formItems count]-1)
        {
            [[self.formItems objectAtIndex:i+1] becomeFirstResponder];
            
            
            break;
        }
    }
}

// --------------------------------------------------------------------
- (void)previousDidTouchDown
{
    for (int i=0; i<[self.formItems count]; i++)
    {
        if ([[self.formItems objectAtIndex:i]  isEditing] && i!=0)
        {
            [[self.formItems objectAtIndex:i-1] becomeFirstResponder];
            
            break;
        }
    }
}

// --------------------------------------------------------------------
- (void)doneDidTouchDown
{
    if (!keyboardVisible) {
        NSLog(@"Keyboard is already hidden. Ignore notification.");
        return;
    }
    
    // Reset the frame scroll view to its original value
    scrollview.frame = CGRectMake(0, 20, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
    
    // Reset the scrollview to previous location
    scrollview.contentOffset = offset;
    keyboardVisible = NO;
    // Keyboard is no longer visible
    keyboardVisible = NO;
    [NameField resignFirstResponder];
    [EmailField resignFirstResponder];
    [PasswordField resignFirstResponder];
    [country_field resignFirstResponder];
    [PIN resignFirstResponder];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
    
    
    if ([[UIScreen mainScreen]bounds].size.height ==480)
    {
        scrollview.frame = CGRectMake(0, 20, 320, 480);
        
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

@end
