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

@synthesize charactersLeftLabel, maxTextLen, segueIDString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maxTextLen = 45;

    if ([segueIDString isEqualToString:@"OverviewToTitle"]) {
        self.nextButton.enabled   = NO;
        self.nextButton.tintColor = [UIColor clearColor];
    }
    
    Singleton* mySingleton = [Singleton sharedSingleton];
    NSString *titleString  = mySingleton.singl_title;
    
    if (!(titleString.length == 0)) {
        self.titlePlaceholder_tv.hidden = YES;
        self.titleInput_tv.text = titleString;
    } else {
        self.titleInput_tv.hidden  = NO;
    }

    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gill-Sans-regular" size:14]}];
//    
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//                                                           shadow, NSShadowAttributeName,
//                                                           [UIFont fontWithN

    self.titleInput_tv.textAlignment = NSTextAlignmentCenter;
    self.titleInput_tv.tintColor     = [UIColor orangeColor];
    
    self.titleInput_tv.delegate = self;
    [self.titleInput_tv becomeFirstResponder];
    
    // charactersCount on top of keyboard
    CGRect keyb_viewFrame        = CGRectMake(0, 0, self.view.frame.size.width, 30);
    UIView *keyb_topView         = [[UIView alloc]initWithFrame:keyb_viewFrame];
    keyb_topView.backgroundColor = [UIColor clearColor];
    
    CGRect labelFrame    = CGRectMake(12, 5, 150, 20);
    UILabel *keyb_label  = [[UILabel alloc]initWithFrame:labelFrame];
    keyb_label.font      = [UIFont fontWithName:@"Gill Sans" size:13.0f];
    keyb_label.textColor = [UIColor darkGrayColor];
    self.charactersLeftLabel = keyb_label;
    
    [keyb_topView addSubview:self.charactersLeftLabel];
    [self.titleInput_tv setInputAccessoryView:keyb_topView];
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
    [self performSegueWithIdentifier:@"TitelToImages" sender:self];
    
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
