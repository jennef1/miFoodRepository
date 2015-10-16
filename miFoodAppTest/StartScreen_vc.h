//
//  StartScreen_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 02.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartScreen_vc : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *findMealsButton;
@property (strong, nonatomic) IBOutlet UIButton *cookMealsButton;
@property (strong, nonatomic) IBOutlet UIButton *recepiesButton;

// get current UserData
- (void)loadUserProfileData;

// Food2Fork get recipes
- (void)foodForkasynchRequestRecipes;

// navigation
- (IBAction)cookAndOfferPressed:(id)sender;
- (IBAction)findMealsPressed:(id)sender;

- (IBAction)logOutPressed:(id)sender;

@end
