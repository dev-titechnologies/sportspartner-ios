//
//  Favourite_Sports_ViewController.m
//  Sports Partner
//
//  Created by Ti Technologies on 06/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "Favourite_Sports_ViewController.h"
#import "FeedViewController.h"
#import "ViewController.h"
#import "IntroViewController.h"
#import "SBJSON.h"
#import "AFNetworking.h"
@interface Favourite_Sports_ViewController ()

@end

@implementation Favourite_Sports_ViewController

@synthesize USER_ID,TOCKEN;

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
    connectobj=[[connection alloc]init];
    styles=[[Styles alloc]init];
    fav_spot_label.font=[UIFont fontWithName:@"Roboto-Regular" size:19];
    go_button.backgroundColor=[style colorWithHexString:terms_of_services_color];
    go_button.layer.cornerRadius=4.0;
    go_button.titleLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:22];
    
    index_array=[[NSMutableArray alloc]init];
    selected_sports_array=[[NSMutableArray alloc]init];
    
    ///////////// LOCAL DB //////////////
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
     sqlfunction=[[SQLFunction alloc]init];
    [sqlfunction load_sports_list];
    
       UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer *recognizer_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer_down:)];
    recognizer_down.direction = UISwipeGestureRecognizerDirectionDown;
    recognizer_down.numberOfTouchesRequired = 1;
    recognizer_down.delegate = self;
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:recognizer_down];
    
    
       
    [sqlfunction SP_ALL_SPORTS];
    [self GET_COMPLETE_SPORTS_LIST];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
   
}
-(void)resign
{
    NSLog(@"RESIGN");
    [text_view resignFirstResponder];
}
- (void) SwipeRecognizer_down:(UISwipeGestureRecognizer *)sender {
    
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE LEFT ***");
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE RIGHT ***");
        
    }
    if ( sender.direction== UISwipeGestureRecognizerDirectionUp )
    {
        NSLog(@"SWIPE UP");
        
        [text_view resignFirstResponder];
        self.view.frame=CGRectMake(0, 0, 320, 568);
        if ([UIScreen mainScreen].bounds.size.height==480)
        {
            collectionview.frame=CGRectMake(7, 99, 306, 230);
            text_view.frame=CGRectMake(7, 340, 306, 60);
            go_button.frame=CGRectMake(20, 410, 280, 50);
            placeholder_label.frame=CGRectMake(11, 346, 244, 21);
        }
        
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionDown ){
        
        [text_view resignFirstResponder];
        self.view.frame=CGRectMake(0, 0, 320, 568);
        if ([UIScreen mainScreen].bounds.size.height==480)
        {
            collectionview.frame=CGRectMake(7, 99, 306, 230);
            text_view.frame=CGRectMake(7, 340, 306, 60);
            go_button.frame=CGRectMake(20, 410, 280, 50);
            placeholder_label.frame=CGRectMake(11, 346, 244, 21);
        }

        NSLog(@" *** SWIPE DOWN ***");
        
    }
}

