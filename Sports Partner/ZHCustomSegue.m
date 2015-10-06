//
//  ZHCustomSegue.m
//  CustomSegue
//
//  Created by Zakir on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZHCustomSegue.h"
#import "QuartzCore/QuartzCore.h"

@implementation ZHCustomSegue


-(void)perform {
    
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    [srcViewController presentViewController:destViewController animated:NO completion:nil];
    
}
@end
