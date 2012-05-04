//
//  DateFieldCell.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NumberFieldCell.h"
#import "NumberPickerController.h"



@implementation NumberFieldCell
@synthesize numberHeld;
@synthesize numberLabel;
@synthesize button;
@synthesize numberPicker;
@synthesize range;
@synthesize pCont;

- (void) reCreateWith:(NSManagedObject *)theManagedObject andKey: (NSString *)thekey andLabel: (NSString *)thelabel andRange: (NSRange) theRange;{
	self.currentManagedObject = theManagedObject;
	self.key = thekey;
	self.textLabel.text = thelabel;
	self.numberHeld = (NSNumber *)[currentManagedObject valueForKey:key];
	self.range = theRange;
	[self updateNumberLabel];
}

- (void) updateNumberLabel{
	if ([numberHeld intValue] == -1) {
		numberLabel.text = @"";
	}
	else {
		numberLabel.text = [NSString stringWithFormat:@"%i",[numberHeld intValue]];
	}
}

- (void) updateAndSave:(NSInteger)row{
	if ([numberHeld isEqualToNumber:[NSNumber numberWithInt:row]]) {
		return;
	}
	numberHeld = [NSNumber numberWithInt:row];
    self.entityEditor.saveNeeded = YES;
    [self.currentManagedObject setValue:numberHeld forKey:self.key];
	[self updateNumberLabel];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UILabel *stringTextField = [[UILabel alloc] initWithFrame:CGRectMake(188, 4, 462, 35)];
		stringTextField.adjustsFontSizeToFitWidth = YES;
		stringTextField.textColor = [UIColor blackColor];
		stringTextField.backgroundColor = [UIColor clearColor];
		stringTextField.textAlignment = UITextAlignmentLeft;
		[self addSubview:stringTextField];
		numberLabel = stringTextField;
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
	NumberPickerController *vCont = [[[NumberPickerController alloc] initWithNibName:nil bundle:nil] autorelease];
	UIPickerView *nPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 120, 216)];
	nPicker.delegate = self;
	nPicker.dataSource = self;
	nPicker.showsSelectionIndicator = YES;
	self.numberPicker = nPicker;
	[vCont.view addSubview:self.numberPicker];
	[self.numberPicker reloadAllComponents];
	[vCont setContentSizeForViewInPopover: CGSizeMake(120, 216)];
	self.pCont = [[UIPopoverController alloc] initWithContentViewController:vCont];
    [self.pCont presentPopoverFromRect:CGRectMake(20, 20, 1, 1) inView:self.button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    if ([self.numberHeld intValue] != -1) {
		NSInteger rowToSelect = [self.numberHeld intValue];
		if (range.location == 1) {
			rowToSelect--;
		}
		[self.numberPicker selectRow:rowToSelect inComponent:0 animated:YES];
	}
	[nPicker release];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (selected) {
		[self showPopover];
	}

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (range.location == 1) {
		row++;
	}
	[self updateAndSave: row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (range.location == 1) {
		row++;
	}
	return [NSString stringWithFormat:@"%i", row];
	return @"Hello";
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	NSInteger length = range.length;
	return length;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (void)dealloc {
    [pCont release];
	[numberHeld release];
	[numberLabel release];
	[button release];
	[numberPicker release];
    [super dealloc];
}


@end
