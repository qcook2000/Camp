//
//  CampInfoController.m
//  Camp
//
//  Created by Quenton Cook on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CampInfoController.h"
#import "Camper.h"
#import "Counselor.h"
#import "Location.h"
#import "Area.h"
#import "Course.h"
#import "Cabin.h"
#import "Course.h"
#import "ASIS3ObjectRequest.h"
#import "ASIS3BucketRequest.h"
#import "ASIS3BucketObject.h"

@implementation CampInfoController

@synthesize basicsFlag;
@synthesize counselorsFlag;
@synthesize campersFlag;
@synthesize classesFlag;
@synthesize camperEnrsFlag;
@synthesize bucket;
@synthesize availableBackups;
@synthesize s3key,s3secretKey,userName,password;

bool hasClearedCamperEnr = false;
bool hasClearedCounselorEnr = false;

static CampInfoController *gInstance = NULL;

+ (CampInfoController *)instance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return(gInstance);
}

- (CampInfoController *) init {
    if ((self = [super init])) {
        
        [self loadVariablesFromDefaults];
        if (s3key == nil || [s3key length] == 0 || s3secretKey == nil || [s3secretKey length] == 0 || bucket == nil || [bucket length] == 0) {
            [self loadTestVariables];
        }
        [ASIS3ObjectRequest setSharedAccessKey:s3key];
        [ASIS3ObjectRequest setSharedSecretAccessKey:s3secretKey];
    }
    return self;
}

- (void) loadTestVariables {
    self.s3key = @"AKIAJ5AVNAWVRICYMDSQ";
    self.s3secretKey = @"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";
    self.bucket = @"testscheduleomatic";
    self.userName = nil;
    self.password = nil;
}

- (void) loadVariablesFromDefaults{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.s3key = [defaults objectForKey:@"s3key"];
    self.s3secretKey = [defaults objectForKey:@"s3secretKey"];
    self.userName = [defaults objectForKey:@"userName"];
    self.password = [defaults objectForKey:@"password"];
    self.bucket = [defaults objectForKey:@"bucket"];
}

- (BOOL) testS3withKey: (NSString *) key andSecret: (NSString *) secKey andBucket:(NSString *) theBucket {
    ASIS3BucketRequest *request = [ASIS3BucketRequest requestWithBucket:theBucket];
    request.secretAccessKey = secKey;
    request.accessKey = key;
    [request startSynchronous];
	if (![request error]) {
		return YES;
	} else {
		return NO;
	}
}

- (NSString *) setNewUN:(NSString *)newUN forOldUN:(NSString *)oldUN andNewPW:(NSString *) newPW forOldPW:(NSString *) oldPW andAK:(NSString *)s3Key andASK: (NSString *) s3sKey andBucket:(NSString*) thebucket andIgnoreOldPW:(BOOL)ignoreOldPW{
    if ((newPW == nil || [newPW length] == 0 || newUN == nil || [newUN length] == 0) && !( newUN == nil && newPW == nil  && [thebucket isEqualToString:@"testscheduleomatic"] )) {
        return @"badNewCred";
    }
    if ([s3Key isEqualToString:@"qqq"] && [s3sKey isEqualToString:@"qqq"]) {
        s3Key = @"AKIAJ5AVNAWVRICYMDSQ";
        s3sKey = @"mnlvNEWJYJWT4EIrZ6Aswc16isyO0EZG8F5KXloc";
    }
    if (ignoreOldPW || (password == nil && userName == nil) || ([password isEqualToString:oldPW] && [userName isEqualToString:oldUN])) {
        if ([self testS3withKey:s3Key andSecret:s3sKey andBucket:thebucket]) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:s3Key forKey:@"s3key"];
            [defaults setObject:s3sKey forKey:@"s3secretKey"];
            [defaults setObject:newUN forKey:@"userName"];
            [defaults setObject:newPW forKey:@"password"];
            [defaults setObject:thebucket forKey:@"bucket"];
            // TOP SECRET
            [defaults synchronize];
            [self loadVariablesFromDefaults];
            return @"good";
        }
        else {
            return @"badS3";
        }
    }
    else {
        return @"badOldCred";
    }
}

- (BOOL) resetToTestS3{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"s3key"];
    [defaults setObject:nil forKey:@"s3secretKey"];
    [defaults setObject:nil forKey:@"userName"];
    [defaults setObject:nil forKey:@"password"];
    [defaults setObject:nil forKey:@"bucket"];
    [defaults synchronize];
    [self loadTestVariables];
    return TRUE;
}





