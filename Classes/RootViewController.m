//
//  RootViewController.m
//  Trash
//
//  Created by Quenton Cook on 10/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "NSArray-NestedArrays.h"
#import "EntityListViewController.h"
#import "EntityEditor.h"
#import "ImportViewController.h"
#import "CampAppDelegate.h"
#import "LoginScreenViewController.h"
#import "MultiEntityList.h"
#import "SpecialQueryTable.h"

#define kSearchAndLookup @"kSearchAndLookup"
#define kNavController @"NavController"
#define kDetailController @"DetailController"
#define kNavAndDetailControllers @"NavAndDetailControllers"
#define kQueryController @"kQueryController"
#define kAction @"Action"


@implementation RootViewController

@synthesize detailViewController,HUD;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	sectionNames = [[NSArray alloc] initWithObjects:
					[NSNull null],
					NSLocalizedString(@"Enrollments", @"Enrollments"),
                    NSLocalizedString(@"Special Searches", @"Special Searches"),
					NSLocalizedString(@"Add/Remove/Edit",@"Add/Remove/Edit"),
					NSLocalizedString(@"Admin", @"Admin"),
					nil];
	rowLabels = [[NSArray alloc] initWithObjects:
				 //section 1
				 [NSArray arrayWithObjects:
				  NSLocalizedString(@"Search and Lookup", @"Search and Lookup"),nil],
                 //section 3
				 [NSArray arrayWithObjects:
				  NSLocalizedString(@"Campers", @"Campers"),
				  NSLocalizedString(@"Counselors", @"Counselors"),nil],
                 //section 4
				 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Dead Classes", @"Dead Classes"),
                  NSLocalizedString(@"Unenrolled Campers", @"Unenrolled Campers"),nil],
				 //Section 5
				 [NSArray arrayWithObjects:
				  NSLocalizedString(@"Campers", @"Campers"),
				  NSLocalizedString(@"Counselors", @"Counselors"),
				  NSLocalizedString(@"Classes", @"Classes"),
				  NSLocalizedString(@"Cabins", @"Cabins"),
				  NSLocalizedString(@"Areas", @"Area"),
				  NSLocalizedString(@"Locations", @"Locations"),nil],
				 //section 6
				 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Save", @"Save"),
				  NSLocalizedString(@"Import", @"Import"),
				  NSLocalizedString(@"Export", @"Export"),nil],
				nil];
	
	rowDisplayType = [[NSArray alloc] initWithObjects:
			   
					  [NSArray arrayWithObjects:
					   kSearchAndLookup,
					   nil],
					  [NSArray arrayWithObjects:
					   kNavController,
					   kNavController,
                       nil],
					  [NSArray arrayWithObjects:
                       kQueryController,
					   kQueryController,
					   nil],
					  [NSArray arrayWithObjects:
					   kNavController,
					   kNavController,
					   kNavController,
					   kNavController,
					   kNavController,
					   kNavController,
					   nil],
					  [NSArray arrayWithObjects:
                       kAction,
					   kDetailController,
					   kDetailController,
					   nil],
					  
					  nil];
	
	rowDisplayControllers = [[NSArray alloc] initWithObjects:
					  
					[NSArray arrayWithObjects:
					  @"MultiEntityList", nil],
					[NSArray arrayWithObjects:
					  [NSNull null],
                      [NSNull null],
                      nil],
                    [NSArray arrayWithObjects:
                      [NSNull null],
                      [NSNull null], nil],
					[NSArray arrayWithObjects:
					  [NSNull null],
					  [NSNull null],
					  [NSNull null],
					  [NSNull null],
					  [NSNull null],
					  [NSNull null],nil],							 
					[NSArray arrayWithObjects:
                      [NSNull null],
                      @"ImportViewController",
                      @"ExportViewController", nil],
					nil];
	rowArguments = [[NSArray alloc] initWithObjects:
					 
					 [NSArray arrayWithObjects:
					  [NSNull null], nil],
					 [NSArray arrayWithObjects:
					  [NSDictionary dictionaryWithObjectsAndKeys: @"Camper", @"entity",    @"NO", @"editable", @"YES",@"forEnrollment",@"YES",@"forSignups", nil],
					  [NSDictionary dictionaryWithObjectsAndKeys: @"Counselor", @"entity", @"NO", @"editable", @"YES",@"forEnrollment",@"YES",@"forSignups", nil],
                      nil],
                    [NSArray arrayWithObjects:
                      kSpecialQueryUnderEnrolledClasses,
                      kSpecialQueryUnderEnrolledCounselors,nil],
					 [NSArray arrayWithObjects:
					  [NSDictionary dictionaryWithObjectsAndKeys: @"Camper", @"entity",    @"YES", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil],
					  [NSDictionary dictionaryWithObjectsAndKeys: @"Counselor", @"entity", @"YES", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil],
					  [NSDictionary dictionaryWithObjectsAndKeys: @"Course", @"entity",    @"YES", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil],
					  [NSDictionary dictionaryWithObjectsAndKeys: @"Cabin", @"entity",     @"YES", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil],
					  [NSDictionary dictionaryWithObjectsAndKeys: @"Area", @"entity",      @"YES", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil],
					  [NSDictionary dictionaryWithObjectsAndKeys: @"Location", @"entity",  @"YES", @"editable", @"NO",@"forEnrollment",@"NO",@"forSignups", nil],nil],							 
					 [NSArray arrayWithObjects:
					  @"saveAndBackup",
                      [NSNull null],
					  [NSNull null], nil],
					 nil];
	
		
    self.clearsSelectionOnViewWillAppear = YES;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	//NSLog(@"NUMBER %n", [rowLabels countOfNestedArray:1]);
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    self.HUD = [[MBProgressHUD alloc] initWithView:[[(CampAppDelegate *)[[UIApplication sharedApplication] delegate] splitViewController] view]];
    //HUD.graceTime = 0.5;
    self.HUD.minShowTime = 0.5;
    // Add HUD to screen
    [[[(CampAppDelegate *)[[UIApplication sharedApplication] delegate] splitViewController] view] addSubview:HUD];
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    self.HUD.delegate = self;
	[super viewDidLoad];
}

