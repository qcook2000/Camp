//
//  SpecialQueryTable.h
//  Camp
//
//  Created by Quenton Cook on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoPopTableController.h"
#import "DetailViewController.h"

#define kSpecialQueryUnderEnrolledCounselors @"kSpecialQueryUnderEnrolledCounselors"
#define kSpecialQueryUnderEnrolledClasses @"kSpecialQueryUnderEnrolledClasses"

@interface SpecialQueryTable : UITableViewController {
    NSArray * objects;
    NSString * key;
    UIPopoverController * infoPopController;
    DetailViewController * dvc;
}

@property (nonatomic, retain) NSArray * objects;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) UIPopoverController * infoPopController;
@property (nonatomic, retain) DetailViewController * dvc;

- (id)initWithSpeialQueryKey:(NSString *) newKey andDVC:(DetailViewController *) newDVC;

@end
