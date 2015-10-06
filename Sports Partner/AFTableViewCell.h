//
//  AFTableViewCell.h
//  AFTabledCollectionView
//
//  Created by Ash Furrow on 2013-03-14.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface AFTableViewCell : UITableViewCell
{
    Styles *style_color;
}
@property (retain, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,retain)UIImageView *prof_pic;
@property(nonatomic,retain)UILabel *time_label;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *name_label;
@property(nonatomic,retain)UIView *prof_bg_view;
@property(nonatomic,retain)UILabel *feed_text;
@property(nonatomic,retain) UIButton *like_button;
@property(nonatomic,retain)UIButton *comment_button;
@property(nonatomic,retain)UIView *line_view;
@property(nonatomic,retain)UILabel *like_label;
@property(nonatomic,retain)UILabel *count_label;
@property(nonatomic,retain)UILabel *like_count_label;
@property(nonatomic,retain)UILabel *comment_count_label;
@property(nonatomic,retain)UIView *footer_view;
@property(nonatomic,retain)UILabel *photo_label;

@property(nonatomic,retain)UIImageView *imageView1;
@property(nonatomic,retain)UIImageView *imageView2;
@property(nonatomic,retain)UIImageView *imageView3;
@property(nonatomic,retain)UIImageView *imageView4;
@property(nonatomic,retain)UIImageView *imageView5;
@property(nonatomic,retain)UIImageView *imageView6;
@property(nonatomic,retain)UIImageView *imageView7;
@property(nonatomic,retain)UIImageView *imageView8;
@property(nonatomic,retain)UIImageView *imageView9;
@property(nonatomic,retain)UIImageView *imageView10;
@property(nonatomic,retain)UIScrollView *scrollview;
@property(nonatomic,retain)UIScrollView *scrollview1;
@property(nonatomic,retain)UIScrollView *scrollview2;
@property(nonatomic,retain)UIImageView *bg_image_view;

@property(nonatomic,retain)UIImageView *imageView01;
@property(nonatomic,retain)UIImageView *imageView02;
@property(nonatomic,retain)UIImageView *imageView03;
@property(nonatomic,retain)UIImageView *imageView04;
@property(nonatomic,retain)UIImageView *imageView05;
@property(nonatomic,retain)UIScrollView *scrollview3;
@property(nonatomic,retain)UIView *background_view;

@property(nonatomic,retain) UIImageView *report_image;
@end
