//
//  Counselor.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Person.h"

@class Cabin;
@class Course;

@interface Counselor :  Person <QCPerson>
{
}

@property (nonatomic, retain) NSSet* courses;
@property (nonatomic, retain) Cabin * cabin;

@end


@interface Counselor (CoreDataGeneratedAccessors)
- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)value;
- (void)removeCourses:(NSSet *)value;

@end

