//
//  SearchCIty_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 14.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "SearchCIty_vc.h"
#import "SearchCity_cell.h"
#import "StartScreen_vc.h"
#import "Results_tvc.h"
#import "Singleton.h"

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface SearchCIty_vc ()

@end

@implementation SearchCIty_vc

@synthesize searchResultCity, searchResultPlaceID, searchResultLocationArray, placesClient;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResultCity          = [[NSMutableArray alloc]init];
    self.searchResultPlaceID       = [[NSMutableArray alloc]init];
    self.searchResultLocationArray = [[NSMutableArray alloc]init];
    
    self.placesClient              = [[GMSPlacesClient alloc] init];
    
    // visual configuration of TFs
    [self.searchBox       setLeftViewMode:UITextFieldViewModeAlways];
    [self.searchBox.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.searchBox.layer setBorderWidth:0.6];
    [self.searchBox.layer setCornerRadius:6];
    [self.searchBox       setClipsToBounds:YES];
    
    [self.currentLocationBoxTF.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.currentLocationBoxTF.layer setBorderWidth:0.6];
    [self.currentLocationBoxTF.layer setCornerRadius:4];
    [self.currentLocationBoxTF       setClipsToBounds:YES];
    
    // delegats
    [self.searchTF        becomeFirstResponder];
    [self.searchTF        setDelegate:self];
    [self.searchTableView setDelegate:self];
    [self.searchTableView setDataSource:self];
    [self createFooterViewForTableView];
    
    self.searchTableView.contentInset = UIEdgeInsetsZero;
    
    [self.searchTF addTarget:self
                      action:@selector(textChanged:)
            forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.searchResultCity count] == 0) {
        return 0;
    } else {
        return [self.searchResultCity count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCity_cell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCityCell_ID" forIndexPath:indexPath];
    
    if ([self.searchResultCity count] == 0) {
        NSLog(@"wait a moment for the geocoder to respond");
        // TODO: add a spinned with the nslog text from above
        
    } else {
        cell.searchResultCityLabel.text = [self.searchResultCity objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - TextField ChangeEvent

- (void)textChanged:(UITextField *)textField {
    
    // show search result only after 3 characters entered
    if (textField.text.length > 2) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode           = MBProgressHUDModeIndeterminate;
        hud.labelText      = @"searching";
        [hud show:YES];
        
        [self.searchResultCity          removeAllObjects];
        [self.searchResultPlaceID       removeAllObjects];
        [self.searchResultLocationArray removeAllObjects];
        
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type                   = kGMSPlacesAutocompleteTypeFilterCity;
        
        [self.placesClient autocompleteQuery:textField.text
                                      bounds:nil
                                      filter:filter
                                    callback:^(NSArray *results, NSError *error) {
                                        if (error != nil) {
                                            NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                            return;
                                        }
                                        
                                        for (GMSAutocompletePrediction* result in results) {
                                            
                                            NSString *placeID = result.placeID;
                                            
                                            [self.placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
                                                if (error != nil) {
                                                    NSLog(@"Place Details error %@", [error localizedDescription]);
                                                    return;
                                                }
                                                
                                                if (place != nil) {
                                                    
                                                    hud.hidden = YES;
                                                    
                                                    if (!(place.name.length == 0)) {
                                                        [self.searchResultCity addObject:place.name];
                                                    } else {
                                                        [self.searchResultCity addObject:place.formattedAddress];
                                                    }
                                                    
                                                    CLLocation *newLoc = [[CLLocation alloc]initWithLatitude:place.coordinate.latitude
                                                                                                   longitude:place.coordinate.longitude];
                                                
                                                    [self.searchResultPlaceID       addObject:placeID];
                                                    [self.searchResultLocationArray addObject:newLoc];
                                                    [self.searchTableView reloadData];
                                    
                                                } else {
                                                    NSLog(@"No place details for %@", placeID);
                                                }
                                            }];
                                            
                                            // TODO: Get CITYNAME only - either like AddressSearch lockUpPlaceID or - NSURL request
                                        }
                                    }];
        
        // TODO: must display "Powered by Google"...
        
        //    NSString *baseURL = @"http://maps.googleapis.com/maps/api/geocode/json?";
        //    NSString *fullURL = [NSString stringWithFormat:@"%@address=%@", baseURL, addressToSegue]; // &sensor=false
        //    fullURL           = [fullURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        //    NSLog(@"full URL: %@", fullURL);
        //    NSURL *queryURL   = [NSURL URLWithString:fullURL];
        //    NSLog(@"query URL: %@", queryURL);
        //    // TODO: asynch probably better to handle other activities in the meantime
        //    dispatch_sync(kBgQueue, ^{
        //
        //        NSData *data            = [NSData dataWithContentsOfURL:queryURL];
        //        NSError *error          = nil;
        //        NSDictionary *jsonDict  = [NSJSONSerialization JSONObjectWithData:data
        //                                                                  options:kNilOptions
        //                                                                    error:&error];
        //        NSArray *results        = [jsonDict objectForKey:@"results"];
        //
        //        for (NSDictionary *dicResult in results){
        //            NSLog(@"results: %@", dicResult);
        //            NSDictionary *geometry = [dicResult objectForKey:@"geometry"];
        //            NSDictionary *location = [geometry objectForKey:@"location"];
        //            NSString *lattitude    = [location objectForKey:@"lat"];
        //            NSString *longitute    = [location objectForKey:@"lng"];
        //            double latDouble       = [lattitude doubleValue];
        //            double lonDouble       = [longitute doubleValue];
        ////            CLLocation *locCoord   = [[CLLocation alloc]initWithLatitude:latDouble longitude:lonDouble];
        //            self.selectedSearchCoordinate = CLLocationCoordinate2DMake(latDouble, lonDouble);
        //        }
        //    });
        
        //    CLLocationCoordinate2D cor2s = [[self.searchResultLocationArray objectAtIndex:indexPath.row] coordinate];
    }
}

#pragma mark - TableViewFooter

- (void)createFooterViewForTableView {
    
    CGRect frameFooter   = CGRectMake(0, (self.view.frame.size.height - 100), self.view.frame.size.width, 70);
    CGRect frameIMV      = CGRectMake(110, 10, 85, 12);
    
    UIView *footerView   = [[UIView alloc]initWithFrame:frameFooter];
    UIImageView *imv     = [[UIImageView alloc]initWithFrame:frameIMV];
    imv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    imv.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    imv.image            = [UIImage imageNamed:@"powered-by-google-on-white"];
    
    [footerView addSubview:imv];
    self.searchTableView.tableFooterView = footerView;
}
    
#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchTF resignFirstResponder];
   
    NSString *cityNameToSegue    = [self.searchResultCity    objectAtIndex:indexPath.row];
    NSString *placeID            = [self.searchResultPlaceID objectAtIndex:indexPath.row];
    CLLocationCoordinate2D cor2D = [[self.searchResultLocationArray objectAtIndex:indexPath.row] coordinate];
    PFGeoPoint *selectedPFGeoP   = [PFGeoPoint geoPointWithLatitude:cor2D.latitude
                                                          longitude:cor2D.longitude];
    
    Singleton *mySingleton            = [Singleton sharedSingleton];
    mySingleton.singl_findCityName    = cityNameToSegue;
    mySingleton.singl_findPlaceID     = placeID;
    mySingleton.singl_findCoordinates = selectedPFGeoP;
}

- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
