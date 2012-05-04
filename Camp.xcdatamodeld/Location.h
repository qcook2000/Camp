//
//  Location.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "QCThing.h"

@class Course;

@interface Location :  QCThing  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* coursesInLocation;

@end


@interface Location (CoreDataGeneratedAccessors)
- (void)addCoursesInLocationObject:(Course *)value;
- (void)removeCoursesInLocationObject:(Course *)value;
- (void)addCoursesInLocation:(NSSet *)value;
- (void)removeCoursesInLocation:(NSSet *)value;

@end

