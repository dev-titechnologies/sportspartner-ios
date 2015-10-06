

//
//  SQLFunction.m
//  Unii
//
//  Created by Ti Technologies on 07/01/14.
//  Copyright (c) 2014 Ti Technologies. All rights reserved.
//

#import "SQLFunction.h"

@implementation SQLFunction

@synthesize userToken,small_icon_data,profile_image_data,cover_image_data,userID,display_name,chat_status,univ_name,sports_name,sports_id,f_chat_status,f_img_data,offline_msg_count,sender_iid,receiver_iid,message,message_type,date,PREVIOU_MESSAGE_ARRAY,delivery_status,f_user_id_array,f_usr_id_im_array,total_msg_count,user_name,first_name,last_name,sports_array,all_sports_array;



#pragma LOGIN_TABLE

-(void) loadLoginSqlLiteDB{
    @try {
        NSLog(@"LOGIN TABLE LOADING");
        NSString *docsDir;
        NSArray *dirPaths;
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"sports.sqlite"]];
        NSLog(@"DBPATH%@",databasePath);
        NSFileManager *filemgr = [NSFileManager defaultManager];
        if ([filemgr fileExistsAtPath:databasePath] == NO)
        {
            
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK)
            {
                char *errMsg;
                
                const char *sql_stmt="CREATE TABLE IF NOT EXISTS LOGIN(LOGIN_ID INTEGER PRIMARY KEY AUTOINCREMENT, USER_ID INTEGER, USER_TOKEN TEXT,LOGIN_STATUS TEXT,LOGIN_TIME TEXT,USER_NAME TEXT,PASSWORD TEXT)";
                
                if (sqlite3_exec(sports_db, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
                {
                }
                
                 sqlite3_close(sports_db);
            }
            NSLog(@"LOGIN TABLE LOADING 2");
            
        }
    }
    @catch (NSException *exception) {
    }
    
    
}

-(NSString*)getCurrentTime{
    @try {
        NSDateFormatter *formatter;
        NSString        *currentTime;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        currentTime = [formatter stringFromDate:[NSDate date]];
        return currentTime;
        
    }
    @catch (NSException *exception) {
    }
}


- (void)SaveToLogintable:(NSInteger)userID1 tokenValue:(NSString *)tokenValue  tokenStatus:(NSString *)tokenStatus user_name :(NSString *)username password:(NSString *)password
{
    @try {
        
        ////////// DELETE LOGIN DATA //////////
        NSLog(@"USERID :%d",userID1);
        
        sqlite3_stmt *delstatement1;
        const char *dbpath1 = [databasePath UTF8String];
        if (sqlite3_open(dbpath1, &sports_db)==SQLITE_OK) {
            
            //
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE  FROM LOGIN"];
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(sports_db, delete_stmt, -1, &delstatement1, NULL);
            if (sqlite3_step(delstatement1)==SQLITE_DONE)
            {
                NSLog(@"DATA DELETED");
            }
            else
            {
            }
        }
        
        /////// END /////////////////
        
        
       NSLog(@"LOGIN TABLE LOADING");
        NSString *currentTime = [self getCurrentTime];
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            
        
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO LOGIN (USER_ID,USER_TOKEN,LOGIN_STATUS,LOGIN_TIME,USER_NAME,PASSWORD) VALUES(\"%ld\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",(long)userID1,tokenValue,tokenStatus,currentTime,username,password];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(sports_db, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"DATA SAVED");
            }
            else
            {
            }
            sqlite3_finalize(statement);
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
    
    
}
- (void)UpdateToLoginDataBase:(NSInteger)userID tokenValue:(NSString *)tokenValue  tokenStatus:(NSString *)tokenStatus
{
    @try {
        sqlite3_stmt *statement;
        NSString *login=@"log_opopopstatus";
        NSInteger lid = 6;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE LOGIN SET USER_TOKEN='%@' LOGIN_STATUS='%@' where LOGIN_ID=?",tokenValue,login];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(sports_db, insert_stmt, -1, &statement, NULL);
            sqlite3_bind_int(statement, 1, lid);
            if (sqlite3_step(statement)==SQLITE_DONE) {
            }
            else
            {
            }
            sqlite3_finalize(statement);
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
    
    
    
}
- (BOOL)SearchFromLoginTable 
{
    @try {
         NSString *loginStatus=@"1";
        BOOL status = false;
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        
        
        if (sqlite3_open(dbpath, &sports_db) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT * from LOGIN where LOGIN_STATUS=\"%@\"",loginStatus];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(sports_db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    userID = sqlite3_column_int(statement,1);
                    userToken = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                    user_name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                    status = true;
                }
                else
                {
                    status = false;
                    
                }
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(sports_db);
        }
        return status;
    }
    @catch (NSException *exception) {
    }
    
    
}

