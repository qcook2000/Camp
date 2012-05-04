//
//  ExportViewController.m
//  Camp
//
//  Created by Quenton Cook on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExportViewController.h"
#import "CampAppDelegate.h"
#import "Camper.h"
#import "Counselor.h"
#import "Cabin.h"
#import "Area.h"
#import "Location.h"
#import "ASIS3ObjectRequest.h"

@implementation ExportViewController

@synthesize datePicker,datePickerController,popOverController,searchField,dateField,outputFileFileField,whatControl,whichControl;

@synthesize resultsLabel,allCamperObjects,campersSubset,allCounselorObjects,counselorsSubset,allClassObjects,classesSubset;

@synthesize camperEntity,counselorEntity,courseEntity,dateHeld,scratchFile,HUD,exportForPrint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        self.camperEntity = [NSEntityDescription entityForName:@"Camper" inManagedObjectContext:[[CampInfoController instance] managedObjectContext]];
        self.counselorEntity = [NSEntityDescription entityForName:@"Counselor" inManagedObjectContext:[[CampInfoController instance] managedObjectContext]];
        self.courseEntity  = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:[[CampInfoController instance] managedObjectContext]];
         
        NSFetchRequest * fetch1 = [[[NSFetchRequest alloc] init] autorelease];
        [fetch1 setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:[[CampInfoController instance] managedObjectContext]]];
        [fetch1 setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"period" ascending:YES],
                                                             [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil]];
        NSFetchRequest * fetch2 = [[[NSFetchRequest alloc] init] autorelease];
        [fetch2 setEntity:[NSEntityDescription entityForName:@"Camper" inManagedObjectContext:[[CampInfoController instance] managedObjectContext]]];
        [fetch2 setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"cabin.name" ascending:YES],
                                                             [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES], nil]];
        NSFetchRequest * fetch3 = [[[NSFetchRequest alloc] init] autorelease];
        [fetch3 setEntity:[NSEntityDescription entityForName:@"Counselor" inManagedObjectContext:[[CampInfoController instance] managedObjectContext]]];
        [fetch3 setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES], nil]];
        
        self.allClassObjects = [[[CampInfoController instance] managedObjectContext] executeFetchRequest:fetch1 error:nil];
        self.allCamperObjects = [[[CampInfoController instance] managedObjectContext] executeFetchRequest:fetch2 error:nil];
        self.allCounselorObjects = [[[CampInfoController instance] managedObjectContext] executeFetchRequest:fetch3 error:nil];
        
        self.datePickerController = [[DateAndTimePickerController alloc] initWithNibName:nil bundle:nil];
        [self.datePickerController setContentSizeForViewInPopover: CGSizeMake(320, 216)];
        self.popOverController = [[UIPopoverController alloc] initWithContentViewController:self.datePickerController];
        self.popOverController.delegate = self;
        
        
        self.scratchFile = [[[CampInfoController instance] applicationDocumentsDirectory] stringByAppendingPathComponent:@"scratch.html"];
        [[CampInfoController instance] checkFileName:@"scratch.html"];
        
        // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
        self.HUD = [[[MBProgressHUD alloc] initWithView:[[(CampAppDelegate *)[[UIApplication sharedApplication] delegate] splitViewController] view]] autorelease];
        
        //HUD.graceTime = 0.5;
        self.HUD.minShowTime = 1.0;
        
        // Add HUD to screen
        [[[(CampAppDelegate *)[[UIApplication sharedApplication] delegate] splitViewController] view] addSubview:self.HUD];
        
        // Regisete for HUD callbacks so we can remove it from the window at the right time
        self.HUD.delegate = self;
    }
    return self;
}

- (void)hudWasHidden:(MBProgressHUD *)hud{

}

