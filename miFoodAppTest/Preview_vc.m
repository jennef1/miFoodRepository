//
//  Preview_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 09.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "Preview_vc.h"
#import "Singleton.h"
#import "StartScreen_vc.h"
#import "HHAlertView.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <Parse/Parse.h>

@interface Preview_vc ()

@end

@implementation Preview_vc

@synthesize chosenImages, profilePictureURL, userMealsOverall_nr, userRatingOverall_nr, foodLocationCoordinate, bankDetailsStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // design config
    [self.backgroundAddressTF.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.backgroundAddressTF.layer setBorderWidth:0.7];
    [self.backgroundDateTF.layer    setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.backgroundDateTF.layer    setBorderWidth:0.7];
    
    CALayer *layer = [self.previewImage1 layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0];
    
    // inputs from masks
    Singleton* mySingleton          = [Singleton sharedSingleton];
    self.chosenImages               = mySingleton.singl_foodImages;
    self.foodTitleLabel.text        = mySingleton.singl_title;
    self.foodDescription_tv.text    = mySingleton.singl_description;
    self.foodPriceLabel.text        = [NSString stringWithFormat:@"%.2lf", mySingleton.singl_price];
    self.addressNameLabel.text      = mySingleton.singl_addressName;
    self.addressCityLabel.text      = mySingleton.singl_cityName;
    self.foodLocationCoordinate     = mySingleton.singl_coordinates;
    
    NSDateFormatter *dateFormater   = [NSDateFormatter new];
    dateFormater.dateFormat         = @"dd.MMM @ HH:mm";
    self.dateLabel.text             = [dateFormater stringFromDate: mySingleton.singl_date];
    self.locationCommentLabel.text  = mySingleton.singl_locationComment;
    
    // main thread
    [self getUserDetails:self];
    [self setLocationOnMap:self];
    [self configureImages:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User details

- (void)getUserDetails:(id)sender {
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser]username]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                
                // get name, picture, rating
                NSString *profileName     = [[object objectForKey:@"profile"] objectForKey:@"name"];
                NSString *URLString       = [[object objectForKey:@"profile"] objectForKey:@"pictureURL"];
                NSURL *pictureURL         = [NSURL URLWithString:URLString];
                self.userNameLabel.text   = profileName;
                self.profilePictureURL    = pictureURL;
                self.userRatingOverall_nr = [object objectForKey:@"ratingOverall"];
                self.userMealsOverall_nr  = [object objectForKey:@"menusOverall"];
                self.bankDetailsStatus    = [object objectForKey:@"bankDetailStatus"];
                
            }
            [self requestFBpictureViaURL:self];
            
            self.userPicture.layer.cornerRadius  = ((self.userPicture.frame.size.width / 2) - 2);
            self.userPicture.clipsToBounds       = YES;
            self.userPicture.layer.borderWidth   = 1.0f;
            self.userPicture.layer.borderColor   = [UIColor whiteColor].CGColor;
            
            self.userMealsOverall_label.text     = [NSString stringWithFormat:@"%@ menus cooked", self.userMealsOverall_nr];
        }
    }];
}

- (void)requestFBpictureViaURL:(id)sender {
    
    // Run network request asynchronously
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.profilePictureURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"start asynch request");
                               if (connectionError == nil && data != nil) {
                                   NSLog(@"finished asynch request");
                                   self.userPicture.image = [UIImage imageWithData:data];
                               }
                           }];
}

-(void)configureImages:(id)sender {
    
    UIImage *placeholderSmall = [UIImage imageNamed:@"imagePlaceholder.png"];
    UIImage *placeholderBig   = [UIImage imageNamed:@"imageLargePlaceholder.png"];
    
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
        self.previewImage5.image = placeholderSmall;
    } else if ([self.chosenImages count] == 3) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = [self.chosenImages objectAtIndex:2];
        self.previewImage4.image = placeholderSmall;
        self.previewImage5.image = placeholderSmall;
    } else if ([self.chosenImages count] == 2) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = [self.chosenImages objectAtIndex:1];
        self.previewImage3.image = placeholderSmall;
        self.previewImage4.image = placeholderSmall;
        self.previewImage5.image = placeholderSmall;
    } else if ([self.chosenImages count] == 1) {
        self.previewImage1.image = [self.chosenImages objectAtIndex:0];
        self.previewImage2.image = placeholderSmall;
        self.previewImage3.image = placeholderSmall;
        self.previewImage4.image = placeholderSmall;
        self.previewImage5.image = placeholderSmall;
    } else {
        self.previewImage1.image = placeholderBig;
        self.previewImage2.image = placeholderSmall;
        self.previewImage3.image = placeholderSmall;
        self.previewImage4.image = placeholderSmall;
        self.previewImage5.image = placeholderSmall;
    }
}

#pragma mark - GoogleMap details

- (void)setLocationOnMap:(id)sender {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.foodLocationCoordinate.latitude
                                                            longitude:self.foodLocationCoordinate.longitude
                                                                 zoom:13];
    [self.foodMap setCamera:camera];
    [self.foodMap setMapType:kGMSTypeNormal];
    
    GMSMarker *marker       = [[GMSMarker alloc]init];
    marker.position         = self.foodLocationCoordinate;
    marker.appearAnimation  = kGMSMarkerAnimationPop;
    marker.icon             = [UIImage imageNamed:@"Location Filled-50.png"];
    marker.map              = self.foodMap;
    
}

#pragma mark - Parse Save Item

