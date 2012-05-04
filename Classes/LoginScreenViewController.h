//
//  LoginScreenViewController.h
//  Camp
//
//  Created by Quenton Cook on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginScreenViewController : UIViewController <UITextFieldDelegate> {
    UIView * mainContent;
    UIButton * clearBackgroundButton;
    UITextField * userName;
    UITextField * password;
    UILabel * feedbackField;
    UISegmentedControl * loginButton;
    UIButton * changeS3button;
    UILabel * loginLabel;
    UILabel * changeS3info;
    UILabel * changeS3prompt;
    BOOL isTyping;
}

@property (nonatomic, retain) UIView * mainContent;
@property (nonatomic, retain) UIButton * clearBackgroundButton;
@property (nonatomic, retain) UITextField * userName;
@property (nonatomic, retain) UITextField * password;
@property (nonatomic, retain) UISegmentedControl * loginButton;
@property (nonatomic, retain) UIButton * changeS3button;
@property (nonatomic, retain) UILabel * loginLabel;
@property (nonatomic, retain) UILabel * changeS3info;
@property (nonatomic, retain) UILabel * changeS3prompt;
@property (nonatomic, retain) UILabel * feedbackField;


- (void) setState;
- (id)initWithState:(int) state;
- (void) resignResponders;
- (void) changeS3;
- (void) loginButtonPressed;

@end
