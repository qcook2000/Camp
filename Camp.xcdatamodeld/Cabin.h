//
//  Cabin.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "QCThing.h"

@class Camper;
@class Counselor;

@interface Cabin :  QCThing  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * cabinAbbreviation;
@property (nonatomic, retain) NSSet*  counselorsInCabin;
@property (nonatomic, retain) NSSet* campersInCabin;

@end


@interface Cabin (CoreDataGeneratedAccessors)
- (void)addCampersInCabinObject:(Camper *)value;
- (void)removeCampersInCabinObject:(Camper *)value;
- (void)addCampersInCabin:(NSSet *)value;
- (void)removeCampersInCabin:(NSSet *)value;

@end