- (IBAction) segmentedControlChange{
    if (self.whichControl.selectedSegmentIndex == 0) {
        self.outputFileFileField.userInteractionEnabled = NO;
        self.outputFileFileField.borderStyle = UITextBorderStyleNone;
        self.outputFileFileField.textColor = [UIColor grayColor];
        self.searchField.hidden = YES;
        self.dateField.hidden = YES;
        if (self.whatControl.selectedSegmentIndex == 0) {
            // Campers
            self.outputFileFileField.text = @"camperLocator.html";
        }
        else if (self.whatControl.selectedSegmentIndex == 1) {
            // Counselors
            self.outputFileFileField.text = @"counselorLocator.html";
        }
        else {
            // Classes
            self.outputFileFileField.text = @"classRosters.html";
        }
    }
    else {
        //self.outputFileFileField.userInteractionEnabled = YES;
        //self.outputFileFileField.borderStyle = UITextBorderStyleRoundedRect;
        //self.outputFileFileField.textColor = [UIColor blackColor];
        [self setOutputFileNameCorrect];
    }
    self.campersSubset = [NSArray array];
    self.counselorsSubset = [NSArray array];
    self.classesSubset = [NSArray array];
    self.searchField.text = nil;
    self.dateField.text = nil;
    [self.searchField resignFirstResponder];
    [self.dateField resignFirstResponder];
    [self.outputFileFileField resignFirstResponder];
    [self updateLabels];
}

- (void) setOutputFileNameCorrect
{
    if (self.whichControl.selectedSegmentIndex == 1) {
        self.searchField.hidden = NO;
        self.dateField.hidden = YES;
        if (self.whatControl.selectedSegmentIndex == 0) {
            // Campers
            self.outputFileFileField.text = @"camperSearchResults.html";
        }
        else if (self.whatControl.selectedSegmentIndex == 1) {
            // Counselors
            self.outputFileFileField.text = @"counselorSearchResults.html";
        }
        else {
            // Classes
            self.outputFileFileField.text = @"classSearchResults.html";
        }
    }
    else {
        self.searchField.hidden = YES;
        self.dateField.hidden = NO;
        if (self.whatControl.selectedSegmentIndex == 0) {
            // Campers
            self.outputFileFileField.text = @"camperChronoResults.html";
        }
        else if (self.whatControl.selectedSegmentIndex == 1) {
            // Counselors
            self.outputFileFileField.text = @"counselorChronoResults.html";
        }
        else {
            // Classes
            self.outputFileFileField.text = @"classChronoResults.html";
        }
    }

}

