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
    NSString        *singl_title;
    NSString        *singl_description;
    NSMutableArray  *singl_foodImages;
    UIImage         *singl_coverImage;
    NSDate          *singl_date;
    double          singl_pickupTime;
    double          singl_price;
    int             singl_quantity;
    
    NSString  *singl_formattedAddressName;
    NSString  *singl_addressName;
    NSString  *singl_cityName;
    NSString  *singl_placeID;
    NSString  *singl_locationComment;
    CLLocationCoordinate2D singl_coordinates;
    
    // find food
    NSDate     *singl_findDate;
    NSString   *singl_findCityName;
    NSString   *singl_findPlaceID;
    PFGeoPoint *singl_findCoordinates;
    NSString   *singl_findFoodID;
    PFObject   *singl_findObjectDetails;
    NSArray    *singl_queryResultObjects;
    
    // recipe details
    NSMutableArray *recipeDictionary;
}

// create food
@property (nonatomic, strong) NSString       *singl_title;
@property (nonatomic, strong) NSString       *singl_description;
@property (nonatomic, strong) NSMutableArray *singl_foodImages;
@property (nonatomic, strong) UIImage        *singl_coverImage;
@property (nonatomic, strong) NSDate         *singl_date;
@property (assign) double singl_pickupTime;
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
@property (nonatomic, strong) NSArray    *singl_queryResultObjects;

// recipe details
@property (nonatomic, strong) NSMutableArray *recipeDictionary;

+ (Singleton *)sharedSingleton;

@end
