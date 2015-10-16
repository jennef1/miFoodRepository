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
@property (nonatomic, readwrite, retain) id buttonIndexData;
@property (assign) NSInteger buttonInt;

- (void)addRecipeButtonPressed:(id)sender;


@end