- (IBAction) exportForPrintPressed {
    if (self.whichControl.selectedSegmentIndex == 0) {
        if (self.whatControl.selectedSegmentIndex == 0) {
            // Campers
            [self exportPeople:self.allCamperObjects withTitle:@"Camper Locator File" splittingByCabin:YES];
            [HUD showWhileExecuting:@selector(pushFileWithPathToS3WithPath:) 
                           onTarget:[CampInfoController instance] 
                         withObject:[NSArray arrayWithObjects:self.scratchFile, @"exports/camperLocator.html", nil] 
                           animated:YES];
        }
        else if (self.whatControl.selectedSegmentIndex == 1) {
            // Counselors
            [self exportPeople:self.allCounselorObjects withTitle:@"Counselor Locator File" splittingByCabin:NO];
            [HUD showWhileExecuting:@selector(pushFileWithPathToS3WithPath:) 
                           onTarget:[CampInfoController instance] 
                         withObject:[NSArray arrayWithObjects:self.scratchFile, @"exports/counselorLoc.html", nil] 
                           animated:YES];
        }
        else {
            // Classes
            [self exportClasses: self.allClassObjects withTitle:@"Class Rosters" splittingByPeriod:YES];
            [HUD showWhileExecuting:@selector(pushFileWithPathToS3WithPath:) 
                           onTarget:[CampInfoController instance] 
                         withObject:[NSArray arrayWithObjects:self.scratchFile, @"exports/classRosters.html", nil] 
                           animated:YES];
            
        }
    }
    else {
        if (self.whichControl.selectedSegmentIndex == 1) {
            if (self.whatControl.selectedSegmentIndex == 0) {
                // Campers
                [self exportPeople:self.campersSubset withTitle:[NSString stringWithFormat:@"Camper Search Results: %@", self.searchField.text] splittingByCabin:NO];
                [HUD showWhileExecuting:@selector(pushFileWithPathToS3WithPath:) 
                               onTarget:[CampInfoController instance] 
                             withObject:[NSArray arrayWithObjects:self.scratchFile, [NSString stringWithFormat:@"exports/%@",self.outputFileFileField.text], nil] 
                               animated:YES];
            }
            else if (self.whatControl.selectedSegmentIndex == 1) {
                // Counselors
                [self exportPeople:self.counselorsSubset withTitle:[NSString stringWithFormat:@"Counselor Search Results: %@", self.searchField.text] splittingByCabin:NO];
                [HUD showWhileExecuting:@selector(pushFileWithPathToS3WithPath:) 
                               onTarget:[CampInfoController instance] 
                             withObject:[NSArray arrayWithObjects:self.scratchFile, [NSString stringWithFormat:@"exports/%@",self.outputFileFileField.text], nil] 
                               animated:YES];
            }
            else {
                // Classes
                [self exportClasses: self.classesSubset withTitle:[NSString stringWithFormat:@"Class Search Results: %@", self.searchField.text] splittingByPeriod:YES];
                [HUD showWhileExecuting:@selector(pushFileWithPathToS3WithPath:) 
                               onTarget:[CampInfoController instance] 
                             withObject:[NSArray arrayWithObjects:self.scratchFile,[NSString stringWithFormat:@"exports/%@",self.outputFileFileField.text], nil] 
                               animated:YES];
            }
        }
        else {
            if (self.whatControl.selectedSegmentIndex == 0) {
                // Campers
                [self exportPeople:self.campersSubset withTitle:[NSString stringWithFormat:@"Campers Updated Since: %@", self.dateField.text] splittingByCabin:NO];
                [HUD showWhileExecuting:@selector(pushFileWithPathToS3WithPath:) 
                               onTarget:[CampInfoController instance] 
                             withObject:[NSArray arrayWithObjects:self.scratchFile, [NSString stringWithFormat:@"exports/%@",self.outputFileFileField.text], nil] 
                               animated:YES];
            }
            else if (self.whatControl.selectedSegmentIndex == 1) {
                // Counselors
                [self exportPeople:self.counselorsSubset withTitle:[NSString stringWithFormat:@"Counselors Updated Since: %@", self.dateField.text] splittingByCabin:NO];
                [HUD showWhileExecuting:@selector(pushFileWithPathToS3WithPath:) 
                               onTarget:[CampInfoController instance] 
                             withObject:[NSArray arrayWithObjects:self.scratchFile, [NSString stringWithFormat:@"exports/%@",self.outputFileFileField.text], nil] 
                               animated:YES];
            }
            else {
                // Classes
                [self exportClasses: self.classesSubset withTitle:[NSString stringWithFormat:@"Classes Updated Since: %@", self.dateField.text] splittingByPeriod:YES];
                [HUD showWhileExecuting:@selector(pushFileWithPathToS3WithPath:) 
                               onTarget:[CampInfoController instance] 
                             withObject:[NSArray arrayWithObjects:self.scratchFile,[NSString stringWithFormat:@"exports/%@",self.outputFileFileField.text], nil] 
                               animated:YES];
            }
        }
    }
}

- (void)dealloc
{
    [ datePicker release];
    [ datePickerController release];
    [ popOverController release];
    
    [searchField release];
    [dateField release];
    [outputFileFileField release];
    
    [whatControl release];
    [whichControl release];
    
    [resultsLabel release];
    
    [exportForPrint release];
    
    [ allCamperObjects release];
    [ campersSubset release];
    
    [ allCounselorObjects release];
    [ counselorsSubset release];
    
    [ allClassObjects release];
    [ classesSubset release];
    
    [ camperEntity release];
    [ counselorEntity release];
    [ courseEntity release];
    [ dateHeld release];
    [scratchFile release];
    [HUD release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateLabels];

}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Searching

