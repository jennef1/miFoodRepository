//
//  Title_vc.m
//  
//
//  Created by Fabian Jenne on 23.10.15.
//
//

#import "Title_vc.h"
#import "Singleton.h"

@interface Title_vc ()

@end

@implementation Title_vc

@synthesize charactersLeftLabel, maxTextLen, segueIDString, nextButtonKB;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maxTextLen                  = 50;
    self.titleInput_tv.textAlignment = NSTextAlignmentCenter;
    self.titleInput_tv.tintColor     = [UIColor orangeColor];
    
    self.titleInput_tv.delegate = self;
    [self.titleInput_tv becomeFirstResponder];
    
    Singleton* mySingleton = [Singleton sharedSingleton];
    NSString *titleString  = mySingleton.singl_title;
    
    if (!(titleString.length == 0)) {
        self.titlePlaceholder_tv.hidden = YES;
        self.titleInput_tv.text = titleString;
    } else {
        self.titleInput_tv.hidden  = NO;
    }
    
    // keyboard Accessory View
    CGRect  keyb_accessoryFrame = CGRectMake(0, 0, self.view.frame.size.width, 70);
    UIView *keyb_accessoryView  = [[UIView alloc]initWithFrame:keyb_accessoryFrame];
    keyb_accessoryView.backgroundColor = [UIColor clearColor];
    
    CGRect labelFrame    = CGRectMake(12, 0, 150, 20);
    UILabel *keyb_label  = [[UILabel alloc]initWithFrame:labelFrame];
    keyb_label.font      = [UIFont fontWithName:@"Gill Sans" size:13.0f];
    keyb_label.textColor = [UIColor darkGrayColor];
    self.charactersLeftLabel = keyb_label;
    
    UIColor *buttonColor = [UIColor colorWithRed:(255/255.0) green:(211/255.0) blue:(41/255.0) alpha:1];
    CGRect buttonFrame   = CGRectMake(0, 20, self.view.frame.size.width, 50);
    self.nextButtonKB    = [[UIButton alloc]init];
    [self.nextButtonKB setFrame: buttonFrame];
    [self.nextButtonKB setBackgroundColor: buttonColor];
    
    if ([segueIDString isEqualToString:@"OverviewToTitle"]) {
        self.nextButton.enabled   = NO;
        self.nextButton.tintColor = [UIColor clearColor];
        [self.nextButtonKB setTitle:@"done" forState:UIControlStateNormal];
        [self.nextButtonKB addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
        CGRect btnIndicatorFrame  = CGRectMake(20, (buttonFrame.size.height/2 - 10), 20, 20);
        UIImageView *btnIndicator = [[UIImageView alloc]initWithFrame:btnIndicatorFrame];
        btnIndicator.image        = [UIImage imageNamed:@"arrowBackWhite"];
        [self.nextButtonKB addSubview: btnIndicator];
    } else {
        [self.nextButtonKB setTitle:@"next" forState:UIControlStateNormal];
        [self.nextButtonKB addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];
        CGRect btnIndicatorFrameB  = CGRectMake((buttonFrame.size.width - 44), (buttonFrame.size.height/2 - 10), 20, 20);
        UIImageView *btnIndicatorB = [[UIImageView alloc]initWithFrame:btnIndicatorFrameB];
        btnIndicatorB.image        = [UIImage imageNamed:@"arrowForwardWhite"];
        [self.nextButtonKB addSubview: btnIndicatorB];
    }
    
    [keyb_accessoryView addSubview:self.nextButtonKB];
    [keyb_accessoryView addSubview:self.charactersLeftLabel];
    [self.titleInput_tv setInputAccessoryView:keyb_accessoryView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - TextViewDelegate

-(void) textViewDidChange:(UITextView *)textView {
    
    if (textView == self.titleInput_tv) {
        if (self.titleInput_tv.text.length == 0) {
            self.titlePlaceholder_tv.hidden = NO;
        } else {
            self.titlePlaceholder_tv.hidden = YES;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView == self.titleInput_tv) {
        // Prevent crashing undo bug – see note below.
        if(range.length + range.location > textView.text.length) {
            return NO;
        }
        
        NSInteger newTextLength = [textView.text length] + [text length] - range.length;
        
        if (newTextLength == 0) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            self.charactersLeftLabel.text = [NSString stringWithFormat:@"%i characters left", self.maxTextLen];
            self.titlePlaceholder_tv.hidden = NO;
            
        } else {
            if ([segueIDString isEqualToString:@"ss"]) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            } else {
               self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"TitelToImages"]) {
        // Store variables globally
        Singleton *mySingleton    = [Singleton sharedSingleton];
        mySingleton.singl_title   = self.titleInput_tv.text;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextPressed:(id)sender {
    if (self.titleInput_tv.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add a title" message:@"Give your menu a great title first"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
       [self performSegueWithIdentifier:@"TitelToImages" sender:self];
    }
}

- (IBAction)backPressed:(id)sender {
    
    if ([segueIDString isEqualToString:@"OverviewToTitle"]) {
        Singleton *mySingleton    = [Singleton sharedSingleton];
        mySingleton.singl_title   = self.titleInput_tv.text;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)seePreviousMenusPressed:(id)sender {
}
@end
