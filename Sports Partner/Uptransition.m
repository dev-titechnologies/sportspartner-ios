//
//  Uptransition.m
//  Sports Partner
//
//  Created by Ti Technologies on 11/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "Uptransition.h"

@implementation Uptransition

-(void)perform {
    
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    [srcViewController presentViewController:destViewController animated:NO completion:nil];
    
}

@end
