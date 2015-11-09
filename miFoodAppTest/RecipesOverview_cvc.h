//
//  RecipesOverview_cvc.h
//  
//
//  Created by Fabian Jenne on 14.10.15.
//
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

@interface RecipesOverview_cvc : UICollectionViewController <CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) UIButton *recipeAddButton;
- (void)addRecipeButtonPressed:(id)sender;

// Food2Fork dictionary results
@property (strong, nonatomic) NSMutableArray *responseDics;

- (IBAction)backPressed:(id)sender;

@end


// Array w RecipeIDs for manual Parse upload:
// ["35120", "54384", "47746", "35fdd3", "47090","5f6a85", "075b6c", "35186", "46983", "5ed6cc", "47776", "46993"]


