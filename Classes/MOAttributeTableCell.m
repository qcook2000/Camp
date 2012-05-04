//
//  MOAttributeTableCell.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MOAttributeTableCell.h"


@implementation MOAttributeTableCell
@synthesize currentManagedObject, key, frController, entityEditor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		UIImageView *iV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Divider.jpg"]];
		iV.frame = CGRectMake(180, 0, 1, 44);
		[self addSubview:iV];
		[iV release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateMO {
    
}

- (void)dealloc {
	[currentManagedObject release];
	[key release];
	[frController release];
	[entityEditor release];
    [super dealloc];
}


@end
