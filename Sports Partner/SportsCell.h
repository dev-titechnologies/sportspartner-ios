//
//  SportsCell.h
//  Sports Partner
//
//  Created by Ti Technologies on 06/08/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportsCell : UICollectionViewCell
@property(nonatomic,retain)IBOutlet UIImageView *sport_image;
@property(nonatomic,retain)IBOutlet UIImageView *prof_images;
@property(nonatomic,retain)IBOutlet UIButton *play_button;
@property(nonatomic,retain)IBOutlet UILabel *sports_name_label;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end
