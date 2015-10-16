//
//  Preview_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 09.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Preview_vc : UIViewController <GMSMapViewDelegate, NSURLConnectionDelegate>

// user details
@property (strong, nonatomic) IBOutlet UILabel     *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPicture;
@property (strong, nonatomic) IBOutlet UIImageView *userRatingOverall_imv;
@property (strong, nonatomic) IBOutlet UILabel     *userMealsOverall_label;
@property (strong, nonatomic) NSNumber *userRatingOverall_nr;
@property (strong, nonatomic) NSNumber *userMealsOverall_nr;
@property (strong, nonatomic) NSString *bankDetailsStatus;

// menu details
@property (strong, nonatomic) IBOutlet UILabel     *foodPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel     *foodTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView  *foodDescription_tv;

@property (strong, nonatomic) IBOutlet UITextField *backgroundAddressTF;
@property (strong, nonatomic) IBOutlet UITextField *backgroundDateTF;
@property (strong, nonatomic) IBOutlet UILabel     *addressNameLabel;
@property (strong, nonatomic) IBOutlet UILabel     *addressCityLabel;
@property (strong, nonatomic) IBOutlet UILabel     *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView  *locationCommentLabel;
@property (nonatomic) CLLocationCoordinate2D       foodLocationCoordinate;

// image details
@property (copy, nonatomic) NSMutableArray *chosenImages;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage1;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage2;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage3;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage4;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage5;
- (void)configureImages:(id)sender;

// google map
@property (strong, nonatomic) IBOutlet GMSMapView *foodMap;
- (void)setLocationOnMap:(id)sender;

// navigation
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (void)saveItemToParse:(id)sender;

// get user details
@property (strong, nonatomic) NSURL *profilePictureURL;
- (void)getUserDetails:(id)sender;
- (void)requestFBpictureViaURL:(id)sender;

@end
