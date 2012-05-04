//
//  TextFieldCell.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOAttributeTableCell.h"


@interface TextFieldCell : MOAttributeTableCell <UITextFieldDelegate> {
	UITextField *textField;
    NSString *originalText;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) NSString *originalText;

- (void) reCreateWith:(NSManagedObject *)theManagedObject andKey: (NSString *)thekey andLabel: (NSString *)thelabel;

@end
