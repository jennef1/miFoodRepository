//
//  PreviousMenus_cvc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 17.11.15.
//  Copyright © 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviousMenus_cvc : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *menuQueryResults;
- (void)queryForMenus;


// navigation
- (IBAction)backPressed:(id)sender;

@end
