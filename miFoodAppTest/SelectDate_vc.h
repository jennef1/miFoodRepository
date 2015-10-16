//
//  SelectDate_vc.h
//  miFoodAppTest
//
//  Created by Fabian Jenne on 15.09.15.
//  Copyright (c) 2015 Fabian Jenne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>


@interface SelectDate_vc : UIViewController <UIPickerViewDelegate, JTCalendarDelegate>

@property (strong, nonatomic) NSDate *selectedDate;

// dateLabel configs
@property (strong, nonatomic) IBOutlet UILabel *dateNumber;
@property (strong, nonatomic) IBOutlet UILabel *dateDay;
@property (strong, nonatomic) IBOutlet UILabel *dateMonthYY;
- (void)configureLabelsWithDate:(NSDate *)date;

// JTCalendar
@property (strong, nonatomic) IBOutlet JTCalendarMenuView     *jtMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *jtCalendar;
@property (strong, nonatomic) JTCalendarManager *calendarManager;

// navigation
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end
