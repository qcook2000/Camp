#import "EntityListViewController.h"
#import "CampAppDelegate.h"
#import "EntityListStyleOption.h"
#import "Camper.h"
#import "EntityEditor.h"
#import "MOAttributeTableCell.h"
#import "PersonScheduleViewController.h"
#import "InfoPopTableController.h"
#import "CampInfoController.h"

@implementation EntityListViewController
@synthesize forSignups;
@synthesize forEnrollments;
@synthesize editable;
@synthesize searching;
@synthesize letUserSelectRow;
@synthesize entityForList;
@synthesize styleOptionsForEnity;
@synthesize detailViewController;
@synthesize formerMO;
@synthesize iPath;
@synthesize courseTable;
@synthesize ovController;
@synthesize listOfItems;
@synthesize copyListOfItems;
@synthesize infoPopController;
#pragma mark -
- (void)addEntity {
    NSManagedObjectContext *context = [[CampInfoController instance] managedObjectContext];

    ((UISearchBar *)self.tableView.tableHeaderView).selectedScopeButtonIndex = -1;
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[self.entityForList name] inManagedObjectContext:context];
    NSError *error = nil;
    if (![context save:&error])
        NSLog(@"Error saving entity: %@", [error localizedDescription]);
    [self.listOfItems insertObject:newManagedObject atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
    [self tableView:self.tableView didSelectRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
}

//- (IBAction)toggleEdit {
//    BOOL editing = !self.tableView.editing;
//    self.navigationItem.rightBarButtonItem.enabled = !editing;
//    self.navigationItem.leftBarButtonItem.title = (editing) ? NSLocalizedString(@"Done", @"Done") : NSLocalizedString(@"Edit", @"Edit");
//    [self.tableView setEditing:editing animated:YES];
//}

- (EntityListViewController *) initWithDictionary:(NSDictionary *) dictionary{
	if ((self = [super initWithStyle:UITableViewStylePlain])) {
		oldSortNum = 0;
		
		forSignups = [(NSString *)[dictionary objectForKey:@"forSignups"] isEqualToString:@"YES"];
		forEnrollments = [(NSString *)[dictionary objectForKey:@"forEnrollment"] isEqualToString:@"YES"];
		editable = [(NSString *)[dictionary objectForKey:@"editable"] isEqualToString:@"YES"];
		
		NSManagedObjectContext *managedObjectContext = [[CampInfoController instance] managedObjectContext];
		
		self.entityForList = [NSEntityDescription entityForName:(NSString *)[dictionary objectForKey:@"entity"] inManagedObjectContext:managedObjectContext];
		searching = NO;
		letUserSelectRow = YES;
		
		if ([[self.entityForList name] isEqualToString:@"Camper"]) {
			self.styleOptionsForEnity =[NSArray arrayWithObjects: 
								   [EntityListStyleOption styleListOptionWithLabel:@"By Name" andSectionKey:nil andSortKeys:[NSArray arrayWithObjects:@"firstName", @"lastName",nil]],
								   [EntityListStyleOption styleListOptionWithLabel:@"By Cabin" andSectionKey:@"cabin" andSortKeys:[NSArray arrayWithObjects:@"cabin", @"firstName",nil]],
								   nil];
		}
		else if ([[self.entityForList name] isEqualToString:@"Counselor"]) {
			self.styleOptionsForEnity =[NSArray arrayWithObjects: 
								   [EntityListStyleOption styleListOptionWithLabel:@"By Name" andSectionKey:nil andSortKeys:[NSArray arrayWithObjects:@"firstName", @"lastName",nil]],
								   [EntityListStyleOption styleListOptionWithLabel:@"By Cabin" andSectionKey:@"cabin" andSortKeys:[NSArray arrayWithObjects:@"cabin", @"firstName",nil]],
								   nil];
		}
		else if ([[self.entityForList name] isEqualToString:@"Course"]) {
			self.styleOptionsForEnity =[NSArray arrayWithObjects: 
								   [EntityListStyleOption styleListOptionWithLabel:@"By Name" andSectionKey:nil andSortKeys:[NSArray arrayWithObjects:@"name", @"period",nil]],
								   [EntityListStyleOption styleListOptionWithLabel:@"By Period" andSectionKey:@"period" andSortKeys:[NSArray arrayWithObjects:@"period", @"name",nil]],
								   nil];
		}
		else if ([[self.entityForList name] isEqualToString:@"Location"]) {
			self.styleOptionsForEnity =[NSArray arrayWithObjects: 
								   [EntityListStyleOption styleListOptionWithLabel:@"By Name" andSectionKey:nil andSortKeys:[NSArray arrayWithObjects:@"name",nil]],
								   [EntityListStyleOption styleListOptionWithLabel:@"By Creation" andSectionKey:nil andSortKeys:[NSArray arrayWithObjects:@"timeCreated",nil]],
								   nil];
		}
		else if ([[self.entityForList name] isEqualToString:@"Cabin"]) {
			self.styleOptionsForEnity =[NSArray arrayWithObjects: 
								   [EntityListStyleOption styleListOptionWithLabel:@"By Name" andSectionKey:nil andSortKeys:[NSArray arrayWithObjects: @"name",nil]],
								   [EntityListStyleOption styleListOptionWithLabel:@"By Creation" andSectionKey:nil andSortKeys:[NSArray arrayWithObjects:@"timeCreated",nil]],
								   nil];
		}
		else if ([[self.entityForList name] isEqualToString:@"Area"]) {
			self.styleOptionsForEnity =[NSArray arrayWithObjects: 
								   [EntityListStyleOption styleListOptionWithLabel:@"By Name" andSectionKey:nil andSortKeys:[NSArray arrayWithObjects: @"name",nil]],
								   [EntityListStyleOption styleListOptionWithLabel:@"By Creation" andSectionKey:nil andSortKeys:[NSArray arrayWithObjects:@"timeCreated",nil]],
								   nil];
		}		
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.title = [NSString stringWithFormat:@"%@ List", [self.entityForList name]];
	
	UISearchBar *temp = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 90)];
	temp.barStyle=UIBarStyleBlackTranslucent;
	temp.showsCancelButton=NO;
	temp.autocorrectionType=UITextAutocorrectionTypeNo;
	temp.autocapitalizationType=UITextAutocapitalizationTypeNone;
	copyListOfItems = [[NSMutableArray alloc] init];
	
	temp.delegate=self;
	temp.showsScopeBar = YES;
	NSMutableArray *titles = [NSMutableArray arrayWithCapacity:3];
	for (int i = 0; i < [self.styleOptionsForEnity count]; i++) {
		[titles addObject:[(EntityListStyleOption *)[self.styleOptionsForEnity objectAtIndex:i] tabLabel]];
	}
	
	temp.scopeButtonTitles = titles;
	self.tableView.tableHeaderView=temp;
    if (forSignups) {
        if(courseTable == NULL) {
            ClassTableWrapper *controller = [[ClassTableWrapper alloc]init];
            self.courseTable = controller;
            [controller release];
        }
		[self.detailViewController setDetailItem:courseTable];
    }
	[temp release];
    if (editable) {
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntity)];
		self.navigationItem.rightBarButtonItem = addButton;
		[addButton release];	
	}
}

