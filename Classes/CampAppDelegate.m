//
//  CampAppDelegate.m
//  Camp
//
//  Created by Quenton Cook on 10/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CampAppDelegate.h"

#import "RootViewController.h"
#import "DetailViewController.h"
#import "Cabin.h"
#import "Camper.h"

@implementation CampAppDelegate

@synthesize window, splitViewController, rootViewController, detailViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    [CampInfoController instance];
    
    // Override point for customization after application launch.
	rootViewController = [[RootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    
    navigationController.delegate = self;
    detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
    rootViewController.detailViewController = detailViewController;
    NSString * bucket = [[NSUserDefaults standardUserDefaults] objectForKey:@"bucket"];
    if (bucket == nil || [bucket isEqualToString:@"testscheduleomatic"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"test" forKey:@"loggedIn"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"loggedIn"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    splitViewController = [[UISplitViewController alloc] init];
    splitViewController.viewControllers = [NSArray arrayWithObjects:navigationController, detailViewController, nil];
	splitViewController.delegate = detailViewController;
    [window addSubview:splitViewController.view];

    [window makeKeyAndVisible];
    
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController 
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    [viewController viewDidAppear:animated];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [[CampInfoController instance] shutDown];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[splitViewController release];
    
    [window release];
    [super dealloc];
}


@end

