//
//  Description_vc.m
//  
//
//  Created by Fabian Jenne on 27.10.15.
//
//

#import "Description_vc.h"
#import "Singleton.h"
#import "Overview_tvc.h"

@interface Description_vc ()

@end

@implementation Description_vc

@synthesize charactersLeftLabel, maxTextLen, backButtonKB;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maxTextLen = 130;
    self.descriptionInput_tv.textAlignment = NSTextAlignmentCenter;
    self.descriptionInput_tv.tintColor     = [UIColor orangeColor];
    
    self.descriptionInput_tv.delegate = self;
    [self.descriptionInput_tv becomeFirstResponder];
    
    Singleton* mySingleton   = [Singleton sharedSingleton];
    NSString *descriptString = mySingleton.singl_description;
    
    if (!(descriptString.length == 0)) {
        self.descriptionPlaceholder_tv.hidden = YES;
        self.descriptionInput_tv.text = descriptString;
    } else {
        self.descriptionPlaceholder_tv.hidden  = NO;
    }
    // TODO: change color of "backButton" when text bigger

    // charactersCount on top of keyboard
    CGRect keyb_accessoryFrame = CGRectMake(0, 0, self.view.frame.size.width, 70);
    UIView *keyb_accessoryView = [[UIView alloc]initWithFrame:keyb_accessoryFrame];
    keyb_accessoryView.backgroundColor = [UIColor clearColor];
    
    CGRect labelFrame    = CGRectMake(12, 0, 150, 20);
    UILabel *keyb_label  = [[UILabel alloc]initWithFrame:labelFrame];
    keyb_label.font      = [UIFont fontWithName:@"Gill Sans" size:13.0f];
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
    [keyb_accessoryView addSubview:self.charactersLeftLabel];
    [keyb_accessoryView addSubview:self.backButtonKB];
    [self.descriptionInput_tv setInputAccessoryView:keyb_accessoryView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add a description" message:@"Give your menu a great description first"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    
    } else {
        Singleton *mySingleton        = [Singleton sharedSingleton];
        mySingleton.singl_description = self.descriptionInput_tv.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
