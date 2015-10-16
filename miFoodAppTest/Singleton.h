//
//  Singleton.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 25.08.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface Singleton : NSObject {
    
    // create food
    NSDate          *singl_date;
    NSMutableArray  *singl_foodImages;
    NSString        *singl_title;
    NSString        *singl_description;
    double          singl_price;
    int             singl_quantity;
    
    NSString                *singl_formattedAddressName;
    NSString                *singl_addressName;
    NSString                *singl_cityName;
    NSString                *singl_placeID;
    CLLocationCoordinate2D  singl_coordinates;
    NSString                *singl_locationComment;
    
    // find food
    NSDate     *singl_findDate;
    NSString   *singl_findCityName;
    NSString   *singl_findPlaceID;
    PFGeoPoint *singl_findCoordinates;
    NSString   *singl_findFoodID;
    PFObject   *singl_findObjectDetails;
}

// create food
@property (nonatomic, strong) NSDate         *singl_date;
@property (nonatomic, strong) NSMutableArray *singl_foodImages;
@property (nonatomic, strong) NSString       *singl_title;
@property (nonatomic, strong) NSString       *singl_description;
@property (assign) double singl_price;
@property (assign) int    singl_quantity;

@property (nonatomic, strong) NSString       *singl_formattedAddressName;
@property (nonatomic, strong) NSString       *singl_addressName;
@property (nonatomic, strong) NSString       *singl_cityName;
@property (nonatomic, strong) NSString       *singl_placeID;
@property (nonatomic) CLLocationCoordinate2D singl_coordinates;
@property (nonatomic, strong) NSString       *singl_locationComment;

// find food
@property (nonatomic, strong) NSDate     *singl_findDate;
@property (nonatomic, strong) NSString   *singl_findCityName;
@property (nonatomic, strong) NSString   *singl_findPlaceID;
@property (nonatomic, strong) PFGeoPoint *singl_findCoordinates;
@property (nonatomic, strong) NSString   *singl_findFoodID;
@property (nonatomic, strong) PFObject   *singl_findObjectDetails;

+ (Singleton *)sharedSingleton;

@end
