//
//  DescriptionInput_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 03.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionInput_vc : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *description_tf;
@property (strong, nonatomic) IBOutlet UITextView *description_tv;

@property (strong, nonatomic) IBOutlet UITextField *commentCharacterLeft_tf;

@property (assign, nonatomic) int maxTextLen;

@property (strong, nonatomic) UIButton *nextButton;
- (void)nextPressed:(id)sender;
- (IBAction)backPressed:(id)sender;

@end
