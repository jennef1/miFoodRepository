//
//  RecipesOverview_cvc.m
//  
//
//  Created by Fabian Jenne on 14.10.15.
//
//

#import "RecipesOverview_cvc.h"
#import "RecipesOverview_cell.h"
#import "RecipesHeaderView.h"
#import "RecipesDetails_vc.h"
#import "Singleton.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Parse/Parse.h>

@interface RecipesOverview_cvc ()

@end

@implementation RecipesOverview_cvc

@synthesize recipeAddButton, responseDics;

static NSString * const reuseIdentifier = @"cellID";

//static NSString * const baseURL = @"http://food2fork.com/api/";
//static NSString * const apiKey  = @"31a6f30afb8d54d0e8f54b624e200e47";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // configer Layout
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];
    layout.sectionInset             = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerHeight             = 35;
    layout.minimumColumnSpacing     = 10;
    layout.minimumInteritemSpacing  = 20;
    
    [self.collectionView registerClass:[RecipesHeaderView class]
        forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
               withReuseIdentifier:@"headerViewID"];
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.autoresizingMask     = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    Singleton *mySingleton = [Singleton sharedSingleton];
    self.responseDics      = [[NSMutableArray alloc]init];
    self.responseDics      = mySingleton.recipeDictionary;

}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecipesOverview_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // configer cell visuals
    CGRect buttonFrame  = CGRectMake((cell.frame.size.width - 31), (cell.frame.size.height - 28), 17, 17);
    UIButton *addButton = [[UIButton alloc]initWithFrame:buttonFrame];
    [addButton setBackgroundImage:[UIImage imageNamed:@"PlusCircleGrey"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addRecipeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.recipeAddButton = addButton;
    [cell.contentView addSubview:self.recipeAddButton];
    
    cell.layer.cornerRadius    = 6;
    cell.layer.masksToBounds   = NO;
    cell.layer.shadowColor     = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset    = CGSizeMake(0.0f, 1.0f);
    cell.layer.shadowRadius    = 0.8f;
    cell.layer.shadowOpacity   = 0.75f;
    cell.layer.shouldRasterize = NO;

    NSDictionary *currentDic    = [self.responseDics objectAtIndex:indexPath.item];
    NSString *title             = [currentDic objectForKey:@"title"];
    NSString *ranking           = [currentDic objectForKey:@"social_rank"];
    NSString *urlString         = [currentDic objectForKey:@"image_url"];
    
    if (!(urlString.length == 0)) {
        cell.recipeTitle_tv.text   = title;
        cell.recipeLikesLabel.text = [NSString stringWithFormat:@"%@", ranking];
        [cell.recipeImageV setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"CookHead"]];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    NSDictionary *selectedRecipe  = [self.responseDics objectAtIndex:indexPath.item];
    RecipesDetails_vc *details_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"recipesDetails_ID"];
    [details_vc setRecipeDetails:selectedRecipe];
    [self.navigationController pushViewController:details_vc animated:YES];
//    [self performSegueWithIdentifier:@"RecipesDetailSegue" sender:self];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int longCellHeigh   = 300;
    int shortCellHeight = 220;
    CGSize viewFrame    = CGSizeMake((self.view.frame.size.width/2 - 10), longCellHeigh);
    
    if (indexPath.item == 0) {
        viewFrame.height = shortCellHeight;
    } else if (indexPath.item == 5) {
        viewFrame.height = shortCellHeight;
    } else if (indexPath.item == 6) {
        viewFrame.height = shortCellHeight;
    } else if (indexPath.item == 11) {
        viewFrame.height = shortCellHeight;
    }
    return viewFrame;
}

#pragma mark - AddRecipe Button

- (void)addRecipeButtonPressed:(id)sender {
    NSLog(@"pressed");
    [self.recipeAddButton setBackgroundImage:[UIImage imageNamed:@"PlusCircleYellow"] forState:UIControlStateNormal];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"headerViewID"
                                                                 forIndexPath:indexPath];
    
    }
    
    return reusableView;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
