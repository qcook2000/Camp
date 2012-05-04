//
//  InfoPopTableController.h
//  HVCold
//
//  Created by Quenton Cook on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsViewControllerDelegate <NSObject>

-(void)didTap:(NSString *)string;

@end

@interface InfoPopTableController : UITableViewController {
	NSMutableArray *peeps;
	NSMutableArray *teachs;
	id delegate;
	BOOL forViewer;
}

@property (nonatomic, retain) NSMutableArray *peeps;
@property (nonatomic, retain) NSMutableArray *teachs;

@property (nonatomic, assign) id<OptionsViewControllerDelegate> delegate;
@property (nonatomic) BOOL forViewer;

@end
