//
//  DateFieldCell.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DateFieldCell.h"
#import "DatePickerController.h"


@implementation DateFieldCell
@synthesize dateHeld;
@synthesize dateLabel;
@synthesize button;
@synthesize datePicker;
@synthesize pCont, vCont;

- (void) reCreateWith:(NSManagedObject *)theManagedObject andKey: (NSString *)thekey andLabel: (NSString *)thelabel andEditable: (BOOL) editable {
	canEdit = editable;
	self.currentManagedObject = theManagedObject;
	self.key = thekey;
	self.textLabel.text = thelabel;
	self.dateHeld = (NSDate *)[currentManagedObject valueForKey:key];
	[self updateDateLabel];
}

- (void) updateDateLabel{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
	if (canEdit) {
        [formatter setTimeStyle:NSDateFormatterNoStyle];
	}
	self.dateLabel.text = [formatter stringFromDate:dateHeld];
	[formatter release];
}

- (void) updateAndSave{
	if ([dateHeld isEqualToDate:datePicker.date]) {
		return;
	}
    
	self.dateHeld = datePicker.date;
    self.entityEditor.saveNeeded = YES;
	[self.currentManagedObject setValue:dateHeld forKey:self.key];
    [self updateDateLabel];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UILabel *stringTextField = [[UILabel alloc] initWithFrame:CGRectMake(188, 4, 462, 35)];
		stringTextField.adjustsFontSizeToFitWidth = YES;
		stringTextField.textColor = [UIColor blackColor];
		stringTextField.backgroundColor = [UIColor clearColor];
		stringTextField.textAlignment = UITextAlignmentLeft;
		[self addSubview:stringTextField];
		self.dateLabel = stringTextField;
		[stringTextField release];
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(188, 5, 462, 35);
		[button addTarget:self action:@selector(showPopover) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
    }
    return self;
}

- (void) showPopover{
    [self.entityEditor newFirstResponder:nil];
	if (!canEdit) {
		return;
	}
	DatePickerController *vContTmp = [[DatePickerController alloc] initWithNibName:nil bundle:nil];
	
	[vContTmp setContentSizeForViewInPopover: CGSizeMake(320, 216)];
	UIPopoverController *pContTmp = [[UIPopoverController alloc] initWithContentViewController:vContTmp];
	
	[pContTmp presentPopoverFromRect:CGRectMake(20, 35, 1, 1) inView:self.button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	if (dateHeld != nil) {
		[vContTmp.dPicker setDate:dateHeld];
	}
	else {
		[vContTmp.dPicker setDate:[NSDate date]];
	}
	[vContTmp.dPicker addTarget:self action:@selector(updateAndSave) forControlEvents:UIControlEventValueChanged];
	
	self.datePicker = vContTmp.dPicker;
    self.vCont = vContTmp;
    self.pCont = pContTmp;
    [vContTmp release];
    [vContTmp release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (selected && canEdit) {
		[self showPopover];
	}

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [pCont release];
    [vCont release];
	[dateHeld release];
	[dateLabel release];
	[button release];
	[datePicker release];
    [super dealloc];
}


@end
