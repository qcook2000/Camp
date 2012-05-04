// 
//  Camper.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Camper.h"

#import "Cabin.h"
#import "Course.h"

@implementation Camper 

@dynamic newAttribute;
@dynamic courses;
@dynamic cabin;

-(NSString *) listName{
	NSString *fn = (self.firstName.length != 0) ? self.firstName : @"First Name";
	NSString *ln = (self.lastName.length != 0) ? self.lastName : @"Last Name";
	NSString *ca = (self.cabin != NULL) ? self.cabin.cabinAbbreviation : @"Cabin";
	
	return [NSString stringWithFormat:@"%@ %@, %@",fn, ln, ca];
}
-(NSString *) listSubtitle{
	return nil;
}

- (NSSet *) enrollInCourse:(Course *)course {
    NSMutableSet *courses = [NSMutableSet setWithCapacity:2];
    for (Course *oldCourse in self.courses) {
        if ([oldCourse.period isEqualToNumber:course.period] &&
            ([course.miniNum intValue] == 0 || [oldCourse.miniNum intValue] == 0 || [course.miniNum isEqualToNumber:oldCourse.miniNum])) {
            [courses addObject:oldCourse];
        }
    }
    [self removeCourses:courses];
    [self addCoursesObject:course];
    [[self managedObjectContext] save:nil];
    return courses;
}

- (void) unenrollInCourse:(Course *)course {
    [self removeCoursesObject:course];
    [[self managedObjectContext] save:nil];
}

- (BOOL) isUnderEnrolled{
    NSMutableIndexSet * pers = [NSMutableIndexSet indexSet];
    for (Course *course in self.courses) {
        [pers addIndex:[course.period intValue]];
    }
    for (int i = 1; i <=4; i++) {
        if (![pers containsIndex:i]) {
            return YES;
        }
    }
    return NO;
}




@end
