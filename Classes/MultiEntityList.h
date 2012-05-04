//
//  MultiEntityList.h
//  Camp
//
//  Created by Quenton Cook on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityListViewController.h"
#import "DetailViewController.h"

@interface MultiEntityList : UIViewController {
    UISegmentedControl * entityChooser;
    EntityListViewController * eList;
    DetailViewController * dvc;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl * entityChooser;
@property (nonatomic, retain) EntityListViewController * eList;
@property (nonatomic, retain) DetailViewController * dvc;

- (IBAction) changeEntity;
- (MultiEntityList *) initWithDVC:(DetailViewController *)theDVC;

@end