-(void)DeleteFromLoginTable:(NSInteger)user_id
{
    @try {
        sqlite3_stmt *delstatement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM LOGIN where USER_ID=\"%d\"",user_id];
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(sports_db, delete_stmt, -1, &delstatement, NULL);
            if (sqlite3_step(delstatement)==SQLITE_DONE)
            {
                sqlite3_finalize(delstatement);
            }
            else
            {
            }
            
            
        }
    }
    @catch (NSException *exception) {
    }
}

- (void)updateLoginTable
{
    @try {
        NSString *loginStatus = @"FALSE";
        NSString *currentLoginStatus = @"TRUE";
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE UNII_LOGIN SET LOGIN_STATUS='%@' where LOGIN_STATUS='%@'",loginStatus,currentLoginStatus];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(sports_db, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement)==SQLITE_DONE) {
            }
            else
            {
            }
            sqlite3_finalize(statement);
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
    
    
    
}

-(void)DELETE_ALL_LOGIN_DATA
{
    @try {
        sqlite3_stmt *delstatement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM LOGIN"];
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(sports_db, delete_stmt, -1, &delstatement, NULL);
            if (sqlite3_step(delstatement)==SQLITE_DONE)
            {
            }
            else
            {
                
            }
            
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
}


//////////// FAVOURITE LIST FUNCTION //////////////


-(void)load_sports_list
{
    @try {
        NSString *docsDir;
        NSArray *dirPaths;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"sports.sqlite"]];
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SPORTS_LIST(ID INTEGER PRIMARY KEY AUTOINCREMENT,USER_ID INTEGER,NAME TEXT,SPORTS_ID INTEGER)";
            if (sqlite3_exec(sports_db, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
            }
            else
            {
            }
            
            sqlite3_close(sports_db);
        }
        else
        {
            
        }
     
        
    }
    @catch (NSException *exception) {
    }
}
-(void)saves_sports_list:(NSInteger)user_id spots_name:(NSString *)name sports_id:(NSInteger)sports_iid
{
    @try
    {
        
        sqlite3_stmt *compiledStmt;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            
            NSString *insertSQL=@"INSERT INTO SPORTS_LIST(USER_ID,NAME,SPORTS_ID) VALUES(?,?,?)";
            if(sqlite3_prepare_v2(sports_db,[insertSQL cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStmt, NULL) == SQLITE_OK)
            {
                
                sqlite3_bind_int(compiledStmt, 1, user_id);
                sqlite3_bind_text(compiledStmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStmt, 3, sports_iid);
                if(sqlite3_step(compiledStmt) != SQLITE_DONE )
                {
                    
                }
                else
                {
                }
                
                sqlite3_finalize(compiledStmt);
            }
            
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
}
-(void)delete_sports_list_Feed:(NSInteger)user_id
{
    sqlite3_stmt *delstatement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM SPORTS_LIST WHERE USER_ID =\"%ld\"",(long)user_id];
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(sports_db, delete_stmt, -1, &delstatement, NULL);
        if (sqlite3_step(delstatement)==SQLITE_DONE)
        {
            
        }
        else
        {
            
        }
        sqlite3_finalize(delstatement);
        sqlite3_close(sports_db);
    }
    
}

