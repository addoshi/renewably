//
//  ViewController.h
//  renewably
//
//  Created by Anup Doshi on 4/20/13.
//  Copyright (c) 2013 Anup Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <UITextFieldDelegate,CLLocationManagerDelegate>

@property IBOutlet UILabel *indexLabel;
@property IBOutlet UIView *indexView;
@property IBOutlet UITextField *zipTextField;

- (IBAction)checkRenewablyIndexAction:(id)sender;

@end
