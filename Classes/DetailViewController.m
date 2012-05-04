//
//  DetailViewController.m
//  Trash
//
//  Created by Quenton Cook on 10/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "EntityEditor.h"
#import "LoginScreenViewController.h"


@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end



@implementation DetailViewController

@synthesize popoverController, detailItem, contentView;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(UIViewController *)newDetailItem {
    if (newDetailItem == nil && [detailItem isKindOfClass:[LoginScreenViewController class]]) {
        return;
    }
    if (newDetailItem == nil) {
        newDetailItem = [[LoginScreenViewController alloc] initWithState:0];
    }
    UIViewAnimationTransition transition = UIViewAnimationTransitionFlipFromLeft;
    if ([detailItem isKindOfClass:[EntityEditor class]] && [newDetailItem isKindOfClass:[EntityEditor class]]) {
        transition =  UIViewAnimationTransitionCurlUp;
    }
    if (detailItem != newDetailItem) {
        newDetailItem.view.frame = self.contentView.bounds;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        [UIView setAnimationTransition:transition forView:self.view  cache:YES];
            [detailItem.view removeFromSuperview];
            [self.view addSubview:newDetailItem.view];
        [UIView commitAnimations]; 
        if (detailItem != nil) {
            [detailItem release];
        }
        detailItem = [newDetailItem retain];
    }       
}


- (void)configureView {
       
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return NO;
	}
	return YES;
}


#pragma mark -
#pragma mark View lifecycle


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	detailDescriptionLabel.textColor = UIColorFromRGB(0x717880);
//	detailDescriptionLabel.font = [UIFont boldSystemFontOfSize:20];
//	[detailDescriptionLabel setShadowOffset:CGSizeMake(0, 1)];
//	detailDescriptionLabel.shadowColor = [UIColor whiteColor];
}
 

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
    [popoverController release];
    [contentView release];
    [detailItem release];
    [super dealloc];
}

@end