#pragma mark -
#pragma mark Core Data stack


- (void) persistentStoreReload {
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Camp.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved Persistent Store error %@, %@", error, [error userInfo]);
        abort();
    }    
}

- (void) managedObjectContextReload {
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        //Undo Support
        NSUndoManager *anUndoManager = [[NSUndoManager  alloc] init];
        [managedObjectContext_ setUndoManager:anUndoManager];
        [anUndoManager release];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTimestamps)
                                                     name:NSManagedObjectContextWillSaveNotification
                                                   object:[[CampInfoController instance] managedObjectContext]];
    }
}

- (void) shutDown{
    NSError *error = nil;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void) managedObjectContextSwitch {
    [self persistentStoreReload];
    [self managedObjectContextReload];
}

- (void) updateTimestamps{
	NSSet* updatedObjects = [self.managedObjectContext updatedObjects];
	NSDate *date = [NSDate date];
	for  (QCThing* mo in updatedObjects) {
		mo.timeStamp = date;
	}
	updatedObjects = [self.managedObjectContext insertedObjects];
	for  (QCThing* mo in updatedObjects) {
		mo.timeCreated = date;
        mo.timeStamp = date;
	}
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    [self managedObjectContextReload];
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Camp" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    [self persistentStoreReload];
    return persistentStoreCoordinator_;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) checkFileName:(NSString *) fileName {
    // Check if the INTERNAL rep has already been saved to the pad
    BOOL success;
    
    // Create a FileManager object, we will use this to check the status
    // of the file and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:fileName]];
    // If the database already exists then return without doing anything
    if(!success){
        // If not then proceed to copy the database from the application to the users filesystem
        
        // Get the path to the database in the application package
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        
        // Copy the database from the package to the users filesystem
        [fileManager copyItemAtPath:databasePathFromApp toPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:fileName] error:nil];
    }
    
}

#pragma mark - Import Export


- (void) setBasics:(int)theBasicsFlag andCounselors:(int)theCounselorFlag andCampers:(int)theCampersFlag andClasses:(int)theClassesFlag andCamperEnr:(int)theCampEnrFlag
{
    basicsFlag = theBasicsFlag;
    counselorsFlag = theCounselorFlag;
    campersFlag = theCampersFlag;
    classesFlag = theClassesFlag;
    camperEnrsFlag = theCampEnrFlag;
}

-(NSString *) requestStringFromAmazon:(NSString*) path {
    
	ASIS3ObjectRequest *request = [ASIS3ObjectRequest requestWithBucket:self.bucket key:path];
	[request startSynchronous];
	if (![request error]) {
		NSString *responseString = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding]autorelease];
		return responseString;
	} else {
		NSLog(@"%@",[[request error] localizedDescription]);
        downLoadingOk = false;
		return nil;
	}
}

- (void) importWithOptions{
    downLoadingOk = true;
    if (basicsFlag == 1) {
        [self importBasics];
    }
    else if (basicsFlag == 2) {
        [self clearBasics];
    }
    
    if (classesFlag == 1 && downLoadingOk) {
        [self importNewClasses];
    }
    else if (classesFlag == 2) {
        [self clearClasses];
    }

    
    if (campersFlag == 1  && downLoadingOk) {
        [self importCampers];
    }
    else if (campersFlag == 2) {
        [self clearCampers];
    }
    
    if (counselorsFlag == 1 && downLoadingOk) {
        [self importCounselorsWithClasses:YES];
    }
    else if (counselorsFlag == 2 && downLoadingOk) {
        [self importCounselorsWithClasses:NO];
    }
    else if (counselorsFlag == 3) {
        [self clearCounselors];
    }
    
    if (camperEnrsFlag == 1) {
        [self clearCamperEnrollments];
    }
    
    NSError *error = nil;
    [self.managedObjectContext save: &error];
    if (!downLoadingOk) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"importFailed" object:nil]];
    }
    downLoadingOk = true;
}

