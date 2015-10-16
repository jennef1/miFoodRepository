//
//  FoodOverview_tvc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 25.08.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "FoodOverview_tvc.h"
#import "Singleton.h"
#import "FoodType_vc.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

@interface FoodOverview_tvc ()

@end

@implementation FoodOverview_tvc

@synthesize chosenImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get global storred variables from mask_vc's
    Singleton* mySingleton      = [Singleton sharedSingleton];
//    self.foodTypeInput          = mySingleton.singl_foodType;
    self.chosenImages           = mySingleton.singl_foodImages;
    self.titleInput             = mySingleton.singl_title;
    self.descriptionInput       = mySingleton.singl_description;
    self.priceInput             = mySingleton.singl_price;
    self.quantityInput          = mySingleton.singl_quantity;
    self.addressInput           = mySingleton.singl_addressName;
    self.dateTimeInput          = mySingleton.singl_date;
    self.locationCommentsInput  = mySingleton.singl_locationComment;
    self.addressCityInput       = mySingleton.singl_cityName;
    
    // Disable / enable submit button
//    self.submitButton.backgroundColor       = [UIColor lightGrayColor];
    self.submitButton.layer.cornerRadius    = 1;
    self.submitButton.alpha                 = 0.8;
    self.submitButton.enabled               = NO;
    
    if ((!([self.chosenImages count] == 0)) && (!([self.titleInput length] == 0)) && (!([self.descriptionInput length] == 0)) && (!(self.priceInput <= 0.0)) && (!(self.dateTimeInput == nil))) {
        self.submitButton.enabled                   = YES;
        self.submitButton.showsTouchWhenHighlighted = YES;
    }
    
    // If user input exists hide TFs, show input
    UIImage *tickBoxImage = [UIImage imageNamed:@"tickGreen.png"];
    
    [self.previewImage1.layer setCornerRadius:2.5];
    
    if ([self.chosenImages count] == 5) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
        self.previewImage4.image = [self.chosenImages objectAtIndex:3];
        self.previewImage5.image = [self.chosenImages objectAtIndex:4];
    } else if ([self.chosenImages count] == 4) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
        self.previewImage4.image = [self.chosenImages objectAtIndex:3];
    } else if ([self.chosenImages count] == 3) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
    } else if ([self.chosenImages count] == 2) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
    } else if ([self.chosenImages count] == 1) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
    }
        
    self.titleLable.hidden               = YES;
    self.descriptionLabel.hidden         = YES;
    self.titlePlaceholder.hidden         = NO;
    
    self.priceLabel.hidden               = YES;
    self.quantityLabel.hidden            = YES;
    self.priceQuantityPlaceholder.hidden = NO;
    
    self.addressLable.hidden             = YES;
    self.addressSublabel.hidden          = YES;
    self.addressLabelPlaceholder.hidden  = NO;
    
    self.dateTimeLabel.hidden            = YES;
    self.locationLabel.hidden            = YES;
    self.dateTimePlaceholder.hidden      = NO;
    
    if (!([self.titleInput length] == 0)) {
        self.titleLable.hidden       = NO;
        self.descriptionLabel.hidden = NO;
        self.titlePlaceholder.hidden = YES;
        self.titleLable.text         = self.titleInput;
        self.descriptionLabel.text   = self.descriptionInput;
        self.tickBox4Title.image     = tickBoxImage;
    }
    
    if (!(self.priceInput <= 0.0)) {
        self.priceLabel.hidden               = NO;
        self.quantityLabel.hidden            = NO;
        self.priceQuantityPlaceholder.hidden = YES;
        self.priceLabel.text                 = [NSString stringWithFormat:@"%.02f £ per menu", self.priceInput];
        self.quantityLabel.text              = [NSString stringWithFormat:@"Offering this menu %i times", self.quantityInput];
        self.tickBox4PriceQuantity.image = tickBoxImage;
    }
    
    if (!([self.addressInput length] == 0)) {
        self.addressLable.hidden             = NO;
        self.addressSublabel.hidden          = NO;
        self.addressLabelPlaceholder.hidden  = YES;
        self.addressLable.text               = self.addressInput;
        self.addressSublabel.text            = self.addressCityInput;
        self.tickBox4Address.image           = tickBoxImage;
    }
    
    if (!(self.dateTimeInput == nil)) {
        self.dateTimeLabel.hidden       = NO;
        self.locationLabel.hidden       = NO;
        self.dateTimePlaceholder.hidden = YES;
        NSDateFormatter *dateFormater   = [NSDateFormatter new];
        dateFormater.dateFormat         = @"dd.MMM yy  @ HH:mm";
        self.dateTimeLabel.text         = [dateFormater stringFromDate:self.dateTimeInput];
        self.locationLabel.text         = self.locationCommentsInput;
        self.tickBox4Date.image         = tickBoxImage;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
      
        // TODO: dont forget to enable SUBMIT button
        if ((!([self.chosenImages count] == 0)) && (!([self.titleInput length] == 0)) && (!([self.descriptionInput length] == 0)) && (!(self.priceInput <= 0.0)) && (!(self.dateTimeInput == nil))) {
//            self.submitButton.backgroundColor   = [UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(39/255.0) alpha:0.7];
//            self.submitButton.enabled           = YES;
            
        }
    }
    
    self.chosenImages = images;
    
    if ([self.chosenImages count] == 5) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
        self.previewImage4.image = [self.chosenImages objectAtIndex:3];
        self.previewImage5.image = [self.chosenImages objectAtIndex:4];
    } else if ([self.chosenImages count] == 4) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
        self.previewImage4.image = [self.chosenImages objectAtIndex:3];
    } else if ([self.chosenImages count] == 3) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
    } else if ([self.chosenImages count] == 2) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
    } else if ([self.chosenImages count] == 1) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
    }

    
