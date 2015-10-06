//
//  MessageCell.m
//  Sports Partner
//
//  Created by Ti Technologies on 07/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
@synthesize profile_pic,Name_label,Message_label,age_label,place_label,abuse_user_btn,chat_button,like_btn,like_count;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.comment_label = [[UILabel alloc] initWithFrame:CGRectMake(62,35,250,25)];
        
        // Configure Main Label
        [self.comment_label setFont:[UIFont boldSystemFontOfSize:24.0]];
        [self.comment_label setTextAlignment:NSTextAlignmentCenter];
        [self.comment_label setTextColor:[UIColor orangeColor]];
        [self.comment_label setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        
        // Add Main Label to Content View
        [self.contentView addSubview:self.comment_label];
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
