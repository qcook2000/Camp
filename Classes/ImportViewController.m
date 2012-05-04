    //
//  ImportViewController.m
//  HVCscheduleomatic
//
//  Created by Quenton Cook on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImportViewController.h"
#import "DetailViewController.h"
#import "ASIS3ObjectRequest.h"
#import "CampAppDelegate.h"
#import "Area.h"
#import "Location.h"
#import "Cabin.h"
#import "Course.h"
#import "Camper.h"
#import "Counselor.h"
#import "CampInfoController.h"
#import "ImportBackupViewController.h"


@implementation ImportViewController
@synthesize areasLocationsAndCabins;
@synthesize counselors;
@synthesize campers;
@synthesize courses;
@synthesize camperEnr;
@synthesize bMode;
@synthesize clearLabel;

@synthesize clearAndLoadFromBackUp, import;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importFailed) name:@"importFailed" object:nil];
        import = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Import with above settings", @"Reset", nil]];
        import.frame = CGRectMake(144, 472, 426, 44);
        [import setWidth:120 forSegmentAtIndex:1];
        import.momentary = YES;
        import.enabled = NO;
        [import addTarget:self action:@selector(importWithOptions) forControlEvents:UIControlEventValueChanged];
        import.alpha = .5;
        [self.view addSubview:import];
    }
    return self;
}

-(void) importFailed {
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Download Failed" message:@"Sorry, check your internet connection and S3 settings then try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self resetSegmentedControls];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) resetSegmentedControls {
    
    [areasLocationsAndCabins setSelectedSegmentIndex:0];
    [campers setSelectedSegmentIndex:0];
    [courses setSelectedSegmentIndex:0];
    [camperEnr setSelectedSegmentIndex:0];
    [counselors setSelectedSegmentIndex:0];
    [bMode setSelectedSegmentIndex:0];
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    [self resetSegmentedControls];
    [hud removeFromSuperview];
}

- (void)dealloc {
    [clearLabel release];
    [areasLocationsAndCabins release];
    [counselors  release];
    [campers release];
    [courses release];
    [camperEnr release];
    [bMode release];
    [clearAndLoadFromBackUp release];
    [import release];
	[super dealloc];
}


-(void) importWithOptionsPrivate {
    [[CampInfoController instance] setBasics:[areasLocationsAndCabins selectedSegmentIndex] 
                     andCounselors:[counselors selectedSegmentIndex] 
                        andCampers:[campers selectedSegmentIndex] 
                        andClasses:[courses selectedSegmentIndex] 
                      andCamperEnr:[camperEnr selectedSegmentIndex]];
    [[CampInfoController instance] importWithOptions];
    [camperEnr setEnabled:YES forSegmentAtIndex:0];
    [camperEnr setTitle:@"Off" forSegmentAtIndex:0];
    [counselors setEnabled:YES forSegmentAtIndex:0];
    [counselors setTitle:@"Off" forSegmentAtIndex:0];
    [counselors setEnabled:YES forSegmentAtIndex:3];
    [counselors setTitle:@"Clear" forSegmentAtIndex:3];
}

-(IBAction) importWithOptions{
    if ([import selectedSegmentIndex] == 0) {
        // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
        MBProgressHUD * HUD = [[[MBProgressHUD alloc] initWithView:[[(CampAppDelegate *)[[UIApplication sharedApplication] delegate] splitViewController] view]] autorelease];
        
        //HUD.graceTime = 0.5;
        HUD.minShowTime = 3.0;
        
        // Add HUD to screen
        [[[(CampAppDelegate *)[[UIApplication sharedApplication] delegate] splitViewController] view] addSubview:HUD];
        
        // Regisete for HUD callbacks so we can remove it from the window at the right time
        HUD.delegate = self;
        
        // Show the HUD while the provided method executes in a new thread
        [HUD showWhileExecuting:@selector(importWithOptionsPrivate) onTarget:self withObject:nil animated:YES];
    }
    else {
        [self resetSegmentedControls];
    }
}

-(IBAction) loadFromBackup{
    // Create the modal view controller
    ImportBackupViewController *viewController = [[ImportBackupViewController alloc] initWithNibName:nil bundle:nil];
    viewController.ivc = self;
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    
    // show the navigation controller modally
    [self presentModalViewController:viewController animated:YES];
    
    // Clean up resources
    [viewController release];
}

-(IBAction) toggleEnableBackupMode{
    if ([bMode selectedSegmentIndex] == 0) {
        [clearLabel setEnabled:NO];
        [clearAndLoadFromBackUp setEnabled:NO];
    }
    else {
        [clearLabel setEnabled:YES];
        [clearAndLoadFromBackUp setEnabled:YES];
    }        
}

-(IBAction) validateSegmentControls{
    if ([areasLocationsAndCabins selectedSegmentIndex] == 2) {
        [counselors setSelectedSegmentIndex:3];
        [campers setSelectedSegmentIndex:2];
        [courses setSelectedSegmentIndex:2];
        [camperEnr setSelectedSegmentIndex:1];
        [counselors setEnabled:NO];
        [campers setEnabled:NO];
        [courses setEnabled:NO];
        [camperEnr setEnabled:NO];
    }
    else {
        [counselors setEnabled:YES];
        [campers setEnabled:YES];
        [courses setEnabled:YES];
        [camperEnr setEnabled:YES];
        if ([areasLocationsAndCabins selectedSegmentIndex] != 0) {
            if ([counselors selectedSegmentIndex] == 0) {
                [counselors setSelectedSegmentIndex:1];
            }
            if ([counselors selectedSegmentIndex] == 0) {
                [counselors setSelectedSegmentIndex:1];
            }
            if ([campers selectedSegmentIndex] == 0) {
                [campers setSelectedSegmentIndex:1];
            }
            if ([courses selectedSegmentIndex] == 0) {
                [courses setSelectedSegmentIndex:1];
            }
            if ([camperEnr selectedSegmentIndex] == 0) {
                [camperEnr setSelectedSegmentIndex:1];
            }
            [counselors setEnabled:NO forSegmentAtIndex:0];
            [campers setEnabled:NO forSegmentAtIndex:0];
            [courses setEnabled:NO forSegmentAtIndex:0];
            [camperEnr setEnabled:NO forSegmentAtIndex:0];
        }
        else {
            [counselors setEnabled:YES forSegmentAtIndex:0];
            [campers setEnabled:YES forSegmentAtIndex:0];
            [courses setEnabled:YES forSegmentAtIndex:0];
            [camperEnr setEnabled:YES forSegmentAtIndex:0];
        }
    }
    if ([counselors selectedSegmentIndex] == 0 && [campers selectedSegmentIndex] == 0 && [camperEnr selectedSegmentIndex] == 0 && [areasLocationsAndCabins selectedSegmentIndex] == 0 && [courses selectedSegmentIndex] == 0) {
        import.enabled = NO;
        import.alpha = .5;
    }
    else {
        import.enabled = YES;
        import.alpha = 1;
    }

}



@end
