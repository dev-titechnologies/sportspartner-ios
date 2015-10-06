//
//  CustomSegue.m
//  Physio
//
//  Created by Ti Technologies on 09/04/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "CustomSegue.h"
#import "QuartzCore/QuartzCore.h"
@implementation CustomSegue


-(void)perform
{
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
   // UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    [srcViewController dismissViewControllerAnimated:NO completion:nil];

}

@end
