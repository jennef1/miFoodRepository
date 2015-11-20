//
//  PreviousMenus_cvc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 17.11.15.
//  Copyright © 2015 Fabian Jenne. All rights reserved.
//

#import "PreviousMenus_cvc.h"
#import "PreviousMenus_cell.h"
#import "PreviousMenus_header.h"
#import "Overview_tvc.h"
#import "Singleton.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <Parse/Parse.h>

@interface PreviousMenus_cvc ()

@end

@implementation PreviousMenus_cvc

@synthesize menuQueryResults;
static NSString * const reuseIdentifier = @"PreviousMenusCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuQueryResults = [[NSMutableArray alloc]init];
    [self.collectionView registerClass:[PreviousMenus_header class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"PreviousMenusHeaderID"];
    
    [self queryForMenus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.menuQueryResults.count == 0) {
        return 0;
    } else {
        return [self.menuQueryResults count];
    }
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PreviousMenus_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.layer.cornerRadius    = 6;
    cell.layer.masksToBounds   = NO;
    cell.layer.shadowColor     = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset    = CGSizeMake(0.0f, 1.0f);
    cell.layer.shadowRadius    = 0.8f;
    cell.layer.shadowOpacity   = 0.75f;
    cell.layer.shouldRasterize = NO;
    
    PFObject *menuObject   = [self.menuQueryResults objectAtIndex:indexPath.item];
    NSString *title        = [menuObject valueForKey:@"offer_title"];
    NSNumber *price        = [menuObject valueForKey:@"offer_price"];
    double priceDouble     = [price doubleValue];
    
    cell.priceLabel.text   = [NSString stringWithFormat:@"CHF %.2lf", priceDouble];
    cell.foodTitle_tv.text = title;
    
    PFFile *imagefile = [menuObject valueForKey:@"coverImageFile"];
    [imagefile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSData *imageData = [imagefile getData];
            
            cell.foodImageV.image         = [UIImage imageWithData:imageData];
            cell.foodImageV.contentMode   = UIViewContentModeScaleAspectFill;
            cell.foodImageV.clipsToBounds = YES;
        }
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int cellHeight   = 260;
    CGSize viewFrame = CGSizeMake((self.view.frame.size.width/2 - 10), cellHeight);
    return viewFrame;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"PreviousMenusHeaderID"
                                                                 forIndexPath:indexPath];
        
    }
    return reusableView;
}

#pragma mark - Query

- (void)queryForMenus {
    
    [self.menuQueryResults removeAllObjects];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode           = MBProgressHUDModeIndeterminate;
    hud.labelText      = @"loading menus";
    [hud show:YES];
    
    PFUser *user   = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Menus"];
 
    [query whereKey:@"createdBy" equalTo:user];
    query.limit = 30;
    
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                [self.menuQueryResults addObject:object];
            }
            hud.hidden = YES;
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    //    if (self.objects.count == 0) { // cache first if now objects loaded
    //        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //    }

    
}

#pragma mark - Navigation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode           = MBProgressHUDModeIndeterminate;
    hud.labelText      = @"creating menu";
    [hud show:YES];
    
    PFObject *selectedMenuObject = [self.menuQueryResults objectAtIndex:indexPath.item];
    
    Singleton *mySingleton                  = [Singleton sharedSingleton];
    mySingleton.singl_title                 = [selectedMenuObject valueForKey:@"offer_title"];
    mySingleton.singl_description           = [selectedMenuObject valueForKey:@"offer_description"];
    mySingleton.singl_formattedAddressName  = [selectedMenuObject valueForKey:@"address_formatted"];
    mySingleton.singl_addressName           = [selectedMenuObject valueForKey:@"address_name"];
    mySingleton.singl_cityName              = [selectedMenuObject valueForKey:@"address_city"];
    mySingleton.singl_placeID               = [selectedMenuObject valueForKey:@"address_placeID"];
    mySingleton.singl_locationComment       = [selectedMenuObject valueForKey:@"address_locationComments"];
    
    PFGeoPoint *geoPoint                    = [selectedMenuObject valueForKey:@"address_geoPointCoordinates"];
    CLLocationCoordinate2D geoCoordinates   = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    mySingleton.singl_coordinates           = geoCoordinates;
    
    PFFile *selectedImagefile = [selectedMenuObject valueForKey:@"coverImageFile"];
    [selectedImagefile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            hud.hidden = YES;
            NSData *imageData = [selectedImagefile getData];
            mySingleton.singl_coverImage = [UIImage imageWithData:imageData];
            Overview_tvc *overView       = [self.storyboard instantiateViewControllerWithIdentifier:@"OverviewID"];
            [self.navigationController pushViewController:overView animated:YES];
        }
    }];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
