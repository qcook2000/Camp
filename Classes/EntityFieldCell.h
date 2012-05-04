//
//  EntityFieldCell.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCThing.h"
#import "MOAttributeTableCell.h"
#import "EntityPickerController.h"



@interface EntityFieldCell : MOAttributeTableCell <UITableViewDelegate, UITableViewDataSource>{

	QCThing *moAttribute;
	UILabel *entityLabel;
	UIButton *button;
	UITableView *pickControl;
	NSArray *listOfPickerThings;
	UIPopoverController *popC;
}

@property (nonatomic, retain) QCThing *moAttribute;
@property (nonatomic, retain) UILabel *entityLabel;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UITableView *pickControl;
@property (nonatomic, retain) NSArray *listOfPickerThings;
@property (nonatomic, retain) UIPopoverController *popC;

- (void) reCreateWith:(NSManagedObject *)theManagedObject andKey: (NSString *)thekey andLabel: (NSString *)thelabel;

- (void) updateEntityLabel;

- (void) showPopover;


@end