-(void)delete_selected_sports:(NSInteger)sports_iid userid:(NSInteger)iid
{
    NSLog(@"SP DELETE");
    sqlite3_stmt *delstatement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM SPORTS_LIST WHERE SPORTS_ID =\"%ld\" AND USER_ID =\"%ld\"",(long)sports_iid,(long)iid];
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(sports_db, delete_stmt, -1, &delstatement, NULL);
        if (sqlite3_step(delstatement)==SQLITE_DONE)
        {
        }
        else
        {
        }
        sqlite3_finalize(delstatement);
        sqlite3_close(sports_db);
    }
 
}
-(void)search_sports_list_Feed:(NSInteger)user_id;
{
    @try {
        sports_array=[[NSMutableArray alloc]init];
        sqlite3_stmt *compiledStmt;
        NSMutableDictionary *dict;
        if(sqlite3_open([databasePath UTF8String], &sports_db)==SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM SPORTS_LIST WHERE USER_ID =\"%ld\"",(long)user_id];
            const char *insertSQL = [query UTF8String];
            if(sqlite3_prepare_v2(sports_db,insertSQL, -1, &compiledStmt, NULL) == SQLITE_OK){
                int i=1;
                while (sqlite3_step(compiledStmt) == SQLITE_ROW)
                {
                    dict = [[NSMutableDictionary alloc]init];
                    i++;
                    sports_id = sqlite3_column_int(compiledStmt,3);
                    sports_name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(compiledStmt, 2)];
                    NSString *user_id_string=[NSString stringWithFormat:@"%ld",(long)sports_id];
                    [dict setObject:user_id_string forKey:@"id"];
                    [dict setObject:sports_name forKey:@"displayname"];
                    [sports_array addObject:dict];
                }
                sqlite3_finalize(compiledStmt);
            }
            
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
    
}


/////////////////// ALLL SPORTS LIST //////////////////

-(void)SP_ALL_SPORTS
{
    @try {
        NSString *docsDir;
        NSArray *dirPaths;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"sports.sqlite"]];
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SP_ALL_SPORTS_LIST(ID INTEGER PRIMARY KEY AUTOINCREMENT,SPORTS TEXT)";
            if (sqlite3_exec(sports_db, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
            }
            else
            {
            }
            
            sqlite3_close(sports_db);
        }
        else
        {
            
        }
        
    }
    @catch (NSException *exception) {
    }

}

