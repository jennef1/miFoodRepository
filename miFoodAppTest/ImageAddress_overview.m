//
//  ImageAddress_overview.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 04.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "ImageAddress_overview.h"
#import "Singleton.h"
#import "Preview_vc.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ImageAddress_overview ()

@end

@implementation ImageAddress_overview

@synthesize chosenImages, saveCommentButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.locComTV setDelegate:self];
    
    // global storred variables from mask_vc's
    Singleton* mySingleton       = [Singleton sharedSingleton];
    self.chosenImages            = mySingleton.singl_foodImages;
    self.locationComment_tv.text = mySingleton.singl_locationComment;
    self.addressInput            = mySingleton.singl_addressName;
    self.dateTimeInput           = mySingleton.singl_date;
    self.addressCityInput        = mySingleton.singl_cityName;
    
    // TODO: add selection of images if user does not have its own
    
    // design configs
    CALayer *layer = [self.previewImage1 layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0];
    
    UIColor *bordercolor = [UIColor colorWithRed:(61/255.0) green:(217/255.0) blue:(196/255.0) alpha:1];
    [self.locComTFplaceholder.layer setBorderColor:[bordercolor CGColor]];
    [self.locComTFplaceholder.layer setBorderWidth:0.9];
    [self.locComTFplaceholder.layer setCornerRadius:3];
    [self.locComTFplaceholder setClipsToBounds:YES];
    
    [self.locComSubView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.locComSubView.layer setBorderWidth:0.7];
    [self.locComSubView.layer setCornerRadius:3];
    [self.locComSubView       setClipsToBounds:YES];
    
    // keyboard nextButton
    UIColor *buttonColor = [UIColor colorWithRed:(255/255.0) green:(211/255.0) blue:(41/255.0) alpha:1];
    CGRect buttonFrame   = CGRectMake(0, 0, self.view.frame.size.width, 50);
    
    self.saveCommentButton = [[UIButton alloc]init];
    [self.saveCommentButton setFrame: buttonFrame];
    [self.saveCommentButton setBackgroundColor: buttonColor];
    [self.saveCommentButton setTitle:@"save" forState:UIControlStateNormal];
    [self.saveCommentButton addTarget:self action:@selector(saveCommentPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.locComTV setInputAccessoryView:self.saveCommentButton];
    
    self.locComSubView.hidden       = YES;
    self.locComTitle.hidden         = YES;
    self.locComSubTitle.hidden      = YES;
    self.locComTFplaceholder.hidden = YES;
    self.locComTV.hidden            = YES;
    
    // gesture for adding images
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] init];
    [singleTap addTarget:self action:@selector(addImagesPressed:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.previewImage1 setUserInteractionEnabled:YES];
    [self.previewImage1 addGestureRecognizer:singleTap];
    
    if (!([self.addressInput length] == 0)) {
        self.addressTitle_label.text    = self.addressInput;
        self.addressSubtitle_label.text = self.addressCityInput;
        self.previewSubmitButton.hidden = NO;
    } else {
        self.previewSubmitButton.hidden = YES;
    }

    if (!([self.locationComment_tv.text length] == 0)) {
        self.locationCom_placeholderTop.hidden    = YES;
        self.locationCom_placeholderBottom.hidden = YES;
        self.locationComment_tv.hidden            = NO;
    } else {
        self.locationCom_placeholderTop.hidden    = NO;
        self.locationCom_placeholderBottom.hidden = NO;
        self.locationComment_tv.hidden            = YES;
    }

    [self configImagesInView];
}

#pragma mark - ELCImagePickerDelegate

- (IBAction)addImagesPressed:(id)sender{
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.imagePickerDelegate = self;
    
    elcPicker.maximumImagesCount    = 5;    // max number of selectable images
    elcPicker.returnsOriginalImage  = YES;  // only return fullScreenImage, not fullResolutionImage (=NO)
    elcPicker.returnsImage          = YES;  // return UIimage. If NO, only return asset location information
    elcPicker.onOrder               = YES;  // for multiple image selection, return order of selection
    elcPicker.mediaTypes            = @[(NSString *)kUTTypeImage]; //...(NSString *)kUTTypeMovie];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    self.previewImage1.image = nil;
    self.previewImage2.image = nil;
    self.previewImage3.image = nil;
    self.previewImage4.image = nil;
    self.previewImage5.image = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    for (NSDictionary *dict in info) {
        
        if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
            
            UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
            
            // reduze image file:
            UIImage *tempImage        = nil;
            CGSize targetsize         = CGSizeMake(self.previewImage1.bounds.size.width, self.previewImage1.bounds.size.height);
            
            UIGraphicsBeginImageContext(targetsize);
            CGRect thumbnailRect      = CGRectMake(0, 0, 0, 0);
            thumbnailRect.origin      = CGPointMake(0.0,0.0);
            thumbnailRect.size.width  = targetsize.width;
            thumbnailRect.size.height = targetsize.height;
            [image drawInRect:thumbnailRect];
            tempImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            image = tempImage;
            
            [images addObject:image];
            
        } else {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
        }
    }
        // TODO: dont forget to enable SUBMIT button
