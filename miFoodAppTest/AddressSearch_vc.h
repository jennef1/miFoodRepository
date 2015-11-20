//
//  AddressSearch_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 31.08.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AddressSearch_vc : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

// tableview & spinner
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, readonly) UIActivityIndicatorView *spinner;
@property (weak, readonly) UIActivityIndicatorView *currentLocationActivityIndicatorView;
- (void)createFooterViewForTableView;

// searchField / events
@property (strong, nonatomic) IBOutlet UITextField *searchBox;
@property (strong, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UITextField *currentLocTF;
- (void)textChanged:(UITextField *)textField;

// search result
@property (strong, nonatomic) NSMutableArray *searchResultMainInfo;
@property (strong, nonatomic) NSMutableArray *searchResultSubInfo;
@property (strong, nonatomic) NSMutableArray *searchResultLocationArray;
@property (strong, nonatomic) NSMutableArray *searchResultPlaceID;
@property (nonatomic) CLLocationCoordinate2D selectedSearchCoordinate;
@property (nonatomic) CLLocationCoordinate2D currentRegion;

@property (nonatomic, strong) NSString *streetname;
@property (nonatomic, strong) NSString *route;
@property (nonatomic, strong) NSString *subLocality;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *subAdministrativeArea;
@property (nonatomic, strong) NSString *administrativeArea;
@property (nonatomic, strong) NSString *administrativeAreaCode;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *ISOcountryCode;

// google map api
@property (strong, nonatomic) GMSPlacesClient *placesClient;

// navigation
@property (strong, nonatomic) NSString *commingFromSegue;
- (IBAction)currentLocationPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end
