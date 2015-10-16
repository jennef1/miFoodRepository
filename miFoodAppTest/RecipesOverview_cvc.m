//
//  RecipesOverview_cvc.m
//  
//
//  Created by Fabian Jenne on 14.10.15.
//
//

#import "RecipesOverview_cvc.h"
#import "RecipesOverview_cell.h"

@interface RecipesOverview_cvc ()

@end

@implementation RecipesOverview_cvc

@synthesize recipeAddButton, buttonIndexData, buttonInt;

static NSString * const reuseIdentifier = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonInt = 100;
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];

    layout.sectionInset             = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerHeight             = 25;
    layout.minimumColumnSpacing     = 10;
    layout.minimumInteritemSpacing  = 20;
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.autoresizingMask     = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
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
    
    CGRect buttonFrame  = CGRectMake((cell.frame.size.width - 31), (cell.frame.size.height - 28), 17, 17);
    UIButton *addButton = [[UIButton alloc]initWithFrame:buttonFrame];
    [addButton setBackgroundImage:[UIImage imageNamed:@"PlusCircleGrey"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addRecipeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [addButton setTag:indexPath.row];
    self.recipeAddButton = addButton;
    [cell.contentView addSubview:self.recipeAddButton];
    
    cell.layer.cornerRadius     = 6;
    cell.layer.masksToBounds    = NO;
    cell.layer.shadowColor      = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset     = CGSizeMake(0.0f, 1.0f);
    cell.layer.shadowRadius     = 0.8f;
    cell.layer.shadowOpacity    = 0.75f;
    cell.layer.shouldRasterize  = NO;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"item :%li", (long)indexPath.row);
    [self performSegueWithIdentifier:@"RecipesDetailSegue" sender:self];
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
//    } else if (indexPath.item == 3) {
//        int heightRow = 170;
//        viewFrame.height = heightRow;
//    } else if (indexPath.item == 4) {
//        int heightRow = 250;
//        viewFrame.height = heightRow;
//    } else if (indexPath.item == 5) {
//        int heightRow = 170;
//        viewFrame.height = heightRow;
//    } else if (indexPath.item == 6) {
//        int heightRow = 250;
//        viewFrame.height = heightRow;
//    } else if (indexPath.item == 7) {
//        int heightRow = 250;
//        viewFrame.height = heightRow;
//    } else if (indexPath.item == 8) {
//        int heightRow = 170;
//        viewFrame.height = heightRow;
//    } else if (indexPath.item == 9) {
//        int heightRow = 250;
//        viewFrame.height = heightRow;
//    }
    return viewFrame;
}

#pragma mark - AddRecipe Button

- (void)addRecipeButtonPressed:(id)sender {
    NSLog(@"pressed");
    [self.recipeAddButton setBackgroundImage:[UIImage imageNamed:@"PlusCircleYellow"] forState:UIControlStateNormal];
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                          withReuseIdentifier:HEADER_IDENTIFIER
//                                                                 forIndexPath:indexPath];
//    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                          withReuseIdentifier:FOOTER_IDENTIFIER
//                                                                 forIndexPath:indexPath];
//    }
//    
//    return reusableView;
//}


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

@end
