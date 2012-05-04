//
//  CampAppDelegate.h
//  Camp
//
//  Created by Quenton Cook on 10/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CampInfoController.h"

@class RootViewController;
@class DetailViewController;

@interface CampAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate> {
    
    UIWindow *window;
	
	UISplitViewController *splitViewController;
	RootViewController *rootViewController;
	DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end

