//
//  ImportViewController.h
//  HVCscheduleomatic
//
//  Created by Quenton Cook on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampInfoController.h"
#import "MBProgressHUD.h"

@interface ImportViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate> {
    UISegmentedControl *areasLocationsAndCabins;
    UISegmentedControl *counselors;
    UISegmentedControl *campers;
    UISegmentedControl *courses;
    UISegmentedControl *camperEnr;
    UISegmentedControl *bMode;
    
    UIButton * clearAndLoadFromBackUp;
    UISegmentedControl * import;
    
    UILabel *clearLabel;
}


@property (nonatomic, retain) IBOutlet UISegmentedControl *areasLocationsAndCabins;
@property (nonatomic, retain) IBOutlet UISegmentedControl *counselors;
@property (nonatomic, retain) IBOutlet UISegmentedControl *campers;
@property (nonatomic, retain) IBOutlet UISegmentedControl *courses;
@property (nonatomic, retain) IBOutlet UISegmentedControl *camperEnr;
@property (nonatomic, retain) IBOutlet UISegmentedControl *bMode;

@property (nonatomic, retain) IBOutlet UIButton * clearAndLoadFromBackUp;
@property (nonatomic, retain) IBOutlet UISegmentedControl * import;

@property (nonatomic, retain) IBOutlet UILabel *clearLabel;


-(IBAction) importWithOptions;
-(IBAction) loadFromBackup;

-(IBAction) toggleEnableBackupMode;
-(IBAction) validateSegmentControls;
-(void) resetSegmentedControls;
-(void) importFailed;
@end
