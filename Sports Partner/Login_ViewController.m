//
//  Login_ViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 04/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "Login_ViewController.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
#import "TextFieldValidator.h"
#import "FeedViewController.h"
#import "IntroViewController.h"
#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"
#define SCROLLVIEW_CONTENT_HEIGHT 568
#define SCROLLVIEW_CONTENT_WIDTH  320

@interface Login_ViewController ()

@end

@implementation Login_ViewController
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
    
   
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0/255.0f green:30/255.0f blue:64/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];

    
    self.screenName=@"SP Login Screen";
    connectobj=[[connection alloc]init];
    style=[[Styles alloc]init];
    sqlfunction=[[SQLFunction alloc]init];
    mainLoginInfo  = [[UITableView alloc] initWithFrame:CGRectMake(10,260, 300,100) style:UITableViewStylePlain];
    mainLoginInfo.dataSource = self;
    mainLoginInfo.dataSource = self;
    mainLoginInfo.layer.cornerRadius =1;
    [mainLoginInfo.layer setMasksToBounds:YES];
    mainLoginInfo.layer.borderWidth=2;
    mainLoginInfo.delegate=self;
    mainLoginInfo.backgroundColor = [UIColor clearColor];
    mainLoginInfo.layer.borderColor=[UIColor clearColor].CGColor;
    mainLoginInfo.scrollEnabled=NO;
    
    [scrollview addSubview:mainLoginInfo];
    
    
    userNameFeild = [[UITextField alloc] initWithFrame:CGRectMake(58,11, 280, 31)];
    userNameFeild.textAlignment = NSTextAlignmentLeft;
    userNameFeild.textColor = [UIColor blackColor];
    userNameFeild.clearButtonMode  = UITextFieldViewModeAlways;
    userNameFeild.delegate = self;
    userNameFeild.autocorrectionType=NO;
    userNameFeild.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
    userNameFeild.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameFeild.keyboardType=UIKeyboardTypeEmailAddress;
    userNameFeild.placeholder=@"Email";
    
    passWordFeild = [[UITextField alloc] initWithFrame:CGRectMake(58,11, 280, 31)];
    passWordFeild.textAlignment = NSTextAlignmentLeft;
    passWordFeild.textColor = [UIColor blackColor];
    passWordFeild.clearButtonMode = UITextFieldViewModeAlways;
    passWordFeild.secureTextEntry = YES;
    passWordFeild.delegate = self;
    passWordFeild.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
    passWordFeild.placeholder=@"Password";
    passWordFeild.secureTextEntry=YES;
    
    
    email_image=[[UIImageView alloc]initWithFrame:CGRectMake(12,10, 28, 28)];
    email_image.image=[UIImage imageNamed:@"email.png"];
    
    
    password_image=[[UIImageView alloc]initWithFrame:CGRectMake(12,8, 30, 30)];
    password_image.image=[UIImage imageNamed:@"password_new.png"];
    
    
    ///////////////////  HEADER VIEW ////////////
    
   
    
    ///////////// SIGN IN BUTTON ///////////
    
    Sign_In_button.backgroundColor=[style colorWithHexString:terms_of_services_color];
    Sign_In_button.layer.cornerRadius=4.0;
    Sign_In_button.layer.masksToBounds=YES;
    [Sign_In_button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    [forgot_password.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12]];
    
    
    ///////// WEB USER DESIGN ////////////
    
   web_user_view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"web_user.png"]];
    web_user_view.layer.cornerRadius=4.0;
    web_user_view.layer.borderWidth=1.0;
    web_user_view.layer.borderColor=[UIColor whiteColor].CGColor;
    web_user_view.layer.masksToBounds=YES;
    
    web_user_label.font=[UIFont fontWithName:@"Roboto-Regular" size:16];
   
    web_user_password.backgroundColor=[UIColor clearColor];
    web_user_password.layer.borderWidth=0.50;
    web_user_password.layer.borderColor=[UIColor whiteColor].CGColor;
    web_user_password.layer.masksToBounds=YES;
   // web_user_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [web_user_password setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    
    web_user_rest_button.backgroundColor=[style colorWithHexString:terms_of_services_color];
    //web_user_rest_button.layer.cornerRadius=4.0;
