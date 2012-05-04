//
//  TextFieldCell.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TextFieldCell.h"


@implementation TextFieldCell

@synthesize textField, originalText;

- (void) reCreateWith:(NSManagedObject *)theManagedObject andKey: (NSString *)thekey andLabel: (NSString *)thelabel{
	self.currentManagedObject = theManagedObject;
	self.key = thekey;
	self.textLabel.text = thelabel;
	self.textField.text = [currentManagedObject valueForKey:key];
    self.textField.returnKeyType = UIReturnKeyDone;
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
	if (self.textField.text != NULL && self.textField.text.length > 0) {
		self.textField.text = [self.textField.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[self.textField.text substringToIndex:1] capitalizedString] ];
	}
	if ([(NSString*)[currentManagedObject valueForKey:key] isEqualToString:self.textField.text]) {
		return;
	}
    self.entityEditor.saveNeeded = YES;
    [self.currentManagedObject setValue:self.textField.text forKey:self.key];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[self.textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:self.originalText]) {
        self.entityEditor.saveNeeded = NO;
    }
    else {
        self.entityEditor.saveNeeded = YES;
    }
    [self.currentManagedObject setValue:self.textField.text forKey:self.key];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)thetextField{
    self.originalText = thetextField.text;
	[self.entityEditor newFirstResponder:textField];
}

- (void) resign {
	if (self.textField.text != NULL && self.textField.text.length > 0) {
		self.textField.text = [self.textField.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[self.textField.text substringToIndex:1] capitalizedString] ];
	}
	[self.textField resignFirstResponder];

	if ([(NSString*)[currentManagedObject valueForKey:key] isEqualToString:self.textField.text]) {
		return;
	}
    [self.currentManagedObject setValue:self.textField.text forKey:self.key];
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UITextField *stringTextField = [[UITextField alloc] initWithFrame:CGRectMake(188, 5, 462, 35)];
		stringTextField.adjustsFontSizeToFitWidth = YES;
		stringTextField.textColor = [UIColor blackColor];
		stringTextField.keyboardType = UIKeyboardTypeDefault;
		stringTextField.backgroundColor = [UIColor clearColor];
		stringTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
		stringTextField.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
		stringTextField.textAlignment = UITextAlignmentLeft;
		stringTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		stringTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
		stringTextField.delegate = self;
		[stringTextField setEnabled: YES];
		[self addSubview:stringTextField];
		textField = stringTextField;
		[textField addTarget:self action:@selector(updateAndSave) forControlEvents:UIControlEventValueChanged];
		[stringTextField release];		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (selected) {
		[self.textField becomeFirstResponder];
	}
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[textField release];
    [originalText release];
    [super dealloc];
}


@end
