//
//  LoginScreenViewController.m
//  Camp
//
//  Created by Quenton Cook on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginScreenViewController.h"
#import "ChangeS3ModalController.h"
#import "CampInfoController.h"
#import "CampAppDelegate.h"
#import "RootViewController.h"

@implementation LoginScreenViewController

@synthesize mainContent, clearBackgroundButton, userName, password, loginButton, changeS3button, loginLabel, changeS3info, changeS3prompt, feedbackField;

- (id)initWithState:(int) state 
{
    CGFloat topOff = 412;
    CGFloat sideOff = 40;
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.mainContent = [[[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width,self.view.bounds.size.height)] autorelease];
        mainContent.backgroundColor = [UIColor clearColor];
        mainContent.opaque = NO;
        //340,190
        self.loginLabel = [[[UILabel alloc]initWithFrame:CGRectMake(106 + sideOff, topOff, 116, 21)] autorelease];
        loginLabel.text = @"For full access:";
        loginLabel.backgroundColor = [UIColor clearColor];
        loginLabel.textColor = [UIColor darkGrayColor];
        loginLabel.shadowColor = [UIColor whiteColor];
        loginLabel.shadowOffset = CGSizeMake(0, 1);
        [mainContent addSubview:loginLabel];
        
        self.feedbackField = [[[UILabel alloc]initWithFrame:CGRectMake(sideOff - 1, 207 + topOff, 331, 21)] autorelease];
        feedbackField.textAlignment = UITextAlignmentCenter;
        feedbackField.font = [UIFont fontWithName:@"Helvetica-Oblique" size:[UIFont systemFontSize]];
        feedbackField.backgroundColor = [UIColor clearColor];
        feedbackField.textColor = [UIColor darkGrayColor];
        feedbackField.shadowColor = [UIColor whiteColor];
        feedbackField.shadowOffset = CGSizeMake(0, 1);
        [mainContent addSubview:feedbackField];
        
        self.changeS3info = [[[UILabel alloc]initWithFrame:CGRectMake(398, 545, 209, 75)] autorelease];
        changeS3info.text = @"You are currently using test data from Amazon S3";
        changeS3info.backgroundColor = [UIColor clearColor];
        changeS3info.numberOfLines = 2;
        changeS3info.textColor = [UIColor darkGrayColor];
        changeS3info.shadowColor = [UIColor whiteColor];
        changeS3info.shadowOffset = CGSizeMake(0, 1);
        [mainContent addSubview:changeS3info];
        
        self.changeS3prompt = [[[UILabel alloc]initWithFrame:CGRectMake(398, 620, 272, 21)] autorelease];
        changeS3prompt.text = @"Touch to change your S3 info:";
        changeS3prompt.backgroundColor = [UIColor clearColor];
        changeS3prompt.textColor = [UIColor darkGrayColor];
        changeS3prompt.shadowColor = [UIColor whiteColor];
        changeS3prompt.shadowOffset = CGSizeMake(0, 1);
        [mainContent addSubview:changeS3prompt];
        [self.view addSubview:mainContent];
        
        self.clearBackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBackgroundButton.frame = mainContent.bounds;
        [clearBackgroundButton addTarget:self action:@selector(resignResponders) forControlEvents:UIControlEventTouchUpInside];
        [mainContent addSubview:clearBackgroundButton];
        
        self.userName = [[[UITextField alloc] initWithFrame:CGRectMake(77 + sideOff, 29 + topOff, 175, 31)] autorelease];
        userName.borderStyle = UITextBorderStyleRoundedRect;
        userName.delegate = self;
        userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
        userName.autocorrectionType = UITextAutocorrectionTypeNo;
        userName.placeholder = @"Username";
        userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        userName.clearButtonMode = UITextFieldViewModeAlways;
        [mainContent addSubview:userName];
        
        self.password = [[[UITextField alloc] initWithFrame:CGRectMake(77 + sideOff, 78 + topOff, 175, 31)] autorelease];
        password.borderStyle = UITextBorderStyleRoundedRect;
        password.secureTextEntry = YES;
        password.autocapitalizationType = UITextAutocapitalizationTypeNone;
        password.autocorrectionType = UITextAutocorrectionTypeNo;
        password.delegate = self;
        password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        password.placeholder = @"Password";
        password.clearButtonMode = UITextFieldViewModeAlways;
        [mainContent addSubview:password];
        
        self.loginButton = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Login"]] autorelease];
        loginButton.frame = CGRectMake(108 + sideOff, 128 + topOff, 113, 44);
        loginButton.momentary = YES;
        [mainContent addSubview:loginButton];
        [loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventValueChanged];
        
        self.changeS3button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        changeS3button.frame = CGRectMake(636, 616, 29, 31);
        [changeS3button addTarget:self action:@selector(changeS3) forControlEvents:UIControlEventTouchUpInside];

        [mainContent addSubview:changeS3button];
        isTyping = NO;
        [self setState];
    }
    return self;
}

