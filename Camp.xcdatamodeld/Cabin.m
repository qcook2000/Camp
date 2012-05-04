// 
//  Cabin.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Cabin.h"

#import "Camper.h"
#import "Counselor.h"

@implementation Cabin 

@dynamic name;
@dynamic cabinAbbreviation;
@dynamic counselorsInCabin;
@dynamic campersInCabin;

-(NSString *) listName{
	NSString *n = (self.name.length != 0) ? self.name : @"Name";
	NSString *a = (self.cabinAbbreviation.length != 0) ? self.cabinAbbreviation : @"Abbreviation";
	return [NSString stringWithFormat:@"%@, %@",n,a];
}
-(NSString *) listSubtitle{
	return nil;
}

- (NSComparisonResult) compare:(id) thing {
	if ([[self class] isSubclassOfClass:[thing class]]) {
		Cabin * mcab =(Cabin *) thing;
		return [self.name compare:mcab.name];
	}
	return NSOrderedSame;
}

@end
