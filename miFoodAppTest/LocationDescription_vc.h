//
//  LocationDescription_vc.h
//  
//
//  Created by Fabian Jenne on 29.10.15.
//
//

#import <UIKit/UIKit.h>

@interface LocationDescription_vc : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *descriptionInput_tv;
@property (strong, nonatomic) IBOutlet UITextView *descriptionPlaceholder_tv;

@property (strong, nonatomic) UILabel *charactersLeftLabel;
@property (assign, nonatomic) int maxTextLen;


// navigation

- (IBAction)backPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) UIButton *backButtonKB;

@end