- (void) loginButtonPressed {
    if ([[loginButton titleForSegmentAtIndex:0] isEqualToString:@"Logout"]) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"NO" forKey:@"loggedIn"];
        [defaults synchronize];
        [self setState];
        [self resignResponders];
    }
    else {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults objectForKey:@"userName"];
        if ([userName.text isEqualToString:[defaults objectForKey:@"userName"]] && [password.text isEqualToString:[defaults objectForKey:@"password"]]) {
             [defaults setObject:@"YES" forKey:@"loggedIn"];
            [defaults synchronize];
            [self setState];

        }
        else {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Incorrect username or password" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
            [alert show];
        }
    }
}

- (void) setState {
    NSString * loginState = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedIn"];
    [[(RootViewController *)[(CampAppDelegate *)[[UIApplication sharedApplication] delegate] rootViewController] tableView] reloadData];
    if ([loginState isEqualToString:@"test"]) { // Test Mode
        userName.alpha = .5;
        userName.userInteractionEnabled = NO; 
        password.alpha = .5;
        password.userInteractionEnabled = NO;
        loginButton.alpha = .5;
        loginLabel.alpha = .5;
        loginButton.userInteractionEnabled = NO;
        [loginButton setTitle:@"Login" forSegmentAtIndex:0];
        feedbackField.text = @"No login needed for test data.";
        changeS3info.text = @"You are currently using test data from Amazon S3";
    }
    else if ([loginState isEqualToString:@"NO"]) { // Unlogged in real mode
        userName.alpha = 1;
        userName.userInteractionEnabled = YES; 
        userName.text = @"";
        password.text = @"";
        password.alpha = 1;
        password.userInteractionEnabled = YES;
        loginButton.alpha = 1;
        loginLabel.alpha = 1;
        loginButton.userInteractionEnabled = YES;
        [loginButton setTitle:@"Login" forSegmentAtIndex:0];
        feedbackField.text = @"";
        changeS3info.text = [NSString stringWithFormat:@"Current Amazon S3 bucket: \"%@\"",[[CampInfoController instance] bucket]];

    }
    else if ([loginState isEqualToString:@"YES"]) { // Logged in real mode
        userName.alpha = 0;
        userName.userInteractionEnabled = NO; 
        password.alpha = 0;
        password.userInteractionEnabled = NO;
        userName.text = @"";
        password.text = @"";
        loginLabel.alpha = 0;
        loginButton.alpha = 1;
        loginButton.userInteractionEnabled = YES;
        [loginButton setTitle:@"Logout" forSegmentAtIndex:0];
        feedbackField.text = @"You are currently logged in.";
        changeS3info.text = [NSString stringWithFormat:@"Current Amazon S3 bucket: \"%@\"",[[CampInfoController instance] bucket]];
    }

}

- (void)dealloc
{
    [feedbackField release];
    [mainContent release];
    [clearBackgroundButton release];
    [userName release];
    [password release];
    [loginButton release];
    [changeS3button release];
    [loginLabel release];
    [changeS3info release];
    [changeS3prompt release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
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

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (!isTyping) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.2];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view  cache:YES];
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 340);
        [UIView commitAnimations];
        isTyping = YES;
    }
}

- (void) animateClose
{
    if (![userName isEditing] && ![password isEditing]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.2];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view  cache:YES];
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 340);
        [UIView commitAnimations];
        isTyping = NO;
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self performSelector:@selector(animateClose) withObject:nil afterDelay:.1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([userName isEditing]) {
        [password becomeFirstResponder];
    }
    else   {
        [self resignResponders];
    }
    return NO;
}

- (void) resignResponders {
    [userName resignFirstResponder];
    [password resignFirstResponder];
}

-(void) changeS3{
    // Create the modal view controller
    NSString * loginState = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedIn"];
    int state = 0;
    if ([loginState isEqualToString:@"NO"]){
        state = 1;
    }
    else if ([loginState isEqualToString:@"YES"]){
        state = 2;
    }
    
    ChangeS3ModalController *viewController = [[ChangeS3ModalController alloc] initWithState:state];
    viewController.loginSVC = self;
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    
    // show the navigation controller modally
    [self presentModalViewController:viewController animated:YES];
    
    // Clean up resources
    [viewController release];
}


@end
