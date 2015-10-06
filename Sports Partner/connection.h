//
//  connection.h
//  Sports Partner
//
//  Created by Ti Technologies on 29/09/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <AVFoundation/AVFoundation.h>
@interface connection : NSObject
{
      AVAudioPlayer *audioPlayer;
}
@property(nonatomic,retain)NSString *url_value;

-(NSString *)value;
-(NSString *)image_value;
-(BOOL)checkNetwork;
-(BOOL)string_check:(NSString *)param;
-(BOOL)int_check:(NSInteger)param;
-(void)messagesound;
@end
