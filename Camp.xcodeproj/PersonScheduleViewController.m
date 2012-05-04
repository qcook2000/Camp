//
//  PersonSchedulePopupViewController.m
//  Camp
//
//  Created by Quenton Cook on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PersonScheduleViewController.h"
#import "Camper.h"
#import "Counselor.h"
#import "Course.h"
#import "ScheduleCourseCell.h"
#import "CourseTableViewController.h"

@implementation PersonScheduleViewController
@synthesize person, courses, ctvc, forParents, canEdit;

+ (PersonScheduleViewController *) controllerForPerson:(Person *) thePerson
{
    PersonScheduleViewController * tmp = [[[PersonScheduleViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    tmp.person = thePerson;
    tmp.canEdit = YES;
    tmp.forParents = false;
    [tmp reloadPersonsData];
    return tmp;
}
+ (PersonScheduleViewController *) parentControllerForPerson:(Person *) thePerson
{
    PersonScheduleViewController * tmp = [[[PersonScheduleViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    tmp.person = thePerson;
    tmp.forParents = true;
    [tmp reloadPersonsData];
    return tmp;
}


- (void) reloadPersonsData
{
    self.courses = [self.person valueForKey:@"courses"];
    [self.tableView reloadData];
}

- (void) updatePeriod:(NSNumber *) number {
    self.courses = [self.person valueForKey:@"courses"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[number intValue]-1] withRowAnimation:UITableViewRowAnimationRight];
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationRight];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [ctvc release];
    [person release];
    [courses release];
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
    
    if (!self.forParents) {
        // create the parent view that will hold header Label
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 55.0)];
        
        // create the button object
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:20];
        headerLabel.frame = CGRectMake(20.0, 10.0, 280.0, 44.0);
        
        // If you want to align the header text as centered
        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
        
        headerLabel.text = [self.person listName]; // i.e. array element
        [customView addSubview:headerLabel];
        self.tableView.tableHeaderView = customView;
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([person isKindOfClass:[Camper class]]) {
        return 4;
    }
    else {
        if (false) { // Turn true for debug
            return 6;
        }
        return 5;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.forParents) {
        return [NSString stringWithFormat:@"Period %d",section + 1];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5) {
        return 1;
    }
    // Return the number of rows in the section.
    int i = 1;
    for (Course *course in courses) {
        if ([course.period intValue] == section+1 && [course.miniNum intValue] != 0) {
            i++;
        }
    }
    return MIN(i, 2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ScheduleCourseCell *cell = (ScheduleCourseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ScheduleCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.section == 5) {// Debug only
        cell.textLabel.textColor = [UIColor redColor];
        NSMutableString * dub  = [NSMutableString stringWithCapacity:100];
        for (Course * course in courses) {
            [dub appendFormat:@"%@", course.name];
        }
        cell.textLabel.text = dub;
        cell.textLabel.font = [UIFont systemFontOfSize:10];
        return cell;
    }
    NSMutableSet * coursesInPeriod = [NSMutableSet setWithCapacity:2];
    for (Course *course in courses) {
        if ([course.period intValue] == indexPath.section + 1) {
            [coursesInPeriod addObject:course];
        }
    }
    NSString * title = @"UNENROLLED";
    cell.textLabel.textColor = [UIColor grayColor];
    cell.course = nil;
    for (Course *course in coursesInPeriod) {
        if ([course.miniNum intValue] == 0 || [course.miniNum intValue] == indexPath.row + 1) {
            title = course.name;
            cell.course = course;
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    cell.textLabel.text = title;
    if (self.forParents) {
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

- (void) disableEditing
{
    canEdit = NO;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.forParents || !canEdit) {
        return NO;
    }
    // Return NO if you do not want the specified item to be editable.
    Course * course = [(ScheduleCourseCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath] course];
    if (course != NULL) {
        return YES;
    }
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Course * course = [(ScheduleCourseCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath] course];
        if (course != NULL) {
            [person unenrollInCourse:course];
            [self updatePeriod:course.period];
            [self.ctvc incrementUndos];
        }
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.ctvc periodClicked:indexPath.section+1];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