- (void)hudWasHidden:(MBProgressHUD *)hud{}

- (void)viewWillAppear:(BOOL)animated {
    NSError * error = nil;
    [[[CampInfoController instance] managedObjectContext] save:&error];
    [super viewWillAppear:animated];
    [self.detailViewController setDetailItem:NULL];
    [(LoginScreenViewController *)self.detailViewController.detailItem setState];
}

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



#pragma mark -
#pragma mark Table view data source

- (NSString *) tableView:(UITableView *) theTableView titleForHeaderInSection: (NSInteger)section{
	id theTitle = [sectionNames objectAtIndex:section];
	if ([theTitle isKindOfClass:[NSNull class]]) {
		return nil;
	}
	return theTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return [sectionNames count];
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [rowLabels countOfNestedArray:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *GOODCellIdentifier = @"ENACellIdentifier";
    static NSString *BADCellIdentifier = @"DISCellIdentifier";
    UITableViewCell *cell;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * loggedIn = [defaults objectForKey:@"loggedIn"];
    if (loggedIn != nil && [loggedIn isEqualToString:@"NO"] && indexPath.section != 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:BADCellIdentifier];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:GOODCellIdentifier];
    }
    // Dequeue or create a cell of the appropriate type.
    if (cell == nil) {
        if (loggedIn != nil && [loggedIn isEqualToString:@"NO"]  && indexPath.section != 0) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BADCellIdentifier] autorelease];
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GOODCellIdentifier] autorelease];
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    // Configure the cell.
    cell.textLabel.text = [rowLabels nestedObjectAtIndexPath:indexPath];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([rowDisplayType nestedObjectAtIndexPath:indexPath] == kNavController) {
		EntityListViewController *entityListViewController = [[EntityListViewController alloc] initWithDictionary:(NSDictionary *)[rowArguments nestedObjectAtIndexPath:indexPath]];
		[entityListViewController setDetailViewController:self.detailViewController];
        [self.detailViewController setDetailItem:nil];
		[self.navigationController pushViewController:entityListViewController animated:YES];
        [entityListViewController release];
	}
	else if ([rowDisplayType nestedObjectAtIndexPath:indexPath] == kDetailController) {
		Class controllerClass = NSClassFromString([rowDisplayControllers nestedObjectAtIndexPath:indexPath]);
		UIViewController * detailVeiwItem = [[controllerClass alloc] init];
		[self.detailViewController setDetailItem:detailVeiwItem];
        [detailVeiwItem release];
	}
	else if ([rowDisplayType nestedObjectAtIndexPath:indexPath] == kSearchAndLookup) {
        MultiEntityList * multiEList = [[MultiEntityList alloc] initWithDVC: self.detailViewController];
        [self.navigationController pushViewController:multiEList animated:YES];
        [multiEList release];
	}
	else if ([rowDisplayType nestedObjectAtIndexPath:indexPath] == kNavAndDetailControllers) {
		EntityListViewController *entityListViewController = [[EntityListViewController alloc] initWithDictionary:(NSDictionary *)[rowArguments nestedObjectAtIndexPath:indexPath]];
		[self.navigationController pushViewController:entityListViewController animated:YES];
        [entityListViewController release];
	}
    else if ([rowDisplayType nestedObjectAtIndexPath:indexPath] == kAction) {
        [self performSelector:NSSelectorFromString((NSString *)[rowArguments nestedObjectAtIndexPath:indexPath]) withObject:nil];
    }
    else if ([rowDisplayType nestedObjectAtIndexPath:indexPath] == kQueryController) {
        SpecialQueryTable *specialQueryTable = [[SpecialQueryTable alloc] initWithSpeialQueryKey:[rowArguments nestedObjectAtIndexPath:indexPath] andDVC: self.detailViewController];
		[self.navigationController pushViewController:specialQueryTable animated:YES];
        [specialQueryTable release];
    }
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) saveAndBackup{
    [HUD showWhileExecuting:@selector(saveBackup) 
                   onTarget:[CampInfoController instance]
                 withObject:nil
                   animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return NO;
	}
	return YES;
}

- (void)dealloc {
    [detailViewController release];
    [HUD release];
    [super dealloc];
}


@end

