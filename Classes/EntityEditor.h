//
//  EntityEditor.h
//  Camp
//
//  Created by Quenton Cook on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityListViewController.h"

@interface EntityEditor : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
	NSArray *sectionNames;
	NSArray *rowLabels;
	NSArray *rowKeys;
	NSArray *editType;
	NSArray *rowArguments;
	NSManagedObject *currentObject;
	EntityListViewController *entityList;
	NSIndexPath *dateUpdatedIndexPath;
    BOOL saveNeeded;
    UIView *currentFirstResponder;
    UIToolbar *saveToolbar;
    UITableView *tableView;
    BOOL lookOnly;
}

@property (nonatomic, retain) NSArray *sectionNames;
@property (nonatomic, retain) NSArray *rowLabels;
@property (nonatomic, retain) NSArray *rowKeys;
@property (nonatomic, retain) NSArray *editType;
@property (nonatomic, retain) NSArray *rowArguments;
@property (nonatomic, retain) NSManagedObject *currentObject;
@property (nonatomic, retain) EntityListViewController *entityList;
@property (nonatomic, retain) NSIndexPath *dateUpdatedIndexPath;
@property (nonatomic, retain) UIView *currentFirstResponder;
@property (nonatomic, retain) UIToolbar *saveToolbar;
@property (nonatomic, retain) UITableView *tableView;
@property (assign) BOOL saveNeeded;
@property (assign) BOOL lookOnly;


+ (EntityEditor *) entityEditorForManagedObject:(NSManagedObject *)managedObject andLookOnly: (BOOL) canLookOnly;
+ (EntityEditor *) entityEditorForEntity:(NSString *)entity;
- (EntityEditor *) initEntityEditorForEntity:(NSString *)entity;
- (void) newFirstResponder:(UIView *) view;
- (void) saveTapped;
- (void) cancelTapped;
- (void) closingTime;
@end
