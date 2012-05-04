//
//  ScheduleCourseCell.h
//  Camp
//
//  Created by Quenton Cook on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"


@interface ScheduleCourseCell : UITableViewCell {
    Course *course;
}

@property (nonatomic, retain) Course * course;

@end
