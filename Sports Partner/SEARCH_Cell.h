//
//  SEARCH_Cell.h
//  Sports Partner
//
//  Created by Ti Technologies on 13/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEARCH_Cell : UITableViewCell

@property(nonatomic,retain)IBOutlet UIImageView *profile_pic;
@property(nonatomic,retain)IBOutlet UILabel *name_label;
@property(nonatomic,retain)IBOutlet UILabel *age_label;
@property(nonatomic,retain)IBOutlet UILabel *place_label;
@property(nonatomic,retain)IBOutlet UIButton *eye_button;
@property(nonatomic,retain)IBOutlet UIButton *chat_button;
@property(nonatomic,retain)IBOutlet UIButton *eye_bacground_button;
@property(nonatomic,retain)IBOutlet UIButton *chat_background_button;

@end
