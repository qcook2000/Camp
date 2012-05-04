//
//  Course.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "QCThing.h"

@class Area;
@class Camper;
@class Counselor;
@class Location;

@interface Course :  QCThing  
{
}

@property (nonatomic, retain) NSNumber * period;
@property (nonatomic, retain) NSNumber * miniNum;
@property (nonatomic, retain) NSNumber * limit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* counselors;
@property (nonatomic, retain) Area * area;
@property (nonatomic, retain) Location * location;
@property (nonatomic, retain) NSSet* campers;

@end


@interface Course (CoreDataGeneratedAccessors)
- (void)addCounselorsObject:(Counselor *)value;
- (void)removeCounselorsObject:(Counselor *)value;
- (void)addCounselors:(NSSet *)value;
- (void)removeCounselors:(NSSet *)value;

- (void)addCampersObject:(Camper *)value;
- (void)removeCampersObject:(Camper *)value;
- (void)addCampers:(NSSet *)value;
- (void)removeCampers:(NSSet *)value;

- (BOOL) isUnderEnrolled;

@end

