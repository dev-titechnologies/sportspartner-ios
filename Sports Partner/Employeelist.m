//
//  Employeelist.m
//  fairoffice
//
//  Created by Ti Technologies on 04/06/15.
//  Copyright (c) 2015 Ti Technologies. All rights reserved.
//

#import "Employeelist.h"

@implementation Employeelist

@synthesize name;

@synthesize description;

@synthesize point;

-(id) initWithName:(NSString *)theName andDescription:(NSString *)theDescription point :(NSString *)point
{
    self = [super init];
    if(self)
    {
        self.name = theName;
        self.description = theDescription;
        self.point=point;
        
    }
    return self;
}

@end
