//
//  AFTableViewCell.m
//  AFTabledCollectionView
//
//  Created by Ash Furrow on 2013-03-14.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFTableViewCell.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"
@implementation AFTableViewCell
@synthesize prof_bg_view,time_label,prof_pic,feed_text,line_view,like_button,like_count_label,like_label,comment_button,count_label,comment_count_label,footer_view,imageView1,imageView9,imageView10,imageView2,imageView,imageView7,imageView6,imageView5,imageView4,imageView3,imageView8,scrollview,scrollview1,scrollview2,photo_label,bg_image_view,scrollview3,imageView01,imageView02,imageView03,imageView04,imageView05,background_view,name_label,report_image;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
    style_color=[[Styles alloc]init];
    prof_bg_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    prof_bg_view.backgroundColor=[style_color colorWithHexString:@"F0F2F1"];
    [self.contentView addSubview:prof_bg_view];
    
    prof_pic=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
   // prof_pic.image=[UIImage imageNamed:@"girl.png"];
    prof_pic.layer.cornerRadius=6.0;
    prof_pic.layer.masksToBounds=YES;
    [self.contentView addSubview:prof_pic];
    
    name_label =[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 252, 20)];
    name_label.font=[UIFont fontWithName:@"Roboto-Regular" size:19];
    name_label.textColor=[style_color colorWithHexString:terms_of_services_color];
    name_label.textAlignment=NSTextAlignmentLeft;
      //  _Name_label.numberOfLines=0;
   // [_Name_label sizeToFit];
    [self.contentView addSubview:name_label];
        
        photo_label=[[UILabel alloc]initWithFrame:CGRectMake(name_label.frame.size.width, 10, 140, 20)];
        photo_label.font=[UIFont fontWithName:@"Roboto-Regular" size:12];
        photo_label.textColor=[style_color colorWithHexString:terms_of_services_color];
        photo_label.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:photo_label];
    
    time_label=[[UILabel alloc]initWithFrame:CGRectMake(60, 33, 200, 20)];
   // time_label.text=@"One hour ago";
    time_label.font=[UIFont fontWithName:@"Roboto-Thin" size:13];
    time_label.textColor=[style_color colorWithHexString:terms_of_services_color];
        time_label.highlightedTextColor=[UIColor blackColor];
    [self.contentView addSubview:time_label];
        
        
        report_image=[[UIImageView alloc]initWithFrame:CGRectMake(286, 0, 33, 33)];
        report_image.image=[UIImage imageNamed:@"report feed.png"];
        [self.contentView addSubview:report_image];
    
    feed_text=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, 310, 40)];
   // feed_text.text=@"he profile picture can be changed as well, by clicking the camera icon appears by hovering over the profile picture";
    feed_text.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    feed_text.textColor=[UIColor grayColor];
    feed_text.numberOfLines=2;
    [self.contentView addSubview:feed_text];

        
        background_view=[[UIView alloc]initWithFrame:CGRectMake(0, 415, 320, 50)];
        background_view.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:background_view];
 
        
    like_count_label =[[UILabel alloc]initWithFrame:CGRectMake(-1, 5, 30, 30)];
//    like_count_label.text=@"5";
    like_count_label.textColor=[style_color colorWithHexString:terms_of_services_color];
    like_count_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    like_count_label.textAlignment=NSTextAlignmentRight;
    [background_view addSubview:like_count_label];
    
    like_label =[[UILabel alloc]initWithFrame:CGRectMake(34, 5, 40, 30)];
    like_label.text=@"Likes";
    like_label.textColor=[style_color colorWithHexString:terms_of_services_color];
    like_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    [background_view addSubview:like_label];
    
    comment_count_label =[[UILabel alloc]initWithFrame:CGRectMake(69, 5, 30, 30)];
//    comment_count_label.text=@"23";
    comment_count_label.textColor=[style_color colorWithHexString:terms_of_services_color];
    comment_count_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    comment_count_label.textAlignment=NSTextAlignmentRight;
    [background_view addSubview:comment_count_label];
    
    count_label =[[UILabel alloc]initWithFrame:CGRectMake(104, 5, 80, 30)];
    count_label.text=@"Comments";
    count_label.textColor=[style_color colorWithHexString:terms_of_services_color];
    count_label.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
    [background_view addSubview:count_label];
    
    like_button =[UIButton buttonWithType:UIButtonTypeCustom];
    //[[UIButton alloc]initWithFrame:CGRectMake(240, 310, 30, 30)];
    like_button.frame=CGRectMake(230, 6, 28, 28);
    like_button.titleLabel.textAlignment=NSTextAlignmentCenter;
