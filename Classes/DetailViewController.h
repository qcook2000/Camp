//
//  DetailViewController.h
//  Trash
//
//  Created by Quenton Cook on 10/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor \
	colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]  
@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIView *contentView;
	
    UIViewController *detailItem;
}

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) UIViewController *detailItem;

@end