-(void)SP_ALL_SPORTS_SAVE:(NSInteger)user_id sports:(NSString *)sports
{
    @try {
        sqlite3_stmt *compiledStmt;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            
            NSString *insertSQL=@"INSERT INTO SP_ALL_SPORTS_LIST(SPORTS) VALUES(?)";
            if(sqlite3_prepare_v2(sports_db,[insertSQL cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStmt, NULL) == SQLITE_OK)
            {
                
                sqlite3_bind_text(compiledStmt, 1, [sports UTF8String], -1, SQLITE_TRANSIENT);
              
                if(sqlite3_step(compiledStmt) != SQLITE_DONE )
                {
                }
                else
                {
                }
                
                sqlite3_finalize(compiledStmt);
            }
            
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
 
}

-(NSString *)SEARCH_ALL_SPORTS
{
    @try {
        
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        NSString *sports_string;
        if (sqlite3_open(dbpath, &sports_db) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT * from SP_ALL_SPORTS_LIST"];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(sports_db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                  
                    sports_string = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                    
                }
                else
                {
                    
                }
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(sports_db);
        }
        return sports_string;
    }
    @catch (NSException *exception)
    
    {
        
    }
}

-(void)load_all_sports_list
{
    @try {
        NSString *docsDir;
        NSArray *dirPaths;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"sports.sqlite"]];
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SP_ALL_SPORTS_LIST(ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,SPORTS_ID INTEGER,SPIMAGE BLOB)";
            if (sqlite3_exec(sports_db, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
            }
            else
            {
            }
            
            sqlite3_close(sports_db);
        }
        else
        {
            
        }
        
    }
    @catch (NSException *exception) {
    }
}
-(void)saves_all_sports_list:(NSString *)name sports_id:(NSInteger)sports_iid image:(NSData *)image_data;
{
    @try {
        sqlite3_stmt *compiledStmt;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            
            NSString *insertSQL=@"INSERT INTO SP_ALL_SPORTS_LIST(NAME,SPORTS_ID,SPIMAGE) VALUES(?,?,?)";
            if(sqlite3_prepare_v2(sports_db,[insertSQL cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStmt, NULL) == SQLITE_OK)
            {
               
                sqlite3_bind_text(compiledStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStmt, 2, sports_iid);
                sqlite3_bind_blob(compiledStmt, 3, [image_data bytes], [image_data length], SQLITE_TRANSIENT);
                if(sqlite3_step(compiledStmt) != SQLITE_DONE )
                {
                }
                else
                {
                }
                
                sqlite3_finalize(compiledStmt);
            }
            
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
}
-(void)delete_all_sports_list_Feed
{
    sqlite3_stmt *delstatement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM SP_ALL_SPORTS_LIST"];
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(sports_db, delete_stmt, -1, &delstatement, NULL);
        if (sqlite3_step(delstatement)==SQLITE_DONE)
        {
          
            
        }
        else
        {
            
        }
        sqlite3_finalize(delstatement);
        sqlite3_close(sports_db);
    }
    
}
-(void)search_all_sports_list_Feed;
{
    @try {
        all_sports_array=[[NSMutableArray alloc]init];
        NSData *i_data;
        sqlite3_stmt *compiledStmt;
        NSMutableDictionary *dict;
        if(sqlite3_open([databasePath UTF8String], &sports_db)==SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"SELECT * FROM ALL_SPORTS_LIST"];
            const char *insertSQL = [query UTF8String];
            if(sqlite3_prepare_v2(sports_db,insertSQL, -1, &compiledStmt, NULL) == SQLITE_OK){
                int i=1;
                while (sqlite3_step(compiledStmt) == SQLITE_ROW)
                {
                    dict = [[NSMutableDictionary alloc]init];
                    i++;
                    sports_id = sqlite3_column_int(compiledStmt,2);
                    sports_name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(compiledStmt, 1)];
                    i_data=[[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStmt, 3) length:sqlite3_column_bytes(compiledStmt, 3)];
                    NSString *user_id_string=[NSString stringWithFormat:@"%ld",(long)sports_id];
                    [dict setObject:user_id_string forKey:@"id"];
                    [dict setObject:sports_name forKey:@"displayname"];
                    [dict setObject:i_data forKey:@"s_image"];
                    [dict setObject:@"0" forKey:@"flag"];
                    [all_sports_array addObject:dict];
                }
                sqlite3_finalize(compiledStmt);
            }
            
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
    
}

#pragma USER PROFILE Functions

-(void)loadUserDetailsTable
{
    @try {
        
        NSString *docsDir;
        NSArray *dirPaths;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"sports.sqlite"]];
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS USER_DETAILS(HOME_ID INTEGER PRIMARY KEY AUTOINCREMENT,USER_ID INTEGER,NAME TEXT,AGE TEXT,PLACE TEXT,PROF_IMAGE BLOB,LIKE_COUNT INTEGER,MSG_COUNT INTEGER,NOTIF_COUNT INTEGER ,FOLLOW_COUNT INTEGER,LATITUDE TEXT,LONGITUDE TEXT,GENDER TEXT,TAG TEXT)";
            if (sqlite3_exec(sports_db, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
                
            }
            
            sqlite3_close(sports_db);
        }
        else
        {
            
        }
        
        
    }
    @catch (NSException *exception)
    {
        
    }
    
}
-(void)saveToUserDetailsTable:(NSInteger)user_id name:(NSString *)name age :(NSString *)age place :(NSString *)place profile_pic:(NSData *) profile_pic like_count:(NSInteger)like_count msg_count:(NSInteger)msg_count notif_ccount:(NSInteger)notif_count follower_count:(NSInteger)follow_count latitude:(NSString *)latitude longitude:(NSString *)longitude gender:(NSString *)gender tag_line:(NSString*)tag
{
    @try
    {
        NSLog(@"TAG LINE : %@",tag);
        
        sqlite3_stmt *compiledStmt;
        sqlite3_stmt *delstatement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            
            //
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM USER_DETAILS WHERE USER_ID ='%ld'",(long)user_id];
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(sports_db, delete_stmt, -1, &delstatement, NULL);
            if (sqlite3_step(delstatement)==SQLITE_DONE)
            {
                NSLog(@"USER DATA DELETED");
            }
            else
            {
                
            }
            
            NSLog(@"AFTER DELETE QUERY");
            
            NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO USER_DETAILS(USER_ID,NAME,AGE,PLACE,PROF_IMAGE,LIKE_COUNT,MSG_COUNT,NOTIF_COUNT,FOLLOW_COUNT,LATITUDE,LONGITUDE,GENDER,TAG) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"];
            NSLog(@"AFTER DELETE QUERYff :%@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            NSLog(@"AFTER DELETE wwww");
            if(sqlite3_prepare_v2(sports_db, insert_stmt, -1, &compiledStmt, NULL) == SQLITE_OK)
            
            {
                sqlite3_bind_int(compiledStmt, 1, user_id);
                sqlite3_bind_text(compiledStmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 3, [age UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 4, [place UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_blob(compiledStmt, 5, [profile_pic bytes], [profile_pic length], SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStmt, 6, like_count);
                sqlite3_bind_int(compiledStmt, 7, msg_count);
                sqlite3_bind_int(compiledStmt, 8, notif_count);
                sqlite3_bind_int(compiledStmt, 9, follow_count);
                sqlite3_bind_text(compiledStmt, 10, [latitude UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 11, [longitude UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 12, [gender UTF8String], -1, SQLITE_TRANSIENT);
                 sqlite3_bind_text(compiledStmt, 13, [tag UTF8String], -1, SQLITE_TRANSIENT);
                
                if(sqlite3_step(compiledStmt) != SQLITE_DONE )
                {
                } else
                {
                }
                sqlite3_finalize(compiledStmt);
            }
        }
        sqlite3_close(sports_db);
                      
    }
    @catch (NSException *exception) {
    }
    
}
-(NSMutableDictionary *)searchUserDetailsTable:(NSInteger)user_id
{
    @try {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        BOOL status=false;
        if (sqlite3_open(dbpath, &sports_db) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM USER_DETAILS WHERE USER_ID =\"%ld\"",(long)user_id];
            
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(sports_db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    NSString *name=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                    NSString *age=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                    NSString *place=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                    NSData *img_data=[[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 5) length:sqlite3_column_bytes(statement, 5)];
                    NSInteger like_count= sqlite3_column_int(statement,6);
                    NSInteger msg_count= sqlite3_column_int(statement,7);
                    NSInteger notif_count= sqlite3_column_int(statement,8);
                    NSInteger follow_count= sqlite3_column_int(statement,9);
                    NSString *latitude=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                    NSString *longitude=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                    NSString *gender=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                    NSString *tag=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                    [dict setObject:name forKey:@"name"];
                    [dict setObject:age forKey:@"age"];
                    [dict setObject:place forKey:@"place"];
                    [dict setObject:img_data forKey:@"image_data"];
                    [dict setObject:[NSNumber numberWithInt:like_count] forKey:@"like_count"];
                    [dict setObject:[NSNumber numberWithInt:msg_count] forKey:@"msg_count"];
                    [dict setObject:[NSNumber numberWithInt:notif_count] forKey:@"notif_count"];
                    [dict setObject:[NSNumber numberWithInt:follow_count] forKey:@"follow_count"];
                    [dict setObject:latitude forKey:@"lat"];
                    [dict setObject:longitude forKey:@"long"];
                    [dict setObject:gender forKey:@"gender"];
                    [dict setObject:tag forKey:@"tag"];
                    
                }
                else
                {
                    status=false;
                }
                
                sqlite3_finalize(statement);
            }
            sqlite3_close(sports_db);
        }
        return dict;
    }
    @catch (NSException *exception) {
    }
    
}

-(void)UpdateUserDetailsTable:(NSInteger)user_id  profile_pic:(NSData *) profile_pic
{
 
    
    sqlite3_stmt *updateStatement;
    
    if (sqlite3_open([databasePath UTF8String], &sports_db) == SQLITE_OK)
    {
        
        const char *sql = "UPDATE USER_DETAILS set PROF_IMAGE = ? WHERE USER_ID = ?";
        if(sqlite3_prepare_v2(sports_db, sql, -1, & updateStatement, NULL) != SQLITE_OK)
        NSLog(@"Error while creating update statement. '%s'", sqlite3_errmsg(sports_db));
        sqlite3_bind_blob(updateStatement, 1, [profile_pic bytes], [profile_pic length], SQLITE_TRANSIENT);
        sqlite3_bind_int(updateStatement, 2, user_id);
        NSLog(@"Error while updating dxcata. '%s'", sqlite3_errmsg(sports_db));
        
        if(SQLITE_DONE != sqlite3_step(updateStatement))
            
             NSLog(@"Error while updating data. '%s'", sqlite3_errmsg(sports_db));
        
        else
            NSLog(@"Successfully updated");
        
        //Reset the update statement.
        sqlite3_reset(updateStatement);
         sqlite3_finalize(updateStatement);
        sqlite3_close(sports_db);
        
    }
    else
        sqlite3_close(sports_db);
}


-(void)UPDATE_TAGLINE:(NSInteger)user_id  tagline:(NSString *) tag
{
    @try {
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE USER_DETAILS SET TAG='%@' where USER_ID =\"%ld\"",tag,(long)user_id];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(sports_db, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"USER DETAILS UPDATEDDDDDD");
            }
            else
            {
            }
            sqlite3_finalize(statement);
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception)
    {
        
    }

}

-(void)DELETE_PROFILE_DETAILS
{
    
    @try {
        
        sqlite3_stmt *delstatement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK) {
            //
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM USER_DETAILS"];
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(sports_db, delete_stmt, -1, &delstatement, NULL);
            if (sqlite3_step(delstatement)==SQLITE_DONE)
            {
                NSLog(@"USER DATA DELETED");
            }
            else
            {
            }
            
        }
        sqlite3_close(sports_db);
    }
    @catch (NSException *exception) {
    }
    
    
}

