//
//  PriceQuantityInput_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 03.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "PriceQuantityInput_vc.h"
#import "Singleton.h"
#import "HHAlertView.h"

@interface PriceQuantityInput_vc ()

@end

@implementation PriceQuantityInput_vc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set keyboard nextButton
    UIColor *buttonColor = [UIColor colorWithRed:(255/255.0) green:(211/255.0) blue:(41/255.0) alpha:1];
    CGRect buttonFrame   = CGRectMake(0, 0, self.view.frame.size.width, 50);
    self.nextButton      = [[UIButton alloc]init];
    [self.nextButton setFrame: buttonFrame];
    [self.nextButton setBackgroundColor: buttonColor];
    [self.nextButton setTitle:@"next" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.priceTF setInputAccessoryView:self.nextButton];
    
    // Quantity counter config
    [self.quantityBackGround.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.quantityBackGround.layer setBorderWidth:1.0];
    [self.quantityBackGround.layer setCornerRadius:4];
    [self.quantityBackGround setClipsToBounds:YES];
    
    self.counter            = 5;
    self.quantityCount.text = [NSString stringWithFormat:@"%i", self.counter];
    
    // Price tf config
    UIView *spacerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.priceTF.text   = @"0.00";
    [self.priceTF setLeftViewMode:UITextFieldViewModeAlways];
    [self.priceTF setLeftView:spacerView];
    
    UIColor *bordercolor = [UIColor colorWithRed:(61/255.0) green:(217/255.0) blue:(196/255.0) alpha:1];
    UIColor *textColor   = [UIColor colorWithRed:(87/255.0) green:(199/255.0) blue:(167/255.0) alpha:1];
    [self.priceTF.layer setBorderColor:[bordercolor CGColor]];
    [self.priceTF.layer setBorderWidth:1.0];
    [self.priceTF.layer setCornerRadius:4];
    [self.priceTF setClipsToBounds:YES];
    
    self.priceTF.textColor                          = textColor;
    self.quantityCount.textColor                    = textColor;
    
    // TODO: How to change button text color programatically
    self.quantityPlussButton.titleLabel.textColor   = textColor;
    self.quantityMinusButton.titleLabel.textColor   = textColor;
    
    // TextField delegat
    [self.priceTF becomeFirstResponder];
    self.priceTF.delegate = self;
    
//    [self.navigationItem setRightBarButtonItem:nil];
    
}

#pragma mark - QuantityButtons +/-

- (IBAction)quantityPlusPressed:(id)sender {
    self.counter = self.counter + 1;
    self.quantityCount.text = [NSString stringWithFormat:@"%i", self.counter];
}

- (IBAction)quantityMinusPressed:(id)sender {
    self.counter = self.counter - 1;
    if (self.counter < 0) {
        self.counter = 0;
    }
    self.quantityCount.text = [NSString stringWithFormat:@"%i", self.counter];
}

#pragma mark - TextField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.priceTF) {
        
        // TODO: Check why app crashes after you press "return" key on keyboard when more then two digits already entered before
        // Currency, two digits, start entry from back
        NSString *text  = [textField.text stringByReplacingCharactersInRange:range withString:string];
        text            = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
        double number   = [text intValue] * 0.01;
        textField.text  = [NSString stringWithFormat:@"%.2lf", number];
        
        NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (updatedText.length > 0) {
//            [self.navigationItem setRightBarButtonItem:self.saveButton];
        } else {
            [self.navigationItem setRightBarButtonItem:nil];
        }
        return NO;
    }
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"showImageAddress"]){
        
        // Convert Price string to double
        NSString *priceStringTrim = [self.priceTF.text
                                     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.foodPrice = [priceStringTrim doubleValue];
        
        // Store variables globally
        Singleton *mySingleton = [Singleton sharedSingleton];
        mySingleton.singl_quantity  = self.counter;
        mySingleton.singl_price     = self.foodPrice;
    }
}

- (void)nextPressed:(id)sender{
    
    double enteredPrice = [self.priceTF.text doubleValue];
    if (enteredPrice == 0) {
        
        [self.priceTF resignFirstResponder];
        [[HHAlertView shared] showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Price missing" detail:@"Is your offer for free?" cancelButton:@"Yes, free!" Okbutton:@"No - change" block:^(HHAlertButton buttonindex) {
        
            if (buttonindex == 1) {
                [self performSegueWithIdentifier:@"showImageAddress" sender:self];
            
            } else if (buttonindex == 0){
                [self.priceTF becomeFirstResponder];
            }
        }];
        
    } else {
        [self performSegueWithIdentifier:@"showImageAddress" sender:self];
    }
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
