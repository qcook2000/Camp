//
//  PersonSchedulePopupViewController.h
//  Camp
//
//  Created by Quenton Cook on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@class CourseTableViewController;

@interface PersonScheduleViewController : UITableViewController {
    Person * person;
    NSSet * courses; 
    CourseTableViewController * ctvc;
    NSMutableArray * caray;
    BOOL debugging;
    BOOL forParents;
    BOOL canEdit;
}

@property (nonatomic, retain) Person * person;
@property (nonatomic, retain) NSSet * courses;
@property (nonatomic, retain) CourseTableViewController * ctvc;
@property  (assign) BOOL forParents;
@property  (assign) BOOL canEdit;

+ (PersonScheduleViewController *) parentControllerForPerson:(Person *) thePerson;
+ (PersonScheduleViewController *) controllerForPerson:(Person *) thePerson;
- (void) reloadPersonsData;
- (void) updatePeriod: (NSNumber *) number;
- (void) disableEditing;

@end
