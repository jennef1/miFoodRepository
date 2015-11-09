//
//  RecipesDetails_vc.h
//  
//
//  Created by Fabian Jenne on 15.10.15.
//
//

#import <UIKit/UIKit.h>

@interface RecipesDetails_vc : UIViewController

@property (strong, nonatomic) NSDictionary *recipeDetails;

@property (strong, nonatomic) IBOutlet UIImageView *Recipe_imv;
@property (strong, nonatomic) IBOutlet UITextField *recipeImvButtom_plhTf;
@property (strong, nonatomic) IBOutlet UITextView  *title_tv;

@property (strong, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UIButton *addRecipeButton;
- (IBAction)addRecipePressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *ingredients_tv;
@property (strong, nonatomic) IBOutlet UIWebView *methodWebView;
@property (strong, nonatomic) IBOutlet UIButton *methodButton;
@property (strong, nonatomic) IBOutlet UIButton *closeWebViewButton;

- (IBAction)methodPressed:(id)sender;
- (IBAction)closeWebViewPressed:(id)sender;

- (IBAction)backPressed:(id)sender;


@end
