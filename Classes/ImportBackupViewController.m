//
//  ImportBackupViewController.m
//  Camp
//
//  Created by Quenton Cook on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImportBackupViewController.h"
#import "ASIS3BucketObject.h"
#import "CampAppDelegate.h"

@implementation ImportBackupViewController
@synthesize ivc;
@synthesize tableView;
@synthesize availableBackups;
@synthesize HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect bounds = self.view.bounds;
        
        UIToolbar * toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 44)] autorelease];
        toolBar.barStyle = UIBarStyleDefault;
        UIBarButtonItem * fixi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
        fixi.width = 70;
        fixi.enabled = NO;
        UIBarButtonItem * flexi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        flexi.enabled = NO;
        UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 200, 20)] autorelease];
        label.text = @"Choose a backup...";
        label.font = [UIFont boldSystemFontOfSize:20];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.textAlignment = UITextAlignmentCenter;
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1.0);
        UIBarButtonItem * title = [[[UIBarButtonItem alloc] initWithCustomView:label]autorelease];
        [toolBar setItems:[NSArray arrayWithObjects:fixi,flexi,title,flexi,[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)] autorelease], nil]];
        
        
        [self.view addSubview:toolBar];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, bounds.size.width, bounds.size.height - 44) style:UITableViewStyleGrouped];
        self.tableView.opaque = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.tableView];
        // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
        self.HUD = [[MBProgressHUD alloc] initWithView: self.view];
        //HUD.graceTime = 0.5;
        self.HUD.minShowTime = 0.5;
        // Add HUD to screen
        [self.view addSubview:self.HUD];
        // Regisete for HUD callbacks so we can remove it from the window at the right time
        self.HUD.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed) name:@"downloadFailed" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupListDownloaded) name:@"backupListDownloaded" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupDownloaded) name:@"backupDownloaded" object:nil];
        [HUD show:YES];
        [[CampInfoController instance] downLoadAvailableBackupsFromServer:YES];
    }
    return self;
}
- (void)hudWasHidden:(MBProgressHUD *)hud{}

- (void) downloadFailed{
    NSLog(@"Download failed");
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Download Failed" message:@"Sorry, check your internet connection and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
    [alert show];
    [self.ivc dismissModalViewControllerAnimated:YES];
    [HUD hide:YES];
}
- (void) backupListDownloaded{
    NSLog(@"Download list success");
    self.availableBackups = [[CampInfoController instance] availableBackups];
    [self.tableView reloadData];
    [HUD hide:YES];
}
- (void) backupDownloaded{
    NSLog(@"Download backup success");
    [HUD hide:YES];
    [self.ivc dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.ivc dismissModalViewControllerAnimated:YES];
}


- (void)dealloc
{
    [HUD release];
    [tableView release];
    [ivc release];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;
    return [self.availableBackups count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    NSString * string = [[(ASIS3BucketObject *)[availableBackups objectAtIndex:indexPath.row] key] substringWithRange:NSMakeRange(8, 16)];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy_MM_dd_HH_mm"];
    NSDate * date = [formatter dateFromString:string];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    cell.textLabel.text = [formatter stringFromDate:date];
    return cell;

}

- (IBAction) cancelPressed {
    [self.ivc dismissModalViewControllerAnimated:YES];
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([actionSheet destructiveButtonIndex] == buttonIndex) {
        [HUD show:YES];
        [[CampInfoController instance] downloadBackupAtIndex:indexRow];
    }
    else {
        [self.ivc dismissModalViewControllerAnimated:YES];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    indexRow = indexPath.row;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Yes, load this backup" otherButtonTitles: @"Cancel",nil];
    [actionSheet showInView:self.view];
}

@end
