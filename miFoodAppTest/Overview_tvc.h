//
//  Overview_tvc.h
//  
//
//  Created by Fabian Jenne on 23.10.15.
//
//

#import <UIKit/UIKit.h>

@interface Overview_tvc : UITableViewController

// labels
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationComs;

// tickBoxes
@property (strong, nonatomic) IBOutlet UIImageView *tickDetails;
@property (strong, nonatomic) IBOutlet UIImageView *tickLocation;
@property (strong, nonatomic) IBOutlet UIImageView *tickDescription;
@property (strong, nonatomic) IBOutlet UIImageView *tickLocationComs;

// singleton properties
@property (strong, nonatomic) UIImage  *coverImage;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *descriptionString;
@property (strong, nonatomic) NSString *addressString;
@property (strong, nonatomic) NSString *locComsString;
@property (strong, nonatomic) NSDate   *pickUpDate;
@property (assign) int menuCount;
@property (assign) double pickUpTime;
@property (assign) double menuPrice;

// navigation
- (IBAction)showPreviewPressed:(id)sender;
- (IBAction)closePressed:(id)sender;

// submitButton
@property (nonatomic, strong) UIButton *previewButton;
@property (assign) int infoMissingCount;
- (void)configurePreviewButton;




@end
