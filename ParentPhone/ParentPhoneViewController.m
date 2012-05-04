//
//  ParentPhoneViewController.m
//  ParentPhone
//
//  Created by Quenton Cook on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParentPhoneViewController.h"
#import "CampInfoController.h"


@implementation ParentPhoneViewController

@synthesize firstName,lastName,birthday,lookupButton,containerView, datePicker,clearButton,HUD,camperScheduleViewController,logout,accuracyLabel, backgroundImage;

- (void)dealloc
{
    [accuracyLabel release];
    [logout release];
    [camperScheduleViewController release];
    [HUD release];
    [datePicker release];
    [containerView release];
    [firstName release];
    [lastName release];
    [birthday release];
    [lookupButton release];
    [clearButton release];
    [backgroundImage release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed) name:@"downloadFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupListDownloaded) name:@"backupListDownloaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupDownloaded) name:@"backupDownloaded" object:nil];
    debug = NO;
    self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneBkg.png"]];
    [backgroundImage sizeToFit];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    backgroundImage.center = CGPointMake(backgroundImage.center.x, backgroundImage.center.y - 20);
    [super viewDidLoad];
     self.firstName = [[[UITextField alloc] initWithFrame:CGRectMake(62, 144, 196, 31)] autorelease];
    self.lastName = [[[UITextField alloc] initWithFrame:CGRectMake(62, 186, 196, 31)] autorelease];
    self.birthday = [[[UITextField alloc] initWithFrame:CGRectMake(62, 228, 196, 31)] autorelease];
    self.firstName.placeholder = @"First Name";
    self.lastName.placeholder = @"Last Name";
    self.birthday.placeholder = @"Birthday";
    self.firstName.clearButtonMode = UITextFieldViewModeAlways;
    self.lastName.clearButtonMode = UITextFieldViewModeAlways;
    self.firstName.textAlignment = UITextAlignmentLeft;
    self.lastName.textAlignment = UITextAlignmentLeft;
    self.birthday.textAlignment = UITextAlignmentLeft;
    self.firstName.borderStyle = UITextBorderStyleRoundedRect;
    self.lastName.borderStyle = UITextBorderStyleRoundedRect;
    self.birthday.borderStyle = UITextBorderStyleRoundedRect;
    self.firstName.backgroundColor = [UIColor clearColor];
    self.lastName.backgroundColor = [UIColor clearColor];
    self.birthday.backgroundColor = [UIColor clearColor];
    self.firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.birthday.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.lastName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.birthday.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.firstName.returnKeyType = UIReturnKeyNext;
    self.firstName.tag = 1;
    self.lastName.tag = 2;
    self.birthday.tag = 3;
    self.lastName.returnKeyType = UIReturnKeyNext;
    self.birthday.returnKeyType = UIReturnKeyDone;
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.birthday.delegate = self;
    self.firstName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.lastName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.birthday.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.lookupButton = [UIButton buttonWithType:UIButtonTypeCustom]; 
    self.lookupButton.frame = CGRectMake(70, 305, 180, 51);
    [self.lookupButton setBackgroundImage:[UIImage imageNamed:@"lookupReg.png"] forState:UIControlStateNormal];
    [self.lookupButton setBackgroundImage:[UIImage imageNamed:@"lookupTouch.png"] forState:UIControlStateHighlighted];
    [self.lookupButton addTarget:self action:@selector(lookupCamper) forControlEvents:UIControlEventTouchUpInside];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 480, 320, 216)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(updateDateLabel) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.datePicker];
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton.frame = self.containerView.bounds;
    [self.containerView addSubview:self.clearButton];
    [self.containerView sendSubviewToBack:self.clearButton];
    [self.clearButton addTarget:self action:@selector(resignPickers) forControlEvents:UIControlEventTouchUpInside];
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    self.HUD = [[MBProgressHUD alloc] initWithView: self.view];
    //HUD.graceTime = 0.5;
    self.HUD.minShowTime = 0.5;
    // Add HUD to screen
    [self.view addSubview:self.HUD];
    
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    self.HUD.delegate = self;
    
    containerCenter = self.containerView.center;
    backgroundCenter = self.backgroundImage.center;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view  cache:YES];
    self.containerView.center = CGPointMake(containerCenter.x, containerCenter.y - 20);
    self.backgroundImage.center = CGPointMake(backgroundCenter.x, backgroundCenter.y - 20);
    [UIView commitAnimations];
    if (self.birthday == textField) {
        [self.firstName resignFirstResponder];
        [self.lastName resignFirstResponder];
        [self showDatePicker];
        return NO;
    }
    else {
        [self dismissDatePicker];
    }
    return YES;
}

