//
//  ClassTableWrapper.m
//  Camp
//
//  Created by Quenton Cook on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClassTableWrapper.h"
#import "Course.h"
#import "Counselor.h"
#import "Camper.h"
#import "CampInfoController.h"


@implementation ClassTableWrapper

@synthesize courseTableVC, toolbar, miniSegC, fullSegC, periSegC, inSignUpLoop; 
@synthesize hasOneOfTwoMinis, filterPeriod, filterFilled, filterMiniNum,topBar;
@synthesize undoButt, insignupsSegCont;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ignore = false;
        if (courseTableVC == NULL) {
            CourseTableViewController *controller = [[CourseTableViewController alloc]init];
            [self.view addSubview:controller.view];
            self.courseTableVC = controller;
            self.courseTableVC.wrapper = self;
            [controller release];
        }
        if (toolbar == NULL) {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 704, 703, 44)];
            toolbar.barStyle = UIBarStyleBlackTranslucent; 
            
            
            miniSegC = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Whole", @"M 1", @"M 2", @"All", nil]];
            fullSegC = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Full Visible", @"Invisible", nil]];
            periSegC  = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil]];
            miniSegC.segmentedControlStyle = UISegmentedControlStyleBar;
            fullSegC.segmentedControlStyle = UISegmentedControlStyleBar;
            periSegC.segmentedControlStyle = UISegmentedControlStyleBar;
            
            [fullSegC setWidth:86.0 forSegmentAtIndex:0];
            [fullSegC setWidth:86.0 forSegmentAtIndex:1];
            
            [fullSegC setSelectedSegmentIndex:0];
            [miniSegC setSelectedSegmentIndex:3];
            [periSegC setSelectedSegmentIndex:0];
            
            [periSegC setWidth:52.0 forSegmentAtIndex:0];
            [periSegC setWidth:52.0 forSegmentAtIndex:1];
            [periSegC setWidth:52.0 forSegmentAtIndex:2];
            [periSegC setWidth:52.0 forSegmentAtIndex:3];
            [periSegC setWidth:52.0 forSegmentAtIndex:4];
            
            [miniSegC setWidth:56.0 forSegmentAtIndex:0];
            [miniSegC setWidth:56.0 forSegmentAtIndex:1];
            [miniSegC setWidth:56.0 forSegmentAtIndex:2];
            [miniSegC setWidth:56.0 forSegmentAtIndex:3];
            
            [fullSegC addTarget:self action:@selector(filterByFilters) forControlEvents:UIControlEventValueChanged];
            [miniSegC addTarget:self action:@selector(filterByFilters) forControlEvents:UIControlEventValueChanged];
            [periSegC addTarget:self action:@selector(filterByFilters) forControlEvents:UIControlEventValueChanged];
            
            [self.view addSubview:toolbar];
            toolbar.items = [NSArray arrayWithObjects:
                                 [[[UIBarButtonItem alloc] initWithCustomView:fullSegC] autorelease],
                                 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                                 [[[UIBarButtonItem alloc] initWithCustomView:miniSegC] autorelease],
                                 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                                 [[[UIBarButtonItem alloc] initWithCustomView:periSegC] autorelease], nil];

            topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 703, 44)];
            topBar.barStyle = UIBarStyleBlackTranslucent; 
            insignupsSegCont  = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Sign ups",@"Class Changes", nil]] ;
            insignupsSegCont.segmentedControlStyle = UISegmentedControlStyleBar;
            insignupsSegCont.selectedSegmentIndex = 1;
            [insignupsSegCont addTarget:self action:@selector(toggleSignups) forControlEvents:UIControlEventValueChanged];
            inSignUpLoop = NO;
            undoButt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoMe)]; 
            undoButt.enabled = NO;
            [self.topBar setItems:[NSArray arrayWithObjects:
                    undoButt,
                    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                    [[[UIBarButtonItem alloc] initWithTitle:@"Enrollments" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease],
                    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                    [[[UIBarButtonItem alloc] initWithCustomView:insignupsSegCont] autorelease],nil] animated:YES];
            [self.view addSubview:topBar];
            self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

        }
    }
    return self;
}

- (void)dealloc
{
    [undoButt release];
    [insignupsSegCont release];
    [topBar release];
    [courseTableVC release];
    [toolbar release];
    [miniSegC release];
    [fullSegC release];
    [periSegC release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
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

- (void) clearPerson{
    self.courseTableVC.person = nil;
    courseTableVC.personScheduleViewController = nil;
    undoButt.enabled = NO;
}
- (void) setPerson:(Person *) person{
    [self.courseTableVC setPerson:person];
}
- (void) setUndoButtEnabled: (BOOL) yesOrNo{
    undoButt.enabled = yesOrNo;
}

- (void) setPersonScheduleViewController: (PersonScheduleViewController *) psvc{
    self.courseTableVC.personScheduleViewController = psvc;
}

- (void) filterByFilters{
    if (ignore) {
        return;
    }
    [courseTableVC filterAndSortForMiniFilter:miniSegC.selectedSegmentIndex andForPeriod:periSegC.selectedSegmentIndex andForFull:fullSegC.selectedSegmentIndex];
}
- (void) toggleSignups{
    if(inSignUpLoop == NO) {
        inSignUpLoop = YES;
    }
    else {
        inSignUpLoop = NO;
    }
}
- (void) undoMe{
    [courseTableVC undoMe];
}

- (void) signUpLoopProgress:(Course *) course{
    [self.courseTableVC.gridView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    ignore= true;
    if (course == nil) {
        if (periSegC.selectedSegmentIndex == 4) {
            [self endLoopFoPerson];
            [miniSegC setSelectedSegmentIndex:3];
            [periSegC setSelectedSegmentIndex:0];
            [fullSegC setSelectedSegmentIndex:1];
        }
        else {
            [miniSegC setSelectedSegmentIndex:3];
            [periSegC setSelectedSegmentIndex:periSegC.selectedSegmentIndex + 1];
            [fullSegC setSelectedSegmentIndex:1];
        }
    }
    else {
        if ([course.miniNum intValue] == 1) {
            [miniSegC setSelectedSegmentIndex:2];
            [fullSegC setSelectedSegmentIndex:1];
        }
        else if (([course.period intValue] == 5 && [self.courseTableVC.person isKindOfClass:[Counselor class]]) ||
                 ([course.period intValue] == 4 && [self.courseTableVC.person isKindOfClass:[Camper class]])) {
            [self endLoopFoPerson];
            [miniSegC setSelectedSegmentIndex:3];
            [periSegC setSelectedSegmentIndex:0];
            [fullSegC setSelectedSegmentIndex:1];
        }
        else {
            [miniSegC setSelectedSegmentIndex:3];
            [periSegC setSelectedSegmentIndex:periSegC.selectedSegmentIndex + 1];
            [fullSegC setSelectedSegmentIndex:1];
        }
    }
    
    ignore= false;
    [self performSelector:@selector(filterByFilters) withObject:nil afterDelay:.4];
}
- (void) endLoopFoPerson{
    [[self.courseTableVC.personScheduleViewController navigationController] popViewControllerAnimated:YES];
}

- (void) periodClicked:(NSInteger) period {
    ignore= true;
    [miniSegC setSelectedSegmentIndex:3];
    [periSegC setSelectedSegmentIndex:period-1];
    [fullSegC setSelectedSegmentIndex:1];
    ignore= false;
    [self filterByFilters];
}

@end
