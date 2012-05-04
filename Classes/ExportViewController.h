//
//  ExportViewController.h
//  Camp
//
//  Created by Quenton Cook on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateFieldCell.h"
#import "DateAndTimePickerController.h"
#import "CampInfoController.h"
#import "MBProgressHUD.h"


@interface ExportViewController : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate, MBProgressHUDDelegate> {
    
    UIDatePicker * datePicker;
    DateAndTimePickerController *datePickerController;
    UIPopoverController *popOverController;
    
    UITextField * searchField;
    UITextField * dateField;
    UITextField * outputFileFileField;
    
    UISegmentedControl * whatControl;
    UISegmentedControl * whichControl;
    
    UILabel * resultsLabel;
    
    UIButton * exportForPrint;
    
    NSArray * allCamperObjects;
    NSArray * campersSubset;
    
    NSArray * allCounselorObjects;
    NSArray * counselorsSubset;
    
    NSArray * allClassObjects;
    NSArray * classesSubset;
    
    NSEntityDescription *camperEntity;
    NSEntityDescription *counselorEntity;
    NSEntityDescription *courseEntity;
    
    NSDate * dateHeld;
    
    NSString * scratchFile;
    
    MBProgressHUD * HUD;
}



@property (nonatomic, retain) UIDatePicker * datePicker;
@property (nonatomic, retain) DateAndTimePickerController *datePickerController;
@property (nonatomic, retain) UIPopoverController *popOverController;

@property (nonatomic, retain) IBOutlet UITextField * searchField;
@property (nonatomic, retain) IBOutlet UITextField * dateField;
@property (nonatomic, retain) IBOutlet UITextField * outputFileFileField;

@property (nonatomic, retain) IBOutlet UISegmentedControl * whatControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl * whichControl;

@property (nonatomic, retain) IBOutlet UILabel * resultsLabel;

@property (nonatomic, retain) IBOutlet UIButton * exportForPrint;

@property (nonatomic, retain) NSArray * allCamperObjects;
@property (nonatomic, retain) NSArray * campersSubset;

@property (nonatomic, retain) NSArray * allCounselorObjects;
@property (nonatomic, retain) NSArray * counselorsSubset;

@property (nonatomic, retain) NSArray * allClassObjects;
@property (nonatomic, retain) NSArray * classesSubset;

@property (nonatomic, retain) NSEntityDescription *camperEntity;
@property (nonatomic, retain) NSEntityDescription *counselorEntity;
@property (nonatomic, retain) NSEntityDescription *courseEntity;

@property (nonatomic, retain) NSDate * dateHeld;

@property (nonatomic, retain) NSString * scratchFile;
@property (nonatomic, retain) MBProgressHUD * HUD;

- (NSArray *) searchForEntities:(NSEntityDescription *) entity withString:(NSString *) string;
    
- (NSArray *) searchForEntities:(NSEntityDescription *) entity withDate:(NSDate *) date;

- (IBAction) segmentedControlChange;

- (void) updateLabels;

- (IBAction) exportForPrintPressed;

- (void) exportPeople:(NSArray *) peopleToExport withTitle: (NSString *) title splittingByCabin:(BOOL) split;
- (void) exportClasses:(NSArray *) classesToExport withTitle: (NSString *) title splittingByPeriod:(BOOL) split;

- (void) appendFile:(NSString *) fileName to: (NSFileHandle *)fileHandle withTitle: (NSString *) title;

- (NSString *) htmlForPerson:(Person *) person andNumber: (int) number andCabinNumber: (int) cabinInt;

- (NSString *) htmlForCourse:(Course *) course andNumber: (int) number andPeriod: (int) period;

- (void) setOutputFileNameCorrect;

@end