- (void) resignPickers {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view  cache:YES];
    self.backgroundImage.center = backgroundCenter;
    self.containerView.center = containerCenter;
    [UIView commitAnimations];

    [self dismissDatePicker];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
}

- (void) updateAccuracyLabel {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"lastMOCswitch"] != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        self.accuracyLabel.text = [NSString stringWithFormat:@"Updated: %@",[formatter stringFromDate:(NSDate*)[[NSUserDefaults standardUserDefaults] valueForKey:@"lastMOCswitch"]]];
        [formatter release]; 
    }
    else {
        self.accuracyLabel.text = @"Never updated.";
    }
}

- (void) lookupCamper {
    [self resignPickers];
    if (debug) {
        self.birthday.text = @"TEST";
    }
    if (self.firstName.text == nil || self.lastName.text == nil || self.birthday.text == nil ) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please Fill In All Fields" message:@"We cannot lookup your camper's classes without a full name and birthday." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Camper" inManagedObjectContext:[[CampInfoController instance]managedObjectContext]];
    NSArray * keys = [NSArray arrayWithObjects:@"firstName", @"lastName", nil];
    NSArray * values = [NSArray  arrayWithObjects:self.firstName.text, self.lastName.text, nil];
    NSArray * matches = [[CampInfoController instance] lookUpObjectsForEntity:entity matchingKeys:keys withStringValues:values onlyForIndexSet:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
    if (matches != nil && [matches count] == 1 && [[(Person *)[matches objectAtIndex:0] birthdate] isEqualToDate:self.datePicker.date]) {
        Person * person = [matches objectAtIndex:0];
        self.camperScheduleViewController = [PersonScheduleViewController parentControllerForPerson:person];
        self.camperScheduleViewController.view.frame = self.view.bounds;
        self.camperScheduleViewController.tableView.backgroundView = nil;
        self.camperScheduleViewController.tableView.backgroundColor = [UIColor clearColor];
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
        UILabel * nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 20)] autorelease];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font =[UIFont boldSystemFontOfSize:20];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.shadowColor = [UIColor whiteColor];
        nameLabel.shadowOffset = CGSizeMake(0,1);
        nameLabel.textAlignment = UITextAlignmentCenter;
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
        [headerView addSubview:nameLabel];
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        self.accuracyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 21)];
        self.accuracyLabel.backgroundColor = [UIColor clearColor];
        self.accuracyLabel.font =[UIFont systemFontOfSize:11];
        self.accuracyLabel.shadowColor = [UIColor whiteColor];
        self.accuracyLabel.shadowOffset = CGSizeMake(0,1);
        self.accuracyLabel.textColor = [UIColor darkGrayColor];
        self.accuracyLabel.textAlignment = UITextAlignmentCenter;
        [self updateAccuracyLabel];
        [headerView addSubview:self.accuracyLabel];
        self.logout = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.logout setBackgroundImage:[UIImage imageNamed:@"backReg.png"] forState:UIControlStateNormal];
        [self.logout setBackgroundImage:[UIImage imageNamed:@"backTouch.png"] forState:UIControlStateHighlighted];
        self.logout.frame = CGRectMake(106, 10, 109, 51);
        [self.logout addTarget:self action:@selector(logoutPressed) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:self.logout];
        self.camperScheduleViewController.tableView.tableFooterView = footerView;
        self.camperScheduleViewController.tableView.tableHeaderView = headerView;
        
        UIImageView * tmp = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneBkgInner.png"]] autorelease];
        tmp.center = CGPointMake(tmp.center.x, tmp.center.y - 20);

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view  cache:YES];
        [self.firstName removeFromSuperview];
        [self.lastName removeFromSuperview];
        [self.birthday removeFromSuperview];
        [self.lookupButton removeFromSuperview];
        [self.backgroundImage removeFromSuperview];
        self.backgroundImage = tmp;
        [self.view addSubview:self.backgroundImage];
        [self.view sendSubviewToBack:self.backgroundImage];
        self.containerView.frame = self.view.bounds;
        [self.containerView addSubview:self.camperScheduleViewController.view];
        [UIView commitAnimations]; 
        schedMode = YES;
        
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Whoops, we cannot find that schedule." message:@"If you are sure you entered that the info correctly please contact Hidden Valley so we can resolve the issue on our end. Don't worry its probably just a mispelled name!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}

