//
//  RecipesHeaderView.m
//  
//
//  Created by Fabian Jenne on 19.10.15.
//
//

#import "RecipesHeaderView.h"

@implementation RecipesHeaderView

#pragma mark - Accessors

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UILabel *headerTitle  = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width/2 - 130), 5, 260, 30)];
        headerTitle.text      = @"cooking inspirations for you";
        headerTitle.font      = [UIFont fontWithName:@"Heiti TC" size:16.0f];
        headerTitle.textColor = [UIColor colorWithRed:(43/255) green:(125/255) blue:(164/255) alpha:1];
        [self addSubview:headerTitle];
    }
    return self;
}
@end
