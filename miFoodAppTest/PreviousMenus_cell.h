//
//  PreviousMenus_cell.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 17.11.15.
//  Copyright © 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviousMenus_cell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *foodImageV;
@property (strong, nonatomic) IBOutlet UITextView *foodTitle_tv;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
