//
//  AppDelegate.h
//  Sports Partner
//
//  Created by Ti Technologies on 04/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLFunction.h"
#import "connection.h"
#import "SBJSON.h"
#import <NewRelicAgent/NewRelic.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    connection *connectobj;
    NSString *ga_tracker_id;
}
@property(nonatomic,retain)SQLFunction *sqlfunction;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)NSString *DEVICE_TOKEN;
@property(nonatomic,readwrite)NSInteger ENTER_FORFROUND_FLAG;

- (void)userLoggedIn;
- (void)userLoggedOut;

@end