#pragma Feed Function

-(void)LOAD_FEED_TABLE
{
    @try {
        
        NSLog(@"USER DEATILS LOADING STARTED");
        NSString *docsDir;
        NSArray *dirPaths;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"sports.sqlite"]];
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS USER_FEED(HOME_ID INTEGER PRIMARY KEY AUTOINCREMENT,USER_ID INTEGER, IMAGE BLOB,LIKE_STATUS TEXT,LOCATION TEXT,LOCATION_POST_ID TEXT,COMMENT_COUNT INTEGER,LIKE_COUNT INTEGER,POSTER_ID INTEGER,POSTER_NAME TEXT,POSTER_PIC BLOB,TEXT_MESSAGE TEXT,TIME TEXT,TYPE TEXT,VIDEO TEXT,VIDEO_IMAGE BLOB)";
            if (sqlite3_exec(sports_db, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK)
            {
                
            }
            else
            {
                NSLog(@"FEED TABLE CREATED");
            }
            
            sqlite3_close(sports_db);
        }
        else
        {
            
        }
        
    }
    @catch (NSException *exception)
    {
        
    }
}
-(void)SAVE_TO_FEED :(NSInteger)user_id image:(NSData *)image like_status:(NSString *)like_status location:(NSString *)location post_id:(NSString *)post_id post_total_comment_count:(NSInteger)post_total_comment_count post_total_like_count:(NSInteger)post_total_like_count poster_id :(NSInteger)poster_id poster_name:(NSString *)poster_name poster_picture:(NSData *)poster_picture text_message:(NSString *)text_message time:(NSString *)time type:(NSString *)type video:(NSString *)video video_thumb_image:(NSData *)video_thumb_image

