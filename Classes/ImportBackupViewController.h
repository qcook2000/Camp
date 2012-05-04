//
//  ImportBackupViewController.h
//  Camp
//
//  Created by Quenton Cook on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImportViewController.h"
#import "CampInfoController.h"
#import "MBProgressHUD.h"

@interface ImportBackupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MBProgressHUDDelegate>{
    ImportViewController * ivc;
    UITableView * tableView;
    int indexRow;
    NSArray * availableBackups;
    MBProgressHUD * HUD;
    
}
@property (nonatomic, retain) ImportViewController * ivc;
@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) NSArray * availableBackups;
@property (nonatomic, retain) MBProgressHUD * HUD;

- (IBAction) cancelPressed;
- (void) downloadFailed;
- (void) backupListDownloaded;
- (void) backupDownloaded;

@end
