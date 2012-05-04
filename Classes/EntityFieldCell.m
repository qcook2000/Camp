//
//  EntityFieldCell.m
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EntityFieldCell.h"


@implementation EntityFieldCell
@synthesize moAttribute;
@synthesize entityLabel;
@synthesize button;
@synthesize pickControl;
@synthesize listOfPickerThings;
@synthesize popC;


	
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.listOfPickerThings count];
}
			
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *EnityListTableViewCell = @"CellID";
    
    UITableViewCell *cell =(UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:EnityListTableViewCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EnityListTableViewCell] autorelease];
    }
	cell.textLabel.text = [(QCThing *)[self.listOfPickerThings objectAtIndex:indexPath.row] listName];
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	self.moAttribute = [listOfPickerThings objectAtIndex:indexPath.row];
	self.entityLabel.text = [(QCThing *)moAttribute listName];
    [self.currentManagedObject setValue:moAttribute forKey:self.key];
    self.entityEditor.saveNeeded = YES;
	[popC dismissPopoverAnimated:YES];
}




- (void) reCreateWith:(NSManagedObject *)theManagedObject andKey: (NSString *)thekey andLabel: (NSString *)thelabel{
	self.currentManagedObject = theManagedObject;
	self.key = thekey;
	self.textLabel.text = thelabel;
	
	self.moAttribute = (QCThing *)[currentManagedObject valueForKey:self.key];
	
	NSFetchRequest * fetch = [[[NSFetchRequest alloc] init] autorelease];
	[fetch setEntity: [NSEntityDescription entityForName:thelabel inManagedObjectContext:[theManagedObject managedObjectContext]]];
	[fetch setSortDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease]]];
	self.listOfPickerThings = [[self.currentManagedObject managedObjectContext] executeFetchRequest:fetch error:nil];
	
	
	[self updateEntityLabel];
	self.pickControl  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 400) style:UITableViewStylePlain];
	[self.pickControl setDelegate:self];
	[self.pickControl setDataSource:self];
	[self.pickControl reloadData];
}

- (void) updateEntityLabel{
	self.entityLabel.text = [moAttribute listName];
}

- (void) showPopover{
    [self.entityEditor newFirstResponder:nil];
    UIViewController *pickCont = [[[UIViewController alloc] init] autorelease];
	//[pickCont.view setFrame:CGRectMake(0 ,0 ,320, 216)];
	[pickCont.view addSubview:self.pickControl];
	UIPopoverController *pCont = [[[UIPopoverController alloc] initWithContentViewController:pickCont] autorelease];
	[pCont setPopoverContentSize:CGSizeMake(250, 400)];
	[pCont presentPopoverFromRect:CGRectMake(20, 35, 1, 1) inView:self.button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	if (moAttribute != nil) {
		[pickControl selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.listOfPickerThings indexOfObject:moAttribute] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop]; 
	}
	self.popC = pCont;
	if (moAttribute != nil) {
		//Flip to correct cabin
	}
	
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UILabel *stringTextField = [[UILabel alloc] initWithFrame:CGRectMake(188, 4, 462, 35)];
		stringTextField.adjustsFontSizeToFitWidth = YES;
		stringTextField.textColor = [UIColor blackColor];
		stringTextField.backgroundColor = [UIColor clearColor];
		stringTextField.textAlignment = UITextAlignmentLeft;
		[self addSubview:stringTextField];
		entityLabel = stringTextField;
		[stringTextField release];
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(188, 5, 462, 35);
		[button addTarget:self action:@selector(showPopover) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
		[self showPopover];
	}
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[moAttribute release];
	[entityLabel release];
	[button release];
	[pickControl release];
	[listOfPickerThings release];
	[popC release];
    [super dealloc];
}


@end
