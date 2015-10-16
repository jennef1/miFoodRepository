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

@interface OrderPreview_vc : UIViewController <GMSMapViewDelegate, NSURLConnectionDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) PFObject *objectDetail;

// creator details
@property (strong, nonatomic) IBOutlet UILabel     *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPicture;
@property (strong, nonatomic) IBOutlet UIImageView *userRatingOverall;
@property (strong, nonatomic) IBOutlet UILabel     *userAmountOfMealsAlready;
@property (strong, nonatomic) NSNumber *userRatingOverall_nr;
@property (strong, nonatomic) NSNumber *userMealsOverall_nr;
@property (strong, nonatomic) NSURL    *profilePictureURL;

// creator food details
@property (strong, nonatomic) IBOutlet UILabel     *foodPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel     *foodPriceCurrency;
@property (strong, nonatomic) IBOutlet UITextField *foodPricePlaceholderTF;
@property (strong, nonatomic) IBOutlet UILabel     *foodTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView  *foodDescription_tv;
@property (strong, nonatomic) PFObject *creatorID;
@property (strong, nonatomic) NSNumber *foodAmountAvailable;
@property (assign) int foodAmountAvailableInt;

// image scrollView
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
@property (assign) int imageCount;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewImages;
- (void)moveToNextPage;

@property (strong, nonatomic) UIImage *previewImage1;
@property (strong, nonatomic) UIImage *previewImage2;
@property (strong, nonatomic) UIImage *previewImage3;
@property (strong, nonatomic) UIImage *previewImage4;
@property (strong, nonatomic) UIImage *previewImage5;

// creator address details
@property (strong, nonatomic) IBOutlet UITextField *backgroundAddressTF;
@property (strong, nonatomic) IBOutlet UITextField *backgroundDateTF;
@property (strong, nonatomic) IBOutlet UILabel     *addressNameLabel;
@property (strong, nonatomic) IBOutlet UILabel     *addressCityLabel;
@property (strong, nonatomic) IBOutlet UILabel     *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView  *locationCommentLabel;
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
- (void)imageSrollViewConfig;

// subView to order / navigaiton
@property (assign) int orderCounter;
@property (strong, nonatomic) IBOutlet UIView       *orderMaskSubView;
@property (strong, nonatomic) IBOutlet UITextField  *quantityBackGround;
@property (strong, nonatomic) IBOutlet UILabel      *quantityCount;
@property (strong, nonatomic) IBOutlet UIButton     *quantityPlussButton;
@property (strong, nonatomic) IBOutlet UIButton     *quantityMinusButton;

- (IBAction)quantityPlusPressed:(id)sender;
- (IBAction)quantityMinusPressed:(id)sender;

// navigation & parse;
- (IBAction)orderPressed:(id)sender;
- (void)saveOrderToParse:(id)sender;
- (IBAction)backPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *orderButton;

@end