{
    @try
    {
      //  NSLog(@"image :%@",image);
        sqlite3_stmt *compiledStmt;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK)
        {
            NSString *insertSQL=@"INSERT INTO USER_FEED(USER_ID,IMAGE,LIKE_STATUS,LOCATION,LOCATION_POST_ID,COMMENT_COUNT,LIKE_COUNT,POSTER_ID,POSTER_NAME,POSTER_PIC,TEXT_MESSAGE,TIME,TYPE,VIDEO,VIDEO_IMAGE) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            if(sqlite3_prepare_v2(sports_db,[insertSQL cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStmt, NULL) == SQLITE_OK){
                
                sqlite3_bind_int(compiledStmt, 1, user_id);
                sqlite3_bind_blob(compiledStmt, 2, [image bytes], [image length], SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 3, [like_status UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 4, [location UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 5, [post_id UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStmt, 6, post_total_comment_count);
                sqlite3_bind_int(compiledStmt, 7, post_total_like_count);
                sqlite3_bind_int(compiledStmt, 8, poster_id);
                sqlite3_bind_text(compiledStmt, 9, [poster_name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_blob(compiledStmt, 10, [poster_picture bytes], [poster_picture length], SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 11, [text_message UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 12, [time UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 13, [type UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStmt, 14, [video UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_blob(compiledStmt, 15, [video_thumb_image bytes], [video_thumb_image length], SQLITE_TRANSIENT);
                if(sqlite3_step(compiledStmt) != SQLITE_DONE )
                {
                     NSLog(@"FEED SAVE NOT");
                } else
                {
                }
                
                sqlite3_finalize(compiledStmt);
            }
        }
        sqlite3_close(sports_db);
        
    }
    @catch (NSException *exception)
    {
        
    }
 
}
-(NSMutableArray *)SEARCH_FEED_TABLE:(NSInteger)user_id
{
    @try {
        NSMutableArray *sub_image_array=[[NSMutableArray alloc]init];
        NSMutableArray *feed_array=[[NSMutableArray alloc]init];
        NSMutableDictionary *dict;
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &sports_db) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM USER_FEED WHERE USER_ID =\"%ld\"",(long)user_id];
            
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(sports_db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    sub_image_array=[[NSMutableArray alloc]init];
                    int i;
                    i++;
                     dict=[[NSMutableDictionary alloc]init];
                    
                    NSData *image=[[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 2) length:sqlite3_column_bytes(statement, 2)];
                    NSString *like_status=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                    NSString *location=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                    NSString *post_id=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                    NSInteger comment_count= sqlite3_column_int(statement,6);
                    NSInteger like_count= sqlite3_column_int(statement,7);
                    NSInteger poster_id= sqlite3_column_int(statement,8);
                    NSString *poster_name=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                    NSData *poster_img_data=[[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 10) length:sqlite3_column_bytes(statement, 10)];
                    NSString *message_text=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                    NSString *time=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                    NSString *type=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                    NSString *video=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                    NSData *video_img_data=[[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 15) length:sqlite3_column_bytes(statement, 15)];
                    
                    
                    if ([type isEqualToString:@"image"])
                    {
                        sub_image_array=[[NSMutableArray alloc]init];
                        [sub_image_array addObject:image];
                        [dict setObject:sub_image_array forKey:@"image"];
                        [dict setObject:like_status forKey:@"like_status"];
                        [dict setObject:location forKey:@"location"];
                        [dict setObject:post_id forKey:@"post_id"];
                        [dict setObject:[NSNumber numberWithInteger:comment_count] forKey:@"post_total_comment_count"];
                        [dict setObject:[NSNumber numberWithInteger:like_count] forKey:@"post_total_like_count"];
                        [dict setObject:[NSNumber numberWithInteger:poster_id] forKey:@"poster_id"];
                        [dict setObject:poster_name forKey:@"poster_name"];
                        [dict setObject:poster_img_data forKey:@"poster_picture"];
                        [dict setObject:message_text forKey:@"text_message"];
                        [dict setObject:time forKey:@"time"];
                        [dict setObject:type forKey:@"type"];
                        [dict setObject:video forKey:@"video"];
                        [dict setObject:video_img_data forKey:@"video_thumb_image"];
                        [feed_array addObject:dict];

                    }
                    else
                    {
                    [dict setObject:image forKey:@"image"];
                    [dict setObject:like_status forKey:@"like_status"];
                    [dict setObject:location forKey:@"location"];
                    [dict setObject:post_id forKey:@"post_id"];
                    [dict setObject:[NSNumber numberWithInteger:comment_count] forKey:@"post_total_comment_count"];
                    [dict setObject:[NSNumber numberWithInteger:like_count] forKey:@"post_total_like_count"];
                    [dict setObject:[NSNumber numberWithInteger:poster_id] forKey:@"poster_id"];
                    [dict setObject:poster_name forKey:@"poster_name"];
                    [dict setObject:poster_img_data forKey:@"poster_picture"];
                    [dict setObject:message_text forKey:@"text_message"];
                    [dict setObject:time forKey:@"time"];
                    [dict setObject:type forKey:@"type"];
                    [dict setObject:video forKey:@"video"];
                    [dict setObject:video_img_data forKey:@"video_thumb_image"];
                    [feed_array addObject:dict];
                    }
                    
                    
                }
                
                sqlite3_finalize(statement);
            }
            sqlite3_close(sports_db);
        }
        return feed_array;
    }
    @catch (NSException *exception) {
    }

}

-(void)DELETE_ALL_FEED_DATA
{
    @try {
        sqlite3_stmt *delstatement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &sports_db)==SQLITE_OK)
        {
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM USER_FEED"];
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(sports_db, delete_stmt, -1, &delstatement, NULL);
            if (sqlite3_step(delstatement)==SQLITE_DONE)
            {
                NSLog(@"FEED DELETE FUNCTION COMPLETED");
            }
            else
            {
                
            }
            
            sqlite3_close(sports_db);
        }
    }
    @catch (NSException *exception) {
    }
}

@end