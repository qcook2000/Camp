//
//  QCThing.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface QCThing :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * uniID;
@property (nonatomic, retain) NSDate * timeCreated;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * displayOrder;

-(NSString *) listName;
-(NSString *) listSubtitle;


@end



