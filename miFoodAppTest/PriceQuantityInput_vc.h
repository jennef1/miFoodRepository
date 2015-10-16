//
//  PriceQuantityInput_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 03.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceQuantityInput_vc : UIViewController <UITextFieldDelegate>

// Variables
@property (assign) int counter;
@property (assign) double foodPrice;

// Quantity Input
@property (strong, nonatomic) IBOutlet UITextField *quantityBackGround;
@property (strong, nonatomic) IBOutlet UILabel  *quantityCount;
@property (strong, nonatomic) IBOutlet UIButton *quantityPlussButton;
@property (strong, nonatomic) IBOutlet UIButton *quantityMinusButton;

- (IBAction)quantityPlusPressed:(id)sender;
- (IBAction)quantityMinusPressed:(id)sender;

// Price Input
@property (strong, nonatomic) IBOutlet UITextField *priceTF;
@property (strong, nonatomic) IBOutlet UILabel *pricePoundSignLabel;

// Navigation
@property (strong, nonatomic) UIButton *nextButton;
- (void)nextPressed:(id)sender;
- (IBAction)backPressed:(id)sender;

@end
