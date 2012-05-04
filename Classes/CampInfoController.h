//
//  CampInfoController.h
//  Camp
//
//  Created by Quenton Cook on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIS3Request.h"

@interface CampInfoController : NSObject {
    int basicsFlag; // 0=off 1=replace 2=clear
    int counselorsFlag; // 0=off 1=replace w/ classes 2=replace clear classes 3=clear
    int campersFlag; // 0=off 1=add 2=replace 3=clear
    int classesFlag; // 0=off 1=replace 2=clear
    int camperEnrsFlag; // 0=off 1=clear

    NSString *s3key;
    NSString *s3secretKey;
    NSString *userName;
    NSString *password;
    NSString *bucket;
    NSArray *availableBackups;
    
    BOOL downLoadingOk;

@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;

}

@property (assign) int basicsFlag; // 0=off 1=replace 2=clear
@property (assign) int counselorsFlag; // 0=off 1=replace w/ classes 2=replace clear classes 3=clear
@property (assign) int campersFlag; // 0=off 1=replace 2=clear
@property (assign) int classesFlag; // 0=off 1=replace 2=clear
@property (assign) int camperEnrsFlag; // 0=off 1=clear

@property (nonatomic, retain) NSString *s3key;
@property (nonatomic, retain) NSString *s3secretKey;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *bucket;
@property (nonatomic, retain) NSArray *availableBackups;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (CampInfoController *)instance;
- (void) setBasics:(int)theBasicsFlag andCounselors:(int)theCounselorFlag andCampers:(int)theCampersFlag andClasses:(int)theClassesFlag andCamperEnr:(int)theCampEnrFlag;
- (NSString *)applicationDocumentsDirectory;
- (void) checkFileName:(NSString *) fileName;
- (void) importWithOptions;


- (void) importBasics;
- (void) importCampers;
- (void) importCounselorsWithClasses:(BOOL) withClasses;

- (void) clearBasics;
- (void) clearCampers;
- (void) clearCounselors;
- (void) clearClasses;
- (void) clearCamperEnrollments;
- (void) importNewClasses;

- (void) clearEntity:(NSEntityDescription *) entity;

-(NSString *) requestStringFromAmazon:(NSString*) path;

- (void) addObjectOfEntity:(NSEntityDescription *) entity withCSVString:(NSString *)line withKeys:(NSArray *)keys andCheckFields:(NSIndexSet *) indexes andTypes:(NSArray *) types andCourses: (BOOL) overWriteCourses;
    

- (NSArray *) underEnrolledClasses;
- (NSArray *) underEnrolledPeople;

- (NSArray *) lookUpObjectsForEntity:(NSEntityDescription *) entity matchingKeys:(NSArray *) keys withStringValues:(NSArray *) values onlyForIndexSet:(NSIndexSet *) indexes;

- (void) pushFileWithPathToS3WithPath:(NSArray *)paths;

- (void) saveBackup;

- (void) downloadBackupAtIndex:(int) index;

- (void) updateTimestamps;

- (void) shutDown;
- (void) managedObjectContextSwitch;
- (void) downloadLatestBackup;

- (void) downLoadAvailableBackupsFromServer:(BOOL) fromServer;
- (void) downLoadAvailableBackupsFromServer:(BOOL) fromServer forParents:(BOOL) forParents;
- (void) downloadBackupAtIndex:(int) index;
- (void) requestFailed:(ASIS3Request *)request;
- (void) requestFinished:(ASIS3Request *)request;

- (NSString *) setNewUN:(NSString *)newUN forOldUN:(NSString *)oldUN andNewPW:(NSString *) newPW forOldPW:(NSString *) oldPW andAK:(NSString *)s3Key andASK: (NSString *) s3sKey andBucket:(NSString*) bucket andIgnoreOldPW:(BOOL)ignoreOldPW;

- (BOOL) resetToTestS3;
- (void) loadVariablesFromDefaults;
- (void) loadTestVariables;

- (BOOL) testS3withKey: (NSString *) key andSecret: (NSString *) password andBucket:(NSString *) theBucket;

@end
