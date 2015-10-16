//
//  Login_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 08.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "Login_vc.h"
#import "StartScreen_vc.h"
#import "Preview_vc.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface Login_vc ()

@end

@implementation Login_vc

@synthesize comingFromViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"comingFrom: %@", self.comingFromViewController);
    
    // TODO: Check AirBnB login (button locations)
    // TODO: add activityIndicator for login
    
//     //Check if user is cached and linked to Facebook, if so, bypass login
//    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        NSLog(@"already logged in");
//        [self _presentLandingPageAnimated:YES];
//    }

}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - LoginProcess

- (IBAction)loginWithFacebookPressed:(id)sender {
    
    NSArray *permissionsArray = @[ @"public_profile"]; 
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray
                                                    block:^(PFUser *user, NSError *error) {
//        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
            
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            } else {
                NSLog(@"User logged in through Facebook!");
            }
            [self loadUserProfileData];
            [self returnToCorrectNextViewController];
        }
    }];
//    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (IBAction)loginWithEmailPressed:(id)sender {
}

#pragma mark - Navigation

- (void) returnToCorrectNextViewController{
    
    if ([self.comingFromViewController isEqualToString:@"StartScreen_vc"]) {
        [self performSegueWithIdentifier:@"Login2DateInput" sender:self];
        
    } else if ([self.comingFromViewController isEqualToString:@"Results_tvc"]) {
        [self performSegueWithIdentifier:@"Login2OrderPreview" sender:self];
    }
}

- (IBAction)cancelPressed:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)loadUserProfileData {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, location, gender"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             
             if (!error) {
                 
                 NSDictionary *userData             = (NSDictionary *)result;
                 NSString *facebookID               = userData[@"id"];
                 NSMutableDictionary *userProfile   = [NSMutableDictionary dictionaryWithCapacity:7];
                 NSString *name                     = userData[@"name"];
                 NSString *location                 = userData[@"location"][@"name"];
                 NSString *gender                   = userData[@"gender"];
                 
                 if (facebookID) {
                     userProfile[@"facebookId"] = facebookID;
                 } if (name) {
                     userProfile[@"name"]       = name;
                 } if (location) {
                     userProfile[@"location"]   = location;
                 } if (gender) {
                     userProfile[@"gender"]     = gender;
                 }
                 userProfile[@"pictureURL"]     = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
                 
                 [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
                 
                 int ratingStart = 0;
                 int menusOffertSoFar = 0;
                 NSString *paymentInfoStatus = @"notAvailable";
                 NSString *bankDetailsStatus = @"notAvailable";
                 [[PFUser currentUser] setObject:[NSNumber numberWithInt:ratingStart]      forKey:@"ratingOverall"];
                 [[PFUser currentUser] setObject:[NSNumber numberWithInt:menusOffertSoFar] forKey:@"menusOverall"];
                 [[PFUser currentUser] setObject:paymentInfoStatus forKey:@"paymentDetailStatus"];
                 [[PFUser currentUser] setObject:bankDetailsStatus forKey:@"bankDetailStatus"];
                 
                 [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     if (succeeded) {
                         NSLog(@"profile & initials upload successful");
                     }
                 }];
                 
             } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                         isEqualToString: @"OAuthException"]) {
                 NSLog(@"The facebook session was invalidated");
                 //                 [self logoutButtonAction:nil];
             } else {
                 NSLog(@"Some other error: %@", error);
             }
         }];
    }
}


//int ratingStart = 1;
//int menusOffertSoFar = 1;
//NSString *paymentInfoStatus = @"notAvailable";
//NSString *bankDetailsStatus = @"notAvailable";
//[user setObject:[NSNumber numberWithInt:ratingStart]      forKey:@"ratingOverall"];
//[user setObject:[NSNumber numberWithInt:menusOffertSoFar] forKey:@"menusOverall"];
//[user setObject:paymentInfoStatus forKey:@"paymentDetailStatus"];
//[user setObject:bankDetailsStatus forKey:@"bankDetailStatus"];
//[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//    if (succeeded) {
//        NSLog(@"userdata successful");
//    }
//}];


@end
