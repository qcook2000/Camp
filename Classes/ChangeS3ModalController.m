//
//  ChangeS3ModalController.m
//  Camp
//
//  Created by Quenton Cook on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChangeS3ModalController.h"
#import "CampInfoController.h"
#import "CampAppDelegate.h"


@implementation ChangeS3ModalController

@synthesize titleLable,oldUserName,oldPassword,newUserName,newPassword,s3AccessKey,s3SecretAccessKey,s3Bucket,cancel,submitButton,loginSVC,HUD,resetToTest;

- (id)initWithState:(int) thestate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        state = thestate;

        // Custom initialization
        // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
        self.HUD = [[MBProgressHUD alloc] initWithView: self.view];
        //HUD.graceTime = 0.5;
        //self.HUD.minShowTime = 0.3;
        // Add HUD to screen
        [self.view addSubview:self.HUD];
        
        // Regisete for HUD callbacks so we can remove it from the window at the right time
        self.HUD.delegate = self;

        editing = NO;
    }
    return self;
}

- (void)dealloc
{
    [resetToTest release];
    [HUD release];
    [loginSVC release];
    [cancel release];
    [submitButton release];
    [titleLable release];
    [oldUserName release];
    [oldPassword release];
    [newUserName release];
    [newPassword release];
    [s3AccessKey release];
    [s3SecretAccessKey release];
    [s3Bucket release];
    [super dealloc];
}

- (void) hudWasHidden:(MBProgressHUD *)hud {
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!editing) {
        editing = true;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.1];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view  cache:YES];
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
        [UIView commitAnimations]; 
    }
}

- (void) pushBackDown {
    if ([oldUserName isFirstResponder] || [oldPassword isFirstResponder] || [newPassword isFirstResponder] || [newUserName isFirstResponder]
        || [s3AccessKey isFirstResponder] || [s3Bucket isFirstResponder] || [s3SecretAccessKey isFirstResponder]) {
        
    }
    else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.1];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view  cache:YES];
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
        [UIView commitAnimations];
        editing = false;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self performSelector:@selector(pushBackDown) withObject:nil afterDelay:.1];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if (state == 0) {
        oldPassword.hidden = YES;
        oldUserName.hidden = YES;
        int mover = 12;
        s3Bucket.center = CGPointMake(s3Bucket.center.x, s3Bucket.center.y - (2 * mover));
        s3SecretAccessKey.center = CGPointMake(s3SecretAccessKey.center.x, s3SecretAccessKey.center.y - (3 * mover));
        s3AccessKey.center = CGPointMake(s3AccessKey.center.x, s3AccessKey.center.y - (4 * mover));
        newPassword.center = CGPointMake(newPassword.center.x, newPassword.center.y - (5 * mover));
        newUserName.center = CGPointMake(newUserName.center.x, newUserName.center.y - (6 * mover));
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) submitButtonPressedInternal
{
    if (newUserName.text == nil || [newUserName.text length] == 0 || newPassword.text == nil || [newPassword.text length] == 0 || s3AccessKey.text == nil || [s3AccessKey.text length] == 0 || s3SecretAccessKey.text == nil || [s3SecretAccessKey.text length] == 0 || s3Bucket.text == nil || [s3Bucket.text length] == 0) {
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Please fill in all the feilds" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
    }
    else {
        NSString * result = [[CampInfoController instance] setNewUN:newUserName.text 
                                                           forOldUN:oldUserName.text 
                                                           andNewPW:newPassword.text 
                                                           forOldPW:oldPassword.text 
                                                              andAK:s3AccessKey.text 
                                                             andASK:s3SecretAccessKey.text 
                                                          andBucket:s3Bucket.text
                                                     andIgnoreOldPW:(state == 0)];
        if ([result isEqualToString:@"badS3"]) {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Either your internet is out or those S3 keys didn't match. Please check your typing and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
            [alert show];
        }
        else if ([result isEqualToString:@"badNewCred"]) {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Please fill in all the feilds" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
            [alert show];
        }
        else if ([result isEqualToString:@"badOldCred"]) {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You did not correctly enter your old password/username." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
            [alert show];
        }
        else if ([result isEqualToString:@"good"]) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"NO" forKey:@"loggedIn"];
            [defaults synchronize];
            [self.loginSVC dismissModalViewControllerAnimated:YES];
            [self.loginSVC setState];
        }
    }
}

- (void) resetButtonPressedInternal
{
    NSString * result = [[CampInfoController instance] setNewUN:nil 
                                                       forOldUN:nil 
                                                       andNewPW:nil
                                                       forOldPW:nil
                                                          andAK:@"qqq" 
                                                         andASK:@"qqq" 
                                                      andBucket:@"testscheduleomatic"
                                                 andIgnoreOldPW:YES];
    if ([result isEqualToString:@"badS3"]) {
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Something went wrong with your internet connection. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
    }
    else if ([result isEqualToString:@"good"]) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"test" forKey:@"loggedIn"];
        [defaults synchronize];
        [self.loginSVC dismissModalViewControllerAnimated:YES];
        [self.loginSVC setState];
    }
    else {
        NSLog(@"VERY BAD!!");
    }
}

- (IBAction) submitButtonPressed{
    [HUD showWhileExecuting:@selector(submitButtonPressedInternal) onTarget:self withObject:nil animated:YES];
}
- (IBAction) cancelButtonPressed{
    [self.loginSVC dismissModalViewControllerAnimated:YES];
}

- (IBAction) resetToTestButtonPressed {
    [HUD showWhileExecuting:@selector(resetButtonPressedInternal) onTarget:self withObject:nil animated:YES];
}

@end
