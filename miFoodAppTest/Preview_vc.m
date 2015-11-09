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

@synthesize profilePictureURL, userMealsOverall_nr, userRatingOverall_nr, foodLocationCoordinate, bankDetailsStatus, submitButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // inputs from masks
    Singleton* mySingleton        = [Singleton sharedSingleton];
    self.coverImage.image         = mySingleton.singl_coverImage;
    self.foodTitle_tv.text        = mySingleton.singl_title;
    self.foodDescription_tv.text  = mySingleton.singl_description;
    self.foodPriceLabel.text      = [NSString stringWithFormat:@"%.2lf", mySingleton.singl_price];
    self.addressNameLabel.text    = mySingleton.singl_addressName;
    self.addressCityLabel.text    = mySingleton.singl_cityName;
    self.foodLocationCoordinate   = mySingleton.singl_coordinates;
    self.locationComment_tv.text  = mySingleton.singl_locationComment;
    self.availabilityCount.text   = [NSString stringWithFormat:@"%d / %d", mySingleton.singl_quantity, mySingleton.singl_quantity];
    double pickuptime             = mySingleton.singl_pickupTime;
    
    double pickUphour;
    double minutes = modf(pickuptime, &pickUphour);
    if (minutes == 0) {
        self.pickUpTime.text = [NSString stringWithFormat:@"%.0f :00", pickUphour];
    } else {
        self.pickUpTime.text = [NSString stringWithFormat:@"%.0f :30", pickUphour];
    }
    
    // design config
    [self.coverImageButtomIcon.layer setCornerRadius:20];
    [self.backgroundAddress_tf.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.backgroundAddress_tf.layer setBorderWidth:0.7];
    [self.backgroundAddress_tf.layer setCornerRadius:4];
    
    CGRect descTVrect             = self.foodDescription_tv.frame;
    descTVrect.size.height        = self.foodDescription_tv.contentSize.height;
    self.foodDescription_tv.frame = descTVrect;
    
    self.scrollView.delegate = self;    
    
    // main thread
    [self getUserDetails:self];
    [self setLocationOnMap:self];
}

#pragma mark - SubmitButton Config

- (void)viewWillAppear:(BOOL)animated {
    
    CGRect btnFrame     = CGRectMake(0, (CGRectGetHeight(self.view.bounds) - 50) , self.view.frame.size.width, 50);
    
    UIButton *btn       = [[UIButton alloc]initWithFrame:btnFrame];
    btn.backgroundColor = [UIColor colorWithRed:(242/255.0) green:(202/255.0) blue:(41/255.0) alpha:1];
    self.submitButton   = btn;
    [self.submitButton setTitle: @"Submit" forState: UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.submitButton];
    [self.scrollView setContentOffset:CGPointMake(0, 1) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect frame    = self.submitButton.frame;
    frame.origin.y  = self.view.frame.size.height - self.submitButton.frame.size.height; // scrollView.contentOffset.y +
    self.submitButton.frame = frame;
    
    [self.view bringSubviewToFront:self.submitButton];
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
            self.userPicture.layer.borderWidth   = 0.8f;
            self.userPicture.layer.borderColor   = [UIColor lightGrayColor].CGColor;
            
            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.userPicture.bounds];
//            self.userPicture.layer.masksToBounds = NO;
            self.userPicture.layer.shadowColor   = [UIColor darkGrayColor].CGColor;
            self.userPicture.layer.shadowOffset  = CGSizeMake(0.0f, 3.0f);
            self.userPicture.layer.shadowOpacity = 0.5f;
            self.userPicture.layer.shadowPath    = shadowPath.CGPath;
            
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

#pragma mark - GoogleMap details

- (void)setLocationOnMap:(id)sender {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.foodLocationCoordinate.latitude
                                                            longitude:self.foodLocationCoordinate.longitude
                                                                 zoom:15];
    [self.foodMap setCamera:camera];
    [self.foodMap setMapType:kGMSTypeNormal];
    
    GMSMarker *marker       = [[GMSMarker alloc]init];
    marker.position         = self.foodLocationCoordinate;
    marker.appearAnimation  = kGMSMarkerAnimationPop;
    marker.icon             = [UIImage imageNamed:@"Location Filled-50.png"];
    marker.map              = self.foodMap;
    
}

#pragma mark - Parse Save Item

- (void)submitPressed:(id)sender {
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
    NSString *pickUpTimeStr     = self.pickUpTime.text;
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
    PFGeoPoint *coordinatePoint = [PFGeoPoint geoPointWithLatitude:coor.latitude
                                                         longitude:coor.longitude];
    
    NSDateFormatter *dateOnlyFm = [[NSDateFormatter alloc] init];
    [dateOnlyFm setDateFormat:@"dd.MMM yy"];
    NSString *dateOnlyString    = [dateOnlyFm stringFromDate:dateInput];
    
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
    [menuItems setObject:dateOnlyString     forKey:@"offer_dateOnlyString"];
    [menuItems setObject:pickUpTimeStr      forKey:@"offer_timeOnlyString"];
    [menuItems setObject:addressFormatted   forKey:@"address_formatted"];
    [menuItems setObject:addressName        forKey:@"address_name"];
    [menuItems setObject:cityName           forKey:@"address_city"];
    [menuItems setObject:placeID            forKey:@"address_placeID"];
    [menuItems setObject:locationComments   forKey:@"address_locationComments"];
    [menuItems setObject:coordinatePoint    forKey:@"address_geoPointCoordinates"];
    [menuItems setObject:[NSNumber numberWithDouble:price] forKey:@"offer_price"];
   
    NSData *imageData = UIImagePNGRepresentation(self.coverImage.image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [menuItems setObject:imageFile forKey:@"coverImageFile"];
    
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

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
