//
//  StartScreen_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 02.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "StartScreen_vc.h"
#import "Login_vc.h"
#import "Singleton.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <AFNetworking/AFNetworking.h>


@interface StartScreen_vc ()

@end

@implementation StartScreen_vc

@synthesize queryResponse, queryURLsArray, responseDics;

static NSString * const baseURL = @"http://food2fork.com/api/";
static NSString * const apiKey  = @"31a6f30afb8d54d0e8f54b624e200e47";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PFCloud callFunctionInBackground:@"hello" withParameters:@{}
                                block:^(NSString *response, NSError *error) {
                                    if (!error) {
                                        NSLog(@"%@", response);
                                    }
                                }];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage     = [UIImage new];
//    self.navigationController.navigationBar.translucent     = YES;
//    self.navigationController.view.backgroundColor          = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    double radius   = 3.0;
    UIColor *border = [UIColor colorWithRed:(255/255.0) green:(254/255.0) blue:(215/255.0) alpha:0.9];
    
    [self.findMealsButton.layer setBorderColor:[border CGColor]];
    [self.findMealsButton.layer setBorderWidth:0.3];
    [self.findMealsButton.layer setCornerRadius:radius];
    [self.findMealsButton setClipsToBounds:YES];
    
    [self.cookMealsButton.layer setBorderColor:[border CGColor]];
    [self.cookMealsButton.layer setBorderWidth:0.3];
    [self.cookMealsButton.layer setCornerRadius:radius];
    [self.cookMealsButton setClipsToBounds:YES];
    
    [self.recepiesButton.layer setBorderColor:[border CGColor]];
    [self.recepiesButton.layer setBorderWidth:0.3];
    [self.recepiesButton.layer setCornerRadius:radius];
    [self.recepiesButton setClipsToBounds:YES];
    
    self.responseDics   = [[NSMutableArray alloc]init];
    self.queryURLsArray = [[NSMutableArray alloc]init];
    
    [self loadUserProfileData];
    [self parseForQueryIDsAndRunNetworkRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Navigation

- (IBAction)cookAndOfferPressed:(id)sender {
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"already logged in");
        [self performSegueWithIdentifier:@"StartScreen2DateInput" sender:self];
        
    } else {
        NSLog(@"log in first");
        [self performSegueWithIdentifier:@"StratScreen2Login" sender:self];
    }
}

- (IBAction)findMealsPressed:(id)sender {
    // TODO: cache previously searched address and forward to SearchCity_vc
    [self performSegueWithIdentifier:@"StartScreen2SelectDate" sender:self];
}

- (IBAction)checkRecipesPressed:(id)sender {
    
    // TODO: what if no connection (fetch data in PARSE?
    
//    NSUInteger i = [self.responseDics count];
//    while (i < 13) {
//        NSLog(@"wait until Dic Count %lu", (unsigned long)[self.responseDics count]);
    
//    }
    
    if ([self.responseDics count] == 12) {
        
        Singleton *mySingleton        = [Singleton sharedSingleton];
        mySingleton.recipeDictionary  = self.responseDics;
        
        [self performSegueWithIdentifier:@"StartScreen2Recipes" sender:self];
    } else {
        NSLog(@"wait... current Dic count: %lu", (unsigned long)[self.responseDics count]);
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"StratScreen2Login"]) {
        Login_vc *loginVC = [segue destinationViewController];
        [loginVC setComingFromViewController:@"StartScreen_vc"];
    }
}

- (IBAction)logOutPressed:(id)sender {
    [PFUser logOut];
    NSLog(@"logged out");
}

#pragma mark - Load UserProfile

- (void)loadUserProfileData {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, location, gender"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             
             if (!error) {
                 
                 NSDictionary *userData             = (NSDictionary *)result;
                 NSString *facebookID               = userData[@"id"];
                 NSMutableDictionary *userProfile   = [NSMutableDictionary dictionaryWithCapacity:7];
                 NSString *name                     = userData[@"name"];
                 NSString *location                 = userData[@"location"][@"name"];
                 NSString *gender                   = userData[@"gender"];
                 
                 if (facebookID) {
                     userProfile[@"facebookId"] = facebookID;
                 } if (name) {
                     userProfile[@"name"]       = name;
                 } if (location) {
                     userProfile[@"location"]   = location;
                 } if (gender) {
                     userProfile[@"gender"]     = gender;
                 }
                 userProfile[@"pictureURL"]     = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
                 
                 [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
                 [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     if (succeeded) {
                         NSLog(@"user-profile upload successful");
                     }
                 }];
                 
             } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                         isEqualToString: @"OAuthException"]) {
                 NSLog(@"The facebook session was invalidated");
//                 [self logoutButtonAction:nil];
             } else {
                 NSLog(@"Some other error: %@", error);
             }
         }];
    }
}

