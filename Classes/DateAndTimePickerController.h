//
//  DateAndTimePickerController.h
//  Camp
//
//  Created by Quenton Cook on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DateAndTimePickerController : UIViewController {
    UIDatePicker *dPicker;
    
}

@property (nonatomic, retain) IBOutlet UIDatePicker *dPicker;

@end