//    web_user_rest_button.layer.borderWidth=1.0;
//    web_user_rest_button.layer.borderColor=[UIColor whiteColor].CGColor;
    web_user_rest_button.layer.masksToBounds=YES;
    [web_user_rest_button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    
    ///////// loading sqlite table///////
    
    [sqlfunction loadLoginSqlLiteDB];
    [sqlfunction SearchFromLoginTable];
    


    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
            
        case 0:
             [cell.contentView addSubview:email_image];
            [cell.contentView addSubview:userNameFeild];
            break;
        case 1:
             [cell.contentView addSubview:password_image];
            [cell.contentView addSubview:passWordFeild];
            
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
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

	keyboardVisible = NO;
    
    if([[UIScreen mainScreen]bounds].size.height ==480)
    {
        Sign_In_button.frame=CGRectMake(13, 378, 294, 50);
        forgot_password.frame=CGRectMake(95, 430, 130, 30);
        
    
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

    if (WEB_USER_FLAG==1)
    {
         web_user_view.frame=CGRectMake(10, 150, 300, 184);
      //  WEB_USER_FLAG=0;
    }
  //
    else
    {
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
	scrollview.frame = viewFrame;
	
	CGRect textFieldRect = [activeField frame];
	textFieldRect.origin.y += 350;
    NSLog(@"size :%f",textFieldRect.origin.y);
	[scrollview scrollRectToVisible:textFieldRect animated:YES];
    
  //  scrollview.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH,
					//					SCROLLVIEW_CONTENT_HEIGHT);
    }
	// Keyboard is now visible
	keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
    
   web_user_view.frame=CGRectMake(10, 172, 300, 184);
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
   // placeholderLabel.frame= CGRectMake(200, 10, 150, 15);
	activeField = textField;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
        if([title isEqualToString:@"Cancel"])
        {
            NSLog(@"CASE 0");
            scrollview.frame = CGRectMake(0, 20, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
            
            // Reset the scrollview to previous location
            // scrollview.contentOffset = offset;
            
            // Keyboard is no longer visible
            keyboardVisible = NO;
        }
        else if([title isEqualToString:@"Submit"])
        {
            NSLog(@"CASE 0");
            
            
            NSLog(@"SEND MESSAGE");
            
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            NSLog(@"alerttextfiled - %@",alertTextField.text);
            
            NSString *emailRegEx =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
            BOOL myStringCheck = [regExpred evaluateWithObject:alertTextField.text];
            
            
            if([alertTextField.text isEqualToString:@""])
            {
                [self alertStatus:@"Please Enter Your Email"];
                return;
            }
            else if(!myStringCheck)
            {
                alertTextField.text=@"";
                
                [self alertStatus:@"Email address should be in yourname@domainname.com  format"];
                return;
            }

            else
            {
            //////// FORGOT API////////////
            
            
            NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObject:alertTextField.text forKey:@"email"];
    
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/forgotpassword?"];
            
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
                                           
                                       }
                                       else
                                       {
                                       NSDictionary *json =
                                       [NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions
                                                                         error:nil];
                                       NSLog(@"DICddd is :%@",json);
                                       
                                       NSInteger status=[[json objectForKey:@"status"]intValue];
                                      
                                       if(status==1)
                                       {
                                          
                                           
                                       }
                                           else
                                           {
                                               [self alertStatus:[json objectForKey:@"message"]];
                                               return ;
                                           }
                                       }
                                       
                                   }];
            
            
            }
            
            
            //////// END FORGOT API CALL //////////

            
            scrollview.frame = CGRectMake(0, 20, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
            
            keyboardVisible = NO;
        }
        else if([title isEqualToString:@"Go to Settings"])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        else if([title isEqualToString:@"Ok"])
        {
           
        }
    
    
    // do whatever you want to do with this UITextField.
}

////////////////// SIGN IN FUNCTIONS ///////////////////////


