//
//  IntroViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 03/11/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "IntroViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FeedViewController.h"
#import "SearchViewController.h"
@interface IntroViewController ()

@end

@implementation IntroViewController

@synthesize USER_ID,device_id,token,LOGIN_FLAG;

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
    
    self.screenName=@"SP Intro Page";
    styles=[[Styles alloc]init];
    
//    UISwipeGestureRecognizer *leftSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftIntroSwiping:)];
//    
//    [leftSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
//    
//    [[self view] addGestureRecognizer:leftSwipeUpRecognizer];
//    
//       //// Right Swipe
//    
//    UISwipeGestureRecognizer *rightSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightIntroSwiping:)];
//    
//    [rightSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
//    
//    [[self view] addGestureRecognizer:rightSwipeUpRecognizer];
//    
    //// Right Swipe
    
    ready_button.hidden=NO;
   // self.view.backgroundColor=[styles colorWithHexString:@"B8E9FF"];
    ready_button.frame=CGRectMake(0, 2750, 320, 50);
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"intro_bg.png"]];
    ready_button.backgroundColor=[styles colorWithHexString:terms_of_services_color];
    skip_btn.backgroundColor=[styles colorWithHexString:terms_of_services_color];
    
     [skip_btn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    
     [ready_button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    
    scrollview.contentSize= CGSizeMake(320,2800);
    
    self.view.backgroundColor=[styles colorWithHexString:@"B9E9FF"];
   
    //////////////// FB SESSION //////////////
    
    
}

- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}





////


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    scrollview.backgroundColor=[UIColor clearColor];
    scrollview.opaque=NO;
    if([[UIScreen mainScreen] bounds].size.height != 568)
        
    {
        
        
        newview=[[UIImageView alloc]initWithFrame:CGRectMake(140, 395, 40, 55)];
        newview.image=[UIImage imageNamed:@"down_arrow.png"];
        [scrollview addSubview:newview];
        padding=395;

        scrollview.frame=CGRectMake(0, 15, 320, 465);
        
        
    }
    else
        
    {
        newview=[[UIImageView alloc]initWithFrame:CGRectMake(140, 480, 40, 60)];
        newview.image=[UIImage imageNamed:@"down_arrow.png"];
        [scrollview addSubview:newview];
        padding=485;

    }
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -10.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.2; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [newview.layer addAnimation:hover forKey:@"myHoverAnimation"];
}


- (IBAction)SKIP:(id)sender

{
    
    [self performSegueWithIdentifier:@"INTRO_SEARCH" sender:self];
    
}

- (IBAction)READY:(id)sender

{
    
    [self performSegueWithIdentifier:@"INTRO_SEARCH" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"INTRO_SEARCH"])
    {
       SearchViewController *feed =segue.destinationViewController;
        feed.INTRO_FLAG=1;
        feed.USER_ID=USER_ID;
        feed.TOKEN=token;
      
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did end decelerating");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [newview removeFromSuperview];
    
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    
    
    
    CGRect frame = newview.frame;
    frame.origin.y = scrollOffset+padding;
    
    
    newview.frame=frame;
    
    [scrollView addSubview:newview];
    
    
    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        
        NSLog(@"SCROLLVIEWREACHEDBOTTOM");
        [newview removeFromSuperview];
        
        // then we are at the end
    }

    //    NSLog(@"Did scroll");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    NSLog(@"Did end dragging");
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did begin decelerating");
}


@end
