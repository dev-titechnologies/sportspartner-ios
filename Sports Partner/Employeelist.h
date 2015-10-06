//
//  Employeelist.h
//  fairoffice
//
//  Created by Ti Technologies on 04/06/15.
//  Copyright (c) 2015 Ti Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employeelist : NSObject

@property (nonatomic, retain) NSString* name;

@property (nonatomic, retain) NSString* description;

@property (nonatomic, retain) NSString* point;

-(id) initWithName:(NSString*) theName andDescription:(NSString*)theDescription point :(NSString *)point;


@end