- (void) alertStatus:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (IBAction)SGN_IN:(id)sender
{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *device_token = [defaults objectForKey:@"devicetoken"];
    NSLog(@"DEVT:%@",device_token);
    
    //// EMAIL VALIDATION /////
    
    NSString *emailRegEx =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringCheck = [regExpred evaluateWithObject:userNameFeild.text];

   
    if([userNameFeild.text isEqualToString:@""])
    {
        [self alertStatus:@"Please Enter Your username"];
        return;
    }
    else if(!myStringCheck)
    {
        userNameFeild.text=@"";
       
        [self alertStatus:@"Email address should be in yourname@domainname.com  format"];
        return;
    }

    else if ([passWordFeild.text isEqualToString:@""])
    {
        [self alertStatus:@"Please Enter Your Password"];
        return;
    }
    else if ([device_token isEqualToString:@""] || device_token==nil || [device_token isEqual:[NSNull null]])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please turn on your Push Notifications to allow Sports Partners find people near you for sports and fitness" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Go to Settings", nil];
        [alert show];
        return;
    }
    else
    {
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
        networkErrorView.hidden=YES;
        [self showPageLoader];
         NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:userNameFeild.text forKey:@"email"];
        [param setObject:passWordFeild.text forKey:@"password"];
        [param setObject:device_token forKey:@"deviceID"];
        [param setObject:@"IOS" forKey:@"deviceOS"];
        [param setObject:[NSNumber numberWithInteger:0] forKey:@"fblogin"];
        NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/login"];
        
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
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
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
                                           [self alertStatus:@"Error in network"];
                                           return ;
                                       });

                                   }
                                   else
                                   {
                                   //    [timer invalidate];
                                    NSLog(@"RESPONSE :%@",response);
                                   NSDictionary *json =
                                   [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:nil];
                                   NSLog(@"DIC is :%@",json);
                                   
                                   NSInteger status=[[json objectForKey:@"status"] intValue];
                                   
                                   if(status==1)
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           [userNameFeild resignFirstResponder];
                                           [passWordFeild resignFirstResponder];
                                           
                                           USER_ID=[[json objectForKey:@"user_id"]intValue];
                                           TOCKEN=[json objectForKey:@"token"];
                                           NSLog(@"TOKEnlooo :%@",TOCKEN);
                                           [sqlfunction SaveToLogintable:[[json objectForKey:@"user_id"]intValue] tokenValue:[json objectForKey:@"token"] tokenStatus:[json objectForKey:@"status"] user_name:userNameFeild.text password:passWordFeild.text];
                                           [HUD hide:YES];
                                           [self stopSpin];
                                           if (WEB_USER_FLAG==1)
                                           {
                                               [self performSegueWithIdentifier:@"LOGIN_INTRO" sender:self];
                                           }
                                           else
                                           {
                                               NSLog(@"INTRO SIGNIN");
                                               [self performSegueWithIdentifier:@"SIGN_IN_FEED" sender:self];
                                           }
                                           
                                           
                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                               
                                               
                                               NSLog(@"SEARCH NAMES");
                                               NSMutableDictionary *param = [NSMutableDictionary dictionary];
                                               [param setObject:TOCKEN forKey:@"token"];
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
                                                                          if (data==nil || [data isEqual:[NSNull null]] || data==NULL)
                                                                          {
                                                                              [HUD hide:YES];
                                                                              [self stopSpin];
                                                                              
                                                                          }
                                                                          else
                                                                          {
                                                                              
                                                                              
                                                                               NSString *str_users = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                              
                                                                              NSDictionary *json1 =
                                                                              [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:kNilOptions
                                                                                                                error:nil];
                                                                              
                                                                              NSInteger status=[[json1 objectForKey:@"status"] intValue];
                                                                              
                                                                              if(status==1)
                                                                              {
                                                                                 
                                                                                  NSUserDefaults *defaults_users = [NSUserDefaults standardUserDefaults];
                                                                                  [defaults_users setObject:str_users forKey:@"users"];
                                                                                  [defaults_users synchronize];
                                                                                  
                                                                                  
                                                                              }
                                                                              else if([[json1 objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
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

                                           
                                       });

                                   }
                                   
                                   else if ([[json objectForKey:@"web_user_status"] intValue]==1)
                                       {
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [userNameFeild resignFirstResponder];
                                               [passWordFeild resignFirstResponder];
                                               
                                               WEB_USER_FLAG=1;
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               backgroundview=[[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
                                               [self.view addSubview:backgroundview];
                                               [self.view addSubview:web_user_view];
                                               web_user_view.hidden=NO;
                                               
                                           });
                                           
                                       }
                                       
                                   else
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           [HUD hide:YES];
                                           [self stopSpin];
                                           userNameFeild.text=@"";
                                           passWordFeild.text=@"";
                                           [userNameFeild resignFirstResponder];
                                           [passWordFeild resignFirstResponder];
                                           [self alertStatus:[json objectForKey:@"message"]];
                                           return ;

                                       });
                                       
                                   }
                                   }
                                   if (connectionError)
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           NSLog(@"error detected:%@", connectionError.localizedDescription);
                                           
                                           [HUD hide:YES];
                                           [self stopSpin];
                                           

                                           
                                       });
                                       
                                   }
                                   

                               }];
        
    }
        else
        {
            NSLog(@"NONET");
            networkErrorView.hidden=NO;
            [HUD hide:YES];
            [self stopSpin];
            [userNameFeild resignFirstResponder];
            [passWordFeild resignFirstResponder];

  
        }

    }
    
}
-(void)cancelURLConnection:(id)sender
{
    [HUD hide:YES];
    [self stopSpin];
    [timer invalidate];
    [self alertStatus:@"Network Error"];
    return ;
}
- (IBAction)Forgot_password:(id)sender
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot Password ?" message:@"Please Enter Your Email" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil] ;
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (IBAction)BACK:(id)sender
{
    [self performSegueWithIdentifier:@"BACK_ID" sender:self];
    
}

