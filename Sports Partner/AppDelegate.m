//
//  AppDelegate.m
//  Sports Partner
//
//  Created by Ti Technologies on 04/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "Styles.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FeedViewController.h"
#import "ViewController.h"
#import "MessageViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "connection.h"
@implementation AppDelegate
@synthesize sqlfunction,ENTER_FORFROUND_FLAG;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    connectobj=[[connection alloc]init];
    sqlfunction=[[SQLFunction alloc]init];
    [sqlfunction loadLoginSqlLiteDB];

    // New Relic Integration
   [NewRelicAgent startWithApplicationToken:@"AA9a8dcfb46ecb15cc2a9ad5a32b455abac807bc41"];
    
    
        /////// Google Analytics Integration
    
    
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {

    NSString *urlpath;
    urlpath=[ [connectobj value] stringByAppendingString:@"apiservices/config?OS=IOS"];
    NSURL *url=[[NSURL alloc] initWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *a = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (![a isEqualToString:@""]|| ![a isEqual:[NSNull null]] )
    {
        SBJSON *parser=[[SBJSON alloc]init];
        NSDictionary *results=[parser objectWithString:a error:nil];
        NSLog(@"tyty: %@",results);
        
        if (results!=nil || ![results isEqual:[NSNull null]])
        {
            NSInteger status=[[results objectForKey:@"status"]intValue];
            
            if(status==1)
            {
                ga_tracker_id=[results objectForKey:@"GATRACK"];
                [GAI sharedInstance].trackUncaughtExceptions = YES;
                [GAI sharedInstance].dispatchInterval = 20;
                [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
                [[GAI sharedInstance] trackerWithTrackingId:ga_tracker_id];
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                NSLog(@"TRACKER ID IS :%@",tracker);
            }

        }
        
        }
        
    }
    
    
    //////////////////////////////////////// ALL SPORTS LISTING ///////////////////////////////////////////////
    
    
    
    
    BOOL netStatus1 = [connectobj checkNetwork];
    if(netStatus1 == true)
    {
        
            NSString *urlpath;
            urlpath=[ [connectobj value] stringByAppendingString:@"apiservices/allsports?"];
            NSURL *url=[[NSURL alloc] initWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString *a = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            if (![a isEqualToString:@""]|| ![a isEqual:[NSNull null]] || a!=nil)
            {
                
                SBJSON *parser=[[SBJSON alloc]init];
                NSDictionary *results=[parser objectWithString:a error:nil];
                
                if (results!=nil || ![results isEqual:[NSNull null]])
                  
                   {
                NSInteger status=[[results objectForKey:@"status"]intValue];
                
                if(status==1 && [results objectForKey:@"result"]!=NULL)
                {
                    
                    [sqlfunction delete_all_sports_list_Feed];
                    [sqlfunction SP_ALL_SPORTS_SAVE:sqlfunction.userID sports:a];
                    
                }
                else if([[results objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                {
                    
                }
                  
                }
            }
        
                
     
    }
    else
    {
       
    }
        Styles *style=[[Styles alloc]init];
    
        [[UIView appearanceWhenContainedIn:[UITabBar class], nil] setTintColor:[style colorWithHexString:terms_of_services_color]];
        [[UITabBar appearance] setSelectedImageTintColor:[style colorWithHexString:favourite_sports_selected_color]];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:10.0f],
                                                        NSForegroundColorAttributeName :[style colorWithHexString:favourite_sports_selected_color]
                                                        } forState:UIControlStateSelected];
    
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:10.0f],
                                                        NSForegroundColorAttributeName : [style colorWithHexString:terms_of_services_color]
                                                        } forState:UIControlStateNormal];
