//
//  RecipesDetails_vc.m
//  
//
//  Created by Fabian Jenne on 15.10.15.
//
//

#import "RecipesDetails_vc.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface RecipesDetails_vc ()

@end

@implementation RecipesDetails_vc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.methodWebView.hidden      = YES;
    self.closeWebViewButton.hidden = YES;
    
    self.recipeImvButtom_plhTf.layer.cornerRadius = 20;
    self.methodButton.layer.cornerRadius = 18;
    self.methodButton.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    self.methodButton.layer.borderWidth  = 0.5;
    
    if (!([self.recipeDetails count] == 0)) {
       
        NSString *title           = [self.recipeDetails objectForKey:@"title"];
        NSString *ranking         = [self.recipeDetails objectForKey:@"social_rank"];
        NSString *urlString       = [self.recipeDetails objectForKey:@"image_url"];
        NSArray *ingredArray      = [self.recipeDetails objectForKey:@"ingredients"];
        NSString *sourceURLstring = [self.recipeDetails objectForKey:@"source_url"];
        
        NSURL *webURL               = [NSURL URLWithString:sourceURLstring];
        NSURLRequest *webURLRequest = [NSURLRequest requestWithURL:webURL];
        [self.methodWebView loadRequest:webURLRequest];
        
//        NSNumberFormatter *formatRanking    = [[NSNumberFormatter alloc] init];
//        formatRanking.numberStyle           = NSNumberFormatterDecimalStyle;
//        formatRanking.maximumFractionDigits = 2;
//        NSNumber *rankingNr                 = [formatRanking numberFromString:ranking];
//        NSLog(@"%@", rankingNr);
        
        NSMutableString *ingredientsString = [[NSMutableString alloc]init];
        
        for (int i = 0; i < [ingredArray count]; i++) {
            NSString *line = [ingredArray objectAtIndex:i];
            [ingredientsString appendString:[NSString stringWithFormat:@"%@ \r", line]];
        }
        
        self.title_tv.text       = title;
        self.likesLabel.text     = [NSString stringWithFormat:@"%@", ranking];
        self.ingredients_tv.text = ingredientsString;
        [self.Recipe_imv setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"CookHead"]];
        
        NSLog(@"ingredients string: %@", ingredientsString);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addRecipePressed:(id)sender {
    
}

- (IBAction)methodPressed:(id)sender {
    
    self.methodWebView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.methodWebView.layer.borderWidth = 0.6;
    self.methodWebView.layer.cornerRadius = 5;
    self.closeWebViewButton.layer.cornerRadius = 5;

    self.methodWebView.hidden      = NO;
    self.closeWebViewButton.hidden = NO;
    
    self.methodWebView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        [self.methodWebView setAlpha:1.0];
    }];
}

- (IBAction)closeWebViewPressed:(id)sender {
    self.methodWebView.hidden      = YES;
    self.closeWebViewButton.hidden = YES;
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