- (void) SwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE LEFT ***");
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight ){
        
        NSLog(@" *** WRITE CODE FOR SWIPE RIGHT ***");
        
    }
    if ( sender.direction== UISwipeGestureRecognizerDirectionUp )
    {
        NSLog(@"SWIPE UP");
        
        [text_view resignFirstResponder];
        self.view.frame=CGRectMake(0, 0, 320, 568);
        if ([UIScreen mainScreen].bounds.size.height==480)
        {
            collectionview.frame=CGRectMake(7, 99, 306, 230);
            text_view.frame=CGRectMake(7, 340, 306, 60);
            go_button.frame=CGRectMake(20, 410, 280, 50);
            placeholder_label.frame=CGRectMake(11, 346, 244, 21);
        }

        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionDown ){
        
        [text_view resignFirstResponder];
        self.view.frame=CGRectMake(0, 0, 320, 568);
        if ([UIScreen mainScreen].bounds.size.height==480)
        {
            collectionview.frame=CGRectMake(7, 99, 306, 230);
            text_view.frame=CGRectMake(7, 340, 306, 60);
            go_button.frame=CGRectMake(20, 410, 280, 50);
            placeholder_label.frame=CGRectMake(11, 346, 244, 21);
        }

        NSLog(@" *** SWIPE DOWN ***");
        
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([UIScreen mainScreen].bounds.size.height==480)
    {
        collectionview.frame=CGRectMake(7, 99, 306, 230);
        text_view.frame=CGRectMake(7, 340, 306, 60);
        go_button.frame=CGRectMake(20, 410, 280, 50);
        placeholder_label.frame=CGRectMake(11, 346, 244, 21);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma Collection View Functions

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return complete_sports_list.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath  *)indexPath
{
    
    
    static NSString  *identifier = @"CELL";

    SportsCell *cell = (SportsCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor=[style colorWithHexString:terms_of_services_color];
    
    NSString *image_url=[connectobj image_value];
    image_url=[image_url stringByAppendingString:[[complete_sports_list objectAtIndex:indexPath.row]objectForKey:@"image"]];
    NSURL *url=[NSURL URLWithString:image_url];
    [cell.sport_image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"no_im_feed.png"]];
    
    cell.sports_name_label.text=[[complete_sports_list objectAtIndex:indexPath.row]objectForKey:@"name"];
    if ([[[complete_sports_list objectAtIndex:indexPath.row]objectForKey:@"flag"]isEqualToString:@"1"])
    {
        cell.backgroundColor=[style colorWithHexString:favourite_sports_selected_color];
    }
    else
    {
        cell.backgroundColor=[style colorWithHexString:terms_of_services_color];
    }
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    SportsCell *cell = (SportsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor=[style colorWithHexString:favourite_sports_selected_color];
    NSString *selected_index=[[complete_sports_list objectAtIndex:indexPath.row]objectForKey:@"id"];
   // NSInteger selected_id=[[[complete_sports_list objectAtIndex:indexPath.row]objectForKey:@"sports_id"]integerValue];
    
    if(index_array.count>0)
    {
        if([index_array containsObject:selected_index])
        {
            NSLog(@"already contains");
             cell.backgroundColor=[style colorWithHexString:terms_of_services_color];
            [index_array removeObject:selected_index];
            
            NSLog(@"DIIIC : %@",[complete_sports_list objectAtIndex:indexPath.row]);
            
            [selected_sports_array removeObject:[complete_sports_list objectAtIndex:indexPath.row]];
            
            flag_dict=[[NSMutableDictionary alloc]init];
            flag_dict=[[complete_sports_list objectAtIndex:indexPath.row]mutableCopy];
            [flag_dict setObject:@"0" forKey:@"flag"];
            [complete_sports_list replaceObjectAtIndex:indexPath.row withObject:flag_dict];
            
            NSLog(@"selected sports array_1 : %@",selected_sports_array);

            

        }
        else
        {
            NSLog(@"Not containd");
          cell.backgroundColor=[style colorWithHexString:favourite_sports_selected_color];
             [index_array addObject:selected_index];
            
             NSLog(@"DIIIC1 : %@",[complete_sports_list objectAtIndex:indexPath.row]);
            
         
            
            flag_dict=[[NSMutableDictionary alloc]init];
            flag_dict=[[complete_sports_list objectAtIndex:indexPath.row]mutableCopy];
            [flag_dict setObject:@"1" forKey:@"flag"];
            [complete_sports_list replaceObjectAtIndex:indexPath.row withObject:flag_dict];
            
               [selected_sports_array addObject:[complete_sports_list objectAtIndex:indexPath.row]];
            NSLog(@"selected sports array_2 : %@",selected_sports_array);

        }
    }
    else
    {
    
        NSLog(@"VERY NEW ONE");
        
        [index_array addObject:selected_index];
        
         NSLog(@"DIIIC2 : %@",[complete_sports_list objectAtIndex:indexPath.row]);
        
        
        
        flag_dict=[[NSMutableDictionary alloc]init];
        flag_dict=[[complete_sports_list objectAtIndex:indexPath.row]mutableCopy];
        [flag_dict setObject:@"1" forKey:@"flag"];
        [complete_sports_list replaceObjectAtIndex:indexPath.row withObject:flag_dict];
        
        [selected_sports_array addObject:[complete_sports_list objectAtIndex:indexPath.row]];
        NSLog(@"selected sports array_3 : %@",selected_sports_array);
        
    }
    
    
    
    
   }

- (IBAction)GO_BUTTON_ACTION:(id)sender
{
    
    NSString *rawString = [text_view text];
    NSLog(@"TExt len:%d",[rawString length]);
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if (([text_view.text isEqualToString:@"Write something about you..."] || [text_view.text isEqualToString:@""] || [trimmed length]==0) && (index_array.count==0 || [index_array isEqual:[NSNull null]]))
    {
        [self alertStatus:@"Please enter a tagline and select atleast one sport to proceed"];
        return;
    }
    else if ([text_view.text isEqualToString:@"Write something about you..."] || [text_view.text isEqualToString:@""] || [trimmed length]==0)
    {
        [self alertStatus:@"Please enter a tagline to proceed"];
        return;
    }
    else if (index_array.count==0 || [index_array isEqual:[NSNull null]])
    {
        [self alertStatus:@"Please select atleast one sport to proceed"];
        return;
    }
   else if([rawString length] > 100)
    {
        [self alertStatus:@"Tagline should not be exceed 100 characters"];
        return;
    }
    else
    {
         [self tag_line];
        
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            networkErrorView.hidden=YES;
                id_string=[index_array componentsJoinedByString: @","];
            
                if ([connectobj string_check:TOCKEN]==true && [connectobj string_check:id_string]==true &&[connectobj int_check:USER_ID]==true)
                {
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    [param setObject:TOCKEN forKey:@"token"];
                    [param setObject:[NSNumber numberWithInt:USER_ID] forKey:@"user_id"];
                    [param setObject:id_string forKey:@"sports"];
                    
                    NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/updateusersports?"];
                    
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
                    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"URL STR IS :%@",jsonString);
                    NSURL *url=[NSURL URLWithString:url_str];
                    
                    
                    NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                    
                    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setURL:url];
                    [request setHTTPMethod:@"POST"];
                    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:postData];
                    [NSURLConnection sendAsynchronousRequest:request
                                                       queue:[NSOperationQueue mainQueue]
                                           completionHandler:^(NSURLResponse *response,
                                                               NSData *data,
                                                               NSError *connectionError) {
                                               NSLog(@"RESPONSE :%@",response);
                                               
                                               if (data==nil || [data isEqual:[NSNull null]])
                                               {
                                                   
                                               }
                                               else
                                               {
                                                   
                                                   NSDictionary *json =
                                                   [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:kNilOptions
                                                                                     error:nil];
                                                   NSLog(@"DIC is :%@",json);
                                                   
                                                   NSInteger status=[[json objectForKey:@"status"] intValue];
                                                   
                                                   if(status==1)
                                                   {
                                                       [sqlfunction delete_sports_list_Feed:USER_ID];
                                                       for (int i=0; i<selected_sports_array.count; i++)
                                                       {
                                                           [sqlfunction saves_sports_list:USER_ID spots_name:[[selected_sports_array objectAtIndex:i] objectForKey:@"name"] sports_id:[[[selected_sports_array objectAtIndex:i] objectForKey:@"id"]intValue]];
                                                       }
                                                       
                                                       [sqlfunction search_sports_list_Feed:USER_ID];
                                                       [self performSegueWithIdentifier:@"FAV_INTO" sender:self];
                                                   }
                                                   else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                                   {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                                           [self presentViewController:view_control animated:YES completion:nil];
                                                       });
                                                       
                                                   }
                                                   else
                                                   {
                                                       
                                                   }
                                                   if (connectionError)
                                                   {
                                                       UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error in network" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                                       [alert show];
                                                       NSLog(@"error detected:%@", connectionError.localizedDescription);
                                                   }
                                               }
                                           }];
                }
                else
                {
                    
                    [self alertStatus:@"Server Error"];
                    return;
                }
            
        }
        else
        {
            networkErrorView.hidden=YES;
            [self alertStatus:@"Error in network connection"];
            return;
        }

    }
    
    
}

