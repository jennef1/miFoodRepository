//
//  FoodType_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 02.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "FoodType_vc.h"
#import "Singleton.h"

@interface FoodType_vc ()

@end

@implementation FoodType_vc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    double radius = 3.0;
    
    [self.breakfastButton.layer setCornerRadius:radius];
    [self.lunchButton.layer     setCornerRadius:radius];
    [self.dinnerButton.layer    setCornerRadius:radius];
    [self.snacksButton.layer    setCornerRadius:radius];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
//    Singleton *mySingleton = [Singleton sharedSingleton];
//    
//    if ([segue.identifier isEqualToString:@"typeBreakfast"]) {
//        mySingleton.singl_foodType = @"Breakfast";
//        
//    } else if ([segue.identifier isEqualToString:@"typeLunch"]) {
//        mySingleton.singl_foodType = @"Lunch";
//        
//    } else if ([segue.identifier isEqualToString:@"typeDinner"]) {
//        mySingleton.singl_foodType = @"Dinner";
//        
//    } else if ([segue.identifier isEqualToString:@"typeSnacks"]) {
//        mySingleton.singl_foodType = @"Snacks";
//    }
    
}

@end
