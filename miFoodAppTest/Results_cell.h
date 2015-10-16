//
//  Results_cell.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 14.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "PFTableViewCell.h"

@interface Results_cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userPicture;
@property (strong, nonatomic) IBOutlet UIImageView *userRating;

@property (strong, nonatomic) IBOutlet PFImageView *imagePreview1;
@property (strong, nonatomic) IBOutlet UILabel *foodTitle;
@property (strong, nonatomic) IBOutlet UILabel *foodPickUpTime;
@property (strong, nonatomic) IBOutlet UILabel *foodAddress;
@property (strong, nonatomic) IBOutlet UILabel *foodPricePlaceHolder;
@property (strong, nonatomic) IBOutlet UILabel *foodPriceTag;
@property (strong, nonatomic) IBOutlet UILabel *foodPriceCurrency;

@end
