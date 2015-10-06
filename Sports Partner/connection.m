//
//  connection.m
//  Sports Partner
//
//  Created by Ti Technologies on 29/09/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "connection.h"
#import <AVFoundation/AVFoundation.h>
@implementation connection
@synthesize url_value;

-(BOOL)checkNetwork
{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        return false;
    }else
    {
        return true;
    }
}
-(NSString *)value;
{
    url_value=@"http://spdemo.titechnologies.in/ssapi/";
    return url_value;
}

-(NSString *)image_value
{
   NSString *image_url=@"http://spdemo.titechnologies.in/ssapi/images/sports/";
    return image_url;
}

-(BOOL)string_check:(NSString *)param
{
    if ([param isEqualToString:@""]|| [param isEqual:[NSNull null]] || param==NULL)
    {
        return false;
    }
    else
        return true;
}

-(BOOL)int_check:(NSInteger)param
{
    if (param==(int)nil)
    {
    
        return false;
    }
     return true;
}

-(void)messagesound
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"messagetone2"
                                         ofType:@"mp3"]];
    
    
    NSLog(@"Audio url : %@",url);
    
    
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    audioPlayer  = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url
                    error:&error];
    
    
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else
    {
        NSLog(@"NO ERROR AUDIO");
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
        
    }
    
}


@end
