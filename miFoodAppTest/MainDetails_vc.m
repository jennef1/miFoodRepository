//
//  MainDetails_vc.m
//  
//
//  Created by Fabian Jenne on 28.10.15.
//
//

#import "MainDetails_vc.h"
#import "Singleton.h"

@interface MainDetails_vc ()

@end

@implementation MainDetails_vc

@synthesize selectedDate, selectedTime, timeCounter, initialTime, menuCounter, foodPrice;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: pickup time: from - till
    
    // TODO: by when do you need to know (evening before, doesnt matter, time)
    
    Singleton *mySingleton  = [Singleton sharedSingleton];
    NSDate *singlDate       = [[NSDate alloc]init];
    singlDate               = mySingleton.singl_date;
    double singlTime        = mySingleton.singl_pickupTime;
    int singlMenuCount      = mySingleton.singl_quantity;
    double singlPrice       = mySingleton.singl_price;
    
    if (singlDate == nil) {
        self.selectedDate = [NSDate date];
    } else {
        self.selectedDate = singlDate;
    }
    
    if (singlTime > 0) {
        self.initialTime = singlTime;
    } else {
        self.initialTime = 11.5;
    }
    
    if (singlMenuCount > 0) {
        self.menuCounter = singlMenuCount;
    } else {
        self.menuCounter = 5;
    }
    
    if (singlPrice > 0) {
        self.priceTF.text = [NSString stringWithFormat:@"%.2f", singlPrice];
    } else {
        self.priceTF.text   = @"0.00";
    }
    
    UIView *spacerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.priceTF setLeftViewMode:UITextFieldViewModeAlways];
    [self.priceTF setLeftView:spacerView];
    
    UIColor *bordercolor   = [UIColor colorWithRed:(254/255.0) green:(221/255.0) blue:(11/255.0) alpha:1];
    self.priceTF.textColor = [UIColor darkGrayColor];
    [self.priceTF.layer setBorderColor:[bordercolor CGColor]];
    [self.priceTF.layer setBorderWidth:1.0];
    [self.priceTF.layer setCornerRadius:4];
    [self.priceTF setClipsToBounds:YES];
    self.priceTF.delegate = self;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] init];
    [singleTap addTarget:self action:@selector(hideKeyboardForPriceTF:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.scrollView addGestureRecognizer:singleTap];
    
    [self configureLabelsWithDate:self.selectedDate];
    [self configureLabelsWithTimenumber:self.initialTime];
    [self registerForKeyboardNotifications];
    self.menuAmount.text = [NSString stringWithFormat:@"%i", self.menuCounter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - DateConfig

- (void)configureLabelsWithDate:(NSDate *)dateInput {
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day               = 1;
    NSDate *tomorrow               = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    NSDateFormatter *checkFormat = [[NSDateFormatter alloc] init];
    checkFormat.dateFormat       = @"dd.MM.yyyy";
    NSString *dateInputString    = [[checkFormat stringFromDate:dateInput] capitalizedString];
    NSString *todaySting         = [[checkFormat stringFromDate:[NSDate date]] capitalizedString];
    NSString *tommorrowSting     = [[checkFormat stringFromDate:tomorrow] capitalizedString];
    
    if ([dateInputString isEqualToString:todaySting]) {
        self.dayIndicator.text = @"today";
    } else if ([dateInputString isEqualToString:tommorrowSting]) {
        self.dayIndicator.text = @"tomorrow";
    } else {
        self.dayIndicator.text = @"";
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:dateInput];
    NSInteger day = [components day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat       = @"MMMM / yyyy";
    NSString *monthYearString      = [[dateFormatter stringFromDate:dateInput] capitalizedString];
    dateFormatter.dateFormat       = @"EEEE";
    NSString *dayString            = [[dateFormatter stringFromDate:dateInput] capitalizedString];
    
    self.dateNumber.text = [NSString stringWithFormat:@"%ld", (long)day];
    self.dateDay.text    = dayString;
    self.dateMMMYY.text  = monthYearString;
}

- (IBAction)datePlusPressed:(id)sender {
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day     = 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nextDate     = [calendar dateByAddingComponents:dayComponent toDate:self.selectedDate options:0];
    self.selectedDate    = nextDate;
    
    [self configureLabelsWithDate:self.selectedDate];
}

- (IBAction)dateMinusPressed:(id)sender {

    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day     = -1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *previousDate = [calendar dateByAddingComponents:dayComponent toDate:self.selectedDate options:0];
    
    if ([previousDate compare:[NSDate date]]== NSOrderedAscending ) {
        NSLog(@"that's in the past");
        self.selectedDate = [NSDate date];
    } else {
        self.selectedDate    = previousDate;
    }
    [self configureLabelsWithDate:self.selectedDate];
}

#pragma mark - TimeConfig

- (void)configureLabelsWithTimenumber:(double)number {
    
    double hour;
    double minutes     = modf(number, &hour);
    NSString *hourStr  = [NSString stringWithFormat:@"%.0f",hour];
    self.timeHour.text = hourStr;
    
    if (minutes == 0) {
        self.timeMinutes.text = [NSString stringWithFormat:@" :00"];
    } else {
        self.timeMinutes.text = [NSString stringWithFormat:@" :30"];
    }
}

- (IBAction)timePlussPressed:(id)sender {
    
    if (self.initialTime < 23.5) {
        self.initialTime = self.initialTime + 0.5;
        [self configureLabelsWithTimenumber:self.initialTime];
    } else {
        self.initialTime = 23.5;
    }
}

- (IBAction)timeMinusPressed:(id)sender {
    
    if (self.initialTime > 1.0) {
        self.initialTime = self.initialTime - 0.5;
        [self configureLabelsWithTimenumber:self.initialTime];
    } else {
        self.initialTime = 1.0;
    }
}

#pragma mark - MenuConfig

- (IBAction)menuPlussPressed:(id)sender {
    self.menuCounter     = self.menuCounter + 1;
    self.menuAmount.text = [NSString stringWithFormat:@"%i", self.menuCounter];
}

- (IBAction)menuMinusPressed:(id)sender {
    self.menuCounter = self.menuCounter - 1;
    if (self.menuCounter < 0) {
        self.menuCounter = 0;
    }
    self.menuAmount.text = [NSString stringWithFormat:@"%i", self.menuCounter];
}

#pragma mark - PriceTF Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.priceTF) {
        
        // TODO: Check why app crashes after you press "return" key on keyboard when more then two digits already entered before
        // Currency, two digits, start entry from back
        NSString *text  = [textField.text stringByReplacingCharactersInRange:range withString:string];
        text            = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
        double number   = [text intValue] * 0.01;
        textField.text  = [NSString stringWithFormat:@"%.2lf", number];
        
       // NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return NO;
    }
    return YES;
}

- (void)hideKeyboardForPriceTF:(id)sender {
    [self.priceTF resignFirstResponder];
}

#pragma mark - Keyboard Notificaiton

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize      = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets   = UIEdgeInsetsMake(0.0, 0.0, (kbSize.height + 50), 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // TODO: add extra space so scrollview scrolls 50px above keyboard and not just only above keyboard
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect       = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.priceTF.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (self.priceTF.frame.origin.y - kbSize.height));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Navigation

- (IBAction)backPressed:(id)sender {
    
    // Convert Price string to double
    NSString *priceStringTrim = [self.priceTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.foodPrice            = [priceStringTrim doubleValue];
    
    if (self.foodPrice == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No price" message:@"Your meal is currently for free"
                                                           delegate:self cancelButtonTitle:@"change price" otherButtonTitles:@"it's free" ,nil];
        [alertView show];
    } else {
        // Store variables globally
        Singleton *mySingleton       = [Singleton sharedSingleton];
        mySingleton.singl_date       = self.selectedDate;
        mySingleton.singl_pickupTime = self.initialTime;
        mySingleton.singl_quantity   = self.menuCounter;
        mySingleton.singl_price      = self.foodPrice;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) { // "change price"
        [self.priceTF becomeFirstResponder];
    
    } else if (buttonIndex == 1) { // "it's free"
        // Store variables globally
        Singleton *mySingleton       = [Singleton sharedSingleton];
        mySingleton.singl_date       = self.selectedDate;
        mySingleton.singl_pickupTime = self.initialTime;
        mySingleton.singl_quantity   = self.menuCounter;
        mySingleton.singl_price      = self.foodPrice;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