-(void)tag_line
{
    NSLog(@"In TAG");
    BOOL netStatus = [connectobj checkNetwork];
    if(netStatus == true)
    {
        networkErrorView.hidden=YES;
        if ([text_view.text isEqualToString:@""])
        {
            tag_string=@"Hi Sports Parters...";
        }
        else
        {
            tag_string=text_view.text;
        }
            id_string=[index_array componentsJoinedByString: @","];
            NSLog(@"IDSTR is :%@",id_string);
            
            if ([connectobj string_check:TOCKEN]==true && [connectobj string_check:tag_string]==true &&[connectobj int_check:USER_ID]==true)
            {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:TOCKEN forKey:@"token"];
                [param setObject:[NSNumber numberWithInt:USER_ID] forKey:@"user_id"];
                [param setObject:tag_string forKey:@"tagline"];
                
                NSString *url_str=[ [connectobj value] stringByAppendingString:@"apiservices/updatetagline?"];
                
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
                NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"URL STR_TAg IS :%@",jsonString);
                NSURL *url=[NSURL URLWithString:url_str];
                
                
                NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                
                NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:url];
                [request setHTTPMethod:@"POST"];
                [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:postData];
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:[NSOperationQueue mainQueue]
                                       completionHandler:^(NSURLResponse *response,
                                                           NSData *data,
                                                           NSError *connectionError) {
                                           NSLog(@"RESPONSE :%@",response);
                                           
                                           if (data==nil || [data isEqual:[NSNull null]])
                                           {
                                               
                                           }
                                           else
                                           {
                                               
                                               NSDictionary *json =
                                               [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
                                               NSLog(@"DIC is :%@",json);
                                               
                                               NSInteger status=[[json objectForKey:@"status"] intValue];
                                               
                                               if(status==1)
                                               {
                                                   
                                               }
                                               else if([[json objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                                               {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                                                       [self presentViewController:view_control animated:YES completion:nil];
                                                   });
                                                   
                                               }
                                               else
                                               {
                                                   
                                               }
                                               if (connectionError)
                                               {
                                                   UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error in network" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                                   [alert show];
                                                   NSLog(@"error detected:%@", connectionError.localizedDescription);
                                                   
                                               }
                                           }
                                       }];
            }
            else
            {
                
                [self alertStatus:@"Server Error"];
                return;
            }
            
            
            
       
    }
    else
    {
        networkErrorView.hidden=YES;
        [self alertStatus:@"Error in network connection"];
        return;
    }

}
- (void) alertStatus:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"FAV_INTO"])
    {
        IntroViewController *feed_controller=segue.destinationViewController;
        feed_controller.USER_ID=USER_ID;
        feed_controller.token=TOCKEN;
    }
}

