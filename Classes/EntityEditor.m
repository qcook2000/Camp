//
//  EntityEditor.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EntityEditor.h"
#import "NSArray-NestedArrays.h"
#import "TextFieldCell.h"
#import "DateFieldCell.h"
#import "EntityFieldCell.h"
#import "NumberFieldCell.h"

#define kStringKey		@"StringKey"
#define kDateKey		@"DateKey"
#define kPickerKey		@"PickerKey"
#define kUneditableKey	@"UneditableKey"
#define kNumberKey		@"NumberKey"

@implementation EntityEditor

@synthesize sectionNames, rowLabels, rowKeys, editType, rowArguments, currentObject, entityList, dateUpdatedIndexPath, saveNeeded, currentFirstResponder;
@synthesize saveToolbar, tableView, lookOnly;

- (void) newFirstResponder:(UIView *) view{
    [self.currentFirstResponder resignFirstResponder];
    self.currentFirstResponder = view;
}

- (void) saveTapped{
    [[self.currentObject managedObjectContext] save:nil];
    [self.entityList objectUpdated:self.currentObject];
    saveNeeded = false;
}

- (void) cancelTapped{
    [[self.currentObject managedObjectContext] refreshObject:self.currentObject mergeChanges:NO];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Initialization

+ (EntityEditor *) entityEditorForEntity:(NSString *)entity{
	return [[[EntityEditor alloc] initEntityEditorForEntity:entity] autorelease];
}

+ (EntityEditor *) entityEditorForManagedObject:(NSManagedObject *)managedObject andLookOnly: (BOOL) canLookOnly
{
	NSString *ename = [[managedObject entity]name];
	EntityEditor * entityE = [[[EntityEditor alloc] initEntityEditorForEntity:ename] autorelease];
    entityE.lookOnly = canLookOnly;
	[entityE setCurrentObject:managedObject];
	[entityE.tableView reloadData];
	return entityE;
}

- (EntityEditor *) initEntityEditorForEntity:(NSString *)entity{
    if ((self = [super init])) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 704, 748) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,704,80)];
        [self.view addSubview:self.tableView];
        
        UIToolbar * tool = [[[UIToolbar alloc]initWithFrame:CGRectMake(0,0,704,44)] autorelease];
        
        
        
        tool.items = [NSArray arrayWithObjects:
                      [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                      [[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ Editor", entity] style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped)]  autorelease],
                      [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]  autorelease], nil];
        [self.view addSubview:tool];
        if ([entity isEqualToString: @"Camper"]) {
			dateUpdatedIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
			sectionNames = [[NSArray alloc] initWithObjects:
							[NSNull null],
							NSLocalizedString(@"Meta",@"Meta"),
							nil];
			rowLabels = [[NSArray alloc] initWithObjects:
						 //section 1
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"First Name", @"First Name"),
						  NSLocalizedString(@"Last Name", @"Last Name"),
						  NSLocalizedString(@"Birthdate",@"Birthdate"),
						  NSLocalizedString(@"Cabin",@"Cabin"),nil],
						 //section 2
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Date Created", @"Date Created"),
						  NSLocalizedString(@"Date Modified",@"Date Modified"),nil],
						 nil];
			
			rowKeys = [[NSArray alloc] initWithObjects:
					   
					   [NSArray arrayWithObjects:
						@"firstName", @"lastName", @"birthdate",@"cabin", nil],
					   
					   [NSArray arrayWithObjects: @"timeCreated", @"timeStamp", nil],
					   
					   nil];
			editType = [[NSArray alloc] initWithObjects:
						 //section 1
						 [NSArray arrayWithObjects:
						  kStringKey,
						  kStringKey,
						  kDateKey,
						  kPickerKey,nil],
						 //section 2
						 [NSArray arrayWithObjects:
						  kUneditableKey,
						  kUneditableKey,nil],
						 nil];
		}
		else if ([entity isEqualToString: @"Course"]) {
			dateUpdatedIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
			sectionNames = [[NSArray alloc] initWithObjects:
							[NSNull null],
							NSLocalizedString(@"Meta",@"Meta"),
							nil];
			rowLabels = [[NSArray alloc] initWithObjects:
						 //section 1
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Name", @"Name"),
						  NSLocalizedString(@"Location",@"Location"),
						  NSLocalizedString(@"Period",@"Period"),
						  NSLocalizedString(@"Mini Number", @"Mini Number"),
						  NSLocalizedString(@"Limit", @"Limit"),
						  NSLocalizedString(@"Area",@"Area"),nil],
						 //section 2
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Date Created", @"Date Created"),
						  NSLocalizedString(@"Date Modified",@"Date Modified"),nil],
						 nil];
			
			rowKeys = [[NSArray alloc] initWithObjects:
					   
					   [NSArray arrayWithObjects:
						@"name", @"location",
						@"period", @"miniNum", @"limit",
						@"area", nil],
					   
					   [NSArray arrayWithObjects: @"timeCreated", @"timeStamp", nil],
					   
					   nil];
			
			editType = [[NSArray alloc] initWithObjects:
						//section 1
						[NSArray arrayWithObjects:
						 kStringKey,
						 kPickerKey,
						 kNumberKey,
						 kNumberKey,
						 kNumberKey,
						 kPickerKey,nil],
						//section 2
						[NSArray arrayWithObjects:
						 kUneditableKey,
						 kUneditableKey,nil],
						nil];
			rowArguments = [[NSArray alloc] initWithObjects:
							[NSArray arrayWithObjects:
							 [NSNull null],
							 [NSNull null],
							 NSStringFromRange(NSMakeRange(1, 5)),
							 NSStringFromRange(NSMakeRange(0, 3)),
							 NSStringFromRange(NSMakeRange(0, 50)),
							 [NSNull null],nil],
							//section 2
							[NSArray arrayWithObjects:
							 [NSNull null],
							 [NSNull null],nil],
							nil];
			
			
		}
		else if ([entity isEqualToString: @"Counselor"]) {
			dateUpdatedIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
			sectionNames = [[NSArray alloc] initWithObjects:
							[NSNull null],
							NSLocalizedString(@"Meta",@"Meta"),
							nil];
			rowLabels = [[NSArray alloc] initWithObjects:
						 //section 1
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"First Name", @"First Name"),
						  NSLocalizedString(@"Last Name", @"Last Name"),
						  NSLocalizedString(@"Birthdate",@"Birthdate"),
						  NSLocalizedString(@"Cabin",@"Cabin"),nil],
						 //section 2
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Date Created", @"Date Created"),
						  NSLocalizedString(@"Date Modified",@"Date Modified"),nil],
						 nil];
			
			rowKeys = [[NSArray alloc] initWithObjects:
					   
					   [NSArray arrayWithObjects:
						@"firstName", @"lastName", @"birthdate",@"cabin", nil],
					   
					   [NSArray arrayWithObjects: @"timeCreated", @"timeStamp", nil],
					   
					   nil];
			editType = [[NSArray alloc] initWithObjects:
						//section 1
						[NSArray arrayWithObjects:
						 kStringKey,
						 kStringKey,
						 kDateKey,
						 kPickerKey,nil],
						//section 2
						[NSArray arrayWithObjects:
						 kUneditableKey,
						 kUneditableKey,nil],
						nil];
		}
		else if ([entity isEqualToString: @"Cabin"]) {
			dateUpdatedIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
			sectionNames = [[NSArray alloc] initWithObjects:
							[NSNull null],
							NSLocalizedString(@"Meta",@"Meta"),
							nil];
			rowLabels = [[NSArray alloc] initWithObjects:
						 //section 1
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Name", @"Name"),
						  NSLocalizedString(@"Abbv.", @"Abbv."),nil],
						 //section 2
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Date Created", @"Date Created"),
						  NSLocalizedString(@"Date Modified",@"Date Modified"),nil],
						 nil];
			
			rowKeys = [[NSArray alloc] initWithObjects:
					   
					   [NSArray arrayWithObjects:
						@"name", @"cabinAbbreviation", nil],
					   
					   [NSArray arrayWithObjects: @"timeCreated", @"timeStamp", nil],
					   
					   nil];
			editType = [[NSArray alloc] initWithObjects:
						//section 1
						[NSArray arrayWithObjects:
						 kStringKey,
						 kStringKey,nil],
						//section 2
						[NSArray arrayWithObjects:
						 kUneditableKey,
						 kUneditableKey,nil],
						nil];
		}
		else if ([entity isEqualToString: @"Location"] ) {
			dateUpdatedIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
			sectionNames = [[NSArray alloc] initWithObjects:
							[NSNull null],
							NSLocalizedString(@"Meta",@"Meta"),
							nil];
			rowLabels = [[NSArray alloc] initWithObjects:
						 //section 1
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Name", @"Name"),nil],
						 //section 2
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Date Created", @"Date Created"),
						  NSLocalizedString(@"Date Modified",@"Date Modified"),nil],
						 nil];
			
			rowKeys = [[NSArray alloc] initWithObjects:
					   
					   [NSArray arrayWithObjects:
						@"name", nil],
					   
					   [NSArray arrayWithObjects: @"timeCreated", @"timeStamp", nil],
					   
					   nil];
			editType = [[NSArray alloc] initWithObjects:
						//section 1
						[NSArray arrayWithObjects:
						 kStringKey,nil],
						//section 2
						[NSArray arrayWithObjects:
						 kUneditableKey,
						 kUneditableKey,nil],
						nil];
			rowArguments = [[NSArray alloc] initWithObjects:
							[NSArray arrayWithObjects:
							 [NSNull null],nil],
							//section 2
							[NSArray arrayWithObjects:
							 [NSNull null],
							 [NSNull null],nil],
							nil];
			
		}
		else if ([entity isEqualToString: @"Area"] ) {
			dateUpdatedIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
			sectionNames = [[NSArray alloc] initWithObjects:
							[NSNull null],
							NSLocalizedString(@"Meta",@"Meta"),
							nil];
			rowLabels = [[NSArray alloc] initWithObjects:
						 //section 1
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Name", @"Name"),nil],
						 //section 2
						 [NSArray arrayWithObjects:
						  NSLocalizedString(@"Date Created", @"Date Created"),
						  NSLocalizedString(@"Date Modified",@"Date Modified"),nil],
						 nil];
			
			rowKeys = [[NSArray alloc] initWithObjects:
					   
					   [NSArray arrayWithObjects:
						@"name", nil],
					   
					   [NSArray arrayWithObjects: @"timeCreated", @"timeStamp", nil],
					   
					   nil];
			editType = [[NSArray alloc] initWithObjects:
						//section 1
						[NSArray arrayWithObjects:
						 kStringKey,nil],
						//section 2
						[NSArray arrayWithObjects:
						 kUneditableKey,
						 kUneditableKey,nil],
						nil];
			rowArguments = [[NSArray alloc] initWithObjects:
							[NSArray arrayWithObjects:
							 [NSNull null],nil],
							//section 2
							[NSArray arrayWithObjects:
							 [NSNull null],
							 [NSNull null],nil],
							nil];
			
		}		
		else {
			NSLog(@"VERY VERY BAD");
		}		
	}
    self.saveToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 704, 703, 44)];
    self.saveToolbar.barStyle = UIBarStyleBlackTranslucent; 
    
    self.saveToolbar.items = [NSArray arrayWithObjects:
                              [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                              [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveTapped)]  autorelease],
                              [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]  autorelease],
                              [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped)]  autorelease],
                              [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]  autorelease], nil];
    
    [self.view addSubview:self.saveToolbar];

	return self;
}


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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

