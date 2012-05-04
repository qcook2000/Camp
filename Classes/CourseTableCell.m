//
//  CourseTableCell.m
//  Camp
//
//  Created by Quenton Cook on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CourseTableCell.h"
#import "CampAppDelegate.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]  


@implementation CourseTableCell

@synthesize course;
@synthesize bimageView, fullimageView, nameLabel, locationLabel;
@synthesize fillAndLimitLabel, miniNumLabel, periodLabel;
@synthesize infoButton, infoPopController;
@synthesize infoTableController;

- (void) setCourse:(Course *) theCourse 
{
    course = theCourse;
	if (self.course != nil) {
        
		self.contentView.hidden = NO;
		int fill = [course.campers count];
		int limit = [self.course.limit integerValue];
		if (fill >= limit) {
			self.fullimageView.hidden  = NO;
		}
		else {
			self.fullimageView.hidden = YES;
		}
		self.nameLabel.text = self.course.name;
		self.locationLabel.text = self.course.location.name;
		self.fillAndLimitLabel.text = [NSString stringWithFormat:@"%d/%d", fill, limit];
		self.miniNumLabel.text = ([self.course.miniNum integerValue] == 0) ? @"" : [NSString stringWithFormat:@"M%d", [self.course.miniNum integerValue]] ;
		self.periodLabel.text = [NSString stringWithFormat:@"%d", [self.course.period integerValue]];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
		self.infoTableController.peeps = [[[[course campers] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy] autorelease];
		self.infoTableController.teachs =[[[[course counselors] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy] autorelease];
        [sortDescriptor release];
		[self.infoTableController.tableView reloadData];
	}
	else {
		self.contentView.hidden = YES;
	}

}

- (CALayer *) glowSelectionLayer
{
    return ( self.bimageView.layer );
}

- (id) initWithFrame: (CGRect) frame reuseIdentifier:(NSString *) reuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: reuseIdentifier];
    if ( self == nil )
        return ( nil );
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.contentView.opaque = NO;
    self.opaque = NO;
    
    self.selectionStyle = AQGridViewCellSelectionStyleNone;
        
    self.contentView.backgroundColor = [UIColor clearColor];
    self.infoTableController = [[InfoPopTableController alloc] initWithStyle:UITableViewStyleGrouped];
    self.infoPopController = [[UIPopoverController alloc] initWithContentViewController:infoTableController];
    self.infoPopController.popoverContentSize = CGSizeMake(250.0, 300.0);
    
    self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.infoButton addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.bimageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    self.bimageView.image = [UIImage imageNamed:@"clButton.png"];
    [self.bimageView sizeToFit];
    self.bimageView.autoresizingMask = (UIViewAutoresizingNone);
    
    
    
    self.fullimageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    self.fullimageView.image = [UIImage imageNamed:@"classFullOverlay.png"];
    self.fullimageView.hidden = YES;
    
    self.nameLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.nameLabel.font = [UIFont boldSystemFontOfSize: 20.0];
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.minimumFontSize = 10.0;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textAlignment = UITextAlignmentCenter;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.shadowColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    
    self.locationLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.locationLabel.font = [UIFont systemFontOfSize: 14.0];
    self.locationLabel.adjustsFontSizeToFitWidth = YES;
    self.locationLabel.minimumFontSize = 10.0;
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.textAlignment = UITextAlignmentLeft;
    self.locationLabel.textColor = [UIColor darkGrayColor];
    
    self.fillAndLimitLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.fillAndLimitLabel.font = [UIFont systemFontOfSize: 13.0];
    self.fillAndLimitLabel.adjustsFontSizeToFitWidth = YES;
    self.fillAndLimitLabel.minimumFontSize = 10.0;
    self.fillAndLimitLabel.backgroundColor = [UIColor clearColor];
    self.fillAndLimitLabel.textAlignment = UITextAlignmentRight;
    self.fillAndLimitLabel.textColor = [UIColor darkGrayColor];
    
    self.periodLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.periodLabel.font = [UIFont boldSystemFontOfSize: 65.0];
    self.periodLabel.adjustsFontSizeToFitWidth = YES;
    self.periodLabel.minimumFontSize = 10.0;
    self.periodLabel.backgroundColor = [UIColor clearColor];
    self.periodLabel.textAlignment = UITextAlignmentCenter;
    self.periodLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.3];    
    
    self.miniNumLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.miniNumLabel.font = [UIFont boldSystemFontOfSize: 16.0];
    self.miniNumLabel.adjustsFontSizeToFitWidth = YES;
    self.miniNumLabel.minimumFontSize = 16.0;
    self.miniNumLabel.backgroundColor = [UIColor clearColor];
    self.miniNumLabel.textAlignment = UITextAlignmentLeft;
    self.miniNumLabel.textColor = [UIColor lightGrayColor];
    
    
    self.bimageView.frame = CGRectMake(0.0, 0, 170.0, 80.0);
    
    self.fullimageView.frame = CGRectMake(0.0, 0, 170.0, 80.0);
    
    self.nameLabel.frame = CGRectMake(0.0, 26.0, 170.0, 24.0);
    self.locationLabel.frame = CGRectMake(7.0, 1.0, 158.0, 20.0);
    self.fillAndLimitLabel.frame = CGRectMake(7.0, 1.0, 158.0, 20.0);
    self.miniNumLabel.frame = CGRectMake(7.0, 55.0, 48.0, 20.0);
    self.periodLabel.frame = CGRectMake(0.0, 4.0, 170.0,70.0);
    self.infoButton.frame = CGRectMake(145.0, 54.0, 22.0,22.0);
    
    self.contentView.hidden = YES;
    [self.contentView addSubview: bimageView];
    [self.contentView addSubview: periodLabel];
    [self.contentView addSubview: nameLabel];
    [self.contentView addSubview: locationLabel];
    [self.contentView addSubview: fillAndLimitLabel];
    [self.contentView addSubview: miniNumLabel];
    [self.contentView addSubview: fullimageView];
    [self.contentView addSubview: infoButton];

    
    return ( self );
}

- (void)dealloc {
	[bimageView release];
	[fullimageView release];
	
    [nameLabel release];
	[locationLabel release];
	[fillAndLimitLabel release];
	[miniNumLabel release];
	[periodLabel release];
	
	
	[infoButton release];
	[infoPopController release];
	[infoTableController release];
	
    [super dealloc];
}

-(void)didTap:(NSString *)string {
	
	[infoPopController dismissPopoverAnimated:YES];
	
}

-(IBAction)togglePopOverController{
	if (infoPopController == nil) {
		
	}
	else if ([infoPopController isPopoverVisible]){
		[infoPopController dismissPopoverAnimated:YES];
	}
	else {
		[infoPopController presentPopoverFromRect:infoButton.frame 
										   inView:self.contentView
						 permittedArrowDirections: UIPopoverArrowDirectionAny  
										 animated:YES];
	}
	
}

- (void) infoButtonPressed{
	[self togglePopOverController];
}

- (void) shake{
    NSLog(@"Shakes");
    self.backgroundColor = [UIColor redColor];
}

@end
