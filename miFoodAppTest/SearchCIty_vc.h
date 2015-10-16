//
//  SearchCIty_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 14.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface SearchCIty_vc : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


// tableView
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, readonly) UIActivityIndicatorView *spinner;
@property (weak, readonly) UIActivityIndicatorView *currentLocationSpinnerView;
- (void)createFooterViewForTableView;

// searchField
@property (strong, nonatomic) IBOutlet UIImageView *background_imv;
@property (strong, nonatomic) IBOutlet UITextField *searchBox;
@property (strong, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UITextField *currentLocationBoxTF;

// searchResults / EventTriggers
@property (strong, nonatomic) NSMutableArray *searchResultCity;
@property (strong, nonatomic) NSMutableArray *searchResultPlaceID;
@property (strong, nonatomic) NSMutableArray *searchResultLocationArray;
- (void)textChanged:(UITextField *)textField;

// google map api
@property (strong, nonatomic) GMSPlacesClient *placesClient;

// navigation
- (IBAction)cancelPressed:(id)sender;

@end
