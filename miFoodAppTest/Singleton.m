//
//  Singleton.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 25.08.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

static Singleton  *sharedSingleton = nil;

// create food
@synthesize singl_date, singl_pickupTime, singl_foodImages, singl_coverImage, singl_title, singl_description, singl_price, singl_quantity;
@synthesize singl_formattedAddressName, singl_addressName, singl_cityName, singl_placeID, singl_coordinates, singl_locationComment;

// find food
@synthesize singl_findDate, singl_findCityName, singl_findPlaceID, singl_findCoordinates, singl_findFoodID, singl_findObjectDetails;

// recipe details
@synthesize recipeDictionary;

+ (Singleton *)sharedSingleton{
    
    @synchronized(self){
        if (sharedSingleton == nil) {
            sharedSingleton = [[self alloc]init];
        }
    }
    return sharedSingleton;
}

@end
