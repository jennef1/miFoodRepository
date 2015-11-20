//
//  MapResults_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 12.11.15.
//  Copyright © 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface MapResults_vc : UIViewController <GMSMapViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>

@property (assign) int selectedIndex;

// map view
@property (strong, nonatomic) IBOutlet GMSMapView *mapFood;
@property (strong, nonatomic) CLLocationManager   *locationManager;
- (void)initiateLocationManager;
- (void)setAnnotationForQueryResults;

// PFQuery
@property (strong, nonatomic) NSArray *queryObjects;
@property (strong, nonatomic) PFGeoPoint *searchReturnGeoPoint;
@property (strong, nonatomic) NSString *dateOnlyForQuery;
- (void)queryForMap;

// scroll view
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
-(void)configureScrollViewWithSubViews:(NSUInteger )subViewCount;

- (void)menuTapped:(UITapGestureRecognizer *)gestureRecognizer;

@end
