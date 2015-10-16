//
//  MapView_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 04.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "MapView_vc.h"
#import "Singleton.h"
#import "AddressSearch_vc.h"
#import "ImageAddress_overview.h"

#import <AddressBook/AddressBook.h>

@interface MapView_vc ()

@end

@implementation MapView_vc

@synthesize currentCoordinates, searchReturn_CityName, searchReturn_PlaceID, searchReturn_FormatAddress, searchReturn_Coordinates;
@synthesize locationManager, addressCity, addressFormated, addressCoordinates;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapFood.delegate         = self;
    self.searchTF.delegate        = self;
    self.locationManager.delegate = self;
    
    // design configurations
    [self.emptyTF       setLeftViewMode:UITextFieldViewModeAlways];
    [self.emptyTF.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.emptyTF.layer setBorderWidth:0.6];
    [self.emptyTF.layer setCornerRadius:4];
    [self.emptyTF       setClipsToBounds:YES];
    
    //    [self.locationNoBUTTONyetTF.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    //    [self.locationNoBUTTONyetTF.layer setBorderWidth:0.6];
    //    [self.locationNoBUTTONyetTF.layer setCornerRadius:4];

    [self.locationButton.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.locationButton.layer setBorderWidth:0.9];
    [self.locationButton.layer setCornerRadius:5];
    
    [self initiateLocationManager];
    
    // TODO: if we can get USER REGION - set region
    // + Starting location london in Singleton.h
    MKCoordinateRegion initialRegion;
    CLLocationCoordinate2D startingPoint;
    startingPoint.latitude  = 51.520380;
    startingPoint.longitude = -0.156891;
    
    if (!((self.searchReturn_Coordinates.latitude == 0) && (self.searchReturn_Coordinates.longitude == 0))) {
        initialRegion.center.latitude  = self.searchReturn_Coordinates.latitude;
        initialRegion.center.longitude = self.searchReturn_Coordinates.longitude;
    } else {
        initialRegion.center.latitude  = startingPoint.latitude;
        initialRegion.center.longitude = startingPoint.longitude;
    }
    self.currentCoordinates = initialRegion.center;

    GMSCameraPosition *initialCam = [GMSCameraPosition
                                     cameraWithLatitude:self.currentCoordinates.latitude
                                              longitude:self.currentCoordinates.longitude
                                                   zoom:12];
    
    [self setMapButtonsWithCoordinates:initialCam];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - LocationManager Delegate

- (void)initiateLocationManager {
    self.locationManager = [[CLLocationManager alloc]init];
    
    // Check for iOS 8 so it won't crash with on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    // TODO: what if location service NOT enabled?
    // Enable Servicelocation
    if([CLLocationManager locationServicesEnabled]){
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ){
            NSLog(@"location services enabled but restricted!");
        }
        else{
            [self.locationManager startUpdatingLocation];
            NSLog(@"location services enabled, good!");
        }
    }
}

#pragma mark - GMSMapView Delegates

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    [self setMapButtonsWithCoordinates:position];
}

- (void)setMapButtonsWithCoordinates:(GMSCameraPosition *)cameraPosition {
    
    [self.mapFood setCamera:cameraPosition];
    [self.mapFood setMapType:kGMSTypeNormal];
    
    id handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error == nil) {
            GMSReverseGeocodeResult *result = response.firstResult;
            self.current_shortAddress       = result.lines[0];
            self.current_FormatAddress      = result.lines[1];
            self.current_CityName           = result.locality;
            
            if (self.current_shortAddress.length == 0) {
                self.locButAddressTitle.text = result.thoroughfare;
            } else {
                self.locButAddressTitle.text = self.current_shortAddress;
            }
            self.locButAddressSubTitle.text = self.current_CityName;
            
        }
    };
    
    GMSGeocoder *geocoder       = [[GMSGeocoder alloc]init];
    [geocoder reverseGeocodeCoordinate:cameraPosition.target completionHandler:handler];
    
    // TODO: get PlaceID in case not going through SearchBar...
    // TODO: check as locButAddressTitle does not showresult when ViewDidLoad
}

#pragma mark - Navigation

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    AddressSearch_vc *msearchvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddressSearch_ID"];
    [msearchvc setCommingFromSegue:@"MapView_vc.h"];
    [self.navigationController pushViewController:msearchvc animated:NO];
    return NO;
}

- (IBAction)currentLocationPressed:(id)sender {
}

- (IBAction)addressConfirmPressed:(id)sender {
    
    // Store variables globally
    Singleton *mySingleton                  = [Singleton sharedSingleton];
    mySingleton.singl_formattedAddressName  = self.current_FormatAddress;
    mySingleton.singl_addressName           = self.locButAddressTitle.text;
    mySingleton.singl_cityName              = self.locButAddressSubTitle.text;
    mySingleton.singl_coordinates           = self.currentCoordinates;
    
    if (self.searchReturn_PlaceID.length == 0) {
        mySingleton.singl_placeID = @"empty";
    } else {
        mySingleton.singl_placeID = self.searchReturn_PlaceID;
    }
    
    ImageAddress_overview *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageAddress_ID"];
    [self.navigationController pushViewController:vc animated:NO];
    
}

- (IBAction)backPressed:(id)sender {
    ImageAddress_overview *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageAddress_ID"];
    [self.navigationController pushViewController:vc animated:NO];
}


@end
