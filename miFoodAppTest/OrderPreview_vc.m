//
//  OrderPreview_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 17.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "OrderPreview_vc.h"
#import "Singleton.h"
#import "StartScreen_vc.h"

#import <MBProgressHUD/MBProgressHUD.h>


@interface OrderPreview_vc ()

@end

@implementation OrderPreview_vc

@synthesize objectDetail, userRatingOverall_nr, userMealsOverall_nr, profilePictureURL, foodAmountAvailable, foodAmountAvailableInt, priceDouble;
@synthesize creatorID, requestorName, requestorPicURL, orderCounter, orderButton, paymentDetailStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Singleton *mySingleton   = [Singleton sharedSingleton];
    self.objectDetail        = mySingleton.singl_findObjectDetails;
    
    self.scrollView.delegate = self;
    
    self.orderCounter = 1;
    self.orderCounterLabel.text = [NSString stringWithFormat:@"%i", self.orderCounter];
    
    // design config
    [self.coverImageButtonIcon.layer setCornerRadius:20];
    [self.backgroundAddressTF.layer  setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.backgroundAddressTF.layer  setBorderWidth:0.7];
    [self.backgroundAddressTF.layer  setCornerRadius:4];

    self.orderMaskSubView.hidden = YES;
    self.finalOrderButton.layer.cornerRadius  = 3;
    self.finalOrderButton.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.finalOrderButton.layer.shadowOffset  = CGSizeMake(3, 3);
    self.finalOrderButton.layer.shadowRadius  = 5;
    self.finalOrderButton.layer.shadowOpacity = 1.0;
    
    [self requestorDetails];
    [self creatorDetails];
    [self foodRemainingDetails];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // orderButton at bottom
    CGRect btnFrame     = CGRectMake(0, (CGRectGetHeight(self.view.bounds) - 50) , self.view.frame.size.width, 50);
    UIButton *btn       = [[UIButton alloc]initWithFrame:btnFrame];
    btn.backgroundColor = [UIColor colorWithRed:(242/255.0) green:(202/255.0) blue:(41/255.0) alpha:1];
    self.orderButton    = btn;
    
    [self.orderButton setTitle: @"Order" forState: UIControlStateNormal];
    [self.orderButton addTarget:self action:@selector(showOrderMaskPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.orderButton];
    [self.scrollView setContentOffset:CGPointMake(0, 1) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect frame    = self.orderButton.frame;
    frame.origin.y  = self.view.frame.size.height - self.orderButton.frame.size.height; // scrollView.contentOffset.y +
    self.orderButton.frame = frame;
    [self.view bringSubviewToFront:self.orderButton];
}

#pragma mark - Requestor Details

- (void)requestorDetails {
    
    // Userprofile picture & name
    PFQuery *requestorQuery = [PFUser query];
    [requestorQuery whereKey:@"username" equalTo:[[PFUser currentUser]username]];
    
    // TODO: test userRatingOverall & userMealsOverall
    [requestorQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                NSLog(@"orderDetails successfully retreived");
                // get name, picture, rating
                self.requestorName       = [[object objectForKey:@"profile"] objectForKey:@"name"];
                self.requestorPicURL     = [[object objectForKey:@"profile"] objectForKey:@"pictureURL"];
                self.paymentDetailStatus = [object objectForKey:@"paymentDetailStatus"];
                NSLog(@"payment details:%@",self.paymentDetailStatus);
            }
        }
    }];
}

- (void)requestorCreditCardCheck {
    // 1. create Payment/ Bank Class
    // 2. link to PFUser by adding "created by"
    // 3. querry here for Credit Card details
    // 4. create a BOOLEAN checking if CreditCard details available
    // 5. send request to STRIPE Connect
    // 6. if successfull: allow PARSE- ORDERITEMS saveInBackground with paymentStatus = @"success"
    
}

#pragma mark - CreatorDetails

- (void)creatorDetails {
    
    self.userNameLabel.text  = self.objectDetail[@"createdBy_name"];
    self.creatorID           = self.objectDetail[@"createdBy"];
    
    // TODO: Rating & amount cooked through PFCloud Function?
    
    NSString *urlString      = self.objectDetail[@"createdBy_URLProfilePic"];
    NSURL *url               = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (connectionError == nil && data != nil) {
                                   self.userPicture.image = [UIImage imageWithData:data];
                               }
                           }];
}

- (void)foodRemainingDetails {

    self.foodTitle_tv.text       = self.objectDetail [@"offer_title"];
    self.foodDescription_tv.text = self.objectDetail [@"offer_description"];
    self.foodAmountAvailable     = self.objectDetail [@"offer_availability"];
    self.foodAmountAvailableInt  = [self.foodAmountAvailable intValue];
    NSNumber *price              = self.objectDetail [@"offer_price"];
    self.priceDouble             = [price doubleValue];
    self.foodPriceLabel.text     = [NSString stringWithFormat:@"%@", price];
    self.priceLabel.text         = [NSString stringWithFormat:@"CHF %@", price];
    
    self.addressNameLabel.text   = self.objectDetail [@"address_name"];
    self.addressCityLabel.text   = self.objectDetail [@"address_city"];
    self.locationComment.text    = self.objectDetail [@"address_locationComments"];
    
    PFFile *imageFile            = self.objectDetail[@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSData *imageData     = [imageFile getData];
            self.coverImage.image = [UIImage imageWithData:imageData];
        }
    }];
    
