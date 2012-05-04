//
//  MOAttributeTableCell.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityEditor.h"


@interface MOAttributeTableCell : UITableViewCell {
	NSManagedObject *currentManagedObject;
	NSString *key;
	NSFetchedResultsController *frController;
	EntityEditor *entityEditor;
}

@property (nonatomic,retain) NSManagedObject *currentManagedObject;
@property (nonatomic,retain) NSString *key;
@property (nonatomic,retain) NSFetchedResultsController *frController;
@property (nonatomic,retain) EntityEditor *entityEditor;

- (void) updateMO;
@end
