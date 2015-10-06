//
//  JSMessagesViewController.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "JSDismissiveTextView.h"

#define INPUT_HEIGHT 40.0f

@interface JSMessagesViewController () <JSDismissiveTextViewDelegate>

- (void)setup;

@end



@implementation JSMessagesViewController

#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    styles=[[Styles alloc]init];
    CGSize size = self.view.frame.size;
    CGRect tableFrame;
    tableFrame = CGRectMake(0.0f, 0.0f, size.width, size.height - INPUT_HEIGHT-6);
    if ([UIScreen mainScreen].bounds.size.height !=568)
    {
        tableFrame = CGRectMake(0.0f, 0.0f, 320, 480 - INPUT_HEIGHT-6);
    }
    
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.contentInset=UIEdgeInsetsMake(60,0.0,0,0.0);
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
	[self.view addSubview:self.tableView];
	 self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"follower_bg.png"]];
     self.tableView.backgroundView=[[UIImageView    alloc]initWithImage:[UIImage imageNamed:@"follower_bg.png"]];
   
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
     containerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"320x60"]];
   // containerView.backgroundColor=[UIColor clearColor];
    //containerView.alpha=.3;
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 7, 240, 50)];
    textView.layer.cornerRadius=4.0;
    textView.layer.borderColor=[UIColor clearColor].CGColor;
    textView.layer.borderWidth=1.0;
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.returnKeyType = UIReturnKeyDefault;
    //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"What you want to say...";
    
    [self.view addSubview:containerView];
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [containerView addSubview:textView];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(containerView.frame.size.width - 57, 6, 35, 35);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:@"" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"fling.png"] forState:UIControlStateNormal];
    //[doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

}


-(void)resignTextView
{
    [self sendPressed:nil];
    textView.text=@"";
    [textView resignFirstResponder];
}
- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollToBottomAnimated:NO];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [containerView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    self.tableView = nil;
    containerView = nil;
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender
{
    
    [self.delegate sendPressed:sender
                      withText:[textView.text trimWhitespace]];
    textView.text=@"";
    [textView resignFirstResponder];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    JSAvatarStyle avatarStyle = [self.delegate avatarStyle];
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasAvatar];
    JSBubbleMessageCell *cell = (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(!cell)
        cell = [[JSBubbleMessageCell alloc] initWithBubbleType:type
                                                   bubbleStyle:bubbleStyle
                                                   avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone
                                                  hasTimestamp:hasTimestamp
                                               reuseIdentifier:CellID];
    
    if(hasTimestamp)
    {
        [cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
    }
    if(hasAvatar) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                switch (type) {
                    case JSBubbleMessageTypeIncoming:
                        [cell setAvatarImage:[self.dataSource avatarImageForIncomingMessage]];
                        break;
                        
                    case JSBubbleMessageTypeOutgoing:
                        [cell setAvatarImage:[self.dataSource avatarImageForOutgoingMessage]];
                        break;
                }
                
            });
        });
           }
    
    [cell setMessage:[self.dataSource textForRowAtIndexPath:indexPath]];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
                                          timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                             avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy])
    {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case JSMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate avatarPolicy])
    {
        case JSMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == JSBubbleMessageTypeIncoming;
            
        case JSMessagesViewAvatarPolicyBoth:
            return YES;
            
        case JSMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }
}

- (void)finishSend
{
   
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = containerView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;

                         containerView.frame = CGRectMake(inputViewFrame.origin.x,
                                                           inputViewFrameY,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - containerView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = containerView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    containerView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = containerView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    containerView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = containerView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    containerView.frame = inputViewFrame;
}


- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
}


@end