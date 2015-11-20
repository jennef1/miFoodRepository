//
//  PreviousMenus_header.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 17.11.15.
//  Copyright © 2015 Fabian Jenne. All rights reserved.
//

#import "PreviousMenus_header.h"

@implementation PreviousMenus_header

#pragma mark - Accessors

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *headerTitle      = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width/2 - 130), 5, 260, 30)];
        headerTitle.text          = @"select one of your previous menus";
        headerTitle.font          = [UIFont fontWithName:@"Heiti TC" size:13.0f];
        headerTitle.textColor     = [UIColor lightGrayColor];
        headerTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:headerTitle];
    }
    
    return self;
}

@end
