//
//  MapView_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 04.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapView_vc : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate> // MKMapViewDelegate

// map items

@property (strong, nonatomic) IBOutlet GMSMapView *mapFood;
@property (nonatomic, strong) CLLocationManager   *locationManager;
- (void)setMapButtonsWithCoordinates:(GMSCameraPosition *)cameraPosition;
- (void)initiateLocationManager;

// search items
@property (strong, nonatomic) IBOutlet UITextField *emptyTF;
@property (strong, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic) CLLocationCoordinate2D searchReturn_Coordinates;
@property (strong, nonatomic) NSString       *searchReturn_shortAddress;
@property (strong, nonatomic) NSString       *searchReturn_CityName;
@property (strong, nonatomic) NSString       *searchReturn_PlaceID;
@property (strong, nonatomic) NSString       *searchReturn_FormatAddress;

@property (nonatomic) CLLocationCoordinate2D currentCoordinates;
@property (strong, nonatomic) NSString       *current_shortAddress;
@property (strong, nonatomic) NSString       *current_CityName;
@property (strong, nonatomic) NSString       *current_PlaceID;
@property (strong, nonatomic) NSString       *current_FormatAddress;

// mapView button
@property (strong, nonatomic) IBOutlet UIButton     *locationButton;
@property (strong, nonatomic) IBOutlet UIView       *locButHubView;
@property (strong, nonatomic) IBOutlet UILabel      *locButAddressTitle;
@property (strong, nonatomic) IBOutlet UILabel      *locButAddressSubTitle;
@property (strong, nonatomic) UIImageView *hudImageViewTick;

// saving items
@property (strong, nonatomic) NSString *addressCity;
@property (strong, nonatomic) NSString *addressFormated;
@property (nonatomic) CLLocationCoordinate2D addressCoordinates;

// navigation
- (IBAction)currentLocationPressed:(id)sender;
- (IBAction)addressConfirmPressed:(id)sender;
- (IBAction)backPressed:(id)sender;

@end