- (void) textViewDidBeginEditing:(UITextView *)textView1

{
    placeholder_label.hidden=YES;\
    NSLog(@"edit start");
    if ([textView1.text isEqualToString:@"Write something about you..."])
    {
        textView1.text=@"";
    }
    //    text_post_field.scrollEnabled=YES;
    textView1.tintColor=[UIColor blackColor];
    
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
     [textView resignFirstResponder];
    //  post_bg_view.hidden=YES;
    
}

-(id)init
{
    self = [super init];
    if(self){
       
    }
    
    return self;
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note
{
    KEYBOARD_SHOW=YES;
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];

    self.view.frame=CGRectMake(0, -keyboardBounds.size.height, 320, 568);
    
    if ([UIScreen mainScreen].bounds.size.height==480)
    {
        collectionview.frame=CGRectMake(7, 99, 306, 230);
        text_view.frame=CGRectMake(7, 340, 306, 60);
        go_button.frame=CGRectMake(20, 410, 280, 50);
        placeholder_label.frame=CGRectMake(11, 346, 244, 21);
    }
    // get keyboard size and loctaion
    NSLog(@"KEYBOARD SHOW");
    
   }

-(void) keyboardWillHide:(NSNotification *)note
{
    KEYBOARD_SHOW=NO;
    NSLog(@"KEYBOARD HIDE");
    if ([text_view.text isEqualToString:@""])
    {
       // text_view.text=@"Write something about you...";
    }
     self.view.frame=CGRectMake(0, 0, 320, 568);
}


