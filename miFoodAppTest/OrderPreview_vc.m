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

@interface OrderPreview_vc ()

@end

@implementation OrderPreview_vc

// meal items
@synthesize objectDetail, userRatingOverall_nr, userMealsOverall_nr, profilePictureURL, foodAmountAvailable, foodAmountAvailableInt;

// meal images
@synthesize imageCount, previewImage1, previewImage2, previewImage3, previewImage4, previewImage5;

// order details
@synthesize creatorID, requestorName, requestorPicURL, orderCounter, paymentDetailStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // design configurations
//    CALayer *layer = [self.previewImage1 layer];
//    [layer setMasksToBounds:YES];
//    [layer setCornerRadius:5.0];
    
    [self.backgroundAddressTF.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.backgroundAddressTF.layer setBorderWidth:0.7];
    [self.backgroundDateTF.layer    setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.backgroundDateTF.layer    setBorderWidth:0.7];
    
    [self.quantityBackGround.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.quantityBackGround.layer setBorderWidth:1.0];
    [self.quantityBackGround.layer setCornerRadius:4];
    [self.quantityBackGround setClipsToBounds:YES];
    
    UIColor *textColor   = [UIColor colorWithRed:(87/255.0) green:(199/255.0) blue:(167/255.0) alpha:1];
    self.quantityCount.textColor                  = textColor;
    self.quantityPlussButton.titleLabel.textColor = textColor;
    self.quantityMinusButton.titleLabel.textColor = textColor;
    
    self.orderCounter       = 1;
    self.quantityCount.text = [NSString stringWithFormat:@"%i", self.orderCounter];
    
    // main thread activities
    Singleton *mySingleton = [Singleton sharedSingleton];
    self.objectDetail      = mySingleton.singl_findObjectDetails;
    
    [self requestorDetails];
    [self creatorDetails];
    [self foodRemainingDetails];
    [self imageSrollViewConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
                self.requestorName    = [[object objectForKey:@"profile"] objectForKey:@"name"];
                self.requestorPicURL  = [[object objectForKey:@"profile"] objectForKey:@"pictureURL"];
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
    
    // amount cooked already
    
    NSString *urlString      = self.objectDetail[@"createdBy_URLProfilePic"];
    NSURL *url               = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil && data != nil) {
                                   NSLog(@"finished asynch request");
                                   self.userPicture.image = [UIImage imageWithData:data];
                               }
                           }];
    
    // star rating
}

- (void)foodRemainingDetails {

    self.foodTitleLabel.text        = self.objectDetail [@"offer_title"];
    self.foodDescription_tv.text    = self.objectDetail [@"offer_description"];
    NSNumber *price                 = self.objectDetail [@"offer_price"];
    self.foodPriceLabel.text        = [NSString stringWithFormat:@"%@", price];
    self.dateLabel.text             = self.objectDetail [@"offer_dateFullString"];
    self.addressNameLabel.text      = self.objectDetail [@"address_name"];
    self.addressCityLabel.text      = self.objectDetail [@"address_city"];
    self.locationCommentLabel.text  = self.objectDetail [@"address_locationComments"];
    self.foodAmountAvailable        = self.objectDetail [@"offer_availability"];
    NSNumber *imageCountNum         = self.objectDetail [@"imageCount"];
    self.imageCount                 = [imageCountNum intValue];
    self.foodAmountAvailableInt     = [self.foodAmountAvailable intValue];
    
    PFGeoPoint *geoCoordinate   = self.objectDetail[@"address_geoPointCoordinates"];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(geoCoordinate.latitude, geoCoordinate.longitude);
    GMSCameraPosition *camera   = [GMSCameraPosition cameraWithLatitude:coor.latitude
                                                            longitude:coor.longitude
                                                                 zoom:13];
    [self.foodMap setCamera:camera];
    [self.foodMap setMapType:kGMSTypeNormal];
    
    GMSMarker *marker       = [[GMSMarker alloc]init];
    marker.position         = coor;
    marker.appearAnimation  = kGMSMarkerAnimationPop;
    marker.icon             = [UIImage imageNamed:@"Location Filled-50.png"];
    marker.map              = self.foodMap;
}

#pragma mark - ImageScrollView

