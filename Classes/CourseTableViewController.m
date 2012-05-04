    //
//  CourseTableViewController.m
//  Camp
//
//  Created by Quenton Cook on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CourseTableViewController.h"
#import "AQGridView.h"
#import "CourseTableCell.h"
#import "CampAppDelegate.h"
#import "ClassTableWrapper.h"
#import "CampInfoController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CourseTableViewController

@synthesize person, personScheduleViewController;
@synthesize coursesShown, coursesTotal, wrapper;

- (void) setPerson:(Person *)theperson {
    [person release];
    person = [theperson retain];
    undosAvailable = 0;
}

- (void) incrementUndos {
    undosAvailable++;
    [self.wrapper setUndoButtEnabled:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    
    [super viewDidLoad];
    indexUpdating = -1;
    self.view.autoresizesSubviews = YES;
    
        
    self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 704, 748)];
    self.gridView.gridHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 704, 44)] autorelease];
    self.gridView.gridFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 704, 44)] autorelease];
    self.gridView.scrollIndicatorInsets= UIEdgeInsetsMake(44, 0, 44, 0);
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    // grid view sits on top of the background image
    self.gridView.autoresizingMask = UIViewAutoresizingNone;
    self.gridView.backgroundColor = [UIColor clearColor];
    self.gridView.opaque = NO;
    self.gridView.scrollEnabled = YES;

    [self update];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return CGSizeMake(170.0, 84.0);
}

- (void) viewWillAppear:(BOOL)animated {
}

- (void) update {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocChanged:) name:NSManagedObjectContextDidSaveNotification object:nil];
     NSFetchRequest * fetch2 = [[[NSFetchRequest alloc] init] autorelease];
    [fetch2 setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:[[CampInfoController instance] managedObjectContext]]];
    [fetch2 setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    self.coursesTotal = [[[[[CampInfoController instance] managedObjectContext] executeFetchRequest:fetch2 error:nil] mutableCopy] autorelease];
    [self filterAndSort];
    [self.gridView reloadData];
    
}

- (void) filterAndSort
{
    [self filterAndSortForMiniFilter:3 andForPeriod: 0 andForFull:0];

}

- (void) filterAndSortForMiniFilter:(int) minFilter andForPeriod: (int) periodFilter andForFull:(int) fullFilter
{
    self.coursesShown = [NSMutableArray arrayWithCapacity:50];
    for (Course *course in self.coursesTotal) {
        if ([course.period intValue] == periodFilter + 1) {
            if (minFilter == 3 || minFilter == [course.miniNum intValue]) {
                if (fullFilter == 0 || [[course mutableSetValueForKey:@"campers"] count] < [course.limit intValue]) {
                    [self.coursesShown addObject:course];
                }
            }
        }
    }
    [self.gridView reloadData];
    [self.gridView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) mocChanged:(NSNotification*)notification
{
    NSSet * set = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
    for (NSManagedObject * course in set) {
        if ([course isKindOfClass:[Course class]]) {            
            int index = [coursesShown indexOfObject:course];
            if (index != NSNotFound) {
                if (indexUpdating == index) {
                    [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationTop];
                }
                else {
                    [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationNone];
                }
            }
        }
    }
}
#pragma mark -
#pragma mark GridView Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return [self.coursesShown count];
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * CellIdentifier = @"CellIdentifier";
    
    CourseTableCell * cell = (CourseTableCell *)[self.gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[[CourseTableCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 170.0, 80.0) reuseIdentifier: CellIdentifier] autorelease];
    }
    cell.course = [self.coursesShown objectAtIndex:index];
    
    return cell;
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index{
    if (person != NULL) {
        indexUpdating = index;
        Course *course = [self.coursesShown objectAtIndex:index];
        [person enrollInCourse: course];
        [personScheduleViewController updatePeriod: course.period];
        [self incrementUndos];
        if (wrapper.inSignUpLoop) {
            [wrapper signUpLoopProgress:course];
        }
        [gridView deselectItemAtIndex:index animated:NO];
        NSError * error = nil;
        [[person managedObjectContext] save:&error];
    }
    else {
        [gridView deselectItemAtIndex:index animated:NO];
        CourseTableCell * cell = (CourseTableCell *)[gridView cellForItemAtIndex:index];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.1];
        [animation setRepeatCount:1];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake([cell center].x - 7.0f, [cell center].y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([cell center].x + 7.0f, [cell center].y)]];
        [[cell layer] addAnimation:animation forKey:@"position"];
    }
}

- (void) viewDidUnload
{ 
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) undoMe {
    NSUndoManager *manager = [[[CampInfoController instance] managedObjectContext] undoManager];
    [manager undo];
    [personScheduleViewController reloadPersonsData];
    [self.gridView reloadData];
    undosAvailable--;
    if (undosAvailable == 0) {
        [self.wrapper setUndoButtEnabled:NO];
    }
}

- (void) periodClicked:(NSInteger) period {
    [self.wrapper periodClicked: period];
}


- (void) dealloc
{
    [wrapper release];
    [personScheduleViewController release];
    [person release];
    [super dealloc];
}

@end
