//
//  DetailSegue.m
//  Sports Partner
//
//  Created by Ti Technologies on 03/11/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "DetailSegue.h"
#import "QuartzCore/QuartzCore.h"
@implementation DetailSegue
-(void)perform {
    
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    [srcViewController presentViewController:destViewController animated:NO completion:nil];
    
}

@end
