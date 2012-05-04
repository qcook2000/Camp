//
//  MultiEntityList.m
//  Camp
//
//  Created by Quenton Cook on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiEntityList.h"


@implementation MultiEntityList

@synthesize entityChooser;
@synthesize eList;
@synthesize dvc;

- (MultiEntityList *) initWithDVC:(DetailViewController *)theDVC
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.dvc = theDVC;
        // Custom initialization
        self.eList =  [[[EntityListViewController alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys: @"Camper", @"entity",    @"NO", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil]] autorelease];
        eList.detailViewController = self.dvc;
        eList.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44);
        [self.view addSubview:eList.view];
    }
    return self;
}

- (void)dealloc
{
    [dvc release];
    [entityChooser release];
    [eList release];
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

- (void) changeEntity {
    EntityListViewController * newElist;
    if ([entityChooser selectedSegmentIndex] == 0) {
        newElist =  [[[EntityListViewController alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys: @"Camper", @"entity",    @"NO", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil]] autorelease];
    }
    else if ([entityChooser selectedSegmentIndex] == 1) {
        newElist =  [[[EntityListViewController alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys: @"Counselor", @"entity", @"NO", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil]] autorelease];
    }
    else {
        newElist =  [[[EntityListViewController alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys: @"Course", @"entity",    @"NO", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil]] autorelease];
    }
    newElist.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    newElist.detailViewController = self.dvc;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view  cache:YES];
    [self.eList.view removeFromSuperview];
    [self.view addSubview:newElist.view];
    [UIView commitAnimations]; 
    self.eList = newElist;
}

@end
