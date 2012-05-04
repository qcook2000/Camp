// 
//  Person.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Person.h"


@implementation Person 

@dynamic firstName;
@dynamic lastName;
@dynamic birthdate;


- (NSSet *) enrollInCourse:(Course *)course {
    return nil;
}

- (void) unenrollInCourse:(Course *)course {
}

- (BOOL) isUnderEnrolled{
    return YES;
}

@end
