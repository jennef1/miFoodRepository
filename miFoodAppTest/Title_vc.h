//
//  Title_vc.h
//  
//
//  Created by Fabian Jenne on 23.10.15.
//
//

#import <UIKit/UIKit.h>

@interface Title_vc : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *titleInput_tv;
@property (strong, nonatomic) IBOutlet UITextView *titlePlaceholder_tv;

@property (strong, nonatomic) UILabel *charactersLeftLabel;
@property (assign, nonatomic) int maxTextLen;

// navigation
@property (strong, nonatomic) NSString *segueIDString;
@property (strong, nonatomic) UIButton *nextButtonKB;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;
- (IBAction)backPressed:(id)sender;
- (IBAction)nextPressed:(id)sender;



- (IBAction)seePreviousMenusPressed:(id)sender;



@end
