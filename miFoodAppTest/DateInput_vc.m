//
//  DateInput_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 03.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "DateInput_vc.h"
#import "Singleton.h"
#import "StartScreen_vc.h"

@interface DateInput_vc ()

@end

@implementation DateInput_vc

@synthesize selectedDate, selectedTime, initialTime;

- (void)viewDidLoad {
    
    // TODO: check for previously offered menues and give the option to pick them directly (with editing if needed)
    
    [super viewDidLoad];
   
    self.initialTime = 11.5;
    
    [self convertNumberToMinutes:self.initialTime];
    [self configureLabelsWithDate:[NSDate date]];
    
    [self.datePicker setMinimumDate: [NSDate date]];
    [self.datePicker setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter   setDateFormat:@"dd.MMM yy  @ HH:mm"];
//    NSString *strDate = [dateFormatter stringFromDate:self.datePicker.date];
//    self.date_tf.text = strDate;
    
//    UIColor *bordercolor = [UIColor colorWithRed:(61/255.0) green:(217/255.0) blue:(196/255.0) alpha:1];
//    [self.date_tf.layer setBorderColor:[bordercolor CGColor]];
//    [self.date_tf.layer setBorderWidth:0.9];
//    [self.date_tf.layer setCornerRadius:4];
//    [self.date_tf setClipsToBounds:YES];
    
    
    
    UIColor *buttonColor = [UIColor colorWithRed:(255/255.0) green:(211/255.0) blue:(41/255.0) alpha:1];
    [self.nextButton setBackgroundColor: buttonColor];
    [self.nextButton setTitle:@"next" forState:UIControlStateNormal];

    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    // configure swipeGesture
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    UISwipeGestureRecognizer *leftSwipe  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.swipeView addGestureRecognizer:rightSwipe];
    [self.swipeView addGestureRecognizer:leftSwipe];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - SwipeGesture & Animation

- (void)didSwipe:(UISwipeGestureRecognizer *)sender {
    
    UISwipeGestureRecognizerDirection direction = sender.direction;
    NSDateComponents *dayComponent = [[NSDateComponents alloc]init];
    
    if (direction == UISwipeGestureRecognizerDirectionRight) {
        dayComponent.day = -1;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.dateNumber.transform = CGAffineTransformMakeTranslation(30, 0);
                             self.dateNumber.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                             NSDate *nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent
                                                                                              toDate:self.selectedDate
                                                                                             options:0];
                             [self configureLabelsWithDate:nextDate];
                             self.dateNumber.transform = CGAffineTransformMakeTranslation(-45, 0);
                             
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  self.dateNumber.transform = CGAffineTransformMakeTranslation(0,0);
                                                  self.dateNumber.alpha = 1;
                                              } completion:nil];
                         }];
        
    } else if (direction == UISwipeGestureRecognizerDirectionLeft) {
        dayComponent.day = 1;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.dateNumber.transform = CGAffineTransformMakeTranslation(-30, 0);
                             self.dateNumber.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                             NSDate *nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent
                                                                                              toDate:self.selectedDate
                                                                                             options:0];
                             [self configureLabelsWithDate:nextDate];
                             self.dateNumber.transform = CGAffineTransformMakeTranslation(45, 0);
                             
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  self.dateNumber.transform = CGAffineTransformMakeTranslation(0,0);
                                                  self.dateNumber.alpha = 1;
                                              } completion:nil];
                         }];
    }

}

#pragma mark - UIDatePicker & DateLabel

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    [self configureLabelsWithDate:datePicker.date];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd.MMM yy  @ HH:mm"];
//    NSString *strDate     = [dateFormatter stringFromDate:datePicker.date];
//    self.date_tf.text     = strDate;
}

- (void)configureLabelsWithDate:(NSDate *)date {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date];
    NSInteger day = [components day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat       = @"MMMM / yyyy";
    NSString *monthYearString      = [[dateFormatter stringFromDate:date] capitalizedString];
    
    dateFormatter.dateFormat       = @"EEEE";
    NSString *dayString            = [[dateFormatter stringFromDate:date] capitalizedString];
    
    self.dateNumber.text   = [NSString stringWithFormat:@"%ld", (long)day];
    self.dateDay.text      = dayString;
    self.dateMonthYY.text  = monthYearString;
    
    self.selectedDate = date;
}

#pragma mark - TimeButtons +/-

- (IBAction)plusPressed:(id)sender {
    
    if (self.initialTime < 23.5) {
        self.initialTime = self.initialTime + 0.5;
        [self convertNumberToMinutes:self.initialTime];
    } else {
        self.initialTime = 23.5;
    }
}

- (IBAction)minusPressed:(id)sender {
    
    if (self.initialTime > 1.0) {
        self.initialTime = self.initialTime - 0.5;
        [self convertNumberToMinutes:self.initialTime];
    } else {
        self.initialTime = 1.0;
    }
}

- (void)convertNumberToMinutes:(double)number {
    
    double hour;
    double minutes = modf(number, &hour);
    NSString *hourStr    = [NSString stringWithFormat:@"%.0f",hour];
    
    if (minutes == 0) {
        NSString *timeString = [NSString stringWithFormat:@"%@:00",hourStr];
        self.timeLabel.text  = timeString;
    
    } else {
        NSString *timeString = [NSString stringWithFormat:@"%@:30",hourStr];
        self.timeLabel.text  = timeString;
    }
}

#pragma mark - Navigation

- (IBAction)nextPressed:(id)sender {
    Singleton *mySingleton  = [Singleton sharedSingleton];
    mySingleton.singl_date  = self.selectedDate;
}

- (IBAction)cancelPressed:(id)sender {
    StartScreen_vc *start_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartScreen_ID"];
    [self.navigationController pushViewController:start_vc animated:NO];
}

@end
