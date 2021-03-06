//
//  LocationDescription_vc.m
//  
//
//  Created by Fabian Jenne on 29.10.15.
//
//

#import "LocationDescription_vc.h"
#import "Singleton.h"

@interface LocationDescription_vc ()

@end

@implementation LocationDescription_vc

@synthesize charactersLeftLabel, maxTextLen, backButtonKB;

- (void)viewDidLoad {
    
    self.maxTextLen = 400;
    self.descriptionInput_tv.textAlignment = NSTextAlignmentCenter;
    self.descriptionInput_tv.tintColor     = [UIColor orangeColor];
    
    self.descriptionInput_tv.delegate = self;
    [self.descriptionInput_tv becomeFirstResponder];
    
    Singleton* mySingleton   = [Singleton sharedSingleton];
    NSString *locDescription = mySingleton.singl_locationComment;
    
    if (!(locDescription.length == 0)) {
        self.descriptionPlaceholder_tv.hidden = YES;
        self.descriptionInput_tv.text = locDescription;
    } else {
        self.descriptionPlaceholder_tv.hidden  = NO;
    }
    
    // charactersCount on top of keyboard
    CGRect keyb_viewFrame        = CGRectMake(0, 0, self.view.frame.size.width, 70);
    UIView *keyb_topView         = [[UIView alloc]initWithFrame:keyb_viewFrame];
    keyb_topView.backgroundColor = [UIColor clearColor];
    
    CGRect labelFrame    = CGRectMake(12, 0, 150, 20);
    UILabel *keyb_label  = [[UILabel alloc]initWithFrame:labelFrame];
    keyb_label.font      = [UIFont fontWithName:@"Gill Sans" size:12.0f];
    keyb_label.textColor = [UIColor darkGrayColor];
    self.charactersLeftLabel = keyb_label;
    
    UIColor *buttonColor = [UIColor colorWithRed:(255/255.0) green:(211/255.0) blue:(41/255.0) alpha:1];
    CGRect buttonFrame   = CGRectMake(0, 20, self.view.frame.size.width, 50);
    self.backButtonKB    = [[UIButton alloc]init];
    [self.backButtonKB setFrame: buttonFrame];
    [self.backButtonKB setBackgroundColor: buttonColor];
    [self.backButtonKB setTitle:@"done" forState:UIControlStateNormal];
    [self.backButtonKB addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect btnIndicatorFrame  = CGRectMake(20, (buttonFrame.size.height/2 - 10), 20, 20);
    UIImageView *btnIndicator = [[UIImageView alloc]initWithFrame:btnIndicatorFrame];
    btnIndicator.image        = [UIImage imageNamed:@"arrowBackWhite"];

    [self.backButtonKB  addSubview: btnIndicator];
    [keyb_topView addSubview:self.charactersLeftLabel];
    [keyb_topView addSubview:self.backButtonKB];
    [self.descriptionInput_tv setInputAccessoryView:keyb_topView];
}

#pragma mark - TextViewDelegate

-(void) textViewDidChange:(UITextView *)textView {
    
    if (textView == self.descriptionInput_tv) {
        if (self.descriptionInput_tv.text.length == 0) {
            self.descriptionPlaceholder_tv.hidden = NO;
        } else {
            self.descriptionPlaceholder_tv.hidden = YES;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    UIColor *buttonCollor = [UIColor colorWithRed:(254/255.0) green:(221/255.0) blue:(11/255.0) alpha:1];
    
    if (textView == self.descriptionInput_tv) {
        // Prevent crashing undo bug – see note below.
        if(range.length + range.location > textView.text.length) {
            return NO;
        }
        
        NSInteger newTextLength = [textView.text length] + [text length] - range.length;
        
        if (newTextLength == 0) {
            self.backButton.tintColor     = [UIColor lightGrayColor];
            self.charactersLeftLabel.text = [NSString stringWithFormat:@"%i characters left", self.maxTextLen];
            self.descriptionPlaceholder_tv.hidden = NO;
            
        } else {
            self.backButton.tintColor = buttonCollor;
            if (newTextLength > (self.maxTextLen - 1)) {
                self.charactersLeftLabel.text      = @"Zero characters left";
                self.charactersLeftLabel.textColor = [UIColor redColor];
            } else {
                self.charactersLeftLabel.text = [NSString stringWithFormat:@"%lu characters left", (self.maxTextLen - newTextLength)];
                self.charactersLeftLabel.textColor = [UIColor darkGrayColor];
            }
        }
        return (newTextLength > self.maxTextLen) ? NO : YES;
    } else {
        return YES;
    }
}

#pragma mark - KeyBoard Notificaiton

- (void)keyboardWillChange:(NSNotification *)notification {
    
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
}

#pragma mark - Navigation

- (IBAction)backPressed:(id)sender {
    if (self.descriptionInput_tv.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        Singleton *mySingleton            = [Singleton sharedSingleton];
        mySingleton.singl_locationComment = self.descriptionInput_tv.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