- (NSArray *) searchForEntities:(NSEntityDescription *) entity withString:(NSString *) string {
    NSMutableArray * objects = [NSMutableArray arrayWithCapacity:300];
    if (entity == self.camperEntity ) {
        for (Camper * camper in self.allCamperObjects) {
            if ([[camper listName] rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound || [camper.cabin.name rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound){
                [objects addObject:camper];
            }
        } 
    }
    else if (entity == self.counselorEntity ) {
        for (Counselor * counselor in self.allCounselorObjects) {
            if ([[counselor listName] rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound || [counselor.cabin.name rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound){
                [objects addObject:counselor];
            }
        } 
    }
    else if (entity == self.courseEntity ){
        for (Course * course in self.allClassObjects) {
            if ([[course listName] rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound || [[course listSubtitle] rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound){
                [objects addObject:course];
            }
        } 
    }
    return objects;
}

- (NSArray *) searchForEntities:(NSEntityDescription *) entity withDate:(NSDate *) date {
    NSFetchRequest * allEntities = [[NSFetchRequest alloc] init];
    [allEntities setEntity:entity];
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"%K > %@", @"timeStamp", date];
    [allEntities setPredicate: predicate];
    if (entity == self.courseEntity) {
        [allEntities setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"period" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil]];
    }
    else if (entity == self.camperEntity) {
        [allEntities setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"cabin.name" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES], nil]];
    }
    else {
        [allEntities setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES], nil]];
    }
    NSError * error = nil;
    NSArray * objects = [[[CampInfoController instance] managedObjectContext] executeFetchRequest:allEntities error:&error];
    [allEntities release];
    return objects;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.outputFileFileField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view  cache:YES];
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
        [UIView commitAnimations]; 
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == self.searchField && self.whichControl.selectedSegmentIndex == 1) {
        if (self.whatControl.selectedSegmentIndex == 0) {
            if (textField.text != NULL && textField.text.length > 0) {
                self.campersSubset = [self searchForEntities: self.camperEntity withString:textField.text];
            }
            else {
                self.campersSubset = [NSArray array];
            }
        }
        else if (self.whatControl.selectedSegmentIndex == 1) {
            if (textField.text != NULL && textField.text.length > 0) {
                self.counselorsSubset = [self searchForEntities: self.counselorEntity withString:textField.text];
            }
            else {
                self.counselorsSubset = [NSArray array];
            }
        }
        else {
            if (textField.text != NULL && textField.text.length > 0) {
                self.classesSubset = [self searchForEntities: self.courseEntity withString:textField.text];
            }
            else {
                self.classesSubset = [NSArray array];
            }
        }
    }
    else if(textField == self.outputFileFileField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view  cache:YES];
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 200);
        [UIView commitAnimations]; 
        if (textField.text == nil || [textField.text length] == 0 || ![textField.text hasSuffix:@".html"]) {
            [self setOutputFileNameCorrect];
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Bad file name" message:@"Output files must end in \".html\"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
            [alert show];
        }
    }
    [self updateLabels];
    return;
	
}