- (void) closingTime {
    if (saveNeeded) {
        UIActionSheet * actionSheet = [[[UIActionSheet alloc] initWithTitle:@"You Have Unsaved Changes" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Discard Changes" otherButtonTitles:@"Save Changes", nil] autorelease];
        [actionSheet showInView:self.view];
    }    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self cancelTapped];
    }
    else {
        [self saveTapped];
    }
}
                                                                                              

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSString *) tableView:(UITableView *) theTableView titleForHeaderInSection: (NSInteger)section{
	id theTitle = [sectionNames objectAtIndex:section];
	if ([theTitle isKindOfClass:[NSNull class]]) {
		return nil;
	}
	return theTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [rowLabels countOfNestedArray:section];
}


// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)thetableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MOAttributeTableCell *rCell = nil;
	if ([editType nestedObjectAtIndexPath:indexPath] == kStringKey) {
		rCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:kStringKey];
		if (rCell == nil) {
			rCell = [[[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStringKey] autorelease];
		}
		[(TextFieldCell *)rCell reCreateWith:self.currentObject andKey:[rowKeys nestedObjectAtIndexPath:indexPath] andLabel:[rowLabels nestedObjectAtIndexPath:indexPath]];
	}
	else if ([editType nestedObjectAtIndexPath:indexPath] == kDateKey){
		rCell = (DateFieldCell *)[tableView dequeueReusableCellWithIdentifier:kDateKey];
		if (rCell == nil) {
			rCell = [[[DateFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDateKey] autorelease];
		}
		[(DateFieldCell *)rCell reCreateWith:self.currentObject andKey:[rowKeys nestedObjectAtIndexPath:indexPath] andLabel:[rowLabels nestedObjectAtIndexPath:indexPath] andEditable:YES];
	}
	else if ([editType nestedObjectAtIndexPath:indexPath] == kPickerKey){
		rCell = (EntityFieldCell *)[tableView dequeueReusableCellWithIdentifier:kPickerKey];
		if (rCell == nil) {
			rCell = [[[EntityFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPickerKey] autorelease];
		}
		[(EntityFieldCell *)rCell reCreateWith:self.currentObject andKey:[rowKeys nestedObjectAtIndexPath:indexPath] andLabel:[rowLabels nestedObjectAtIndexPath:indexPath]];
	}
	else if ([editType nestedObjectAtIndexPath:indexPath] == kUneditableKey){
		rCell = (DateFieldCell *)[tableView dequeueReusableCellWithIdentifier:kDateKey];
		if (rCell == nil) {
			rCell = [[[DateFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDateKey] autorelease];
		}
		[(DateFieldCell *)rCell reCreateWith:self.currentObject andKey:[rowKeys nestedObjectAtIndexPath:indexPath] andLabel:[rowLabels nestedObjectAtIndexPath:indexPath] andEditable:NO];		
	}
	else if ([editType nestedObjectAtIndexPath:indexPath] == kNumberKey){
		rCell = (NumberFieldCell *)[tableView dequeueReusableCellWithIdentifier:kNumberKey];
		if (rCell == nil) {
			rCell = [[[NumberFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNumberKey] autorelease];
		}
		[(NumberFieldCell *)rCell reCreateWith:self.currentObject andKey:[rowKeys nestedObjectAtIndexPath:indexPath] andLabel:[rowLabels nestedObjectAtIndexPath:indexPath] andRange: NSRangeFromString([rowArguments nestedObjectAtIndexPath:indexPath])];		
	}
    if (rCell != NULL) {
        rCell.textLabel.text = [rowLabels nestedObjectAtIndexPath:indexPath];
        rCell.entityEditor = self;
        [rCell setUserInteractionEnabled:!lookOnly];
        return rCell;
    }
    NSLog(@"Cell of invalid type NULL returned");
    return NULL;
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

- (void)tableView:(UITableView *)thetableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([editType nestedObjectAtIndexPath:indexPath] == kUneditableKey) {
		return nil;
	}
	return indexPath;
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
    [tableView release];
    [saveToolbar release];
	[sectionNames release];
	[currentObject release];
	[rowLabels release];
	[rowKeys release];
	[editType release];
	[rowArguments release];
	[entityList release];
	[dateUpdatedIndexPath release];
    [currentFirstResponder release];
    [super dealloc];
}


@end