- (IBAction)rest_btn_action:(id)sender
{
    NSInteger myLength = [web_user_password.text length];
    NSRange whiteSpaceRange = [web_user_password.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
  
    
    if ([web_user_password.text isEqualToString:@""])
    {
        [self alertStatus:@"Please Enter Your Password"];
        return;
    }
    else if(myLength<6)
    {
        [self alertStatus:@"Password characters limit should be come between 6-20"];
        return;
    }
    
    else if (whiteSpaceRange.location != NSNotFound)
    {
        [self alertStatus:@"Please Enter A Valid String"];
        return;
    }
    else
    {
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            
            networkErrorView.hidden=YES;
            [self showPageLoader];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:userNameFeild.text forKey:@"email"];
            [param setObject:web_user_password.text forKey:@"new_pass"];
            [param setObject:[NSNumber numberWithInteger:0] forKey:@"fblogin"];
            NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/onetimechangepassword"];
            
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
                                           //    [timer invalidate];
                                           NSLog(@"RESPONSE :%@",response);
                                           NSDictionary *json =
                                           [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                                           NSLog(@"DIC is :%@",json);
                                           
                                           NSInteger status=[[json objectForKey:@"status"] intValue];
                                           
                                           if(status==1)
                                           {
                                               
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               [backgroundview removeFromSuperview];
                                               [web_user_view resignFirstResponder];
                                               web_user_view.hidden=YES;
                                               userNameFeild.text=@"";
                                               passWordFeild.text=@"";
                                               web_user_password.text=@"";
                                               [userNameFeild resignFirstResponder];
                                               [passWordFeild resignFirstResponder];
                                               [web_user_password resignFirstResponder];

                                               [self alertStatus:@"your password has been successfully reset"];
                                               return;
                                           }
                                           else
                                           {
                                               [web_user_view resignFirstResponder];
                                               [HUD hide:YES];
                                               [self stopSpin];
                                               [userNameFeild resignFirstResponder];
                                               [passWordFeild resignFirstResponder];
                                               [web_user_password resignFirstResponder];
                                               [self alertStatus:[json objectForKey:@"message"]];
                                               return ;
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
        else
        {
            NSLog(@"NONET");
            networkErrorView.hidden=NO;
            [HUD hide:YES];
            [self stopSpin];
            
            
        }
        
    }

}

- (IBAction)web_user_close:(id)sender
{
    [backgroundview removeFromSuperview];
    [web_user_password resignFirstResponder];
    web_user_view.frame=CGRectMake(10, 172, 300, 184);
    web_user_view.hidden=YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SIGN_IN_FEED"])
    {
        NSLog(@"TOKEnlo :%@",TOCKEN);
        FeedViewController *feed_controller=segue.destinationViewController;
        feed_controller.USER_ID=USER_ID;
        feed_controller.TOCKEN=TOCKEN;
        
        
    }
    else if([segue.identifier isEqualToString:@"LOGIN_INTRO"])
    {
        IntroViewController *introcontrol=segue.destinationViewController;
        introcontrol.USER_ID=USER_ID;
        introcontrol.token=TOCKEN;
    }
}

/////////////// PAGE LOADING /////////////////

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

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(refreshNetworkStatus:) userInfo: nil repeats: YES];
    web_user_view.frame=CGRectMake(10, 172, 300, 184);
    
}


-(void)refreshNetworkStatus:(NSTimer*)time
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