- (void) updateLabels {
    if (self.whichControl.selectedSegmentIndex == 0) {
        if (self.whatControl.selectedSegmentIndex == 0) {
            self.resultsLabel.text = [NSString stringWithFormat:@"All %d Campers", [self.allCamperObjects count]];
        }
        else if (self.whatControl.selectedSegmentIndex == 1) {
            self.resultsLabel.text = [NSString stringWithFormat:@"All %d Counselors", [self.allCounselorObjects count]];
        }
        else {
            self.resultsLabel.text = [NSString stringWithFormat:@"All %d Classes", [self.allClassObjects count]];
        }
    }
    else {
        if (self.whatControl.selectedSegmentIndex == 0) {
            self.resultsLabel.text = [NSString stringWithFormat:@"%d Campers", [self.campersSubset count]];
        }
        else if (self.whatControl.selectedSegmentIndex == 1) {
            self.resultsLabel.text = [NSString stringWithFormat:@"%d Counselors", [self.counselorsSubset count]];
        }
        else {
            self.resultsLabel.text = [NSString stringWithFormat:@"%d Classes", [self.classesSubset count]];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

# pragma mark - Actions

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.dateField == textField) {
        [self.outputFileFileField resignFirstResponder];
        [self.searchField resignFirstResponder];
        if (self.dateField.text == nil || [self.dateField.text length] == 0) {
            self.datePickerController.dPicker.date = [NSDate date];
        }

        [self.popOverController presentPopoverFromRect:CGRectMake(70, 30, 1, 1) inView:self.dateField permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        return NO;
    }
    return YES;
}  

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.dateHeld = self.datePickerController.dPicker.date;
    if (self.whatControl.selectedSegmentIndex == 0) {
        self.campersSubset = [self searchForEntities:self.camperEntity withDate: self.dateHeld ];
    }
    else if (self.whatControl.selectedSegmentIndex == 1) {
        self.counselorsSubset = [self searchForEntities:self.counselorEntity withDate: self.dateHeld ];
    }
    else {
        self.classesSubset = [self searchForEntities:self.courseEntity withDate: self.dateHeld ];
    }
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dateField.text = [formatter stringFromDate:self.dateHeld];
}

- (void) exportPeople:(NSArray *) peopleToExport withTitle: (NSString *) title splittingByCabin:(BOOL) split{
    if (peopleToExport == NULL || [peopleToExport count] == 0) {
        return;
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.scratchFile];
    [fileHandle truncateFileAtOffset:0];
    [[CampInfoController instance] checkFileName:@"personHeader.txt"];
    [[CampInfoController instance] checkFileName:@"personFooter.txt"];
    [self appendFile:[[[CampInfoController instance] applicationDocumentsDirectory] stringByAppendingPathComponent:@"personHeader.txt"] to:fileHandle withTitle:title];
    int i = 1;
    Cabin *cabin = [(Person *)[peopleToExport objectAtIndex:0] valueForKey:@"cabin"];
    int cabinInt = 1;
    for (Person * person in peopleToExport) {
        if (cabin != [person valueForKey:@"cabin"]) {
            cabin = [person valueForKey:@"cabin"];
            cabinInt++;
        }
        [fileHandle writeData:[[self htmlForPerson:person andNumber:i andCabinNumber: cabinInt] dataUsingEncoding:NSUTF8StringEncoding]];
        i++;
    }
    NSString * string = split ? @"true" : @"false";
    [self appendFile:[[[CampInfoController instance] applicationDocumentsDirectory] stringByAppendingPathComponent:@"personFooter.txt"] to:fileHandle withTitle:string];  
    [fileHandle closeFile];
}

- (void) exportClasses:(NSArray *) classesToExport withTitle: (NSString *) title splittingByPeriod:(BOOL) split{
    if (classesToExport == NULL || [classesToExport count] == 0) {
        return;
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.scratchFile];
    [fileHandle truncateFileAtOffset:0];
    [[CampInfoController instance] checkFileName:@"classHeader.txt"];
    [[CampInfoController instance] checkFileName:@"classFooter.txt"];
    [self appendFile:[[[CampInfoController instance] applicationDocumentsDirectory] stringByAppendingPathComponent:@"classHeader.txt"] to:fileHandle withTitle:title];
    int i = 1;
    int period = 1;
    for (Course * course in classesToExport) {
        if (period != [course.period intValue]) {
            period = [course.period intValue];
        }
        [fileHandle writeData:[[self htmlForCourse:course andNumber:i andPeriod:period] dataUsingEncoding:NSUTF8StringEncoding]];
        i++;
    }
    NSString * string = split ? @"true" : @"false";
    [self appendFile:[[[CampInfoController instance] applicationDocumentsDirectory] stringByAppendingPathComponent:@"classFooter.txt"] to:fileHandle withTitle:string];  
    [fileHandle closeFile];
}


- (void) appendFile:(NSString *) fileName to: (NSFileHandle *)fileHandle withTitle: (NSString *) title{
    NSString * boilerplate = [NSString stringWithContentsOfFile: fileName encoding: NSUTF8StringEncoding error:NULL];
    boilerplate = [boilerplate stringByReplacingOccurrencesOfString:@"XXXXXXXXXXXX" withString:title];
    [fileHandle writeData:[boilerplate dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *) htmlForPerson:(Person *) person andNumber: (int) number andCabinNumber: (int) cabinInt{
    NSMutableString * personHTML = [NSMutableString stringWithCapacity:1000];
    [personHTML appendFormat:@"<div id=\"%d\" class=\"schedDiv\" cabin=\"%d\">",number, cabinInt];
    [personHTML appendFormat:@"<div class=\"schedNameLine\">%@</div>", [person listName]];
    NSSet * courses = [person valueForKey:@"courses"];
    BOOL needsOtherMini = NO;
    BOOL hasAnyClass = NO;
    for (int i = 1; i <= 5; i++) {
        for (int g = 0; g <= 2; g++) {
            for (Course * course in courses) {
                if ([course.period intValue] == i && [course.miniNum intValue] == g) {
                    if (g == 0) {
                        [personHTML appendFormat:@"<div class=\"schedTitleLine\">%d: %@</div><div class=\"schedLocLine\">@: %@</div>", i, course.name, course.location.name];
                    }
                    else if (g == 1) {
                        needsOtherMini = YES;
                        [personHTML appendFormat:@"<div class=\"schedTitleLine\">%d M1: %@</div><div class=\"schedLocLine\">@: %@</div>", i, course.name, course.location.name];
                    }
                    else if (g == 2 && !needsOtherMini) {
                        needsOtherMini = NO;
                        [personHTML appendFormat:@"<div class=\"schedTitleLine\">%d M1: NOT ENROLLED</div><div class=\"schedLocLine\">@: </div>"];
                        [personHTML appendFormat:@"<div class=\"schedTitleLine\">%d M2: %@</div><div class=\"schedLocLine\">@: %@</div>", i, course.name, course.location.name];
                    }
                    else if (g == 2) {
                        needsOtherMini = NO;
                        [personHTML appendFormat:@"<div class=\"schedTitleLine\">%d M2: %@</div><div class=\"schedLocLine\">@: %@</div>", i, course.name, course.location.name];
                    }
                    hasAnyClass = YES;
                    break;
                }
            }
        }
        if (needsOtherMini) {
            [personHTML appendFormat:@"<div class=\"schedTitleLine\">%d M2: NOT ENROLLED</div><div class=\"schedLocLine\">@: </div>", i];
        }
        if(!hasAnyClass) {
            if (i == 5 && [person class] == [Camper class]) { 
            }
            else {
                [personHTML appendFormat:@"<div class=\"schedTitleLine\">%d: NOT ENROLLED</div><div class=\"schedLocLine\">@: </div>", i];
            }
        }
        hasAnyClass = NO;
        needsOtherMini = NO;
    }
    [personHTML appendFormat:@"</div>\n"];
    return personHTML;
}

- (NSString *) htmlForCourse:(Course *) course andNumber: (int) number andPeriod: (int) period{
    NSMutableString * courseHTML = [NSMutableString stringWithCapacity:1000];
    [courseHTML appendFormat:@"<div id=\"%d\" class=\"courseDiv\" period=\"%d\">",number, period];
    [courseHTML appendFormat:@"<div class=\"courseTitleLine\">%@, L: %d</div>",course.name, [course.limit intValue]];
    if ([course.miniNum intValue] != 0) {
        [courseHTML appendFormat:@"<div class=\"courseSubtitleLine\">P: %d, M: %d, %@</div>",[course.period intValue], [course.miniNum intValue], course.location.name];
    }
    else {
        [courseHTML appendFormat:@"<div class=\"courseSubtitleLine\">P: %d, %@</div>",[course.period intValue], course.location.name];
    }
    [courseHTML appendFormat:@"<div class=\"courseDivider\"></div>"];
    BOOL first = true;
    [courseHTML appendFormat:@"<div class=\"courseTeacherLine\">"];
    for (Counselor * counselor in course.counselors) {
        if (!first) {
            [courseHTML appendFormat:@" - %@", [counselor listName]];
        }
        else {
            first = false;
            [courseHTML appendFormat:@"%@", [counselor listName]];
        }
    }
    [courseHTML appendFormat:@"</div>"];
    [courseHTML appendFormat:@"<div class=\"courseDivider\"></div>"];
    int numOfCampers = 0;
    for (Camper * camper in course.campers) {
        numOfCampers++;
        [courseHTML appendFormat:@"<div class=\"courseCamperLine\">%d: %@</div>", numOfCampers, [camper listName]];        
    }
    numOfCampers++;
    while (numOfCampers <= [course.limit intValue]) {
        [courseHTML appendFormat:@"<div class=\"courseCamperLine\">%d:</div>", numOfCampers];   
        numOfCampers++;
    }
    [courseHTML appendFormat:@"</div>\n"];
    return courseHTML;
}



@end