//        if ((!([self.chosenImages count] == 0)) && (!([self.titleInput length] == 0)) && (!([self.descriptionInput length] == 0)) && (!(self.priceInput <= 0.0)) && (!(self.dateTimeInput == nil))) {
            //            self.submitButton.backgroundColor   = [UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(39/255.0) alpha:0.7];
            //            self.submitButton.enabled           = YES;
            
//        }
//    }
    
    self.chosenImages            = images;
    Singleton *mySingleton       = [Singleton sharedSingleton];
    mySingleton.singl_foodImages = self.chosenImages;
    
    [self configImagesInView];
}
    
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configImagesInView {
    
    UIImage *placeholderSmall = [UIImage imageNamed:@"imagePlaceholder.png"];
    UIImage *placeholderBig   = [UIImage imageNamed:@"imageLargePlaceholder.png"];
    
    // TODO: check whats better: AspectFit vs AspectFill
    self.previewImage1.contentMode = UIViewContentModeScaleAspectFit;
    self.previewImage2.contentMode = UIViewContentModeScaleAspectFit;
    self.previewImage3.contentMode = UIViewContentModeScaleAspectFit;
    self.previewImage4.contentMode = UIViewContentModeScaleAspectFit;
    self.previewImage5.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([self.chosenImages count] == 5) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
        self.previewImage4.image = [self.chosenImages objectAtIndex:3];
        self.previewImage5.image = [self.chosenImages objectAtIndex:4];
        self.preview1Text.hidden = YES;
    } else if ([self.chosenImages count] == 4) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
        self.previewImage4.image = [self.chosenImages objectAtIndex:3];
        self.previewImage5.image = placeholderSmall;
        self.preview1Text.hidden = YES;
    } else if ([self.chosenImages count] == 3) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
        self.previewImage4.image = placeholderSmall;
        self.previewImage5.image = placeholderSmall;
        self.preview1Text.hidden = YES;
    } else if ([self.chosenImages count] == 2) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = placeholderSmall;
        self.previewImage4.image = placeholderSmall;
        self.previewImage5.image = placeholderSmall;
        self.preview1Text.hidden = YES;
    } else if ([self.chosenImages count] == 1) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = placeholderSmall;
        self.previewImage3.image = placeholderSmall;
        self.previewImage4.image = placeholderSmall;
        self.previewImage5.image = placeholderSmall;
        self.preview1Text.hidden = YES;
    } else {
        self.previewImage1.image = placeholderBig;
        self.previewImage2.image = placeholderSmall;
        self.previewImage3.image = placeholderSmall;
        self.previewImage4.image = placeholderSmall;
        self.previewImage5.image = placeholderSmall;
        self.preview1Text.hidden = NO;
    }
}

#pragma mark - LocationComment SubView & TV delegate

- (IBAction)locComPressed:(id)sender {
    self.locComSubView.hidden       = NO;
    self.locComTitle.hidden         = NO;
    self.locComSubTitle.hidden      = NO;
    self.locComTFplaceholder.hidden = NO;
    self.locComTV.hidden            = NO;
    
    [self.locComTV becomeFirstResponder];
}

- (void)saveCommentPressed:(id)sender{
    [self.locComTV resignFirstResponder];
    
    Singleton *mySingleton              = [Singleton sharedSingleton];
    
    if (!([self.locComTV.text length] == 0)) {
        self.locationCom_placeholderTop.hidden    = YES;
        self.locationCom_placeholderBottom.hidden = YES;
        self.locationComment_tv.hidden            = NO;
        self.locationComment_tv.text              = self.locComTV.text;
        mySingleton.singl_locationComment   = self.locComTV.text;
    } else {
        mySingleton.singl_locationComment   = @"empty";
    }
    
    self.locComSubView.hidden       = YES;
    self.locComTitle.hidden         = YES;
    self.locComSubTitle.hidden      = YES;
    self.locComTFplaceholder.hidden = YES;
    self.locComTV.hidden            = YES;
}

#pragma mark - Navigation & Parse data

- (IBAction)previewSubmitPressed:(id)sender {

    Singleton* mySingleton          = [Singleton sharedSingleton];
    mySingleton.singl_addressName   = self.addressInput;
    mySingleton.singl_cityName      = self.addressCityInput;
    
    [self performSegueWithIdentifier:@"ImageAddress2Preview" sender:self];
}


@end
