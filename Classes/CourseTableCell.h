//
//  CBViewController.h
//  HVC
//
//  Created by Quenton Cook on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"
#import "Course.h"
#import "Person.h"
#import "Location.h"

#import "InfoPopTableController.h"

@interface CourseTableCell : AQGridViewCell {
	UIImageView * bimageView;
	UIImageView * fullimageView;
	
    UILabel * nameLabel;
	UILabel * locationLabel;
	UILabel * fillAndLimitLabel;
	UILabel * miniNumLabel;
	UILabel * meriodLabel;
	
	Course * course;
 	
	UIButton * infoButton;
	UIPopoverController *infoPopController;
	InfoPopTableController *infoTableController;
    
    BOOL initialized;
	
}
@property (nonatomic, retain) UIImageView * bimageView;
@property (nonatomic, retain) UIImageView * fullimageView;

@property (nonatomic, retain) UILabel * nameLabel;
@property (nonatomic, retain) UILabel * locationLabel;
@property (nonatomic, retain) UILabel * fillAndLimitLabel;
@property (nonatomic, retain) UILabel * miniNumLabel;
@property (nonatomic, retain) UILabel * periodLabel;

@property (nonatomic, retain) Course * course;

@property (nonatomic, retain) UIButton * infoButton;
@property (nonatomic, retain) UIPopoverController *infoPopController;
@property (nonatomic, retain) InfoPopTableController *infoTableController;

- (IBAction) togglePopOverController;
- (void) shake;

@end
