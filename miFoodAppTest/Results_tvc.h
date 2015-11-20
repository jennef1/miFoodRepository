//
//  Results_tvc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 14.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface Results_tvc : PFQueryTableViewController

// query input
@property (strong, nonatomic) PFGeoPoint *searchReturnGeoPoint;
@property (strong, nonatomic) NSString *dateOnlyForQuery;

// navigation
- (IBAction)showMapResultsPressed:(id)sender;
- (IBAction)backPressed:(id)sender;

@end
