//
//  SpecialQueryTable.m
//  Camp
//
//  Created by Quenton Cook on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "SpecialQueryTable.h"
#import "CampInfoController.h"
#import "NSArray-NestedArrays.h"
#import "QCThing.h"
#import "Person.h"
#import "Course.h"
#import "PersonScheduleViewController.h"

@implementation SpecialQueryTable

@synthesize objects, key, infoPopController, dvc;

- (id)initWithSpeialQueryKey:(NSString *) newKey andDVC:(DetailViewController *) newDVC
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.key = newKey;
        self.dvc = newDVC;
        // Custom initialization
        if ([key isEqualToString:kSpecialQueryUnderEnrolledClasses]) {
            self.objects = [[CampInfoController instance] underEnrolledClasses];
        }
        else if ([key isEqualToString:kSpecialQueryUnderEnrolledCounselors]) {
            self.objects = [[CampInfoController instance] underEnrolledPeople];
        }
        else {
            self.objects = [NSMutableArray array];
        }
    }
    return self;
}

- (void)dealloc
{
    [dvc release];
    [key release];
    [objects release];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return [objects count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([key isEqualToString:kSpecialQueryUnderEnrolledClasses]) {
        if (section == 0) {
            return @"Classes";
        }
    }
    else if ([key isEqualToString:kSpecialQueryUnderEnrolledCounselors]) {
        if (section == 0) {
            return @"Counselors";
        }
        else {
            return @"Campers";
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [(NSArray *)[objects objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [(QCThing *)[objects nestedObjectAtIndexPath:indexPath] listName];
    cell.detailTextLabel.text = [(QCThing *)[objects nestedObjectAtIndexPath:indexPath] listSubtitle];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController * controller;
    QCThing * thing = [objects nestedObjectAtIndexPath:indexPath];
    if ([thing isKindOfClass:[Person class]]) {
        controller =[PersonScheduleViewController controllerForPerson:(Person *)thing];
        [(PersonScheduleViewController *)controller disableEditing];
    }
    else {
        Course * course = (Course *)thing;
        InfoPopTableController * infoTableController = [[[InfoPopTableController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        infoTableController.peeps = [[[[course campers] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy] autorelease];
        infoTableController.teachs =[[[[course counselors] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy] autorelease];
        [sortDescriptor release];
        [infoTableController.tableView reloadData];
        controller = infoTableController;
    }
    if (self.infoPopController == nil) {
        self.infoPopController = [[[UIPopoverController alloc] initWithContentViewController:controller] autorelease];
        self.infoPopController.passthroughViews = [NSArray arrayWithObject:self.view];
    }
    else {
        [infoPopController setContentViewController:controller animated:YES];
    }
    if (![self.infoPopController isPopoverVisible]) {
        [infoPopController presentPopoverFromRect: CGRectMake(0, 370, 1, 1)
                                           inView:self.dvc.view
                         permittedArrowDirections: UIPopoverArrowDirectionLeft  
                                         animated:YES];
    }

}

@end
