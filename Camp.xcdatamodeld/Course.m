// 
//  Course.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Course.h"

#import "Area.h"
#import "Camper.h"
#import "Counselor.h"
#import "Location.h"

@implementation Course 

@dynamic period;
@dynamic miniNum;
@dynamic limit;
@dynamic name;
@dynamic counselors;
@dynamic area;
@dynamic location;
@dynamic campers;

-(NSString *) listName{
	NSString *fn = (self.name.length != 0) ? self.name : @"Course Name";
	
	return [NSString stringWithFormat:@"%@",fn];
}
-(NSString *) listSubtitle{
	NSString *fn = (self.location.name.length != 0) ? self.location.name : @"Location Name";
	NSString *miniStr = [self.miniNum intValue] == 0 ? @"" : [NSString stringWithFormat:@", M %i", [self.miniNum intValue]];
	return [NSString stringWithFormat:@"P: %i%@, %i/%i, %@, %@",[self.period intValue], miniStr,[self.campers count], [self.limit intValue], fn, self.area.name];
}

- (BOOL) isUnderEnrolled{
    if ([self.campers count] == 0 && [self.limit intValue] != 0) {
        return YES;
    }
    else if ([self.counselors count] == 0) {
        return YES;
    }
    return NO;
}


@end