- (void) viewWillAppear:(BOOL)animated {
    NSUndoManager *manager = [[[CampInfoController instance] managedObjectContext] undoManager];
    [manager removeAllActions];
    [self.courseTable clearPerson];
}

- (void) viewWillDisappear:(BOOL)animated {
    if (editable) {
        if ([self.detailViewController.detailItem isKindOfClass:[EntityEditor class]]) {
            [(EntityEditor *)self.detailViewController.detailItem closingTime];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.tableView = nil;
}


- (void)dealloc {
    [infoPopController release];
    [listOfItems release];
	[entityForList release];
	[styleOptionsForEnity release];
	[detailViewController release];
    [copyListOfItems release];
	[formerMO release];
	[ovController release];
    [courseTable release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods
- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
		return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (searching) {
		return [self.copyListOfItems count];
	}
    return [self.listOfItems count];
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *EnityListTableViewCell = @"EnityListTableViewCell";
    
    UITableViewCell *cell =(UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:EnityListTableViewCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:EnityListTableViewCell] autorelease];
    }
	QCThing *oneHero;
	if (searching) {
		oneHero = [self.copyListOfItems objectAtIndex:indexPath.row];
	}
	else {
		oneHero = [self.listOfItems objectAtIndex:indexPath.row];
	}
	
	cell.textLabel.text = [oneHero listName];
	cell.detailTextLabel.text = [oneHero listSubtitle];
	
	
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (searching) {
		self.formerMO = [self.copyListOfItems objectAtIndex:indexPath.row];
		[self doneSearching_Clicked:[NSNull null]];
	}
	else {
		self.formerMO = [self.listOfItems objectAtIndex:indexPath.row];
	}
	if (editable) {
        if ([self.detailViewController.detailItem isKindOfClass:[EntityEditor class]]) {
            [(EntityEditor *)self.detailViewController.detailItem closingTime];
        }
		[theTableView deselectRowAtIndexPath:indexPath animated:YES];
		EntityEditor *controller = [EntityEditor entityEditorForManagedObject:self.formerMO andLookOnly:NO];
		[controller setEntityList:self];
		[self.detailViewController setDetailItem:controller];
	}
	else if (forSignups) {
		PersonScheduleViewController *personScheduleViewController = [PersonScheduleViewController controllerForPerson:(Person *) self.formerMO];
		[self.navigationController pushViewController:personScheduleViewController animated:YES];
        [self.courseTable setPerson:(Person *) self.formerMO];
        [self.courseTable setPersonScheduleViewController: personScheduleViewController];
        [personScheduleViewController setCtvc:self.courseTable.courseTableVC];
        [theTableView deselectRowAtIndexPath:indexPath animated:YES];
	}
    else {
        UIViewController * controller;
        if ([self.formerMO isKindOfClass:[Person class]]) {
            controller =[PersonScheduleViewController controllerForPerson:(Person *)self.formerMO];
            [(PersonScheduleViewController *)controller disableEditing];
        }
        else {
            Course * course = (Course *)self.formerMO;
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
                                               inView:self.detailViewController.view
                             permittedArrowDirections: UIPopoverArrowDirectionLeft  
                                             animated:YES];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(searching)
		return @"";
	return @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return editable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [[CampInfoController instance] managedObjectContext];
        if (searching) {
            [context deleteObject:[self.copyListOfItems objectAtIndex:indexPath.row]];
            if ([self.copyListOfItems objectAtIndex:indexPath.row] == self.formerMO) {
                [self.detailViewController setDetailItem:NULL];		
            }
            [self doneSearching_Clicked:[NSNull null]];
            [self.copyListOfItems removeObjectAtIndex:indexPath.row];
        }
        else {
            [context deleteObject:[self.listOfItems objectAtIndex:indexPath.row]];
            if ([self.listOfItems objectAtIndex:indexPath.row] == self.formerMO) {
                [self.detailViewController setDetailItem:NULL];		
            }
            [self.listOfItems removeObjectAtIndex:indexPath.row];
        }
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving after delete", @"Error saving after delete.") 
                                                            message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.",@"Error was: %@, quitting."), [error localizedDescription]]
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts")
                                                  otherButtonTitles:nil];
            [alert show];
			exit(-1);
		}
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	}   
}

