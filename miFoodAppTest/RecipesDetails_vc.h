//
//  RecipesDetails_vc.h
//  
//
//  Created by Fabian Jenne on 15.10.15.
//
//

#import <UIKit/UIKit.h>

@interface RecipesDetails_vc : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *Recipe_imv;
@property (strong, nonatomic) IBOutlet UITextView  *title_tv;
@property (strong, nonatomic) IBOutlet UIImageView *titleLogo_imv;
@property (strong, nonatomic) IBOutlet UITextView  *details_tv;


@property (strong, nonatomic) IBOutlet UIButton *ingredient_btn;
@property (strong, nonatomic) IBOutlet UIButton *method_btn;
- (IBAction)ingredientPressed:(id)sender;
- (IBAction)methodPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *like_btn;
- (IBAction)likeButtonPressed:(id)sender;

@end
