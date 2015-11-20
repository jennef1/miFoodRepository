//
//  Results_tvc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 14.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "Results_tvc.h"
#import "Results_cell.h"
#import "MapResults_vc.h"
#import "Preview_vc.h"
#import "Login_vc.h"
#import "Singleton.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface Results_tvc ()

@end

@implementation Results_tvc

@synthesize searchReturnGeoPoint, dateOnlyForQuery;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithClassName:@"Menus"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.parseClassName       = @"Menus";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled    = YES;
        self.objectsPerPage       = 20;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    // This method is called every time objects are loaded from Parse via the PFQuery
}

#pragma mark - PFQuery

- (PFQuery *)queryForTable {
    
    PFQuery *query            = [PFQuery queryWithClassName:self.parseClassName];
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
    
    // TODO: order by userRating // by distance
    //    [query orderByDescending:@"createdAt"];
    
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    if (self.objects.count == 0) { // cache first if now objects loaded
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    return query;
}

#pragma mark - UITableViewDelegate
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    Results_cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Results_cell_ID"];
    
    // userInfo:
    NSString *urlString      = object[@"createdBy_URLProfilePic"];
    NSURL *url               = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil && data != nil) {
                                   NSLog(@"finished asynch request");
                                   cell.userPicture.image = [UIImage imageWithData:data];
                                   cell.userPicture.layer.cornerRadius  = (cell.userPicture.frame.size.width / 2);
                                   cell.userPicture.layer.borderColor   = [UIColor whiteColor].CGColor;
                                   cell.userPicture.layer.borderWidth   = 1.2f;
                                   cell.userPicture.clipsToBounds       = YES;
                               }
                           }];
    // menuInfo:
    NSString *titleString    = object[@"offer_title"];
    NSString *addressName    = object[@"address_name"];
    NSString *pickUpTime     = object[@"offer_timeOnlyString"];
    NSNumber *price          = object[@"offer_price"];
    PFFile *imagefile        = object[@"coverImageFile"];
    PFGeoPoint *menuGeoPoint = object[@"address_geoPointCoordinates"];
    
    CLLocation *searchLoc    = [[CLLocation alloc]initWithLatitude:self.searchReturnGeoPoint.latitude longitude:self.searchReturnGeoPoint.longitude];
    CLLocation *menuLoc      = [[CLLocation alloc]initWithLatitude:menuGeoPoint.latitude longitude:menuGeoPoint.longitude];
    CLLocationDistance dist  = [menuLoc distanceFromLocation:searchLoc];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@"'"];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setMaximumFractionDigits:0];
    NSString *distnace = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:dist]];
    
    [imagefile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                 if (!error) {
                     NSData *imageData = [imagefile getData];
                     
                     cell.imagePreview1.image         = [UIImage imageWithData:imageData];
                     cell.imagePreview1.contentMode   = UIViewContentModeScaleAspectFill;
                     cell.imagePreview1.clipsToBounds = YES;
                 }
             }];
    
    cell.foodTitle.text      = titleString;
    cell.foodPickUpTime.text = pickUpTime;
    cell.foodAddress.text    = addressName;
//    cell.foodDistance.text   = [NSString stringWithFormat:@"%.0fm",dist];
    cell.foodDistance.text   = [NSString stringWithFormat:@"%@m",distnace];
    cell.foodPriceTag.text   = [NSString stringWithFormat:@"%@", price];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    PFObject *selectedobject            = [self.objects objectAtIndex:indexPath.row];
    Singleton *mySingleton              = [Singleton sharedSingleton];
    mySingleton.singl_findObjectDetails = selectedobject;
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self performSegueWithIdentifier:@"Result2OrderPreview" sender:self];
        
    } else {
        // login first:
        [self performSegueWithIdentifier:@"Result2Login" sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"Result2Login"]) {
        Login_vc *loginVC = [segue destinationViewController];
        [loginVC setComingFromViewController:@"Results_tvc"];
        
    } else if ([segue.identifier isEqualToString:@"showMapResults"]) {

        // TODO: if self.object = nil run the query first (and show a hub)
    }
}

- (IBAction)showMapResultsPressed:(id)sender {
    
    Singleton *mySingleton = [Singleton sharedSingleton];
    mySingleton.singl_queryResultObjects = self.objects;
    [self performSegueWithIdentifier:@"showMapResults" sender:self];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */




@end
