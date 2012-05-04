//
//  Area.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "QCThing.h"

@class Course;

@interface Area :  QCThing  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* coursesInArea;

@end


@interface Area (CoreDataGeneratedAccessors)
- (void)addCoursesInAreaObject:(Course *)value;
- (void)removeCoursesInAreaObject:(Course *)value;
- (void)addCoursesInArea:(NSSet *)value;
- (void)removeCoursesInArea:(NSSet *)value;

@end

