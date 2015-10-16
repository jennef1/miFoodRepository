//
//  DescriptionInput_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 03.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "DescriptionInput_vc.h"
#import "Singleton.h"
#import "HHAlertView.h"

@interface DescriptionInput_vc ()

@end

@implementation DescriptionInput_vc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.description_tf becomeFirstResponder];
    [self.description_tf setDelegate:self];
    
    UIView *spacerView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIColor *bordercolor = [UIColor colorWithRed:(61/255.0) green:(217/255.0) blue:(196/255.0) alpha:1];
    
    [self.description_tf setLeftViewMode:UITextFieldViewModeAlways];
    [self.description_tf setLeftView:spacerView];
    
    [self.description_tf.layer setBorderColor:[bordercolor CGColor]];
    [self.description_tf.layer setBorderWidth:0.9];
    [self.description_tf.layer setCornerRadius:4];
    [self.description_tf setClipsToBounds:YES];
    
    self.maxTextLen                   = 100;
    self.commentCharacterLeft_tf.text = [NSString stringWithFormat:@"%i characters left", self.maxTextLen];
    
    // Navigation bar configuration
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    // set keyboard nextButton
    UIColor *buttonColor = [UIColor colorWithRed:(255/255.0) green:(211/255.0) blue:(41/255.0) alpha:1];
    CGRect buttonFrame   = CGRectMake(0, 0, self.view.frame.size.width, 50);
    self.nextButton      = [[UIButton alloc]init];
    [self.nextButton setFrame: buttonFrame];
    [self.nextButton setBackgroundColor: buttonColor];
    [self.nextButton setTitle:@"next" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.description_tf setInputAccessoryView:self.nextButton];
    
}

#pragma makr - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (newLength == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.commentCharacterLeft_tf.text      = [NSString stringWithFormat:@"%i characters left", self.maxTextLen];
        self.commentCharacterLeft_tf.textColor = [UIColor colorWithRed:(255/255.0) green:(128/255.0) blue:(0/255.0) alpha:1];
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (newLength > (self.maxTextLen - 1)) {
            self.commentCharacterLeft_tf.text       = @"Zero characters left";
            self.commentCharacterLeft_tf.textColor  = [UIColor redColor];
        } else {
            self.commentCharacterLeft_tf.text       = [NSString stringWithFormat:@"%u characters left", (self.maxTextLen - newLength)];
            self.commentCharacterLeft_tf.textColor  = [UIColor colorWithRed:(255/255.0) green:(128/255.0) blue:(0/255.0) alpha:1];
        }
    }
    self.description_tv.text = [NSString stringWithFormat:@"%@%@", textField.text, string];
    return (newLength > self.maxTextLen) ? NO : YES;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"PriceSegue"]){
        
        // Store variables globally
        Singleton *mySingleton    = [Singleton sharedSingleton];
        mySingleton.singl_description   = self.description_tv.text;
    }
}

- (void)nextPressed:(id)sender {
    
    if (([self.description_tf.text length] == 0)) {
        [self.description_tf resignFirstResponder];
        [[HHAlertView shared] showAlertWithStyle:HHAlertStyleError inView:self.view Title:@"Description missing" detail:@"add a good description" cancelButton:nil Okbutton:@"OK!" block:^(HHAlertButton buttonindex) {
            if (buttonindex == 0) {
                [self.description_tf becomeFirstResponder];
            }
        }];
       
    } else {
        [self performSegueWithIdentifier:@"PriceSegue" sender:self];
    }
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