//    self.dateLabel.text             = self.objectDetail [@"offer_dateFullString"];
    
    PFGeoPoint *geoCoordinate   = self.objectDetail[@"address_geoPointCoordinates"];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(geoCoordinate.latitude, geoCoordinate.longitude);
    GMSCameraPosition *camera   = [GMSCameraPosition cameraWithLatitude:coor.latitude
                                                            longitude:coor.longitude
                                                                 zoom:13];
    [self.foodMap setCamera:camera];
    [self.foodMap setMapType:kGMSTypeNormal];
    
    GMSMarker *marker      = [[GMSMarker alloc]init];
    marker.position        = coor;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon            = [UIImage imageNamed:@"Location Filled-50.png"];
    marker.map             = self.foodMap;
}

#pragma mark - OrderMask

- (void)showOrderMaskPressed:(id)sender {
    
    self.orderMaskFrontView.layer.cornerRadius = 3.0;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.orderButton.backgroundColor = [UIColor lightGrayColor];
    self.orderButton.enabled         = NO;
    self.orderMaskSubView.hidden     = NO;

//    // check for credit card details
//    NSString *paymentAvailableCompareString = @"available";
//    
//    if ([self.paymentDetailStatus isEqualToString:paymentAvailableCompareString]) {
//        [self saveOrderToParse:self];
//    } else {
//        // show alert and save credit card details
//    }
}

- (IBAction)closeOrderMaskPressed:(id)sender {
    self.orderButton.backgroundColor = [UIColor colorWithRed:(242/255.0) green:(202/255.0) blue:(41/255.0) alpha:1];
    self.orderButton.enabled         = YES;
    self.orderMaskSubView.hidden     = YES;
}

#pragma mark - OrderCounter Buttons +/-

- (IBAction)quantityPlusPressed:(id)sender {
    
    if (self.orderCounter < self.foodAmountAvailableInt) {
        self.orderCounter = self.orderCounter + 1;
        self.orderCounterLabel.text = [NSString stringWithFormat:@"%i", self.orderCounter];
        
        double newPrice;
        newPrice = self.priceDouble * self.orderCounter;
        self.priceLabel.text = [NSString stringWithFormat:@"CHF %.2f", newPrice];
        
    } else {
        NSString *leftOnly = [NSString stringWithFormat:@"Only %d menus left!", self.foodAmountAvailableInt];
        NSString *leftMsg  = [NSString stringWithFormat:@"Hungry you - there are only %d left", self.foodAmountAvailableInt];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:leftOnly
                                                       message:leftMsg
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)quantityMinusPressed:(id)sender {
    
    self.orderCounter = self.orderCounter - 1;
    if (self.orderCounter < 1) {
        self.orderCounter = 1;
    }
    self.orderCounterLabel.text = [NSString stringWithFormat:@"%i", self.orderCounter];
    
    double newPrice;
    newPrice = self.priceDouble * self.orderCounter;
    self.priceLabel.text = [NSString stringWithFormat:@"CHF %.2f", newPrice];
}


#pragma mark - Parse saving

- (IBAction)finalOrderPressed:(id)sender {
    [self saveOrderToParse:self];
}

- (void)saveOrderToParse:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode           = MBProgressHUDModeIndeterminate;
    hud.labelText      = @"placing order";
    [hud show:YES];
    
    NSString *menuID        = self.objectDetail.objectId;
    NSString *orderStatus   = @"orderRequested";
    NSString *paymentStatus = @"allowed";
    
    // Parse Object
    PFObject *orderItem = [PFObject objectWithClassName:@"Orders"];
    
    [orderItem setObject:[PFUser currentUser]   forKey:@"orderedBy"];
    [orderItem setObject:self.requestorName     forKey:@"orderedBy_name"];
    [orderItem setObject:self.requestorPicURL   forKey:@"orderedBy_URLProfilePic"];
    
    [orderItem setObject:menuID                 forKey:@"menuID"];
    [orderItem setObject:self.creatorID         forKey:@"createdBy"];
    
    [orderItem setObject:[NSNumber numberWithInt:self.orderCounter] forKey:@"orderAmount"];
    [orderItem setObject:orderStatus            forKey:@"order_status"];
    [orderItem setObject:paymentStatus          forKey:@"payment_status"];
    
    // TODO: if succeeded: Say thankyou , navigate home?
    [orderItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"OrderItem data upload successful");
            hud.hidden = YES;
            
            // update availability number
            NSString *menuObjectId = self.objectDetail.objectId;
            int newAmountLeft      = (self.foodAmountAvailableInt - self.orderCounter);
            NSString *offerStatus  = [[NSString alloc]init];
            if (newAmountLeft == 0) {
                offerStatus = @"sold_out";
            } else {
                offerStatus = @"available";
            }
            
            PFQuery *updateMenuAmount = [PFQuery queryWithClassName:@"Menus"];
            [updateMenuAmount whereKey:@"objectId" equalTo:menuObjectId];
            [updateMenuAmount getFirstObjectInBackgroundWithBlock:^(PFObject *menuItem, NSError *error) {
                if (!error) {
                    
                    [menuItem setObject:[NSNumber numberWithInt:newAmountLeft]      forKey:@"offer_availability"];
                    [menuItem setObject:[NSNumber numberWithInt:self.orderCounter]  forKey:@"offer_currentOrder"];
                    [menuItem setObject:offerStatus                                 forKey:@"offer_status"];
                    [menuItem saveInBackground];
                } else {
                    // Did not find any objectItem
                    NSLog(@"Error: %@", error);
                }
            }];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank you"
                                                                message:@"Your have successfully placed the order. A confirmation request will be send to the cook. Enjoy your meal!"
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    // TODO: send notificaiton to cook
    
    // TODO: add User "status" so we know he still needs to provide rating?
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        StartScreen_vc *start_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartScreen_ID"];
        [self.navigationController pushViewController:start_vc animated:NO];
    }
}

#pragma mark - Navigaiton

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)contactUserPressed:(id)sender {
    
}

@end
