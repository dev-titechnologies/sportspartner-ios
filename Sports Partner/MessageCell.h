//
//  MessageCell.h
//  Sports Partner
//
//  Created by Ti Technologies on 07/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UIImageView *profile_pic;
@property(nonatomic,retain)IBOutlet UILabel *Name_label;
@property(nonatomic,retain)IBOutlet UILabel *Message_label;
@property(nonatomic,retain)IBOutlet UILabel *time_label;
@property(nonatomic,retain)IBOutlet UILabel *age_label;
@property(nonatomic,retain)IBOutlet UILabel *place_label;
@property(nonatomic,retain)IBOutlet UIButton *abuse_user_btn;
@property(nonatomic,retain)IBOutlet UIButton *chat_button;
@property (weak, nonatomic) IBOutlet UIView *side_view;
@property(nonatomic,retain)IBOutlet UIButton *like_btn;
@property(nonatomic,retain)IBOutlet UILabel *like_count;
@property(nonatomic,retain)IBOutlet UIView *like_view;
@property (weak, nonatomic) IBOutlet UIButton *follow_button;
@property(nonatomic,retain)UILabel *comment_label;
@property(nonatomic,retain)IBOutlet UIButton *like_background_button;
@property(nonatomic,retain)IBOutlet UIImageView *follow_green_tick;

@end
