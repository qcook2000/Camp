//
//  EntityListViewController.h
//  Camp
//
//  Created by Quenton Cook on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "OverlayViewController.h"
#import "ClassTableWrapper.h"


@interface EntityListViewController : UITableViewController 
	<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UISearchBarDelegate>
{
	bool forSignups;
	bool forEnrollments;
	bool editable;
	bool searching;
	bool letUserSelectRow;
	NSInteger sectionInsertCount;
	NSArray *styleOptionsForEnity;
    NSEntityDescription *entityForList;
	DetailViewController *detailViewController;
	NSManagedObject *formerMO;
	NSIndexPath *iPath;
	NSMutableArray *copyListOfItems;
	NSMutableArray *listOfItems;
    OverlayViewController *ovController;
	NSInteger oldSortNum;
    ClassTableWrapper *courseTable;
    UIPopoverController *infoPopController;
}

@property (nonatomic, assign) bool forSignups;
@property (nonatomic, assign) bool forEnrollments;
@property (nonatomic, assign) bool editable;
@property (nonatomic, assign) bool searching;
@property (nonatomic, assign) bool letUserSelectRow;


@property (nonatomic, retain) NSArray *styleOptionsForEnity;
@property (nonatomic, retain) ClassTableWrapper *courseTable;
@property (nonatomic, retain) NSEntityDescription *entityForList;
@property (nonatomic, retain) DetailViewController *detailViewController;
@property (nonatomic, retain) NSManagedObject *formerMO;
@property (nonatomic, retain) NSIndexPath *iPath;
@property (nonatomic, retain) OverlayViewController *ovController;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, retain) NSMutableArray *copyListOfItems;
@property (nonatomic, retain) UIPopoverController *infoPopController;


- (EntityListViewController *) initWithDictionary:(NSDictionary *) dictionary;
- (void) doneSearching_Clicked:(id) sender;
- (void) updateTotalList: (int) index;
- (void) objectUpdated:(NSManagedObject *)object;

@end
