//
//  StartScreen_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 02.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "StartScreen_vc.h"
#import "Login_vc.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>


@interface StartScreen_vc ()

@end

@implementation StartScreen_vc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PFCloud callFunctionInBackground:@"hello" withParameters:@{}
                                block:^(NSString *response, NSError *error) {
                                    if (!error) {
                                        NSLog(@"%@", response);
                                    }
                                }];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage     = [UIImage new];
    self.navigationController.navigationBar.translucent     = YES;
    self.navigationController.view.backgroundColor          = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    double radius   = 3.0;
    UIColor *border = [UIColor colorWithRed:(255/255.0) green:(254/255.0) blue:(215/255.0) alpha:0.9];
    
    [self.findMealsButton.layer setBorderColor:[border CGColor]];
    [self.findMealsButton.layer setBorderWidth:0.3];
    [self.findMealsButton.layer setCornerRadius:radius];
    [self.findMealsButton setClipsToBounds:YES];
    
    [self.cookMealsButton.layer setBorderColor:[border CGColor]];
    [self.cookMealsButton.layer setBorderWidth:0.3];
    [self.cookMealsButton.layer setCornerRadius:radius];
    [self.cookMealsButton setClipsToBounds:YES];
    
    [self.recepiesButton.layer setBorderColor:[border CGColor]];
    [self.recepiesButton.layer setBorderWidth:0.3];
    [self.recepiesButton.layer setCornerRadius:radius];
    [self.recepiesButton setClipsToBounds:YES];
    
    [self loadUserProfileData];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Navigation

- (IBAction)cookAndOfferPressed:(id)sender {
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"already logged in");
        [self performSegueWithIdentifier:@"StartScreen2DateInput" sender:self];
        
    } else {
        NSLog(@"log in first");
        [self performSegueWithIdentifier:@"StratScreen2Login" sender:self];
    }
}

- (IBAction)findMealsPressed:(id)sender {
    // TODO: cache previously searched address and forward to SearchCity_vc
    [self performSegueWithIdentifier:@"StartScreen2SelectDate" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"StratScreen2Login"]) {
        Login_vc *loginVC = [segue destinationViewController];
        [loginVC setComingFromViewController:@"StartScreen_vc"];
    }
}

- (IBAction)logOutPressed:(id)sender {
    [PFUser logOut];
    NSLog(@"logged out");
}

#pragma mark - Load UserProfile

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
                 [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     if (succeeded) {
                         NSLog(@"user-profile upload successful");
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

- (void)foodForkasynchRequestRecipes {
    
}
@end
