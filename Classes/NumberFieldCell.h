//
//  DateFieldCell.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOAttributeTableCell.h"


@interface NumberFieldCell : MOAttributeTableCell <UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
	NSNumber *numberHeld;
	UILabel *numberLabel;
	UIButton *button;
	UIPickerView *numberPicker;
	NSRange range;
    UIPopoverController *pCont;
}

@property (nonatomic, retain) NSNumber *numberHeld;
@property (nonatomic, retain) UILabel *numberLabel;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIPickerView *numberPicker;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) UIPopoverController *pCont;

- (void) reCreateWith:(NSManagedObject *)theManagedObject andKey: (NSString *)thekey andLabel: (NSString *)thelabel andRange: (NSRange) theRange;

- (void) updateAndSave:(NSInteger)row;

- (void) updateNumberLabel;

- (void) showPopover;


@end