- (IBAction)submitPressed:(id)sender {
    //
    //    // check if bank details available
    //    NSString *bankDetailsAvailableCompareString = @"available";
    //
    //    if ([self.bankDetailsStatus isEqualToString:bankDetailsAvailableCompareString]) {
    //        [self saveItemToParse:self];
    //
    //    } else {
    //        // show alert and save credit card details
    //    }
    [self saveItemToParse:self];
}

- (void)saveItemToParse:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode           = MBProgressHUDModeIndeterminate;
    hud.labelText      = @"uploading";
    [hud show:YES];
    
    NSString *availabilityStat  = @"available";
    int initialOrder            = 0;
    
    Singleton* mySingleton      = [Singleton sharedSingleton];
    int quantity                = mySingleton.singl_quantity;
    double price                = mySingleton.singl_price;
    NSString *title             = mySingleton.singl_title;
    NSString *description       = mySingleton.singl_description;
    NSDate   *dateInput         = mySingleton.singl_date;
    NSString *addressFormatted  = mySingleton.singl_formattedAddressName;
    NSString *addressName       = mySingleton.singl_addressName;
    NSString *cityName          = mySingleton.singl_cityName;
    NSString *placeID           = mySingleton.singl_placeID;
    NSString *locationComments  = mySingleton.singl_locationComment;
    CLLocationCoordinate2D coor = mySingleton.singl_coordinates;
    NSString *urlString         = [self.profilePictureURL absoluteString];
    NSUInteger imageCount       = [self.chosenImages count];
    PFGeoPoint *coordinatePoint = [PFGeoPoint geoPointWithLatitude:coor.latitude
                                                         longitude:coor.longitude];
    
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"dd.MMM yy  @ HH:mm"];
    NSString *dateString        = [dFormatter stringFromDate:dateInput];
    
    NSDateFormatter *dateOnlyFm = [[NSDateFormatter alloc] init];
    [dateOnlyFm setDateFormat:@"dd.MMM yy"];
    NSString *dateOnlyString    = [dateOnlyFm stringFromDate:dateInput];
    
    NSDateFormatter *timeOnlyFm = [[NSDateFormatter alloc] init];
    [timeOnlyFm setDateFormat:@"HH:mm"];
    NSString *timeOnlyString    = [timeOnlyFm stringFromDate:dateInput];
    
    // Parse Object
    PFObject *menuItems = [PFObject objectWithClassName:@"Menus"];
    [menuItems setObject:[PFUser currentUser]    forKey:@"createdBy"];
    [menuItems setObject:urlString               forKey:@"createdBy_URLProfilePic"];
    [menuItems setObject:self.userNameLabel.text forKey:@"createdBy_name"];
    
    [menuItems setObject:[NSNumber numberWithInt:quantity]     forKey:@"offer_initialQuantity"];
    [menuItems setObject:[NSNumber numberWithInt:initialOrder] forKey:@"offer_currentOrder"];
    [menuItems setObject:[NSNumber numberWithInt:quantity]     forKey:@"offer_availability"];
    [menuItems setObject:availabilityStat                      forKey:@"offer_status"];
    
    [menuItems setObject:title              forKey:@"offer_title"];
    [menuItems setObject:description        forKey:@"offer_description"];
    [menuItems setObject:dateString         forKey:@"offer_dateFullString"];
    [menuItems setObject:dateOnlyString     forKey:@"offer_dateOnlyString"];
    [menuItems setObject:timeOnlyString     forKey:@"offer_timeOnlyString"];
    [menuItems setObject:addressFormatted   forKey:@"address_formatted"];
    [menuItems setObject:addressName        forKey:@"address_name"];
    [menuItems setObject:cityName           forKey:@"address_city"];
    [menuItems setObject:placeID            forKey:@"address_placeID"];
    [menuItems setObject:locationComments   forKey:@"address_locationComments"];
    [menuItems setObject:coordinatePoint    forKey:@"address_geoPointCoordinates"];
    [menuItems setObject:[NSNumber numberWithDouble:price]            forKey:@"offer_price"];
    [menuItems setObject:[NSNumber numberWithUnsignedLong:imageCount] forKey:@"imageCount"];
    
    for (int i = 0; i < [self.chosenImages count]; i++) {
        NSData *imageData       = UIImagePNGRepresentation([self.chosenImages objectAtIndex:i]);
        PFFile *imageFile       = [PFFile fileWithName:@"image.png" data:imageData];
        NSString *keyforImage   = [NSString stringWithFormat:@"imageFile%d", i];
        [menuItems setObject:imageFile forKey:keyforImage];
    }

    
    // TODO: if succeeded: Say thankyou , navigate home?
    [menuItems saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"MenuItem data upload successful");
            
            hud.hidden = YES;
            
            [[HHAlertView shared] showAlertWithStyle:HHAlertStyleOk inView:self.view Title:@"Congrats!" detail:@"Share it on FB if you like to make your offer more popular" cancelButton:@"Share on FB!" Okbutton:@"Not now" block:^(HHAlertButton buttonindex) {
                
                if (buttonindex == 1) { // cancelButton
                    // share on FB
                    
                } else if (buttonindex == 0){ // OkButton
                    StartScreen_vc *start_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartScreen_ID"];
                    [self.navigationController pushViewController:start_vc animated:NO];
                }
            }];
        }
    }];
}

#pragma mark - Navigation

- (IBAction)cancelPressed:(id)sender {
}

@end
