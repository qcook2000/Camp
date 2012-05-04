//
//  ParentPhoneAppDelegate.h
//  ParentPhone
//
//  Created by Quenton Cook on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CampInfoController.h"

@class ParentPhoneViewController;

@interface ParentPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    BOOL loadingDone;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ParentPhoneViewController *viewController;

@end
