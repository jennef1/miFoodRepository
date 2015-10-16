//
//  TitleInput_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 03.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleInput_vc : UIViewController <UITextFieldDelegate, UITextViewDelegate>

// title
@property (strong, nonatomic) IBOutlet UITextField *titleCharacterLeft_tf;
@property (strong, nonatomic) IBOutlet UITextField *foodTitle_tf;
@property (assign, nonatomic) int maxTextLen;

// add description
- (IBAction)addInfoPressed:(id)sender;
- (IBAction)cancelInfoPressed:(id)sender;
- (void)saveDescriptionPressed:(id)sender;
@property (strong, nonatomic) NSString *descriptionString;
@property (strong, nonatomic) UIButton *saveDescriptionButton;
@property (strong, nonatomic) IBOutlet UIView *descriptionSubView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTV;
@property (strong, nonatomic) IBOutlet UILabel *description_tf;

// navigation
@property (strong, nonatomic) UIButton *nextButton;
- (void)nextPressed:(id)sender;
- (IBAction)backPressed:(id)sender;


@end
