// 
//  Area.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Area.h"

#import "Course.h"

@implementation Area 

@dynamic name;
@dynamic coursesInArea;

-(NSString *) listName{
	NSString *fn = (self.name.length != 0) ? self.name : @"Area Name";

	return [NSString stringWithFormat:@"%@",fn];
}

@end
