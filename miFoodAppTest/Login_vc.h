//
//  Login_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 08.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login_vc : UIViewController

// Login
- (IBAction)loginWithFacebookPressed:(id)sender;
- (IBAction)loginWithEmailPressed:(id)sender;

// navigation
@property (strong, nonatomic) NSString *comingFromViewController;
- (void) returnToCorrectNextViewController;
- (IBAction)cancelPressed:(id)sender;

- (void)loadUserProfileData;



@end
