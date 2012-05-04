//
//  InfoPopTableController.m
//  HVCold
//
//  Created by Quenton Cook on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfoPopTableController.h"
#import "Person.h"


@implementation InfoPopTableController
@synthesize peeps, delegate, teachs, forViewer;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (self.forViewer) {
		UILabel *tmp = [[[UILabel alloc] init] autorelease];
		if (section == 0) {
			tmp.text = @"Campers";
		}
		else {
			tmp.text = @"Counselors";
		}
		tmp.textAlignment = UITextAlignmentCenter;
		tmp.font = [UIFont systemFontOfSize:18];
		tmp.textColor = [UIColor whiteColor];
		tmp.backgroundColor = [UIColor clearColor];
		return tmp;
	}
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
		return 40;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 1) {
		if (teachs == nil) {
			return 1;
		}
		else {
			if ([teachs count] == 0) {
				return 1;
			}
			return [teachs count];
		}
	}
	else if (peeps == nil) {
		return 1;
 	}
	else if ([peeps count] == 0) {
		return 1;
	}

    return [peeps count];
}


// Customize the appearance of table view cells.
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section{
	if (self.forViewer == NO) {
		if (section == 0) {
			return @"Campers";
		}
		return @"Counselors";
	}
	return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if (indexPath.section == 0) {
		if (peeps == nil || [peeps count] == 0) {
			cell.textLabel.text = @"NO CAMPERS";
		}
		else{
			cell.textLabel.text = [(Person *)[peeps objectAtIndex:indexPath.row] listName];
		}
	}
	else {
		if (teachs == nil || [teachs count] == 0) {
			cell.textLabel.text = @"NO TEACHERS";
		}
		else{
			cell.textLabel.text = [(Person *)[teachs objectAtIndex:indexPath.row] listName];
		}
	}
	cell.userInteractionEnabled = NO;
    // Configure the cell...
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[delegate release];
	[peeps release];
	[teachs release];
    [super dealloc];
}


@end

