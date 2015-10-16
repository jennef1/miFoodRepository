//
//  RecipesOverview_cell.h
//  
//
//  Created by Fabian Jenne on 14.10.15.
//
//

#import <UIKit/UIKit.h>

@interface RecipesOverview_cell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *recipeImageV;
@property (strong, nonatomic) IBOutlet UITextView *recipeTitle_tv;
@property (strong, nonatomic) IBOutlet UILabel *recipeLikesLabel;


@end
