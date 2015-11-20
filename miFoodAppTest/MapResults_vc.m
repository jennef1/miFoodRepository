//
//  MapResults_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 12.11.15.
//  Copyright © 2015 Fabian Jenne. All rights reserved.
//

#import "MapResults_vc.h"
#import "Singleton.h"
#import "Login_vc.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface MapResults_vc ()

@end

@implementation MapResults_vc

@synthesize searchReturnGeoPoint, dateOnlyForQuery, queryObjects, selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapFood.delegate         = self;
    self.scrollView.delegate      = self;
    self.locationManager.delegate = self;
    
    // TODO: do we want them to scroll? (would need to find out zIndex and select corresponding marker...)
    self.scrollView.scrollEnabled = NO;
    self.scrollView.userInteractionEnabled = YES;
    self.selectedIndex = 0;
    
    Singleton *mySingleton    = [Singleton sharedSingleton];
    self.searchReturnGeoPoint = mySingleton.singl_findCoordinates;
    self.queryObjects         = mySingleton.singl_queryResultObjects;
    
    if (self.queryObjects.count == 0) {
        [self queryForMap];
    }
    
    [self initiateLocationManager];

    GMSCameraPosition *initialCam = [GMSCameraPosition
                                     cameraWithLatitude:self.searchReturnGeoPoint.latitude
                                     longitude:self.searchReturnGeoPoint.longitude
                                     zoom:10];
    
    [self.mapFood setCamera:initialCam];
    [self.mapFood setMapType:kGMSTypeNormal];
    [self setAnnotationForQueryResults];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self configureScrollViewWithSubViews:self.queryObjects.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - LocationManager Delegate

- (void)initiateLocationManager {
    
    // TODO: add a nice first view telling about theim to accelpt location manager because...
    
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
    self.mapFood.myLocationEnabled = YES;
}

#pragma mark - Map settings

- (void)setAnnotationForQueryResults {
    
    int indexCount = 300;
    for (PFObject *object in self.queryObjects) {
        PFGeoPoint *menuGeoPoint = object[@"address_geoPointCoordinates"];
        CLLocation *menuLocation = [[CLLocation alloc]initWithLatitude:menuGeoPoint.latitude longitude:menuGeoPoint.longitude];
        CLLocationCoordinate2D menuCoord = menuLocation.coordinate;
        
        GMSMarker *marker = [[GMSMarker alloc]init];
        marker.position   = menuCoord;
        marker.zIndex     = indexCount;
        marker.appearAnimation = kGMSMarkerAnimationPop;
//        marker.icon = [UIImage imageNamed:@"CookHead"];
        marker.map  = self.mapFood;
        indexCount  = indexCount +1;
    }
}

// TODO: start new query when map moved (map idle at position... i guess) and different self.searchResultPosition - marker.position > 5km (or half of mapscreen size)

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    [self.mapFood animateToLocation:marker.position];
    
    int positionCount  = (marker.zIndex - 300);
    self.selectedIndex = positionCount;
    
    [self.scrollView setContentOffset: CGPointMake((positionCount * self.view.frame.size.width), 0) animated:YES];
    // TODO: make sure marker is colored
    return YES;
}

#pragma mark - ScrollView

