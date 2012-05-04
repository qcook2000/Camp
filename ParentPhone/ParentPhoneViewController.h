//
//  ParentPhoneViewController.h
//  ParentPhone
//
//  Created by Quenton Cook on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PersonScheduleViewController.h"

@interface ParentPhoneViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate>{
    UIImageView * backgroundImage;
    UITextField * firstName;
    UITextField * lastName;
    UITextField * birthday;
    UIButton * lookupButton;
    UIView *containerView;
    UIDatePicker * datePicker;
    UIButton * clearButton;
    MBProgressHUD * HUD;
    PersonScheduleViewController * camperScheduleViewController;
    BOOL debug;
    UIButton * logout;
    UILabel * accuracyLabel;
    BOOL schedMode;
    CGPoint containerCenter;
    CGPoint backgroundCenter;
}

@property (nonatomic, retain) IBOutlet UITextField * firstName;
@property (nonatomic, retain) IBOutlet UITextField * lastName;
@property (nonatomic, retain) IBOutlet UITextField * birthday;
@property (nonatomic, retain) IBOutlet UIButton * lookupButton;
@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) UIDatePicker * datePicker;
@property (nonatomic, retain) UIButton * clearButton;
@property (nonatomic, retain) MBProgressHUD * HUD;
@property (nonatomic, retain) PersonScheduleViewController * camperScheduleViewController;
@property (nonatomic, retain) UIButton * logout;
@property (nonatomic, retain) UILabel * accuracyLabel;
@property (nonatomic, retain) UIImageView * backgroundImage;


- (void) showDatePicker;
- (void) dismissDatePicker;
- (void) updateDateLabel;
- (void) resignPickers;
- (void) lookupCamper;
- (void) updateAccuracyLabel;
- (void) downloadFailed;
- (void) backupListDownloaded;
- (void) backupDownloaded;
- (void) enterForground;
- (void) enterBackground;
- (void) logoutPressed;

@end
