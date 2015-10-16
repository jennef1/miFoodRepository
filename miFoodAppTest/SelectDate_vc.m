//
//  SelectDate_vc.m
//  miFoodAppTest
//
//  Created by Fabian Jenne on 15.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import "SelectDate_vc.h"
#import "StartScreen_vc.h"
#import "Singleton.h"

@interface SelectDate_vc ()

@end

@implementation SelectDate_vc

@synthesize selectedDate;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendarManager          = [JTCalendarManager new];
    self.calendarManager.delegate = self;
    
    [self.calendarManager setMenuView:self.jtMenuView];
    [self.calendarManager setContentView:self.jtCalendar];
    [self.calendarManager setDate:[NSDate date]];
    
    // TODO: adjust height of calendar & Check if font can be increased
    self.calendarManager.settings.weekModeEnabled = YES;
    [self.calendarManager reload];
    
    [self configureLabelsWithDate:[NSDate date]];
    
//    UIColor *buttonColor = [UIColor colorWithRed:(255/255.0) green:(211/255.0) blue:(41/255.0) alpha:1];
    UIColor *buttonColor = [UIColor colorWithRed:(231/255.0) green:(48/255.0) blue:(40/255.0) alpha:1];
    [self.nextButton setBackgroundColor: buttonColor];
    [self.nextButton setTitle:@"next" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - JTCalendar Delegate

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    
    dayView.hidden = NO;
    
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([self.calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden           = NO;
        dayView.circleView.backgroundColor  = [UIColor blueColor];
        dayView.dotView.backgroundColor     = [UIColor whiteColor];
        dayView.textLabel.textColor         = [UIColor whiteColor];
    }
    // Selected date
    else if(self.selectedDate && [self.calendarManager.dateHelper date:self.selectedDate isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden           = NO;
        dayView.circleView.backgroundColor  = [UIColor redColor];
        dayView.dotView.backgroundColor     = [UIColor whiteColor];
        dayView.textLabel.textColor         = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden       = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor     = [UIColor blackColor];
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView {
    
    if ([self.calendarManager.dateHelper date:dayView.date isEqualOrAfter:[NSDate date]]) {
        self.selectedDate = dayView.date;
        [self configureLabelsWithDate:dayView.date];

    } else {
        NSLog(@"that s in the past dude...");
        dayView.date = [NSDate date];
        [self.calendarManager reload];
    }
    
    // circleView annimation
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [self.calendarManager reload];
                    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    if(![self.calendarManager.dateHelper date:self.jtCalendar.date isTheSameMonthThan:dayView.date]) {
        if([self.jtCalendar.date compare:dayView.date] == NSOrderedAscending) {
            [self.jtCalendar loadNextPageWithAnimation];
        }
        else {
            [self.jtCalendar loadPreviousPageWithAnimation];
        }
    }
}

- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date {
    
    return [self.calendarManager.dateHelper date:date isEqualOrAfter:[NSDate date]];
}

//#pragma mark - UIDatePicker
//
//- (void)datePickerChanged:(UIDatePicker *)datePicker
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd.MMM yy"];
//    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
//    self.date_tf.text = strDate;
//}

#pragma mark - DateLabel Configuration

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
}

#pragma mark - Navigation

- (IBAction)nextPressed:(id)sender {
    Singleton *mySingleton     = [Singleton sharedSingleton];
    mySingleton.singl_findDate = self.selectedDate;
}

- (IBAction)cancelPressed:(id)sender {
    StartScreen_vc *start_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartScreen_ID"];
    [self.navigationController pushViewController:start_vc animated:NO];
}


@end
