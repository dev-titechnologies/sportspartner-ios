//
//  Video_Table_Cell.h
//  Sports Partner
//
//  Created by Ti Technologies on 11/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Video_Table_Cell : UITableViewCell
@property(nonatomic,retain)IBOutlet UIView *header_bg_view;
@property(nonatomic,retain)IBOutlet UIImageView *prof_pic;
@property(nonatomic,retain)IBOutlet UILabel *name_label;
@property(nonatomic,retain)IBOutlet UILabel *time_label_text
;
@property(nonatomic,retain)IBOutlet UILabel *feed_post;
@property(nonatomic,retain)IBOutlet UIImageView *video_image;
@property(nonatomic,retain)IBOutlet UIView *like_view;

@property(nonatomic,retain)IBOutlet UIButton *like_button;
@property(nonatomic,retain) IBOutlet UIButton *comment_button;
@property(nonatomic,retain)IBOutlet UIView *line_view;
@property(nonatomic,retain)IBOutlet UILabel *like_label;
@property(nonatomic,retain) IBOutlet UILabel *count_label;
@property(nonatomic,retain)IBOutlet UILabel *like_count_label;
@property(nonatomic,retain)IBOutlet UILabel *comment_count_label;
@property (weak, nonatomic) IBOutlet UIButton *video_play_button;
@property (weak, nonatomic) IBOutlet UILabel *has_added_label;
@property(nonatomic,retain)IBOutlet UIImageView *report_image;
@end