-(void)configureScrollViewWithSubViews:(NSUInteger )subViewCount {
    
    // TODO: check how to create a class for View with all the labels....
    // TODO: load images in seperate thread and store them into an array with the right order!
    // TODO: ...or dont load INBACKGROUND but just "getData" and wait... (or always get 3 at a time)
    // TODO: check FONT naming & change price image
    
    int height_sv               = 128;
    float width_sv              = self.view.frame.size.width;
    
    self.scrollView.frame       = CGRectMake(0, 0, width_sv, height_sv);
    CGRect scvFrame             = self.scrollView.frame;
    int contentWidth            = subViewCount * scvFrame.size.width;
    self.scrollView.contentSize = CGSizeMake(contentWidth, scvFrame.size.height);
    self.scrollView.userInteractionEnabled = YES;
    
    int positionIndex = 0;
    for (PFObject *object in self.queryObjects) {
        
        UIView *menuView       = [[UIView alloc]initWithFrame:CGRectMake((positionIndex * width_sv), 0, width_sv, height_sv)];
        UIImageView *imgV      = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, (height_sv - 12), (height_sv - 12))];
        UITextView  *title_tv  = [[UITextView alloc]initWithFrame:CGRectMake((height_sv+2), 4, (width_sv - height_sv -4), 48)];
        menuView.userInteractionEnabled = YES;
        title_tv.userInteractionEnabled = NO;

        UIImageView *time_imV  = [[UIImageView alloc]initWithFrame:CGRectMake((height_sv+7), (52+10), 16, 16)];
        UIImageView *addrs_imv = [[UIImageView alloc]initWithFrame:CGRectMake((height_sv+5), (78+14), 20, 18)];
        UIImageView *price_imv = [[UIImageView alloc]initWithFrame:CGRectMake(230, (52+10), 16, 16)];
        UILabel *time_label    = [[UILabel alloc]initWithFrame:CGRectMake((height_sv+31), (52+10), 40, 16)];
        UILabel *addrs_label   = [[UILabel alloc]initWithFrame:CGRectMake((height_sv+31), (78+14), (width_sv-height_sv-17), 16)];
        UILabel *price_label   = [[UILabel alloc]initWithFrame:CGRectMake(255, (52+10), 70, 16)];
        
        title_tv.font    = [UIFont fontWithName:@"Gill Sans" size:15.0f];
        time_label.font  = [UIFont fontWithName:@"Gill Sans" size:11.0f];
        addrs_label.font = [UIFont fontWithName:@"Gill Sans" size:11.0f];
        price_label.font = [UIFont fontWithName:@"Gill Sans" size:11.0f];
        
        title_tv.textColor    = [UIColor darkGrayColor];
        time_label.textColor  = [UIColor colorWithRed:(145/255.0) green:(165/255.0) blue:(167/255.0) alpha:1];
        addrs_label.textColor = [UIColor colorWithRed:(145/255.0) green:(165/255.0) blue:(167/255.0) alpha:1];
        price_label.textColor = [UIColor colorWithRed:(225/255.0) green:(125/255.0) blue:(36/255.0) alpha:1];

        NSString *titleString = object[@"offer_title"];
        NSString *pickUpTime  = object[@"offer_timeOnlyString"];
        NSString *addressName = object[@"address_name"];
        NSNumber *price       = object[@"offer_price"];
        
        title_tv.text    = titleString;
        time_label.text  = pickUpTime;
        addrs_label.text = addressName;
        price_label.text = [NSString stringWithFormat:@"CHF: %@", price];
        
        time_imV.image   = [UIImage imageNamed:@"Watch-25-grey.png"];
        addrs_imv.image   = [UIImage imageNamed:@"Location-25.png"];
        price_imv.image   = [UIImage imageNamed:@"moneyBagYellow"];
        
        PFFile *imagefile     = object[@"coverImageFile"];

        [imagefile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSData *imageData = [imagefile getData];
                
                imgV.image         = [UIImage imageWithData:imageData];
                imgV.contentMode   = UIViewContentModeScaleAspectFill;
                imgV.clipsToBounds = YES;
            }
        }];

        UITapGestureRecognizer *menuViewTap = [[UITapGestureRecognizer alloc] init];
        menuViewTap.delegate = self;
        [menuViewTap addTarget:self action:@selector(menuTapped:)];
        [menuViewTap setNumberOfTapsRequired:1];
        [menuView addGestureRecognizer:menuViewTap];
        
        [menuView addSubview:imgV];
        [menuView addSubview:title_tv];
        [menuView addSubview:time_imV];
        [menuView addSubview:time_label];
        [menuView addSubview:addrs_imv];
        [menuView addSubview:addrs_label];
        [menuView addSubview:price_imv];
        [menuView addSubview:price_label];
    
        [self.contentView addSubview:menuView];
        
        positionIndex = positionIndex + 1;
    }
}


#pragma mark - Query

- (void)queryForMap {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode           = MBProgressHUDModeIndeterminate;
    hud.labelText      = @"loading menus";
    [hud show:YES];
    
    PFQuery *query            = [PFQuery queryWithClassName:@"Menus"];
    Singleton *mySingleton    = [Singleton sharedSingleton];
    
    NSDateFormatter *form     = [[NSDateFormatter alloc] init];
    form.dateFormat           = @"dd.MMM yy";
    NSString *strDate         = [form stringFromDate:mySingleton.singl_findDate];
    self.dateOnlyForQuery     = strDate;
    self.searchReturnGeoPoint = mySingleton.singl_findCoordinates;
    
    [query whereKey:@"offer_status"         equalTo:@"available"];
    //    [query whereKey:@"offer_dateOnlyString" equalTo:self.dateOnlyForQuery];
    
    [query whereKey:@"address_geoPointCoordinates"  nearGeoPoint:self.searchReturnGeoPoint];
    //   withinKilometers:15.0];
    
    query.limit = 30; // limit query results
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            
            self.queryObjects = objects;
            
            
            hud.hidden = YES;

        }
    }];
    
    // TODO: order by userRating // by distance
    //    [query orderByDescending:@"createdAt"];
    
//    if (self.objects.count == 0) { // cache first if now objects loaded
//        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    }
}

#pragma mark - Navigation

- (void)menuTapped:(UITapGestureRecognizer *)gestureRecognizer {

    PFObject *tappedObject = [self.queryObjects objectAtIndex:self.selectedIndex];
    
    Singleton *mySingleton              = [Singleton sharedSingleton];
    mySingleton.singl_findObjectDetails = tappedObject;
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self performSegueWithIdentifier:@"ResultMap2OrderPreview" sender:self];
        
    } else {
        // login first:
        [self performSegueWithIdentifier:@"ResultMap2Login" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"ResultMap2Login"]) {
        Login_vc *loginVC = [segue destinationViewController];
        [loginVC setComingFromViewController:@"Results_tvc"];
        
    }
}

@end
