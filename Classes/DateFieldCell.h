//
//  DateFieldCell.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOAttributeTableCell.h"
#import "DatePickerController.h"


@interface DateFieldCell : MOAttributeTableCell <UIPopoverControllerDelegate>{
	NSDate *dateHeld;
	UILabel *dateLabel;
	UIButton *button;
	UIDatePicker *datePicker;
	BOOL canEdit; 
    DatePickerController *vCont;
    UIPopoverController *pCont;
}

@property (nonatomic, retain) NSDate *dateHeld;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) DatePickerController *vCont;
@property (nonatomic, retain) UIPopoverController *pCont;

- (void) reCreateWith:(NSManagedObject *)theManagedObject andKey: (NSString *)thekey andLabel: (NSString *)thelabel andEditable: (BOOL) editable;

- (void) updateAndSave;

- (void) updateDateLabel;

- (void) showPopover;


@end
