//
//  ChangeS3ModalController.h
//  Camp
//
//  Created by Quenton Cook on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginScreenViewController.h"
#import "MBProgressHUD.h"


@interface ChangeS3ModalController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate>
{
    UILabel * titleLable;
    UITextField * oldUserName;
    UITextField * oldPassword;
    UITextField * newUserName;
    UITextField * newPassword;
    UITextField * s3AccessKey;
    UITextField * s3SecretAccessKey;
    UITextField * s3Bucket;
    UIButton * submitButton;
    UIButton * cancel;
    UIButton * resetToTest;
    LoginScreenViewController * loginSVC;
    MBProgressHUD * HUD;
    int state;
    BOOL editing;
}

@property (nonatomic, retain) IBOutlet UILabel * titleLable;
@property (nonatomic, retain) IBOutlet UITextField * oldUserName;
@property (nonatomic, retain) IBOutlet UITextField * oldPassword;
@property (nonatomic, retain) IBOutlet UITextField * newUserName;
@property (nonatomic, retain) IBOutlet UITextField * newPassword;
@property (nonatomic, retain) IBOutlet UITextField * s3AccessKey;
@property (nonatomic, retain) IBOutlet UITextField * s3SecretAccessKey;
@property (nonatomic, retain) IBOutlet UITextField * s3Bucket;
@property (nonatomic, retain) IBOutlet UIButton * submitButton;
@property (nonatomic, retain) IBOutlet UIButton * cancel;
@property (nonatomic, retain) IBOutlet UIButton * resetToTest;
@property (nonatomic, retain) LoginScreenViewController * loginSVC;
@property (nonatomic, retain) MBProgressHUD * HUD;

- (IBAction) submitButtonPressed;
- (IBAction) cancelButtonPressed;
- (IBAction) resetToTestButtonPressed;
- (id)initWithState:(int) state;
- (void) pushBackDown;

@end
