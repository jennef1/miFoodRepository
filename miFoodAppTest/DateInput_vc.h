//
//  DateInput_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 03.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateInput_vc : UIViewController <UIPickerViewDelegate>

// date selection
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDate *selectedTime;

@property (strong, nonatomic) IBOutlet UILabel *dateNumber;
@property (strong, nonatomic) IBOutlet UILabel *dateDay;
@property (strong, nonatomic) IBOutlet UILabel *dateMonthYY;
- (void)configureLabelsWithDate:(NSDate *)date;

// time selection
@property (strong, nonatomic) IBOutlet UITextField *timeBox;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) double initialTime;
- (IBAction)plusPressed:(id)sender;
- (IBAction)minusPressed:(id)sender;
- (void)convertNumberToMinutes:(double)number;

// navigation
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

// swipe test area
@property (strong, nonatomic) IBOutlet UIView *swipeView;
- (void)didSwipe:(UISwipeGestureRecognizer *)sender;

- (void)datePickerChanged:(UIDatePicker *)datePicker;

@end