//
    
    [sqlfunction SearchFromLoginTable];
    BOOL logStatus = [sqlfunction SearchFromLoginTable];
    if(logStatus == true)
    {
        FeedViewController *controller=[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"FEED"];
        controller.USER_ID= [[NSString stringWithFormat:@"%d",sqlfunction.userID] integerValue];
        controller.TOCKEN=sqlfunction.userToken;
        self.window.rootViewController = controller;
        [self.window makeKeyAndVisible];
        
    }
    else
    {
        ViewController *controller=[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
        self.window.rootViewController = controller;
        [self.window makeKeyAndVisible];
    }

    
    // Override point for customization after application launch.
  
    
    #define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    if(IS_OS_8_OR_LATER)
    {
        NSLog(@"IOSS GREATER THAN 8");
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        NSLog(@"LESSS THAN *");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"78yuyh8h7ttyt56778tuyty" forKey:@"devicetoken"];
    [defaults synchronize];

    return YES;
    
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSString*)deviceToken
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSString *devicetoken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    devicetoken = [devicetoken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"DEvice token is :%@",deviceToken);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:devicetoken forKey:@"devicetoken"];
    [defaults synchronize];
    
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
    if (ENTER_FORFROUND_FLAG==1)
    {
        sqlfunction=[[SQLFunction alloc]init];
        [sqlfunction loadLoginSqlLiteDB];
        [sqlfunction SearchFromLoginTable];
        
        NSString *type=[userInfo objectForKey:@"type"];
        
        if ([type isEqualToString:@"message"])
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MESSAGE"];
            vc.USER_ID=[[userInfo objectForKey:@"receiver_id"] integerValue];
            vc.TOKEN=sqlfunction.userToken;
            self.window.rootViewController = vc;
        }
        
        else if ([type isEqualToString:@"follow"])
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FollowerViewController *vc_follow = [sb instantiateViewControllerWithIdentifier:@"FOLLOW"];
            vc_follow.USER_ID=sqlfunction.userID;
            vc_follow.TOKEN=sqlfunction.userToken;
            self.window.rootViewController = vc_follow;
        }
        
        ENTER_FORFROUND_FLAG=0;
    }
    else if (ENTER_FORFROUND_FLAG==0)
    {
        
        NSString *type=[userInfo objectForKey:@"type"];
        
        if ([type isEqualToString:@"message"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushmessage" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushchatmessage" object:self];
            
        }
        else if ([type isEqualToString:@"follow"])
            
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"followlist" object:self];
        }
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
 // This method will handle ALL the session state changes in the app
 - (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
 {
 // If the session was opened successfully
 if (!error && state == FBSessionStateOpen){
 // Show the user the logged-in UI
 [self userLoggedIn];
 return;
 }
 if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
 // If the session is closed
 // Show the user the logged-out UI
 [self userLoggedOut];
 }
 
 // Handle errors
 if (error){

 // If the error requires people using an app to make an action outside of the app in order to recover
 if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
// alertTitle = @"Something went wrong";
// alertText = [FBErrorUtility userMessageForError:error];
 } else {
 
 // If the user cancelled login, do nothing
 if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
 
 // Handle session closures that happen outside of the app
 } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
// alertTitle = @"Session Error";
// alertText = @"Your current session is no longer valid. Please log in again.";
 
 // Here we will handle all other errors with a generic error message.
 // We recommend you check our Handling Errors guide for more information
 // https://developers.facebook.com/docs/ios/errors/
 } else {
 //Get more error information from the error
// NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
 
 // Show the user an error message
// alertTitle = @"Something went wrong";
// alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
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
 }
 
 // Show the user the logged-in UI
 - (void)userLoggedIn
 {
 // Set the button title as "Log out"

 
 }

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BACKGROUNDTIMER" object:self];
    NSLog(@"ENTER BACKGROUND");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    NSLog(@"ENTER FORGROUND");
    
    ENTER_FORFROUND_FLAG=1;
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL wasHandled = [FBAppCall handleOpenURL:url
                             sourceApplication:sourceApplication];
    
    // add app-specific handling code here
    return wasHandled;
}
@end
