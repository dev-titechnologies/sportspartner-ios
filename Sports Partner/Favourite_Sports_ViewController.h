//
//  Favourite_Sports_ViewController.h
//  Sports Partner
//
//  Created by Ti Technologies on 06/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "ViewController.h"
#import "SportsCell.h"
#import "Styles.h"
#import "SQLFunction.h"
#import "connection.h"
@interface Favourite_Sports_ViewController : ViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    __weak IBOutlet UILabel *fav_spot_label;
    __weak IBOutlet UICollectionView *collectionview;
    __weak IBOutlet UIButton *go_button;
    Styles *styles;
    NSMutableArray *index_array;
    NSMutableArray *complete_sports_list;
    NSMutableArray *selected_sports_array;
    SQLFunction *sqlfunction;
    NSString *id_string;
    __weak IBOutlet UIView *networkErrorView;
    connection *connectobj;
    __weak IBOutlet UITextView *text_view;
    NSString *tag_string;
    
    UIView *t_view;
    UIView *t_view_1;
    MBProgressHUD *HUD;
    BOOL animating;
    UIImageView *imageView;
    
    __weak IBOutlet UILabel *placeholder_label;
    
    NSMutableDictionary *flag_dict;
    BOOL KEYBOARD_SHOW;
    
   
}
@property(nonatomic,retain) NSString *TOCKEN;
@property(nonatomic,readwrite)NSInteger USER_ID;
- (IBAction)GO_BUTTON_ACTION:(id)sender;

@end
