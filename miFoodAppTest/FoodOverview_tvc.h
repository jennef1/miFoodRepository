//
//  FoodOverview_tvc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 25.08.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELCImagePickerHeader.h"

@interface FoodOverview_tvc : UITableViewController <ELCImagePickerControllerDelegate>

// preview images
@property (strong, nonatomic) IBOutlet UIImageView *previewImage1;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage2;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage3;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage4;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage5;

// input labels
@property (strong, nonatomic) IBOutlet UILabel *titlePlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) IBOutlet UILabel *priceQuantityPlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;

@property (strong, nonatomic) IBOutlet UILabel *addressLabelPlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *addressLable;
@property (strong, nonatomic) IBOutlet UILabel *addressSublabel;

@property (strong, nonatomic) IBOutlet UILabel *dateTimePlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

// Tickbox images
@property (strong, nonatomic) IBOutlet UIImageView *tickBox4Image;
@property (strong, nonatomic) IBOutlet UIImageView *tickBox4Title;
@property (strong, nonatomic) IBOutlet UIImageView *tickBox4PriceQuantity;
@property (strong, nonatomic) IBOutlet UIImageView *tickBox4Address;
@property (strong, nonatomic) IBOutlet UIImageView *tickBox4Date;

// Input from user by different Masks_vc's
@property (strong, nonatomic) NSString *foodTypeInput;
@property (strong, nonatomic) NSString *titleInput;
@property (strong, nonatomic) NSString *descriptionInput;
@property (assign) double priceInput;
@property (assign) int    quantityInput;
@property (strong, nonatomic) NSString *addressInput;
@property (strong, nonatomic) NSString *addressCityInput;
@property (strong, nonatomic) NSDate   *dateTimeInput;
@property (strong, nonatomic) NSString *locationCommentsInput;

// Image Picker
@property (copy, nonatomic) NSMutableArray *chosenImages;

- (IBAction)addImagesPressed:(id)sender;

// Navigation
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitPressed:(id)sender;

- (IBAction)backButtonPressed:(id)sender;

@end