- (void)parseForQueryIDsAndRunNetworkRequest {
    
    // Parse for current recipeIDs
    PFQuery *recipeQuery = [PFQuery queryWithClassName:@"Recipes"];
    [recipeQuery whereKey:@"currentOrDate" equalTo:@"current"];
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            NSArray *firstLine = [objects firstObject];
            NSArray *IdArray   = [firstLine valueForKey:@"Food2ForkIDs"];
            NSLog(@"ParseIDs:%@", IdArray);
            [self.queryURLsArray removeAllObjects];
            for (int i = 0; i < [IdArray count] ; i++) {
                NSString *recipeId    = [IdArray objectAtIndex:i];
                NSString *urlString   = [NSString stringWithFormat:@"%@get?key=%@&rId=%@",baseURL,apiKey,recipeId];
                NSURL *url            = [[NSURL alloc] initWithString: urlString];
                [self.queryURLsArray addObject:url];
            }
            [self runNetworkRequestswithURLs:self.queryURLsArray];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            NSArray *alternativeIDs = [[NSArray alloc] initWithObjects:
                                       @"35120", @"54384", @"47746", @"35fdd3", @"47090",
                                       @"5f6a85", @"075b6c", @"35186", @"46983", @"5ed6cc",  nil];
            [self.queryURLsArray removeAllObjects];
            for (int i = 0; i < [alternativeIDs count] ; i++) {
                NSString *recipeId    = [alternativeIDs objectAtIndex:i];
                NSString *urlString   = [NSString stringWithFormat:@"%@get?key=%@&rId=%@",baseURL,apiKey,recipeId];
                NSURL *url            = [[NSURL alloc] initWithString: urlString];
                [self.queryURLsArray addObject:url];
            }
            [self runNetworkRequestswithURLs:self.queryURLsArray];
        }
    }];

}

- (void)runNetworkRequestswithURLs:(NSArray *)urlArray {
    
    [self.responseDics removeAllObjects];
    
    // .......................... Request 0 ..........................
    NSURLRequest *request0             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:0]];
    AFHTTPRequestOperation *operation0 = [[AFHTTPRequestOperation alloc] initWithRequest:request0];
    [operation0 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation0 start];
    
    // .......................... Request 1 ..........................
    NSURLRequest *request1             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:1]];
    AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation1 start];
    
    // .......................... Request 2 ..........................
    NSURLRequest *request2             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:2]];
    AFHTTPRequestOperation *operation2 = [[AFHTTPRequestOperation alloc] initWithRequest:request2];
    [operation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation2 start];
    
    // .......................... Request 3 ..........................
    NSURLRequest *request3             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:3]];
    AFHTTPRequestOperation *operation3 = [[AFHTTPRequestOperation alloc] initWithRequest:request3];
    [operation3 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation3 start];
    
    // .......................... Request 4 ..........................
    NSURLRequest *request4             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:4]];
    AFHTTPRequestOperation *operation4 = [[AFHTTPRequestOperation alloc] initWithRequest:request4];
    [operation4 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation4 start];
    
    // .......................... Request 5 ..........................
    NSURLRequest *request5             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:5]];
    AFHTTPRequestOperation *operation5 = [[AFHTTPRequestOperation alloc] initWithRequest:request5];
    [operation5 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation5 start];
    
    // .......................... Request 6 ..........................
    NSURLRequest *request6             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:6]];
    AFHTTPRequestOperation *operation6 = [[AFHTTPRequestOperation alloc] initWithRequest:request6];
    [operation6 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation6 start];
    
    // .......................... Request 7 ..........................
    NSURLRequest *request7             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:7]];
    AFHTTPRequestOperation *operation7 = [[AFHTTPRequestOperation alloc] initWithRequest:request7];
    [operation7 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation7 start];
    
    // .......................... Request 8 ..........................
    NSURLRequest *request8             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:8]];
    AFHTTPRequestOperation *operation8 = [[AFHTTPRequestOperation alloc] initWithRequest:request8];
    [operation8 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation8 start];
    
    // .......................... Request 9 ..........................
    NSURLRequest *request9             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:9]];
    AFHTTPRequestOperation *operation9 = [[AFHTTPRequestOperation alloc] initWithRequest:request9];
    [operation9 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation9 start];
    
    // .......................... Request 10 .........................
    NSURLRequest *request10             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:10]];
    AFHTTPRequestOperation *operation10 = [[AFHTTPRequestOperation alloc] initWithRequest:request10];
    [operation10 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation10 start];
    
    // .......................... Request 11 .........................
    NSURLRequest *request11             = [[NSURLRequest alloc] initWithURL:[urlArray objectAtIndex:11]];
    AFHTTPRequestOperation *operation11 = [[AFHTTPRequestOperation alloc] initWithRequest:request11];
    [operation11 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *recipe = [self.queryResponse objectForKey:@"recipe"];
        [self.responseDics addObject:recipe];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",  [error localizedDescription]);
    }];
    [operation11 start];

}
@end
