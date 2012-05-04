//
//  RootViewController.h
//  Trash
//
//  Created by Quenton Cook on 10/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSArray-NestedArrays.h"
#import "MBProgressHUD.h"


@class DetailViewController;

@interface RootViewController : UITableViewController<MBProgressHUDDelegate> {
    DetailViewController *detailViewController;
	
	NSArray *sectionNames;
	NSArray *rowLabels;
	NSArray *rowDisplayType;
	NSArray *rowDisplayControllers;
	NSArray *rowArguments;
    MBProgressHUD * HUD;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) MBProgressHUD * HUD;
@end
