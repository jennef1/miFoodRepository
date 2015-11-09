//
//  Overview_tvc.m
//  
//
//  Created by Fabian Jenne on 23.10.15.
//
//

#import "Overview_tvc.h"
#import "Singleton.h"
#import "Title_vc.h"
#import "Image_vc.h"
#import "Description_vc.h"
#import "StartScreen_vc.h"

#import <APParallaxHeader/UIScrollView+APParallaxHeader.h>

@interface Overview_tvc () <APParallaxViewDelegate>

@end

@implementation Overview_tvc

@synthesize coverImage, titleString, descriptionString, addressString, locComsString, menuCount, pickUpDate, pickUpTime, menuPrice, previewButton, infoMissingCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: check Image: it cuts too much from top...
    
    // storredInput
    Singleton* mySingleton  = [Singleton sharedSingleton];
    self.coverImage         = mySingleton.singl_coverImage;

    [self.tableView addParallaxWithImage:coverImage andHeight:180 andShadow:YES];
    
    CGRect btnFrame     = CGRectMake(0, (CGRectGetHeight(self.view.bounds) - 50) , self.view.frame.size.width, 50);
    UIButton *btn       = [[UIButton alloc]initWithFrame:btnFrame];
    btn.backgroundColor = [UIColor colorWithRed:(73/255.0) green:(74/255.0) blue:(76/255.0) alpha:1];
    self.previewButton  = btn;
    [self.tableView setContentOffset:CGPointMake(0, 1) animated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
  
    // TODO: check if after pushViewController i can call "viewDidLoad" again
    
    Singleton* mySingleton  = [Singleton sharedSingleton];
    self.titleString        = mySingleton.singl_title;
    self.descriptionString  = mySingleton.singl_description;
    self.menuCount          = mySingleton.singl_quantity;
    self.addressString      = mySingleton.singl_addressName;
    self.pickUpDate         = mySingleton.singl_date;
    self.pickUpTime         = mySingleton.singl_pickupTime;
    self.menuPrice          = mySingleton.singl_price;
    self.locComsString      = mySingleton.singl_locationComment;
    self.coverImage         = mySingleton.singl_coverImage;
    
    [self.tableView addParallaxWithImage:coverImage andHeight:180 andShadow:YES];
    
    self.titleLabel.text = self.titleString;
    
    self.infoMissingCount = 3;
    
    if (self.menuCount > 0) {
        self.infoMissingCount = self.infoMissingCount - 1;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat       = @"dd MM yyyy";
        NSString *dateString           = [[dateFormatter stringFromDate:self.pickUpDate] capitalizedString];
        
        double hour;
        double minutes = modf(self.pickUpTime, &hour);
        NSString *timestring = [[NSString alloc]init];
        NSString *hourStr    = [NSString stringWithFormat:@"%.0f",hour];
        if (minutes == 0) {
            timestring = [NSString stringWithFormat:@"%@:00",hourStr];
        } else {
            timestring = [NSString stringWithFormat:@"%@:30",hourStr];
        }
        
        NSString *details = [NSString stringWithFormat:@"%@ @%@ offering: %d menus each £%.2f",dateString, timestring, self.menuCount, self.menuPrice];
        self.detailsLabel.text = details;
        self.tickDetails.image = [UIImage imageNamed:@"TickCircleYellow"];
    }
    if (!([self.addressString length] == 0)) {
        self.infoMissingCount   = self.infoMissingCount - 1;
        self.locationLabel.text = self.addressString;
        self.tickLocation.image = [UIImage imageNamed:@"TickCircleYellow"];
    }
    if (!(self.descriptionString.length == 0)) {
        self.infoMissingCount      = self.infoMissingCount - 1;
        self.descriptionLabel.text = self.descriptionString;
        self.tickDescription.image = [UIImage imageNamed:@"TickCircleYellow"];
    }
    if (!([self.locComsString length] == 0)) {
        self.locationComs.text      = self.locComsString;
        self.tickLocationComs.image = [UIImage imageNamed:@"TickCircleYellow"];
    }
    [self configurePreviewButton];
}


#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    } else {
        return 20.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            Title_vc *titleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TitleID"];
            [titleVC setSegueIDString:@"OverviewToTitle"];
            [self.navigationController pushViewController:titleVC animated:YES];
            
        } else if (indexPath.row == 1) {
            Image_vc *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageID"];
            [imageVC setSegueIDString:@"OverviewToImage"];
            [self.navigationController pushViewController:imageVC animated:YES];
            
        } else if (indexPath.row == 2) {
            [self performSegueWithIdentifier:@"OverviewToDescription" sender:self];
        }
    }
}

#pragma mark - TableView Footer

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static UIView *footerView;
    if (footerView != nil)
        return footerView;
    
    if (section == 2) {
        static UIView *footerView;
        if (footerView != nil)
            return footerView;
        
        //    NSString *footerText = NSLocalizedString(@"Your input is saved automatically", nil);
        
        float footerWidth            = 200.0f;
        footerView                   = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, footerWidth, 40.0)];
        footerView.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
        
        UILabel *footerLabel         = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, footerWidth - 20, 20.0)];
        footerLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        footerLabel.textAlignment    = NSTextAlignmentCenter;
        footerLabel.font             = [UIFont fontWithName:@"GillSans" size:12.0];
        footerLabel.textColor        = [UIColor lightGrayColor];
        footerLabel.text             = @"Your input is saved automatically";
        
        [footerView addSubview:footerLabel];
        return footerView;
    } else {
        return nil;
    }
}

#pragma mark - Navigation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect frame    = self.previewButton.frame;
    frame.origin.y  = scrollView.contentOffset.y + self.tableView.frame.size.height - self.previewButton.frame.size.height;
    self.previewButton.frame = frame;
    
    [self.view bringSubviewToFront:self.previewButton];
}

- (void)configurePreviewButton {
    
    if (self.infoMissingCount > 0) {
        NSString *buttonTitle = [NSString stringWithFormat:@"%d items left", infoMissingCount];
        [self.previewButton setTitle: buttonTitle forState: UIControlStateNormal];
    
    } else {
        NSString *buttonTitle   = @"Preview";
        UIColor *btnNormalColor = [UIColor colorWithRed:(242/255.0) green:(202/255.0) blue:(41/255.0) alpha:1];
        [self.previewButton setTitle: buttonTitle forState: UIControlStateNormal];
        [self.previewButton setBackgroundColor:btnNormalColor];
        [self.previewButton addTarget:self action:@selector(showPreviewPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.previewButton];
}

- (IBAction)showPreviewPressed:(id)sender {
    NSLog(@"preview it is");
    [self performSegueWithIdentifier:@"OverviewToPreview" sender:self];
}

- (IBAction)closePressed:(id)sender {
    StartScreen_vc *start_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartScreen_ID"];
    [self.navigationController pushViewController:start_vc animated:NO];
}
@end
