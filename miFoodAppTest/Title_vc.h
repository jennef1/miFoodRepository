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
@property (nonatomic, strong) NSString *segueIDString;

- (IBAction)backPressed:(id)sender;
- (IBAction)nextPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;

- (IBAction)seePreviousMenusPressed:(id)sender;



@end