- (void) importBasics {
    [self clearBasics];
    NSArray *areasLn = [[self requestStringFromAmazon: @"areas.txt"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSArray *cabinsLn = [[self requestStringFromAmazon: @"cabins.txt"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSArray *locationsLn = [[self requestStringFromAmazon: @"locations.txt"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	for (NSString *line in areasLn){
		[self addObjectOfEntity:[NSEntityDescription entityForName:@"Area" inManagedObjectContext:self.managedObjectContext] 
                  withCSVString:line 
                       withKeys:[NSArray arrayWithObject:@"name"] 
                 andCheckFields:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] 
                       andTypes:[NSArray arrayWithObject:[NSString class]]
                     andCourses:NO];
	}
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error saving entity: %@", [error localizedDescription]);

	for (NSString *line in cabinsLn){
		[self addObjectOfEntity:[NSEntityDescription entityForName:@"Cabin" inManagedObjectContext:self.managedObjectContext] 
                  withCSVString:line 
                       withKeys:[NSArray arrayWithObjects:@"name", @"cabinAbbreviation", nil] 
                 andCheckFields:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] 
                       andTypes:[NSArray arrayWithObjects:[NSString class],[NSString class],nil]
                     andCourses:NO];
	}
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error saving entity: %@", [error localizedDescription]);
	for (NSString *line in locationsLn){
		[self addObjectOfEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext] 
                  withCSVString:line 
                       withKeys:[NSArray arrayWithObject:@"name"] 
                 andCheckFields:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] 
                       andTypes:[NSArray arrayWithObject:[NSString class]]
                     andCourses:NO];
	}
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error saving entity: %@", [error localizedDescription]);
}



- (void) importCampers {
    [self clearCampers];
    NSArray *campersLn = [[self requestStringFromAmazon: @"campers.txt"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	for (NSString *line in campersLn){
        [self addObjectOfEntity:[NSEntityDescription entityForName:@"Camper" inManagedObjectContext:self.managedObjectContext] 
                  withCSVString:line 
                       withKeys:[NSArray arrayWithObjects:@"firstName",    @"lastName",     @"cabin",  @"birthdate", @"birthdate",  @"birthdate", nil] 
                 andCheckFields:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] 
                       andTypes:[NSArray arrayWithObjects:[NSString class],[NSString class],[Cabin class],[NSDate class],[NSDate class],[NSDate class], nil]
                     andCourses:NO];
	}
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error saving entity: %@", [error localizedDescription]);
}

- (void) importCounselorsWithClasses:(BOOL) withClasses{
    [self clearCounselors];
    NSArray *counselorsLn = [[self requestStringFromAmazon: @"counselors_with_classes.txt"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	for (NSString *line in counselorsLn){
		[self addObjectOfEntity:[NSEntityDescription entityForName:@"Counselor" inManagedObjectContext:self.managedObjectContext] 
                  withCSVString:line 
                       withKeys:[NSArray arrayWithObjects:@"firstName",    @"lastName",     @"cabin", @"courses",@"courses",@"courses",@"courses",@"courses",  nil] 
                 andCheckFields:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] 
                       andTypes:[NSArray arrayWithObjects:[NSString class],[NSString class],[Cabin class],[Course class],[Course class],[Course class],[Course class],[Course class], nil]
                     andCourses:withClasses];
	}
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error saving entity: %@", [error localizedDescription]);
}

- (NSArray *) underEnrolledPeople
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];

    NSFetchRequest * counselors = [[NSFetchRequest alloc] init];
    [counselors setEntity:[NSEntityDescription entityForName:@"Counselor" inManagedObjectContext:self.managedObjectContext]];
    NSError * error = nil;
    [counselors setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray * couns = [self.managedObjectContext executeFetchRequest:counselors error:&error];
    NSMutableArray * rCouns = [NSMutableArray arrayWithCapacity:[couns count]];
    [counselors release];
    for (int i = 0; i < [couns count]; i++) {
        if ([[couns objectAtIndex:i] isUnderEnrolled]) {
            [rCouns addObject:[couns objectAtIndex:i]];
        }
    }
    
    NSFetchRequest * campers = [[NSFetchRequest alloc] init];
    [campers setEntity:[NSEntityDescription entityForName:@"Camper" inManagedObjectContext:self.managedObjectContext]];
    [campers setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray * camps = [self.managedObjectContext executeFetchRequest:campers error:&error];
    NSMutableArray * rCamps = [NSMutableArray arrayWithCapacity:[camps count]];
    [campers release];
    for (int i = 0; i < [camps count]; i++) {
        if ([[camps objectAtIndex:i] isUnderEnrolled]) {
            [rCamps addObject:[camps objectAtIndex:i]];
        }
    }
    [sortDescriptor release];

    return [NSArray arrayWithObjects:rCouns, rCamps, nil];
}

- (NSArray *) underEnrolledClasses
{
    NSFetchRequest * courses = [[NSFetchRequest alloc] init];
    [courses setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext]];
    NSError * error = nil;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [courses setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray * cours = [self.managedObjectContext executeFetchRequest:courses error:&error];
    NSMutableArray * rCourses = [NSMutableArray arrayWithCapacity:[cours count]];
    [courses release];
    [sortDescriptor release];
    for (int i = 0; i < [cours count]; i++) {
        if ([[cours objectAtIndex:i] isUnderEnrolled]) {
            [rCourses addObject:[cours objectAtIndex:i]];
        }
    }
    
    return [NSArray arrayWithObject: rCourses];
}

- (NSArray *) lookUpObjectsForEntity:(NSEntityDescription *) entity matchingKeys:(NSArray *) keys withStringValues:(NSArray *) values onlyForIndexSet:(NSIndexSet *) indexes
{
    NSMutableString * predicateString = [NSMutableString stringWithCapacity:100];
    BOOL firstOne = true;
    for (int i = 0; i < [keys count]; i++) {
        if ([indexes containsIndex:i]){
            if (!firstOne) {
                [predicateString appendFormat:@" AND "];
            }
            [predicateString appendFormat:@"(%@ LIKE[c] '%@')", [keys objectAtIndex:i], [values objectAtIndex:i]];
            firstOne = false;
        }
    }
    NSFetchRequest * allEntities = [[NSFetchRequest alloc] init];
    [allEntities setEntity:entity];
    NSPredicate * predicate = [NSPredicate predicateWithFormat: predicateString];
    [allEntities setPredicate: predicate];
    NSError * error = nil;
    NSArray * objects = [self.managedObjectContext executeFetchRequest:allEntities error:&error];
    [allEntities release];
    return objects;
}

- (void) addObjectOfEntity:(NSEntityDescription *) entity withCSVString:(NSString *)line withKeys:(NSArray *)keys andCheckFields:(NSIndexSet *) indexes andTypes:(NSArray *) types andCourses: (BOOL) overWriteCourses{
	if (line == nil || [line length] == 0 ) {
        return;
    }
    @try
    {
        NSArray *blueprint = [line componentsSeparatedByString:@","];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
        for (int i = 0; i < [keys count]; i++) {
            if ([types objectAtIndex:i] == [NSString class]) {
                if ([(NSString *)[keys objectAtIndex:i] isEqualToString:@"cabinAbbreviation"]) {
                    [newManagedObject setValue:[[(NSString *)[blueprint objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString] forKey:[keys objectAtIndex:i]];
                }
                else {
                    NSString * string = (NSString *)[blueprint objectAtIndex:i];
                    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    string = [string capitalizedString];
                    [newManagedObject setValue:string forKey:[keys objectAtIndex:i]];
                }
            }
            else if ([types objectAtIndex:i] == [NSDate class]) {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                [components setMonth:[(NSString *)[blueprint objectAtIndex:i] integerValue]]; 
                i++;
                [components setDay:[(NSString *)[blueprint objectAtIndex:i] integerValue]];
                i++;
                [components setYear:[(NSString *)[blueprint objectAtIndex:i] integerValue]];
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                [newManagedObject setValue:[gregorian dateFromComponents:components] forKey:[keys objectAtIndex:i]];
                [gregorian release];
                [components release];
            }
            else if ([types objectAtIndex:i] == [NSNumber class]) { 
                NSNumber * number = [NSNumber numberWithInt:[(NSString *)[blueprint objectAtIndex:i] intValue]];
                [newManagedObject setValue:number forKey:[keys objectAtIndex:i]];
            }
            else if ([types objectAtIndex:i] == [Course class]) {
                if (!overWriteCourses) {
                    break;
                }
                NSMutableSet *coursesToAdd = [NSMutableSet setWithCapacity:10];

                for (int period = 1; period <= 5; period++) {
                    NSArray *coursesWithName = [self lookUpObjectsForEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext] 
                                                       matchingKeys:[NSArray arrayWithObject:@"name"] 
                                                   withStringValues:[NSArray arrayWithObject:[blueprint objectAtIndex:i]] 
                                                    onlyForIndexSet:[NSIndexSet indexSetWithIndex:0]];
                    for (Course * course in coursesWithName) {
                        if ([course.period intValue] == period) {
                            [coursesToAdd addObject:course];
                        }
                    }
                    i++;
                }
                [newManagedObject setValue:coursesToAdd forKey:@"courses"];
            }
            else if ([(Class)[types objectAtIndex:i] isSubclassOfClass:[QCThing class]]) {
                // We need to lookup an object
                NSArray * objects = NULL;
                if ([types objectAtIndex:i] == [Cabin class]) {
                    objects = [self lookUpObjectsForEntity:[NSEntityDescription entityForName:@"Cabin" inManagedObjectContext:self.managedObjectContext] 
                                              matchingKeys:[NSArray arrayWithObject:@"cabinAbbreviation"] 
                                          withStringValues:[NSArray arrayWithObject:[blueprint objectAtIndex:i]] 
                                           onlyForIndexSet:[NSIndexSet indexSetWithIndex:0]];
                }
                else if ([types objectAtIndex:i] == [Area class]) {
                    objects = [self lookUpObjectsForEntity:[NSEntityDescription entityForName:@"Area" inManagedObjectContext:self.managedObjectContext] 
                                              matchingKeys:[NSArray arrayWithObject:@"name"] 
                                          withStringValues:[NSArray arrayWithObject:[blueprint objectAtIndex:i]] 
                                           onlyForIndexSet:[NSIndexSet indexSetWithIndex:0]];
                }
                else if ([types objectAtIndex:i] == [Location class]) {
                    objects = [self lookUpObjectsForEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext] 
                                              matchingKeys:[NSArray arrayWithObject:@"name"] 
                                          withStringValues:[NSArray arrayWithObject:[blueprint objectAtIndex:i]] 
                                           onlyForIndexSet:[NSIndexSet indexSetWithIndex:0]];
                }
                if (objects != NULL && [objects count] == 1) {
                    QCThing * thing = (QCThing *)[objects objectAtIndex:0];
                    NSString * string = [keys objectAtIndex:i];
                    [newManagedObject setValue:thing forKey:string];
                }
                else {
                    NSLog(@"Error saving relationship for import with csv string: %@", line);
                }
            }
        }
        NSError *error = nil;
        if (![self.managedObjectContext save:&error])
            NSLog(@"Error saving entity: %@", [error localizedDescription]);

        
        
	}
    @catch (NSException* ex) {
        NSLog(@"%@ with csv string not added:", [entity name]);
		NSLog(@"%@", line);
    }
}

- (void) importNewClasses {
    //Animal,Animal Care,Animal Pen,8,1,1,2,1,0
    // 0 = no class, 1 = class, 2 = mini 
    [self clearClasses];
    NSArray *classLn = [[self requestStringFromAmazon: @"classes.txt"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	for (NSString *line in classLn){
        if ([line length] < 9) {
            continue;
        }
        NSMutableArray * realLines = [NSMutableArray arrayWithCapacity:10];
        NSString * prefix = [line substringToIndex:[line length] - 9];
        NSArray * indicators = [[line substringFromIndex:[line length] - 9] componentsSeparatedByString:@","];
        for (int i = 0; i < 5; i++) {
            if ([(NSString *)[indicators objectAtIndex:i] isEqualToString:@"1"]) {
                [realLines addObject:[NSString stringWithFormat:@"%@%d,0",prefix,i+1]];
            }
            else if ([(NSString *)[indicators objectAtIndex:i] isEqualToString:@"2"]) {
                [realLines addObject:[NSString stringWithFormat:@"%@%d,1",prefix,i+1]];
                [realLines addObject:[NSString stringWithFormat:@"%@%d,2",prefix,i+1]];
            }
                
        }
        
        for (NSString *newLine in realLines) {
            [self addObjectOfEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext] 
                      withCSVString:newLine 
                           withKeys:[NSArray arrayWithObjects:@"area",     @"name",         @"location",     @"limit",        @"period",       @"miniNum", nil] 
                     andCheckFields:[NSIndexSet indexSet] 
                           andTypes:[NSArray arrayWithObjects:[Area class],[NSString class],[Location class],[NSNumber class],[NSNumber class],[NSNumber class],nil]
                         andCourses:NO];
        }
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error saving entity: %@", [error localizedDescription]);

}

- (void) clearBasics{
    [self clearEntity:[NSEntityDescription entityForName:@"Area" inManagedObjectContext:self.managedObjectContext]];
    [self clearEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext]];
    [self clearEntity:[NSEntityDescription entityForName:@"Cabin" inManagedObjectContext:self.managedObjectContext]];
}

- (void) clearCampers{
    [self clearEntity:[NSEntityDescription entityForName:@"Camper" inManagedObjectContext:self.managedObjectContext]];
}

- (void) clearCounselors{
    [self clearEntity:[NSEntityDescription entityForName:@"Counselor" inManagedObjectContext:self.managedObjectContext]];
}

- (void) clearClasses{
    [self clearEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext]];
}

- (void) clearEntity:(NSEntityDescription *) entity{
    NSFetchRequest * allEntities = [[NSFetchRequest alloc] init];
    [allEntities setEntity:entity];
    [allEntities setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * objects = [self.managedObjectContext executeFetchRequest:allEntities error:&error];
    [allEntities release];
    //error handling goes here
    for (NSManagedObject * object in objects) {
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save: &error];
}

- (void) clearCamperEnrollments{
    if (!hasClearedCamperEnr) {
        NSFetchRequest * allEntities = [[NSFetchRequest alloc] init];
        [allEntities setEntity:[NSEntityDescription entityForName:@"Camper" inManagedObjectContext:self.managedObjectContext]];
        
        NSError * error = nil;
        NSArray * objects = [self.managedObjectContext executeFetchRequest:allEntities error:&error];
        [allEntities release];
        //error handling goes here
        for (Camper * object in objects) {
            [object setCourses:[NSSet set]];
        }
        hasClearedCamperEnr = true;
    }
}

- (void) pushFileWithPathToS3WithPath:(NSArray *)paths {
    ASIS3ObjectRequest *request = [ASIS3ObjectRequest PUTRequestForFile: [paths objectAtIndex:0] withBucket:self.bucket key:[paths objectAtIndex:1]];
    [request startSynchronous];
    if ([request error]) {
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Upload Failed" message:@"Sorry, check your internet connection and S3 settings then try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
        NSLog(@"%@",[[request error] localizedDescription]);
    }
}

- (void) saveBackup {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy_MM_dd_HH"];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
    NSInteger minute = [comp minute];
    NSString * prefix = [NSString stringWithFormat:@"backups/%@",[formatter stringFromDate:date]];
    if (minute >= 30) {
        prefix = [prefix stringByAppendingFormat:@"_30"];
    }
    else {
        prefix = [prefix stringByAppendingFormat:@"_00"];
    }
    [self pushFileWithPathToS3WithPath: [NSArray arrayWithObjects:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Camp.sqlite"], [NSString stringWithFormat:@"%@Camp.sqlite",prefix], nil]];
}

- (void) downLoadAvailableBackupsFromServer:(BOOL) fromServer {
    [self downLoadAvailableBackupsFromServer:fromServer forParents:NO];
}

- (void) downLoadAvailableBackupsFromServer:(BOOL) fromServer forParents:(BOOL) forParents{
    if (availableBackups == nil || fromServer) {
        NSString * bucketNow = bucket;
        if (forParents) {
            bucketNow = @"hiddenvalley";
        }
        ASIS3BucketRequest *listRequest = [ASIS3BucketRequest requestWithBucket:bucketNow];
        [listRequest setPrefix:@"backups/"];
        [listRequest setDelegate:self];
        [listRequest startAsynchronous];
    }
}

- (void) downloadBackupAtIndex:(int) index {
    ASIS3BucketObject *object = [self.availableBackups objectAtIndex:index];
    ASIS3ObjectRequest *request = [object GETRequest];
    
    [request setDownloadDestinationPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Camp.sqlite"]];
    [request setDelegate:self];
	[request startAsynchronous];
}

- (void) downloadLatestBackup {
    [self downloadBackupAtIndex:0];
}



- (void)requestFinished:(ASIS3Request *)request
{
    if ([request isKindOfClass:[ASIS3BucketRequest class]]) {
        availableBackups = [[(ASIS3BucketRequest *)request objects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"key" ascending:NO], nil]];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"backupListDownloaded" object:nil]];
    }
    else if ([request isKindOfClass:[ASIS3ObjectRequest class]]){
        // Nothing the file was downlaoded to the correct place.
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"lastMOCswitch"];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"backupDownloaded" object:nil]];
        [self managedObjectContextSwitch];
    }   
}

- (void)requestFailed:(ASIS3Request *)request
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"downloadFailed" object:nil]];
    NSLog(@"Dammit, something went wrong: %@",[[request error] localizedDescription]);
}

- (void) dealloc
{
    [s3key release];
    [s3secretKey release];
    [userName release];
    [password release];
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    [availableBackups release];
	[bucket release];
    [super dealloc];
}

@end