-(void)GET_COMPLETE_SPORTS_LIST
{
    index_array=[[NSMutableArray alloc]init];
    
    
    if (sqlfunction.all_sports_array.count==0 || sqlfunction.all_sports_array==Nil)
    {
        BOOL netStatus = [connectobj checkNetwork];
        if(netStatus == true)
        {
            networkErrorView.hidden=YES;
            [self showPageLoader_public];
            
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *urlpath;
            urlpath=[ [connectobj value] stringByAppendingString:@"apiservices/allsports?"];
            NSURL *url=[[NSURL alloc] initWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString *a = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            if (![a isEqualToString:@""]|| ![a isEqual:[NSNull null]] || a!=nil)
            {
                SBJSON *parser=[[SBJSON alloc]init];
                NSDictionary *results=[parser objectWithString:a error:nil];
                NSInteger status=[[results objectForKey:@"status"]intValue];
                
                if(status==1)
                {
                    
                    [sqlfunction delete_all_sports_list_Feed];
                    [sqlfunction SP_ALL_SPORTS_SAVE:USER_ID sports:a];
                    complete_sports_list=[results objectForKey:@"result"];
                    
                    for (int i=0; i<complete_sports_list.count; i++)
                    {
                        flag_dict=[[NSMutableDictionary alloc]init];
                        flag_dict=[[complete_sports_list objectAtIndex:i]mutableCopy];
                        [flag_dict setObject:@"0" forKey:@"flag"];
                        [complete_sports_list replaceObjectAtIndex:i withObject:flag_dict];
                    }

                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [HUD_1 hide:YES];
                        [self stopSpin];
                        [collectionview performBatchUpdates:^{
                            [collectionview reloadSections:[NSIndexSet indexSetWithIndex:0]];
                        } completion:nil];
                        
                        [collectionview reloadData];
                        
                    });
                    
                }
                else if([[results objectForKey:@"message"] isEqualToString:@"Token expired.Login again"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD_1 hide:YES];
                        [self stopSpin];

                        ViewController *view_control=[self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
                        [self presentViewController:view_control animated:YES completion:nil];
                    });
                }
            }
                 
             });
        }
        else
        {
            networkErrorView.hidden=YES;
        }
        
    }

}

-(void)showPageLoader_public
{
    if ([[UIScreen mainScreen]bounds].size.height !=568)
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    else
    {
        t_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }
    t_view.backgroundColor=[UIColor blackColor];
    t_view.alpha=.2;
    t_view.hidden=NO;
    [self.view addSubview:t_view];
    
    t_view_1=[[UIView alloc]initWithFrame:CGRectMake(110, 209, 100, 100)];
    t_view_1.layer.cornerRadius=4.0;
    t_view_1.clipsToBounds=YES;
    t_view_1.backgroundColor=[UIColor blackColor];
    t_view_1.alpha=.4;
    [self.view addSubview:t_view_1];
    
    imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(110, 209, 100, 100) ];
    [self.view addSubview:imageView];
    imageView.animationImages = [[NSArray alloc] initWithObjects:
                                 [UIImage imageNamed:@"1.png"],
                                 [UIImage imageNamed:@"2.png"],
                                 [UIImage imageNamed:@"3.png"],
                                 [UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"5.png"],[UIImage imageNamed:@"6.png"],[UIImage imageNamed:@"7.png"],[UIImage imageNamed:@"8.png"],[UIImage imageNamed:@"9.png"],[UIImage imageNamed:@"10.png"],[UIImage imageNamed:@"11.png"],[UIImage imageNamed:@"12.png"],[UIImage imageNamed:@"13.png"],[UIImage imageNamed:@"14.png"],[UIImage imageNamed:@"15.png"],[UIImage imageNamed:@"16.png"],[UIImage imageNamed:@"17.png"],[UIImage imageNamed:@"18.png"],[UIImage imageNamed:@"19.png"],
                                 nil];
    imageView.animationDuration=5;
    [imageView startAnimating];
    
    
}

- (void) stopSpin
{
    [t_view removeFromSuperview];
    [t_view_1 removeFromSuperview];
    [imageView removeFromSuperview];
    [imageView stopAnimating];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"TEXT %@",text);
    NSLog(@"TYT: %@",textView.text);
       if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
        else {
            return NO;
        }
    }
    else if([[textView text] length] > 99 )
    {
        return NO;
    }
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView {
    // Enable and disable lblPlaceHolderText
    if ([textView.text length] > 0) {
        [textView setBackgroundColor:[UIColor whiteColor]];
        [placeholder_label setHidden:YES];
    } else {
        [textView setBackgroundColor:[UIColor whiteColor]];
        [placeholder_label setHidden:NO];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==collectionview)
    {
        if(KEYBOARD_SHOW)
        {
            
       
        if ([scrollView.panGestureRecognizer translationInView:scrollView].y > 0)
        {
            [text_view resignFirstResponder];
            self.view.frame=CGRectMake(0, 0, 320, 568);
            if ([UIScreen mainScreen].bounds.size.height==480)
            {
                collectionview.frame=CGRectMake(7, 99, 306, 230);
                text_view.frame=CGRectMake(7, 340, 306, 60);
                go_button.frame=CGRectMake(20, 410, 280, 50);
                placeholder_label.frame=CGRectMake(11, 346, 244, 21);
            }
            
        }
        else
        {
            
            
        }
            
        }
        
    }
    
}

@end
