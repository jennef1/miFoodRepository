//
//  MainDetails_vc.h
//  
//
//  Created by Fabian Jenne on 28.10.15.
//
//

#import <UIKit/UIKit.h>

@interface MainDetails_vc : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// date
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) IBOutlet UILabel *dayIndicator;
@property (strong, nonatomic) IBOutlet UILabel *dateNumber;
@property (strong, nonatomic) IBOutlet UILabel *dateDay;
@property (strong, nonatomic) IBOutlet UILabel *dateMMMYY;

- (void)configureLabelsWithDate:(NSDate *)dateInput;
- (IBAction)datePlusPressed:(id)sender;
- (IBAction)dateMinusPressed:(id)sender;

// pickupTime
@property (assign) int timeCounter;
@property (nonatomic) double initialTime;
@property (strong, nonatomic) NSDate *selectedTime;
@property (strong, nonatomic) IBOutlet UILabel *timeHour;
@property (strong, nonatomic) IBOutlet UILabel *timeMinutes;

- (void)configureLabelsWithTimenumber:(double)number;
- (IBAction)timePlussPressed:(id)sender;
- (IBAction)timeMinusPressed:(id)sender;

// menuAmount
@property (assign) int menuCounter;
@property (strong, nonatomic) IBOutlet UILabel *menuAmount;
- (IBAction)menuPlussPressed:(id)sender;
- (IBAction)menuMinusPressed:(id)sender;

// price
@property (assign) double foodPrice;
@property (strong, nonatomic) IBOutlet UITextField *priceTF;
- (void)hideKeyboardForPriceTF:(id)sender;

// keyboardNotifications
- (void)registerForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;

// navigation
- (IBAction)backPressed:(id)sender;



@end
