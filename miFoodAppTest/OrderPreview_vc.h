//
//  OrderPreview_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 17.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface OrderPreview_vc : UIViewController <GMSMapViewDelegate, NSURLConnectionDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) PFObject *objectDetail;

// creator details
@property (strong, nonatomic) PFObject *creatorID;
@property (strong, nonatomic) IBOutlet UILabel     *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPicture;
@property (strong, nonatomic) IBOutlet UIImageView *userRatingOverall;
@property (strong, nonatomic) IBOutlet UILabel     *userAmountOfMealsAlready;
@property (strong, nonatomic) NSNumber *userRatingOverall_nr;
@property (strong, nonatomic) NSNumber *userMealsOverall_nr;
@property (strong, nonatomic) NSURL    *profilePictureURL;

// food details
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UITextField *coverImageButtonIcon;
@property (strong, nonatomic) IBOutlet UITextView  *foodTitle_tv;
@property (strong, nonatomic) IBOutlet UITextView  *foodDescription_tv;
@property (strong, nonatomic) IBOutlet UILabel     *foodPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel     *foodPriceCurrency;
@property (strong, nonatomic) IBOutlet UITextField *foodPricePlaceholderTF;
@property (strong, nonatomic) NSNumber *foodAmountAvailable;
@property (assign) int foodAmountAvailableInt;
@property (assign) double priceDouble;

// food address
@property (strong, nonatomic) IBOutlet UITextField *backgroundAddressTF;
@property (strong, nonatomic) IBOutlet UILabel     *addressNameLabel;
@property (strong, nonatomic) IBOutlet UILabel     *addressCityLabel;
@property (strong, nonatomic) IBOutlet UITextView  *locationComment;
@property (strong, nonatomic) IBOutlet GMSMapView  *foodMap;

// requestor details
@property (strong, nonatomic) NSString *requestorName;
@property (strong, nonatomic) NSString *requestorPicURL;
@property (strong, nonatomic) NSString *paymentDetailStatus;

// main thread actions
- (void)requestorDetails;
- (void)requestorCreditCardCheck;
- (void)creatorDetails;
- (void)foodRemainingDetails;

// subView to order / navigaiton
@property (assign) int orderCounter;
@property (strong, nonatomic) IBOutlet UIView   *orderMaskSubView;
@property (strong, nonatomic) IBOutlet UIView *orderMaskFrontView;
@property (strong, nonatomic) IBOutlet UILabel  *orderCounterLabel;
@property (strong, nonatomic) IBOutlet UILabel  *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *finalOrderButton;
@property (strong, nonatomic) UIButton *orderButton;
- (IBAction)quantityPlusPressed:(id)sender;
- (IBAction)quantityMinusPressed:(id)sender;
- (IBAction)finalOrderPressed:(id)sender;
- (IBAction)closeOrderMaskPressed:(id)sender;
- (void)showOrderMaskPressed:(id)sender;
- (void)saveOrderToParse:(id)sender;

// navigation
- (IBAction)contactUserPressed:(id)sender;
- (IBAction)backPressed:(id)sender;


@end
