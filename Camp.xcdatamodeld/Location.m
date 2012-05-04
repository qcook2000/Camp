// 
//  Location.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

#import "Course.h"

@implementation Location 

@dynamic name;
@dynamic coursesInLocation;

-(NSString *) listName{
	NSString *fn = (self.name.length != 0) ? self.name : @"Location Name";

	return [NSString stringWithFormat:@"%@",fn];
}

@end