//    like_button.layer.cornerRadius=3.0;
//    like_button.layer.masksToBounds=YES;
//    like_button.layer.borderWidth=0.50;
//    like_button.layer.borderColor=[UIColor lightGrayColor].CGColor;
    like_button.backgroundColor=[UIColor clearColor];
    like_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    [like_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-heart"] forState:UIControlStateNormal];
     [background_view addSubview:like_button];
    
    comment_button=[UIButton buttonWithType:UIButtonTypeCustom];
    comment_button.backgroundColor=[UIColor redColor];
    comment_button.frame=CGRectMake(272, 4, 70, 40);
    comment_button.contentEdgeInsets=UIEdgeInsetsMake(-11.0, -45.0, 0.0, 0.0);
//    comment_button.layer.cornerRadius=3.0;
//    comment_button.layer.masksToBounds=YES;
//    comment_button.layer.borderWidth=0.5;
//    comment_button.layer.borderColor=[UIColor lightGrayColor].CGColor;
    comment_button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    [comment_button setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-comment"] forState:UIControlStateNormal];
    comment_button.backgroundColor=[UIColor clearColor];
    [comment_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [background_view addSubview:comment_button];
    
        
    
   
    footer_view=[[UIView alloc]initWithFrame:CGRectMake(0, 460, 320, 6)];
    footer_view.backgroundColor=[UIColor whiteColor];
    //[self.contentView addSubview:footer_view];
        
        
        
        
        // Set the contentSize equal to the size of the UIImageView
        // scrollView.contentSize = imageView.scrollview.size;
      
        
        /////////// COUNT 1////////////////////
        
        imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
        imageView1.clipsToBounds=YES;
        imageView1.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView1];
        
        /////////// COUNT 2 ////////////////////
        bg_image_view=[[UIImageView alloc]initWithFrame:CGRectMake(0,100,320,300)];
        bg_image_view.image=[UIImage imageNamed:@"intro_bg.png"];
        // [self.contentView addSubview:bg_image_view];
        
        scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,100,320,300)];
        scrollview.pagingEnabled = YES;
        //scrollview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"intro_bg.png"]];
        [scrollview setShowsHorizontalScrollIndicator:NO];
        [self.contentView addSubview:scrollview];
        
        imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 300, 300)];
        imageView2.clipsToBounds=YES;
        imageView2.contentMode=UIViewContentModeScaleAspectFill;
        [scrollview addSubview:imageView2];
        
        imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(imageView2.frame.size.width+12, 0, 300, 300)];
        imageView3.contentMode=UIViewContentModeScaleAspectFill;
        imageView3.clipsToBounds=YES;
        [scrollview addSubview:imageView3];
        scrollview.contentSize = CGSizeMake(imageView2.frame.size.width+50+imageView1.frame.size.width, 300);
        
        
        /////////// COUNT 3 ////////////////////
        
        
        scrollview1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0,100,320,300)];
        scrollview1.pagingEnabled = YES;
        [scrollview1 setShowsHorizontalScrollIndicator:NO];
        [self.contentView addSubview:scrollview1];
        
        imageView8 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 300, 300)];
        imageView8.contentMode=UIViewContentModeScaleAspectFill;
        imageView8.clipsToBounds=YES;
        [scrollview1 addSubview:imageView8];
        
        imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(imageView8.frame.size.width+16, 0, 300, 300)];
        imageView4.contentMode=UIViewContentModeScaleAspectFill;
        imageView4.clipsToBounds=YES;
        [scrollview1 addSubview:imageView4];
        
        imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(622, 0,300, 300)];
        imageView5.contentMode=UIViewContentModeScaleAspectFill;
        imageView5.clipsToBounds=YES;
        [scrollview1 addSubview:imageView5];
        
        scrollview1.contentSize = CGSizeMake(940, 300);
        
        
        /////////// COUNT 4 ////////////////////
        
        scrollview2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0,100,320,300)];
        scrollview2.pagingEnabled = YES;
        [scrollview2 setShowsHorizontalScrollIndicator:NO];
        [self.contentView addSubview:scrollview2];
        
        imageView9 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 300, 300)];
        imageView9.clipsToBounds=YES;
        imageView9.contentMode=UIViewContentModeScaleAspectFill;
        [scrollview2 addSubview:imageView9];
        
        imageView10 = [[UIImageView alloc] initWithFrame:CGRectMake(315, 0, 300, 300)];
        imageView10.clipsToBounds=YES;
        imageView10.contentMode=UIViewContentModeScaleAspectFill;
        [scrollview2 addSubview:imageView10];
        
        imageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(624, 0,300, 300)];
        imageView6.contentMode=UIViewContentModeScaleAspectFill;
        imageView6.clipsToBounds=YES;
        [scrollview2 addSubview:imageView6];
        
        imageView7 = [[UIImageView alloc] initWithFrame:CGRectMake(930, 0,300, 300)];
        imageView7.clipsToBounds=YES;
        imageView7.contentMode=UIViewContentModeScaleAspectFill;
        [scrollview2 addSubview:imageView7];
        
        scrollview2.contentSize = CGSizeMake(1250, 300);
        
        
        /////////// COUNT 5 ////////////////////
        
        scrollview3 = [[UIScrollView alloc] initWithFrame:CGRectMake(0,100,320,300)];
        scrollview3.pagingEnabled = YES;
        [scrollview3 setShowsHorizontalScrollIndicator:NO];
        [self.contentView addSubview:scrollview3];
        
        imageView01 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 300, 300)];
        imageView01.clipsToBounds=YES;
        imageView01.contentMode=UIViewContentModeScaleAspectFill;
        [scrollview3 addSubview:imageView01];
        
        imageView02 = [[UIImageView alloc] initWithFrame:CGRectMake(315, 0, 300, 300)];
        imageView02.clipsToBounds=YES;
        imageView02.contentMode=UIViewContentModeScaleAspectFill;
        [scrollview3 addSubview:imageView02];
        
        imageView03 = [[UIImageView alloc] initWithFrame:CGRectMake(623, 0,300, 300)];
        imageView03.clipsToBounds=YES;
        imageView03.contentMode=UIViewContentModeScaleAspectFill;
        [scrollview3 addSubview:imageView03];
        
        imageView04 = [[UIImageView alloc] initWithFrame:CGRectMake(930, 0,300, 300)];
        imageView04.clipsToBounds=YES;
        imageView04.contentMode=UIViewContentModeScaleAspectFill;
        [scrollview3 addSubview:imageView04];
        
        imageView05 = [[UIImageView alloc] initWithFrame:CGRectMake(1237, 0,300, 300)];
        imageView05.clipsToBounds=YES;
        imageView05.contentMode=UIViewContentModeScaleAspectFill;
        [scrollview3 addSubview:imageView05];
        scrollview3.contentSize = CGSizeMake(1550, 300);

        
    }

    
    return self;
}


@end
