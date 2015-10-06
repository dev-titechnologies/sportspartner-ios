//
//  SQLFunction.h
//  Unii
//
//  Created by Ti Technologies on 07/01/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SQLFunction : NSObject
{
    sqlite3 *sports_db;
    NSString *databasePath;
    NSInteger message_count_db;

   
}

@property(nonatomic,retain)NSString *userToken;
@property(nonatomic,retain)NSMutableArray *sports_array;
@property(nonatomic,retain)NSMutableArray *all_sports_array;
@property(nonatomic,retain)NSData *small_icon_data;
@property(nonatomic,retain)NSData *profile_image_data;
@property(nonatomic,retain)NSData *cover_image_data;
@property(nonatomic,readwrite)NSInteger userID;
@property(nonatomic,retain)NSString *display_name;
@property(nonatomic,retain)NSString *chat_status;
@property(nonatomic,retain)NSString *univ_name;
@property(nonatomic,retain)NSMutableArray *PREVIOU_MESSAGE_ARRAY;

@property(nonatomic,readwrite)NSInteger sports_id;
@property(nonatomic,retain)NSString *sports_name;
@property(nonatomic,retain)NSString *f_chat_status;
@property(nonatomic,retain)NSData *f_img_data;
@property(nonatomic,readwrite)NSInteger offline_msg_count;
@property(nonatomic,retain)NSString *sender_iid;
@property(nonatomic,retain)NSString *receiver_iid;
@property(nonatomic,retain)NSString *message_type;
@property(nonatomic,retain)NSString *message;
@property(nonatomic,retain)NSString *date;
@property(nonatomic,retain)NSString *delivery_status;
@property(nonatomic,retain)NSMutableArray *f_usr_id_im_array;
@property(nonatomic,retain)NSMutableArray *f_user_id_array;
@property(nonatomic,readwrite)NSInteger total_msg_count;
@property(nonatomic,retain)NSString *user_name;
@property(nonatomic,retain)NSString *first_name;
@property(nonatomic,retain)NSString *last_name;

#pragma LOGIN_TABLE FUNCTIONS

- (void)loadLoginSqlLiteDB;
- (void)SaveToLogintable:(NSInteger)userID tokenValue:(NSString *)tokenValue  tokenStatus:(NSString *)tokenStatus user_name :(NSString *)username password:(NSString *)password;
- (void)UpdateToLoginDataBase:(NSInteger)userID tokenValue:(NSString *)tokenValue  tokenStatus:(NSString *)tokenStatus;
- (BOOL)SearchFromLoginTable;
- (void)updateLoginTable;
-(void)DeleteFromLoginTable:(NSInteger)user_id;
-(void)DELETE_ALL_LOGIN_DATA;


#pragma Favourite listing Function

-(void)load_sports_list;
-(void)saves_sports_list:(NSInteger)user_id spots_name:(NSString *)name sports_id:(NSInteger)sports_iid;
-(void)search_sports_list_Feed:(NSInteger)user_id;
-(void)delete_sports_list_Feed:(NSInteger)user_id;
-(void)delete_selected_sports:(NSInteger)sports_iid userid:(NSInteger)iid;


#pragma ALL listing Function

-(void)load_all_sports_list;
-(void)saves_all_sports_list:(NSString *)name sports_id:(NSInteger)sports_iid image:(NSData *)image_data;
-(void)search_all_sports_list_Feed;
-(void)delete_all_sports_list_Feed;

-(void)SP_ALL_SPORTS;

-(void)SP_ALL_SPORTS_SAVE:(NSInteger)user_id sports:(NSString *)sports;

-(NSString *)SEARCH_ALL_SPORTS;


#pragma Profile Details Functions

-(void)loadUserDetailsTable;
-(void)saveToUserDetailsTable:(NSInteger)user_id name:(NSString *)name age :(NSString *)age place :(NSString *)place profile_pic:(NSData *) profile_pic like_count:(NSInteger)like_count msg_count:(NSInteger)msg_count notif_ccount:(NSInteger)notif_count follower_count:(NSInteger)follow_count latitude:(NSString *)latitude longitude:(NSString *)longitude gender:(NSString *)gender tag_line:(NSString*)tag;
-(NSMutableDictionary *)searchUserDetailsTable:(NSInteger)user_id;
-(void)loadStatTable;
-(void)saveToStatTable;
-(void)updateuserDetails:(NSInteger)user_id profile_status:(NSString *)status;
-(BOOL)getFromStatTable;
-(void)DELETE_PROFILE_DETAILS;
-(void)UpdateUserDetailsTable:(NSInteger)user_id  profile_pic:(NSData *) profile_pic;
-(void)UPDATE_TAGLINE:(NSInteger)user_id  tagline:(NSString *) tag;

#pragma FEED FUNCTION
-(void)updateUser;
-(void)LOAD_FEED_TABLE;
-(void)SAVE_TO_FEED :(NSInteger)user_id image:(NSData *)image like_status:(NSString *)like_status location:(NSString *)location post_id:(NSString *)post_id post_total_comment_count:(NSInteger)post_total_comment_count post_total_like_count:(NSInteger)post_total_like_count poster_id :(NSInteger)poster_id poster_name:(NSString *)poster_name poster_picture:(NSData *)poster_picture text_message:(NSString *)text_message time:(NSString *)time type:(NSString *)type video:(NSString *)video video_thumb_image:(NSData *)video_thumb_image;
-(NSMutableArray *)SEARCH_FEED_TABLE:(NSInteger)user_id;
-(void)DELETE_ALL_FEED_DATA;

@end
