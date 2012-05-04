//
//  ClassTableWrapper.h
//  Camp
//
//  Created by Quenton Cook on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "PersonScheduleViewController.h"
#import "CourseTableViewController.h"


@interface ClassTableWrapper : UIViewController {
    CourseTableViewController  * courseTableVC;
    UIToolbar * toolbar;
    UISegmentedControl *miniSegC;
	UISegmentedControl *fullSegC;
	UISegmentedControl *periSegC;
	UIToolbar *topBar;
	bool inSignUpLoop;
	
	bool hasOneOfTwoMinis;
	
	NSUInteger filterPeriod;
	NSUInteger filterFilled;
	NSUInteger filterMiniNum;
    
    UIBarButtonItem * undoButt;
    UISegmentedControl * insignupsSegCont;
    bool ignore;
}
@property (nonatomic, retain) CourseTableViewController  * courseTableVC;
@property (nonatomic, retain) UIToolbar * toolbar;
@property (nonatomic, retain) UIToolbar *topBar;
@property (nonatomic, retain) UISegmentedControl *miniSegC;
@property (nonatomic, retain) UISegmentedControl *fullSegC;
@property (nonatomic, retain) UISegmentedControl *periSegC;

@property (nonatomic) bool inSignUpLoop;

@property (nonatomic) bool hasOneOfTwoMinis;

@property (nonatomic) NSUInteger filterPeriod;
@property (nonatomic) NSUInteger filterFilled;
@property (nonatomic) NSUInteger filterMiniNum;
@property (nonatomic, retain) UIBarButtonItem * undoButt;
@property (nonatomic, retain) UISegmentedControl * insignupsSegCont;

- (void) filterByFilters;

- (void) clearPerson;
- (void) setPerson:(Person *) person;
- (void) setPersonScheduleViewController: (PersonScheduleViewController *) psvc;
- (void) toggleSignups;
- (void) undoMe;
- (void) endLoopFoPerson;
- (void) setUndoButtEnabled: (BOOL) yesOrNo;
- (void) signUpLoopProgress:(Course *) course;
- (void) periodClicked:(NSInteger) period;
@end