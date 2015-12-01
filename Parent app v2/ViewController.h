//
//  ViewController.h
//  Parent app v2
//
//  Created by Chris on 6/23/15.
//  Copyright (c) 2015 chuppy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, NSURLConnectionDataDelegate> {
    
    @public
        NSMutableData *_responseData;
    
}

@property (weak, nonatomic) IBOutlet UITextField *userID;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) IBOutlet UITextField *radius;
@property (weak, nonatomic) IBOutlet UITextField *childLongitude;
@property (weak, nonatomic) IBOutlet UITextField *childLatitude;

- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;

- (IBAction)childInfoButtonPressed:(id)sender;


@end