//    [self.scrollViewImage setPagingEnabled:YES];
//    [self.scrollViewImage setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
    // store images in singleton
    Singleton *mySingleton = [Singleton sharedSingleton];
    mySingleton.singl_foodImages = self.chosenImages;
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation & Parse

- (IBAction)submitPressed:(id)sender {
    
/* older version
    - (void)submitPressed:(id)sender {
        
        // Create Parse Object MenuImages
        PFObject *menuImages = [PFObject objectWithClassName:@"Menu_Images"];
        [menuImages setObject:[PFUser currentUser] forKey:@"createdBy"];
        [menuImages save];
        
        for (int i = 0; i < [self.chosenImages count]; i++) {
            NSData *imageData       = UIImagePNGRepresentation([self.chosenImages objectAtIndex:i]);
            PFFile *imageFile       = [PFFile fileWithName:@"image.png" data:imageData];
            NSString *keyforImage   = [NSString stringWithFormat:@"imageFile%d", i];
            [menuImages setObject:imageFile forKey:keyforImage];
            [menuImages saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"imageFile save successful");
                }
            }];
            
            // TODO: Create Parse Object Menu Items with link to Menu Images
            
            NSString *initialStatus     = @"available";
            Singleton* mySingleton      = [Singleton sharedSingleton];
            int quantity                = mySingleton.singl_quantity;
            double price                = mySingleton.singl_price;
            NSString *title             = mySingleton.singl_title;
            NSString *description       = mySingleton.singl_description;
            NSDate   *date              = mySingleton.singl_dateDate;
            NSDate   *time              = mySingleton.singl_dateTime;
            NSString *addressFormatted  = mySingleton.singl_formattedAddressName;
            NSString *addressName       = mySingleton.singl_addressName;
            NSString *cityName          = mySingleton.singl_cityName;
            NSString *placeID           = mySingleton.singl_placeID;
            NSString *locationComments  = mySingleton.singl_locationComment;
            CLLocationCoordinate2D coor = mySingleton.singl_coordinates;
            PFGeoPoint *coordinatePoint = [PFGeoPoint geoPointWithLatitude:coor.latitude longitude:coor.longitude];
            
            PFObject *menuItems = [PFObject objectWithClassName:@"Menu_Offers"];
            
            for (int i = 0; i < quantity; i++) {
                [menuItems setObject:[menuImages objectId] forKey:@"menuImageId"];
                [menuItems setObject:[PFUser currentUser]  forKey:@"createdBy"];
                
                [menuItems setObject:initialStatus forKey:@"status"];
                
                [menuItems setObject:title              forKey:@"food_title"];
                [menuItems setObject:description        forKey:@"food_description"];
                [menuItems setObject:date               forKey:@"food_date"];
                [menuItems setObject:time               forKey:@"food_time"];
                [menuImages setObject:addressFormatted  forKey:@"address_formatted"];
                [menuItems setObject:addressName        forKey:@"address_name"];
                [menuItems setObject:cityName           forKey:@"address_city"];
                [menuItems setObject:placeID            forKey:@"address_placeID"];
                [menuItems setObject:locationComments   forKey:@"address_locationComments"];
                [menuItems setObject:coordinatePoint    forKey:@"address_geoPointCoordinates"];
                [menuItems setObject:[NSNumber numberWithDouble:price] forKey:@"food_price"];
                [menuItems setObject:[NSNumber numberWithInt:quantity] forKey:@"food_quantity"];
                
                NSData *imageData = UIImagePNGRepresentation([self.chosenImages objectAtIndex:0]);
                PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                [menuItems setObject:imageFile forKey:@"imageFile0"];
                
                [menuItems saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"MenuItem data upload successful");
                    }
                }];
            }
        }
    }
*/
    // Create Parse Object MenuImages
    PFObject *menuImages = [PFObject objectWithClassName:@"Menu_Images"];
    [menuImages setObject:[PFUser currentUser] forKey:@"createdBy"];
    [menuImages save];
    
    for (int i = 0; i < [self.chosenImages count]; i++) {
        NSData *imageData       = UIImagePNGRepresentation([self.chosenImages objectAtIndex:i]);
        PFFile *imageFile       = [PFFile fileWithName:@"image.png" data:imageData];
        NSString *keyforImage   = [NSString stringWithFormat:@"imageFile%d", i];
        [menuImages setObject:imageFile forKey:keyforImage];
        [menuImages saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"imageFile save successful");
            }
        }];
        // TODO: save coordinates to Parse
        // Create Parse Object Menu Items with link to Menu Images
        PFObject *menuItems = [PFObject objectWithClassName:@"Menu_Items"];
        NSString *initialStatus = @"available";
        
        for (int i = 0; i < self.quantityInput; i++) {
            [menuItems setObject:[menuImages objectId] forKey:@"menuImageId"];
            [menuItems setObject:[PFUser currentUser] forKey:@"createdBy"];
//            [menuItems setObject:self.foodTypeInput forKey:@"food_typeCategory"];
            
            [menuItems setObject:initialStatus forKey:@"status"];
            
            [menuItems setObject:self.titleInput forKey:@"food_title"];
            [menuItems setObject:self.descriptionInput forKey:@"food_comment"];
            [menuItems setObject:[NSNumber numberWithDouble:self.priceInput] forKey:@"food_price"];
            [menuItems setObject:[NSNumber numberWithInt:self.quantityInput] forKey:@"food_quantity"];
            
            [menuItems setObject:self.addressInput forKey:@"address_name"];
            [menuItems setObject:self.addressCityInput forKey:@"address_city"];
            [menuItems setObject:self.locationCommentsInput forKey:@"address_coment"];
            [menuItems setObject:self.dateTimeInput forKey:@"address_dateTime"];
            
            NSData *imageData = UIImagePNGRepresentation([self.chosenImages objectAtIndex:0]);
            PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
            [menuItems setObject:imageFile forKey:@"imageFile0"];
            
            [menuItems saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"MenuItem data upload successful");
                }
            }];
        }
    }
}

- (IBAction)backButtonPressed:(id)sender {
    
    FoodType_vc *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFoodType_ID"];
    [self.navigationController pushViewController:tvc animated:NO];
}


@end
