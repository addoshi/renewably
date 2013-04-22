//
//  ViewController.m
//  renewably
//
//  Created by Anup Doshi on 4/20/13.
//  Copyright (c) 2013 Anup Doshi. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

#define kReneablyAPI @"http://ec2-54-224-192-157.compute-1.amazonaws.com/renew.php?zipcode=%@"

float customRounding(float value) {
    const float roundingValue = 0.05;
    int mulitpler = floor(value / roundingValue);
    return mulitpler * roundingValue;
}

@interface ViewController ()
{
    float re_index;
    UITextField *activeField;
    CLGeocoder *geocoder;
    CLLocationManager *locationManager;
    NSOperationQueue *queue;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.indexView.layer setCornerRadius:30.0f];
    [self.indexView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.indexView.layer setBorderWidth:1.5f];
    [self.indexView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.indexView.layer setShadowOpacity:0.8];
    [self.indexView.layer setShadowRadius:3.0];
    [self.indexView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupIndexView
{
    self.indexLabel.text = [NSString stringWithFormat:@"%.2f",re_index];
    self.indexView.backgroundColor = [UIColor colorWithRed:1.0-re_index/100.0 green:re_index/100.0 blue:0 alpha:1];
}

- (void)searchREIndex:(NSString *)zipCode
{
    NSURL *renewablyURL = [NSURL URLWithString:[NSString stringWithFormat:kReneablyAPI,zipCode]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:renewablyURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (!queue)
        queue  = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error) {
            NSLog(@"Connection Error: %@",[error description]);
            [SVProgressHUD showErrorWithStatus:@"Failed"];
            return;
        }
        
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSRange range = [dataString rangeOfString:@"index:"];
        NSString *indexString = [[dataString substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        re_index = customRounding([indexString floatValue]*100);
        
        NSLog(@"Index %f",re_index);
        
        
//        NSError *jsonError=nil;
//        NSDictionary *infoDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//        if (jsonError) {
//            NSLog(@"JSON error: %@", [jsonError description]);
//        }
        [SVProgressHUD showSuccessWithStatus:@"Success!"];
        [self performSelectorOnMainThread:@selector(setupIndexView) withObject:nil waitUntilDone:NO];   

        
    }];
}

- (void)checkRenewablyIndexAction:(id)sender
{
    //FIXME: Generating Random index. Use API
    [activeField resignFirstResponder];
    [SVProgressHUD showWithStatus:@"Checking" maskType:SVProgressHUDMaskTypeClear];
    
    if (self.zipTextField.text.length == 0) {
        if (!locationManager)
            locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [locationManager startUpdatingLocation];
    } else {
        
        NSString *zipCode = self.zipTextField.text;
        [self searchREIndex:zipCode];
    }
    
}



- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.origin.y -= kbSize.height;
    self.view.frame = aRect;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect aRect = self.view.frame;
    aRect.origin.y += kbSize.height;
    self.view.frame = aRect;
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self checkRenewablyIndexAction:nil];
    return YES;
}


#pragma mark - Location Services

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy <= manager.desiredAccuracy) {
        [locationManager stopUpdatingLocation];
        locationManager.delegate = nil;
        
        [self geocodeLocation:location];
    }
    
}

- (void)geocodeLocation:(CLLocation*)location
{
    if (!geocoder)
        geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             if (placemark.postalCode.length) {
                 _zipTextField.text = placemark.postalCode;
                 [self searchREIndex:placemark.postalCode];
             } else {
                 [SVProgressHUD showErrorWithStatus:@"Failed to Locate"];
             }
             
         }
     }];
}



@end