- (void) logoutPressed {
    UIImageView * tmp = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneBkg.png"]] autorelease];
    tmp.center = CGPointMake(tmp.center.x, tmp.center.y - 20);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view  cache:YES];
    [self.camperScheduleViewController.tableView removeFromSuperview];
    [self.containerView addSubview:self.firstName];
    [self.containerView addSubview:self.lastName];
    [self.containerView addSubview:self.birthday];
    [self.containerView addSubview:self.lookupButton];
    [self.backgroundImage removeFromSuperview];
    self.backgroundImage = tmp;
    [self.view addSubview:self.backgroundImage];
    [self.view sendSubviewToBack:self.backgroundImage];
    [self updateDateLabel];
    [UIView commitAnimations]; 
    schedMode = NO;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.firstName) {
    }
    else if (textField == self.lastName) {
    }
    else {
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIView * tfield = [self.containerView viewWithTag:textField.tag + 1];
    if (tfield != nil) {
        [tfield becomeFirstResponder];
    }
    else {
        [self resignPickers];
    }
    return NO;
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    if (schedMode) {
        return;
    }

    if (!schedMode) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.containerView  cache:YES];
        [self.containerView addSubview:self.firstName];
        [self.containerView addSubview:self.lastName];
        [self.containerView addSubview:self.birthday];
        [self.containerView addSubview:self.lookupButton];
        [UIView commitAnimations]; 
    }
    if (debug) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        self.datePicker.date = [formatter dateFromString:@"1/1/90"];
        [formatter release];
        self.firstName.text = @"Alec";
        self.lastName.text = @"Small";
        [self lookupCamper];
    }

}

- (void) downloadFailed{
    NSLog(@"Download failed");
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Download Failed" message:@"Sorry we could not download the HVC class rosters at this time. Please check your internet connection and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [HUD hide:YES];
}
- (void) backupListDownloaded{
    NSLog(@"Download list success");
    [[CampInfoController instance] downloadLatestBackup];
}
- (void) backupDownloaded{
    NSLog(@"Download backup success");
    if (self.camperScheduleViewController != nil) {
        [self.camperScheduleViewController.tableView reloadData];
        [self updateAccuracyLabel];
    }
    [HUD hide:YES];
}

- (void) enterForground {
    [HUD show:YES];
    [[CampInfoController instance] downLoadAvailableBackupsFromServer:YES forParents:YES];
}

- (void) enterBackground {
    if (!schedMode) {
        [self resignPickers];
        [self.firstName removeFromSuperview];
        [self.lastName removeFromSuperview];
        [self.birthday removeFromSuperview];
        [self.lookupButton removeFromSuperview];
        self.backgroundImage.center = backgroundCenter;
        self.containerView.center = containerCenter;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [self enterForground];
}

- (void) showDatePicker{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.datePicker  cache:YES];
    self.datePicker.frame = CGRectMake(0, 244, 320, 216);
    [UIView commitAnimations]; 
}

- (void) updateDateLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter stringFromDate:self.datePicker.date];
    self.birthday.text = [formatter stringFromDate:self.datePicker.date];
    [formatter release];
}

- (void) dismissDatePicker {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.datePicker  cache:YES];
    self.datePicker.frame = CGRectMake(0, 480, 320, 216);
    [UIView commitAnimations];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
