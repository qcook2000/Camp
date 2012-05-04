//
//  CourseTableViewController.h
//  Camp
//
//  Created by Quenton Cook on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "Person.h"
#import "PersonScheduleViewController.h"
#import "AQGridViewController.h"
@class ClassTableWrapper;
@class SpringBoardIconCell;

@interface CourseTableViewController : AQGridViewController <AQGridViewDataSource, AQGridViewDelegate, NSFetchedResultsControllerDelegate> {
    NSMutableArray * coursesTotal;
    NSMutableArray * coursesShown;
    
    ClassTableWrapper * wrapper;
    Person * person;
    PersonScheduleViewController * personScheduleViewController;
    int indexUpdating;
    
    int undosAvailable;

}

@property (nonatomic, retain) NSMutableArray *coursesShown;
@property (nonatomic, retain) NSMutableArray *coursesTotal;
@property (nonatomic, retain) Person * person;
@property (nonatomic, retain) PersonScheduleViewController * personScheduleViewController;
@property (nonatomic, retain) ClassTableWrapper * wrapper;
- (void) mocChanged:(NSNotification*)notification;
- (void) update;
- (void) filterAndSort;
- (void) filterAndSortForMiniFilter:(int) minFilter andForPeriod: (int) periodFilter andForFull:(int) fullFilter;
- (void) undoMe;
- (void) incrementUndos;

- (void) periodClicked:(NSInteger) period;


@end
