//
//  Video_Table_Cell.m
//  Sports Partner
//
//  Created by Ti Technologies on 11/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "Video_Table_Cell.h"

@implementation Video_Table_Cell
@synthesize  prof_pic,header_bg_view,name_label,time_label_text,feed_post,video_image,line_view,like_button,like_count_label,like_label,comment_button,count_label,comment_count_label,video_play_button,has_added_label;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