- (NSMutableArray *) listOfItems {
    if (listOfItems == NULL) {
        [self updateTotalList: oldSortNum];
    }
    return listOfItems;
}
  
- (void) updateTotalList:(int)index {
	oldSortNum = index;
	EntityListStyleOption *styleoptions = (EntityListStyleOption *)[self.styleOptionsForEnity objectAtIndex:index];
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithCapacity:3];
	NSSortDescriptor *sortDescriptor1;
	NSSortDescriptor *sortDescriptor2;
	NSSortDescriptor *sortDescriptor3;
	if ([styleoptions.sortKeys count] >= 1) {
		sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:[styleoptions.sortKeys objectAtIndex:0] ascending:YES] autorelease];
		[sortDescriptors addObject:sortDescriptor1];
	}
	if ([styleoptions.sortKeys count] >= 2) {
		sortDescriptor2 = [[[NSSortDescriptor alloc] initWithKey:[styleoptions.sortKeys objectAtIndex:1] ascending:YES] autorelease];
		[sortDescriptors addObject:sortDescriptor2];
	}
	if ([styleoptions.sortKeys count] >= 3) {
		sortDescriptor3 = [[[NSSortDescriptor alloc] initWithKey:[styleoptions.sortKeys objectAtIndex:2] ascending:YES] autorelease];
		[sortDescriptors addObject:sortDescriptor3];
	}

	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setSortDescriptors:sortDescriptors];
   	[fetchRequest setEntity:self.entityForList];
    NSError *error = nil;
    self.listOfItems = [[[[[CampInfoController instance] managedObjectContext] executeFetchRequest:fetchRequest error:&error] mutableCopy] autorelease];

	[sortDescriptors release];
	[fetchRequest release];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    exit(-1); 
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:nil bundle:nil];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController = self;
	
	[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

//RootViewController.m
- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[self.copyListOfItems removeAllObjects];
	
	if([searchText length] != 0) {
		ovController.view.frame = CGRectMake(ovController.view.frame.origin.x, ovController.view.frame.origin.y, ovController.view.frame.size.width, 45);
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		
		for (QCThing *sTemp in self.listOfItems)
		{
			if ([[[sTemp listName] uppercaseString] hasPrefix:[searchText uppercaseString]]) {
				[self.copyListOfItems addObject:sTemp];
			}
		}
		
		
	}
	else {
		ovController.view.frame = CGRectMake(ovController.view.frame.origin.x, ovController.view.frame.origin.y, ovController.view.frame.size.width, self.view.frame.size.height); ;
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}

- (void) objectUpdated:(NSManagedObject *)object {
    ((UISearchBar *)self.tableView.tableHeaderView).selectedScopeButtonIndex = -1;
    int index = [self.listOfItems indexOfObject:object];
    if (index != NSNotFound) {
        //[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void) doneSearching_Clicked:(id)sender {
	
	UISearchBar * searchBar = (UISearchBar *)self.tableView.tableHeaderView;
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	if (editable) {
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEntity)];
		self.navigationItem.rightBarButtonItem = addButton;
		[addButton release];	
	}
	else {
		self.navigationItem.rightBarButtonItem = nil;
	}
	self.tableView.scrollEnabled = YES;
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateTotalList:selectedScope];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return NO;
	}
	return YES;
}


@end