//
//  ImageAddress_overview.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 04.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"

@interface ImageAddress_overview : UIViewController <ELCImagePickerControllerDelegate, UITextViewDelegate>

// preview images
@property (strong, nonatomic) IBOutlet UIImageView *previewImage1;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage2;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage3;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage4;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage5;
@property (strong, nonatomic) IBOutlet UILabel *preview1Text;

// input from address / locationComment
@property (strong, nonatomic) NSString *addressInput;
@property (strong, nonatomic) NSString *addressCityInput;
@property (strong, nonatomic) NSDate   *dateTimeInput;

// image picker
@property (copy, nonatomic) NSMutableArray *chosenImages;
- (IBAction)addImagesPressed:(id)sender;
- (void)configImagesInView;

@property (strong, nonatomic) IBOutlet UILabel *addressTitle_label;
@property (strong, nonatomic) IBOutlet UILabel *addressSubtitle_label;
@property (strong, nonatomic) IBOutlet UILabel *locationCom_placeholderTop;
@property (strong, nonatomic) IBOutlet UILabel *locationCom_placeholderBottom;
@property (strong, nonatomic) IBOutlet UITextView *locationComment_tv;

// location comment subview
@property (strong, nonatomic) IBOutlet UIView *locComSubView;
@property (strong, nonatomic) IBOutlet UILabel *locComTitle;
@property (strong, nonatomic) IBOutlet UILabel *locComSubTitle;
@property (strong, nonatomic) IBOutlet UITextField *locComTFplaceholder;
@property (strong, nonatomic) IBOutlet UITextView *locComTV;
@property (strong, nonatomic) UIButton *saveCommentButton;
- (void)saveCommentPressed:(id)sender;
- (IBAction)locComPressed:(id)sender;

// navigation
@property (strong, nonatomic) IBOutlet UIButton *previewSubmitButton;
- (IBAction)previewSubmitPressed:(id)sender;


@end
