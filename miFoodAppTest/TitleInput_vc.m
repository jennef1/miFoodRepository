//
//  TitleInput_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 03.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "TitleInput_vc.h"
#import "Singleton.h"
#import "HHAlertView.h"

#import <UIKit/UIKit.h>

@interface TitleInput_vc ()

@end

@implementation TitleInput_vc

@synthesize saveDescriptionButton, descriptionString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.foodTitle_tf becomeFirstResponder];
    [self.foodTitle_tf setDelegate:self];
    
    self.descriptionSubView.hidden = YES;
    
    // set keyboard nextButton
    UIColor *buttonColor = [UIColor colorWithRed:(255/255.0) green:(211/255.0) blue:(41/255.0) alpha:1];
    CGRect buttonFrame   = CGRectMake(0, 0, self.view.frame.size.width, 50);
    self.nextButton      = [[UIButton alloc]init];
    [self.nextButton setFrame: buttonFrame];
    [self.nextButton setBackgroundColor: buttonColor];
    [self.nextButton setTitle:@"next" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.foodTitle_tf setInputAccessoryView:self.nextButton];
    
    NSString *placeholderTxt = @"give your menu a great title";
    NSAttributedString *strg = [[NSAttributedString alloc] initWithString:placeholderTxt
                                                              attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.foodTitle_tf.attributedPlaceholder = strg;
    
    self.maxTextLen                 = 35;
    self.titleCharacterLeft_tf.text = [NSString stringWithFormat:@"%i characters left", self.maxTextLen];
    
    // visual configuraitons
//    UIView *spacerView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//    UIColor *bordercolor = [UIColor colorWithRed:(61/255.0) green:(217/255.0) blue:(196/255.0) alpha:1];
//
//    [self.foodTitle_tf setLeftViewMode:UITextFieldViewModeAlways];
//    [self.foodTitle_tf setLeftView:spacerView];
//    [self.foodTitle_tf.layer setBorderColor:[bordercolor CGColor]];
//    [self.foodTitle_tf.layer setBorderWidth:0.9];
//    [self.foodTitle_tf.layer setCornerRadius:4];
//    [self.foodTitle_tf setClipsToBounds:YES];
    
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (newLength == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.titleCharacterLeft_tf.text      = [NSString stringWithFormat:@"%i characters left", self.maxTextLen];
        self.titleCharacterLeft_tf.textColor = [UIColor colorWithRed:(255/255.0) green:(128/255.0) blue:(0/255.0) alpha:1];
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (newLength > (self.maxTextLen - 1)) {
            self.titleCharacterLeft_tf.text       = @"Zero characters left";
            self.titleCharacterLeft_tf.textColor  = [UIColor redColor];
        } else {
            self.titleCharacterLeft_tf.text       = [NSString stringWithFormat:@"%lu characters left", (self.maxTextLen - newLength)];
            self.titleCharacterLeft_tf.textColor  = [UIColor colorWithRed:(255/255.0) green:(128/255.0) blue:(0/255.0) alpha:1];
        }
    }
    
//    self.foodTitle_tf.text = [NSString stringWithFormat:@"%@%@", textField.text, string];
    
    return (newLength > self.maxTextLen) ? NO : YES;
}

#pragma mark - DescriptionTextField / SubView

- (IBAction)addInfoPressed:(id)sender {
    
    [self.foodTitle_tf resignFirstResponder];
    [self.descriptionSubView setHidden:NO];

    self.descriptionSubView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.descriptionSubView setAlpha:1.0];
    }];
    
    // keyboard nextButton
    UIColor *buttonColor = [UIColor colorWithRed:(255/255.0) green:(211/255.0) blue:(41/255.0) alpha:1];
    CGRect buttonFrame   = CGRectMake(0, 0, self.view.frame.size.width, 50);
    
    self.saveDescriptionButton  = [[UIButton alloc]init];
    [self.saveDescriptionButton setFrame: buttonFrame];
    [self.saveDescriptionButton setBackgroundColor: buttonColor];
    [self.saveDescriptionButton setTitle:@"save description" forState:UIControlStateNormal];
    [self.saveDescriptionButton addTarget:self
                                   action:@selector(saveDescriptionPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.descriptionTV setInputAccessoryView:self.saveDescriptionButton];
    [self.descriptionTV becomeFirstResponder];
}

- (void)saveDescriptionPressed:(id)sender {
    
    self.descriptionString   = self.descriptionTV.text;
    self.description_tf.text = self.descriptionTV.text;
    [self.descriptionTV      resignFirstResponder];
    [self.descriptionSubView setHidden:YES];
    [self.foodTitle_tf       becomeFirstResponder];
}

- (IBAction)cancelInfoPressed:(id)sender {
    
    [self.descriptionTV      resignFirstResponder];
    [self.descriptionSubView setHidden:YES];
    [self.foodTitle_tf       becomeFirstResponder];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"PirceAmountSegue"]){
        
        // Store variables globally
        Singleton *mySingleton    = [Singleton sharedSingleton];
        mySingleton.singl_title   = self.foodTitle_tf.text;
        mySingleton.singl_description = self.descriptionString;
    }
}

- (void)nextPressed:(id)sender{
    
    if (([self.foodTitle_tf.text length] == 0)) {
        [self.foodTitle_tf resignFirstResponder];
        [[HHAlertView shared] showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Title missing" detail:@"add an appealing title first" cancelButton:nil Okbutton:@"OK!" block:^(HHAlertButton buttonindex) {
            if (buttonindex == 0) {
                [self.foodTitle_tf becomeFirstResponder];
            }
        }];
    } else {
        [self performSegueWithIdentifier:@"PirceAmountSegue" sender:self];
    }
    
    
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
