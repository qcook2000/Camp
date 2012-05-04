//
//  QCPerson.h
//  Camp
//
//  Created by Quenton Cook on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"


@protocol QCPerson <NSObject>

-(NSSet *) enrollInCourse:(Course *) course;
-(void) unenrollInCourse:(Course *) course;
-(BOOL) isUnderEnrolled;

@end