- (void)imageSrollViewConfig {
    
    self.scrollViewImages.frame  = CGRectMake(0, 0, self.view.frame.size.width, 200);
    CGRect frame                 = self.scrollViewImages.frame;
    
    if (self.imageCount == 5) {
        CGRect frame0 = CGRectMake(0, 0, frame.size.width, frame.size.height);
        CGRect frame1 = CGRectMake(1*frame.size.width, 0, frame.size.width, frame.size.height);
        CGRect frame2 = CGRectMake(2*frame.size.width, 0, frame.size.width, frame.size.height);
        CGRect frame3 = CGRectMake(3*frame.size.width, 0, frame.size.width, frame.size.height);
        CGRect frame4 = CGRectMake(4*frame.size.width, 0, frame.size.width, frame.size.height);
        
        UIImageView *imV0 = [[UIImageView alloc]initWithFrame:frame0];
        UIImageView *imV1 = [[UIImageView alloc]initWithFrame:frame1];
        UIImageView *imV2 = [[UIImageView alloc]initWithFrame:frame2];
        UIImageView *imV3 = [[UIImageView alloc]initWithFrame:frame3];
        UIImageView *imV4 = [[UIImageView alloc]initWithFrame:frame4];
    
        PFFile *imageFile0  = self.objectDetail[@"imageFile0"];
        PFFile *imageFile1  = self.objectDetail[@"imageFile1"];
        PFFile *imageFile2  = self.objectDetail[@"imageFile2"];
        PFFile *imageFile3  = self.objectDetail[@"imageFile3"];
        PFFile *imageFile4  = self.objectDetail[@"imageFile4"];
        
        [imageFile0 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData0 = [imageFile0 getData];
                imV0.image = [UIImage imageWithData:imageData0];
            }
        }];
        [imageFile1 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData1 = [imageFile1 getData];
                imV1.image = [UIImage imageWithData:imageData1];
            }
        }];
        [imageFile2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData2 = [imageFile2 getData];
                imV2.image = [UIImage imageWithData:imageData2];
            }
        }];
        [imageFile3 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData3 = [imageFile0 getData];
                imV3.image = [UIImage imageWithData:imageData3];
            }
        }];
        [imageFile4 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData4 = [imageFile4 getData];
                imV4.image = [UIImage imageWithData:imageData4];
            }
        }];
        [self.scrollViewImages addSubview:imV0];
        [self.scrollViewImages addSubview:imV1];
        [self.scrollViewImages addSubview:imV2];
        [self.scrollViewImages addSubview:imV3];
        [self.scrollViewImages addSubview:imV4];
        
    } else if (self.imageCount == 4) {
        CGRect frame0 = CGRectMake(0, 0, frame.size.width, frame.size.height);
        CGRect frame1 = CGRectMake(1*frame.size.width, 0, frame.size.width, frame.size.height);
        CGRect frame2 = CGRectMake(2*frame.size.width, 0, frame.size.width, frame.size.height);
        CGRect frame3 = CGRectMake(3*frame.size.width, 0, frame.size.width, frame.size.height);
        
        UIImageView *imV0 = [[UIImageView alloc]initWithFrame:frame0];
        UIImageView *imV1 = [[UIImageView alloc]initWithFrame:frame1];
        UIImageView *imV2 = [[UIImageView alloc]initWithFrame:frame2];
        UIImageView *imV3 = [[UIImageView alloc]initWithFrame:frame3];
        
        PFFile *imageFile0  = self.objectDetail[@"imageFile0"];
        PFFile *imageFile1  = self.objectDetail[@"imageFile1"];
        PFFile *imageFile2  = self.objectDetail[@"imageFile2"];
        PFFile *imageFile3  = self.objectDetail[@"imageFile3"];
        
        [imageFile0 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData0 = [imageFile0 getData];
                imV0.image = [UIImage imageWithData:imageData0];
            }
        }];
        [imageFile1 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData1 = [imageFile1 getData];
                imV1.image = [UIImage imageWithData:imageData1];
            }
        }];
        [imageFile2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData2 = [imageFile2 getData];
                imV2.image = [UIImage imageWithData:imageData2];
            }
        }];
        [imageFile3 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData3 = [imageFile0 getData];
                imV3.image = [UIImage imageWithData:imageData3];
            }
        }];
        [self.scrollViewImages addSubview:imV0];
        [self.scrollViewImages addSubview:imV1];
        [self.scrollViewImages addSubview:imV2];
        [self.scrollViewImages addSubview:imV3];
        
    } else if (self.imageCount == 3) {
        CGRect frame0 = CGRectMake(0, 0, frame.size.width, frame.size.height);
        CGRect frame1 = CGRectMake(1*frame.size.width, 0, frame.size.width, frame.size.height);
        CGRect frame2 = CGRectMake(2*frame.size.width, 0, frame.size.width, frame.size.height);
        
        UIImageView *imV0 = [[UIImageView alloc]initWithFrame:frame0];
        UIImageView *imV1 = [[UIImageView alloc]initWithFrame:frame1];
        UIImageView *imV2 = [[UIImageView alloc]initWithFrame:frame2];
        
        PFFile *imageFile0  = self.objectDetail[@"imageFile0"];
        PFFile *imageFile1  = self.objectDetail[@"imageFile1"];
        PFFile *imageFile2  = self.objectDetail[@"imageFile2"];
        
        [imageFile0 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData0 = [imageFile0 getData];
                imV0.image = [UIImage imageWithData:imageData0];
            }
        }];
        [imageFile1 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData1 = [imageFile1 getData];
                imV1.image = [UIImage imageWithData:imageData1];
            }
        }];
        [imageFile2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData2 = [imageFile2 getData];
                imV2.image = [UIImage imageWithData:imageData2];
            }
        }];
        [self.scrollViewImages addSubview:imV0];
        [self.scrollViewImages addSubview:imV1];
        [self.scrollViewImages addSubview:imV2];
        
    } else if (self.imageCount == 2) {
        CGRect frame0 = CGRectMake(0, 0, frame.size.width, frame.size.height);
        CGRect frame1 = CGRectMake(1*frame.size.width, 0, frame.size.width, frame.size.height);
        
        UIImageView *imV0 = [[UIImageView alloc]initWithFrame:frame0];
        UIImageView *imV1 = [[UIImageView alloc]initWithFrame:frame1];
        
        PFFile *imageFile0  = self.objectDetail[@"imageFile0"];
        PFFile *imageFile1  = self.objectDetail[@"imageFile1"];
        
        [imageFile0 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData0 = [imageFile0 getData];
                imV0.image = [UIImage imageWithData:imageData0];
            }
        }];
        [imageFile1 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData1 = [imageFile1 getData];
                imV1.image = [UIImage imageWithData:imageData1];
            }
        }];
        [self.scrollViewImages addSubview:imV0];
        [self.scrollViewImages addSubview:imV1];
        
    } else if (self.imageCount == 1) {
        CGRect frame0       = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIImageView *imV0   = [[UIImageView alloc]initWithFrame:frame0];
        PFFile *imageFile0  = self.objectDetail[@"imageFile0"];
        
        [imageFile0 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData0 = [imageFile0 getData];
                imV0.image = [UIImage imageWithData:imageData0];
            }
        }];
        [self.scrollViewImages addSubview:imV0];
    }

    self.scrollViewImages.contentSize = CGSizeMake(frame.size.width*self.imageCount, frame.size.height);
    self.scrollViewImages.delegate    = self;
    
    self.pageController.numberOfPages = imageCount;
    self.pageController.currentPage   = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(moveToNextPage)
                                   userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // Test the offset and calculate the current page after scrolling ends
    CGFloat pageWidth   = CGRectGetWidth(scrollView.frame);
    CGFloat currentPage = floor((scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    
    // Change the indicator
    self.pageController.currentPage = (int)currentPage;
}

- (void)moveToNextPage {
    
    CGFloat pageWidth     = CGRectGetWidth(self.scrollViewImages.frame);
    CGFloat pageHeight    = CGRectGetHeight(self.scrollViewImages.frame);
    CGFloat maxWidth      = pageWidth * imageCount;
    CGFloat contentOffset = self.scrollViewImages.contentOffset.x;
    
    float slideToX = contentOffset + pageWidth;
    
    if  ((contentOffset + pageWidth) == maxWidth) {
        slideToX = 0;
        self.pageController.currentPage = 0;
    }
    CGRect visibleFrame = CGRectMake(slideToX, 0, pageWidth, pageHeight);
    [self.scrollViewImages scrollRectToVisible:visibleFrame animated:YES];
    
    // TODO: currentPage not = 0 if from last back to first item...
    CGFloat currentPage = floor((self.scrollViewImages.contentOffset.x - pageWidth/2) / pageWidth) + 2;
    self.pageController.currentPage = (int)currentPage;
}

#pragma mark - Parse OrderSubmission

- (IBAction)orderPressed:(id)sender {
    
    [self saveOrderToParse:self];
//    // check for credit card details
//    NSString *paymentAvailableCompareString = @"available";
//    
//    if ([self.paymentDetailStatus isEqualToString:paymentAvailableCompareString]) {
//        [self saveOrderToParse:self];
//    } else {
//        // show alert and save credit card details
//    }
}

- (void)saveOrderToParse:(id)sender {
    
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
            StartScreen_vc *start_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartScreen_ID"];
            [self.navigationController pushViewController:start_vc animated:NO];
            
            // say thank you and return to home!
        }
    }];
    
    // update availability number of menuItem
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
}

#pragma mark - OrderCounter Buttons +/-

- (IBAction)quantityPlusPressed:(id)sender {
    
    if (self.orderCounter < self.foodAmountAvailableInt) {
        self.orderCounter = self.orderCounter + 1;
        self.quantityCount.text = [NSString stringWithFormat:@"%i", self.orderCounter];
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
    if (self.orderCounter < 0) {
        self.orderCounter = 0;
    }
    self.quantityCount.text = [NSString stringWithFormat:@"%i", self.orderCounter];
}


#pragma mark - Navigaiton

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
