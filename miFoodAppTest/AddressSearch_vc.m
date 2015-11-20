//
//  AddressSearch_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 31.08.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "AddressSearch_vc.h"
#import "AddressSearch_cell.h"
#import "MapView_vc.h"

#import <AddressBookUI/AddressBookUI.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface AddressSearch_vc ()

@end

@implementation AddressSearch_vc

@synthesize searchResultMainInfo, searchResultSubInfo, searchResultLocationArray, searchResultPlaceID, selectedSearchCoordinate;
@synthesize currentRegion, placesClient, streetname, route, subLocality, locality, subAdministrativeArea, administrativeArea, administrativeAreaCode, postalCode, country, commingFromSegue, ISOcountryCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // delegats
    [self.searchTF        becomeFirstResponder];
    [self.searchTF        setDelegate:self];
    [self.searchTableView setDelegate:self];
    [self.searchTableView setDataSource:self];
    [self createFooterViewForTableView];
    
    self.placesClient               = [[GMSPlacesClient alloc] init];
    
    self.searchResultMainInfo       = [[NSMutableArray alloc]init];
    self.searchResultSubInfo        = [[NSMutableArray alloc]init];
    self.searchResultPlaceID        = [[NSMutableArray alloc]init];
    self.searchResultLocationArray  = [[NSMutableArray alloc]init];
    
    // visual configuration of TFs
    [self.searchBox       setLeftViewMode:UITextFieldViewModeAlways];
    [self.searchBox.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.searchBox.layer setBorderWidth:0.6];
    [self.searchBox.layer setCornerRadius:4];
    [self.searchBox       setClipsToBounds:YES];
    
    [self.currentLocTF.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.currentLocTF.layer setBorderWidth:0.6];
    [self.currentLocTF.layer setCornerRadius:4];
    [self.currentLocTF       setClipsToBounds:YES];
    
    self.searchTableView.contentInset = UIEdgeInsetsZero;
    
    [self.searchTF addTarget:self
                      action:@selector(textChanged:)
            forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - TableView DataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.searchResultMainInfo count] == 0) {
        return 0;
    } else {
        return [self.searchResultMainInfo count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressSearch_cell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressSearchCell_ID" forIndexPath:indexPath];
    
    if ([self.searchResultMainInfo count] == 0) {
        NSLog(@"wait a moment for the geocoder to respond");
        
    } else {
        cell.searchResultTitle.text     = [self.searchResultMainInfo objectAtIndex:indexPath.row];
        cell.searchResultSubTitle.text  = [self.searchResultSubInfo  objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - Performe google search

- (void)textChanged:(UITextField *)textField{
    
    // TODO: when tipping and undo quickly HUD remains but can't select anything...
    
    
     // show search result only after 3 characters entered
    if (textField.text.length > 2) {
        
        // Show progress
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode           = MBProgressHUDModeIndeterminate;
        hud.labelText      = @"searching";
        [hud show:YES];
        
        [self.searchResultMainInfo removeAllObjects];
        [self.searchResultSubInfo  removeAllObjects];
        [self.searchResultPlaceID  removeAllObjects];
        [self.searchResultLocationArray removeAllObjects];
        
        [self.placesClient autocompleteQuery:textField.text
                                  bounds:nil
                                  filter:nil
                                callback:^(NSArray *results, NSError *error) {
                                    if (error != nil) {
                                        NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                        hud.hidden = YES;
                                        return;
                                    }
                                    
                                    for (GMSAutocompletePrediction* result in results) {
                                        NSString *placeID = result.placeID;
        
                                        [self.placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
                                            if (error != nil) {
                                                hud.hidden = YES;
                                                NSLog(@"Place Details error %@", [error localizedDescription]);
                                                return;
                                            }
                                            
                                            if (place != nil) {
                                                
                                                hud.hidden = YES;

                                                CLLocation *longLat = [[CLLocation alloc]
                                                                       initWithLatitude:place.coordinate.latitude
                                                                              longitude:place.coordinate.longitude];
                                                
                                                [self.searchResultMainInfo      addObject:place.formattedAddress];
                                                [self.searchResultSubInfo       addObject:place.name];
                                                [self.searchResultPlaceID       addObject:placeID];
                                                [self.searchResultLocationArray addObject:longLat];
                                                [self.searchTableView           reloadData];
                                                
                                            } else {
                                                hud.hidden = YES;
                                                NSLog(@"No place details for %@", placeID);
                                            }
                                        }];
                                        [self.searchTableView reloadData];
                                    }
                                }];
    }
}

- (IBAction)currentLocationPressed:(id)sender {
    // tbd what to do here...
}

#pragma mark - TableViewFooter (Google logo)

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.searchTF resignFirstResponder];
    
    NSString *addressToSegue     = [self.searchResultMainInfo       objectAtIndex:indexPath.row];
    NSString *cityNameToSegue    = [self.searchResultSubInfo        objectAtIndex:indexPath.row];
    NSString *placeID            = [self.searchResultPlaceID        objectAtIndex:indexPath.row];
    CLLocationCoordinate2D cor2D = [[self.searchResultLocationArray objectAtIndex:indexPath.row] coordinate];
    NSLog(@"selected lat:%f, lon:%f", cor2D.latitude, cor2D.longitude);
    
    
//    NSString *baseURL = @"http://maps.googleapis.com/maps/api/geocode/json?";
//    NSString *fullURL = [NSString stringWithFormat:@"%@address=%@", baseURL, addressToSegue]; // &sensor=false
//    fullURL           = [fullURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    NSLog(@"full URL: %@", fullURL);
//    NSURL *queryURL   = [NSURL URLWithString:fullURL];
//    NSLog(@"query URL: %@", queryURL);
//
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
    
    if ([self.commingFromSegue isEqualToString:@"MapView_vc.h"]) {
        MapView_vc *foodMapView_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView_ID"];
        [foodMapView_vc setSearchReturn_FormatAddress: addressToSegue];
        [foodMapView_vc setSearchReturn_CityName: cityNameToSegue];
        [foodMapView_vc setSearchReturn_Coordinates: cor2D];
        [foodMapView_vc setSearchReturn_PlaceID:placeID];
        [self.navigationController pushViewController:foodMapView_vc animated:NO];
        
    } }

- (IBAction)cancelPressed:(id)sender {
    MapView_vc *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView_ID"];
    [self.navigationController pushViewController:tvc animated:NO];
}

@end
