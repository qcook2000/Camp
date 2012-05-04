//
//  ScheduleCourseCell.m
//  Camp
//
//  Created by Quenton Cook on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleCourseCell.h"


@implementation ScheduleCourseCell

@synthesize course;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [course release];
    [super dealloc];
}

@end
