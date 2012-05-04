//
//  EntityListStyleOption.m
//  Camp
//
//  Created by Quenton Cook on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EntityListStyleOption.h"


@implementation EntityListStyleOption

@synthesize tabLabel, sectionsKey, sortKeys;

+ (EntityListStyleOption *)styleListOptionWithLabel: (NSString *) label andSectionKey: (NSString *)sectionKey andSortKeys: (NSArray *)theSortKeys{
	EntityListStyleOption *newOpt = [[[EntityListStyleOption alloc] init] autorelease];
	newOpt.sortKeys = theSortKeys;
	newOpt.tabLabel = label;
	newOpt.sectionsKey = sectionKey;
	return newOpt;
}

- (void) dealloc{
	[sectionsKey release];
	[tabLabel release];
	[sortKeys release];
	[super dealloc];
}

@end
