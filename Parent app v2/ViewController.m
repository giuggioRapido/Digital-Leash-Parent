//
//  ViewController.m
//  Parent app v2
//
//  Created by Chris on 6/23/15.
//  Copyright (c) 2015 chuppy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController {
    CLLocationManager *locationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Location manager stuffs */
    locationManager = [[CLLocationManager alloc]init];
    [locationManager requestAlwaysAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonPressed:(id)sender {
    
    /* POSTING PARENT DATA */
    
    /* If Username textfield is empty, show alert, else run everything */
    if(_userID.text.length == 0) {
        UIAlertView *emptyFieldAlert =
        [[UIAlertView alloc]initWithTitle:@"Please enter a username" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [emptyFieldAlert show];
    } else {
        

        //Aditya - check for valid object for conversion
        
        NSDictionary *userDetails =
        @{@"utf8": @"✓", @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=", @"user":@{@"username":self.userID.text,@"latitude":self.latitude.text,@"longitude":self.longitude.text,@"radius":self.radius.text}, @"commit":@"Create User", @"action":@"update", @"controller":@"users"};
        
        /* Convert NSDictionary to JSON */
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDetails options:NSJSONWritingPrettyPrinted error:nil];
        
        /* Create URL request and set HTTP method, etc */
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://protected-wildwood-8664.herokuapp.com/users"]];
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [postRequest setHTTPBody:jsonData];
        
        /* Create connection */
        NSURLConnection *postConn = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
    }
}

- (IBAction)updateButtonPressed:(id)sender {
    
    /* USING PATCH REQUEST TO UPDATE A USER'S DATA */
    
    /* If username text field is empty, show alert. Else, do rest. */
    if(_userID.text.length == 0) {
        UIAlertView *emptyFieldAlert =
        [[UIAlertView alloc]initWithTitle:@"Please enter a username" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [emptyFieldAlert show];
    } else {
        NSDictionary *userDetails =
        @{@"utf8": @"✓", @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=", @"user":@{@"username":self.userID.text,@"latitude":self.latitude.text,@"longitude":self.longitude.text,@"radius":self.radius.text}, @"commit":@"Create User", @"action":@"update", @"controller":@"users"};
        
        /* Convert NSDictionary to JSON */
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDetails options:NSJSONWritingPrettyPrinted error:nil];
        
        /* Create mutable string for URL */
        NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/"];
        [url appendString:self.userID.text];
        [url appendFormat:@".json"];
        
        /* Create PATCH request */
        NSMutableURLRequest *patchRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [patchRequest setHTTPMethod:@"PATCH"];
        [patchRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [patchRequest setHTTPBody:jsonData];
        
        /* Create connection */
        NSURLConnection *patchConn = [[NSURLConnection alloc] initWithRequest:patchRequest delegate:self];
    }
}

- (IBAction)childInfoButtonPressed:(id)sender {
    
    /* GETTING CHILD DATA */
    
    /* If username text field is empty, show alert. Else, do rest. */
    if(_userID.text.length == 0) {
        UIAlertView *emptyFieldAlert =
        [[UIAlertView alloc]initWithTitle:@"Please enter a username" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [emptyFieldAlert show];
    } else {
        /* Create string for URL and with it create an NSURL */
        NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/"];
        [url appendString:self.userID.text];
        [url appendFormat:@".json"];
        NSURL *myURL = [NSURL URLWithString:url];
        
        /* Create GET request */
        NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [getRequest setHTTPMethod:@"GET"];
        [getRequest setURL:myURL];
        
        /* Create JSON dict and then convert to NSDictionary */
        NSData *jsDict = [NSData dataWithContentsOfURL:myURL];
        NSDictionary *childDict = [NSJSONSerialization JSONObjectWithData:jsDict options:kNilOptions error:nil];
        
        /* Check if there is a child for the current user. If not, show alert, else do rest */
        if (childDict[@"user"] == 0){
            UIAlertView *noChildAlert =
            [[UIAlertView alloc]initWithTitle:@"There is no child associated with this username" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [noChildAlert show];
        } else {
            /* Create NSStrings for child's lat and long and assign them to text fields */
            NSString *childLat =[childDict[@"current_lat"]stringValue];
            NSString *childLong =[childDict[@"current_longitude"]stringValue];
            _childLatitude.text = childLat;
            _childLongitude.text = childLong;
            
            /* Create BOOL for is_in_zone and use it to display message to parent... */
            BOOL isInZone;
            
            if([childDict[@"is_in_zone"]integerValue] ==  1) {
                isInZone = YES;
            } else {
                isInZone = NO;
            }
            
            /* ...using Alert */
            if(isInZone == YES) {
                UIAlertView *zoneAlert =
                [[UIAlertView alloc]initWithTitle:@"Child is in zone" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [zoneAlert show];
                
            } else {
                UIAlertView *zoneAlert =
                [[UIAlertView alloc]initWithTitle:@"Alert: Child NOT in zone" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [zoneAlert show];
            }
        }
    }
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *) manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert =
    [[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        _longitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}

#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Connection Initialized");
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"I got a piece of data!");
    NSLog(@"Adding it to _responseData");
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"I'm done getting all the data!");
    NSLog(@"You can find it in _responseData");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Something went wrong!");
    NSLog(@"%@", error.localizedDescription);
    
    /* Create UIAlert for failed connection */
    UIAlertView *failedConnectionAlert =
    [[UIAlertView alloc]initWithTitle:@"Connection Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [failedConnectionAlert show];
}


@end
