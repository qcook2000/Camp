// 
//  QCThing.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QCThing.h"


@implementation QCThing 

@dynamic uniID;
@dynamic timeCreated;
@dynamic timeStamp;
@dynamic displayOrder;


-(NSString *) listName{
	return @"QCTHING";
}
-(NSString *) listSubtitle{
	return [NSString stringWithFormat:@"%n", self.uniID ];
}

@end
