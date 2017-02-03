//
//  ScheduleViewController.m
//  Reservation
//
//  Created by Shiva Sai Rudra on 01/02/17.
//  Copyright © 2017 Shiva. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleDateCell.h"
#import "AvailableTimeCell.h"
#import <IonIcons.h>

@interface ScheduleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property(nonatomic, strong) NSMutableArray *datesThisMonth;
@property(nonatomic, strong) NSMutableArray *timesOfTheDay;
@property (weak, nonatomic) IBOutlet UICollectionView *scheduleDateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *availableTimeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceName;


@end

@implementation ScheduleViewController

ScheduleDateCell *selectedDateCell;
NSInteger SelectedDateIndex;
AvailableTimeCell *selectedTimeCell;
NSInteger SelectedTimeIndex;

NSArray *pickerData;
NSString *selectedPartySize;

@synthesize ServiceName;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblServiceName.text = @"Hot Stone Massage";
    
    //Get date and calender objects to calculate date parts and components
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    //Creating instance for _datesThisMonth array to bind thedates schedule cell.
    _datesThisMonth = [NSMutableArray array];
    NSRange rangeOfDaysThisMonth = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:today];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    //Getting Month, MonthName and Year using date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSDateFormatter *monthNameFormatter = [[NSDateFormatter alloc] init];
    //NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d"];
    NSInteger date = [[dateFormatter stringFromDate:today] integerValue];
    
    [dateFormatter setDateFormat: @"yyyy"];
    NSInteger year = [[dateFormatter stringFromDate: today] integerValue];
    
    [dateFormatter setDateFormat: @"M"];
    NSInteger month = [[dateFormatter stringFromDate: today] integerValue];
    
    [components setYear:year];
    [components setMonth:month];
    
    //Loop through the remaining months in this year and add them to dates array
    for (NSInteger i = date; i <= rangeOfDaysThisMonth.length; ++i) {
        [components setDay:i];
        NSDate *dayInMonth = [cal dateFromComponents:components];
        [_datesThisMonth addObject:dayInMonth];
    }
    
    //Setting lable to current month
    [dateFormatter setDateFormat: @"MMMM"];
    self.lblMonth.text =[[dateFormatter stringFromDate: today] uppercaseString];
    
    _timesOfTheDay = [NSMutableArray array];
    
    //Setting button party border and round corner
    _btnPartySize.layer.borderColor = [UIColor blueColor].CGColor;
    _btnPartySize.layer.cornerRadius = 5;
    _btnPartySize.layer.borderWidth = 1.0;
    
    //Initializing picker data to bind the picker for Party Size
    pickerData = @[@"1",@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
}

-(void)viewWillAppear:(BOOL)animated
{
    SelectedDateIndex = -1;
    SelectedTimeIndex = -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Source methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    NSInteger cellCount = 0;
    
    //Condition based collection view handling for two collection views namely date and time
    if([collectionView isEqual:_scheduleDateCollectionView])
        cellCount = [_datesThisMonth count];
    else if([collectionView isEqual:_availableTimeCollectionView])
        cellCount = [_timesOfTheDay count];
    
    return cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //Condition based collection view handling for two collection views namely date and time
    if([collectionView isEqual:_scheduleDateCollectionView]){
        NSString *MyIdentifier = @"scCell";
        ScheduleDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdentifier forIndexPath:indexPath];
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 1.0;
        
        //Fetch date from dates array and set day and day of the week
        NSDate *date = _datesThisMonth[indexPath.row];
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat: @"d"];
        NSString *day = [dayFormatter stringFromDate: date];
        NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
        [weekdayFormatter setDateFormat: @"EEE"];
        NSString *weekday = [[weekdayFormatter stringFromDate: date] uppercaseString];
        
        cell.lblDay.text = day;
        cell.lblDayOfTheWeek.text = weekday;
        
        return cell;
    }
    else if([collectionView isEqual:_availableTimeCollectionView]){
        NSString *MyIdentifier = @"atCell";
        AvailableTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdentifier forIndexPath:indexPath];
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 1.0;
        
        NSDate *date = _timesOfTheDay[indexPath.row];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat: @"hh:mm a"];
        
        cell.lblTime.text = [[timeFormatter stringFromDate:date] uppercaseString];
        
        return cell;
    }
    else{
        return [[UICollectionViewCell alloc] init];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([collectionView isEqual:_scheduleDateCollectionView]){
        ScheduleDateCell *cell = (ScheduleDateCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        //Bind the Available time collection view for selected cell
        if(cell.isSelected){
            SelectedDateIndex = indexPath.row;
            [self bindAvailableTimes:indexPath.row!=0];
        }
        else{
            SelectedTimeIndex = indexPath.row;
            _timesOfTheDay = nil;
            [_availableTimeCollectionView reloadData];
        }
    }
    else{
        SelectedTimeIndex = indexPath.row;
    }
}

//Method used to bind available times
-(void)bindAvailableTimes:(BOOL)FullDay
{
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"H"];
    NSInteger hour = [[dateFormatter stringFromDate: today] integerValue];
    
    _timesOfTheDay = [NSMutableArray array];
    
    //Get the range of hours in a day
    NSRange rangeOfHoursThisDay = [cal rangeOfUnit:NSCalendarUnitHour inUnit:NSCalendarUnitDay forDate:today];
    
    if(!FullDay){
        for (NSInteger i = hour+1; i <= rangeOfHoursThisDay.length - 1; ++i) {
            [components setHour:i];
            NSDate *timeInDay = [cal dateFromComponents:components];
            [_timesOfTheDay addObject:timeInDay];
        }
    }
    else{
        for (NSInteger i = rangeOfHoursThisDay.location; i <= rangeOfHoursThisDay.length - 1; ++i) {
            [components setHour:i];
            NSDate *timeInDay = [cal dateFromComponents:components];
            [_timesOfTheDay addObject:timeInDay];
        }
    }
    
    //Deselect the previously selecte cell by it's tag
    [[selectedTimeCell viewWithTag:111] removeFromSuperview];
    selectedTimeCell = nil;
    [_availableTimeCollectionView reloadData];
}

- (IBAction)btnPartySize_TouchUpInside:(id)sender {
    //Show the picker view and picker view buttons upon party size selected
    _pickerButtonView.hidden = NO;
    _partySizePickerView.hidden = NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    return pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    selectedPartySize = pickerData[row];
}

- (IBAction)btnCancelPickerView:(id)sender {
    _pickerButtonView.hidden = YES;
    _partySizePickerView.hidden = YES;
}

- (IBAction)btnDonePickerView:(id)sender {
    _pickerButtonView.hidden = YES;
    _partySizePickerView.hidden = YES;
    [_btnPartySize setTitle:selectedPartySize forState:UIControlStateNormal];
}

- (IBAction)btnReserve_TouchUpInside:(id)sender {
    
    //Throw alert messages when Date or Time is not selected, nee to change these to constants for better maintainablility
    if (SelectedDateIndex == -1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Select Date" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    if (SelectedTimeIndex == -1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Select Time" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //Prepare dictionary with selected inputs
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSDate *selectedDate = _datesThisMonth[SelectedDateIndex];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
    
    //Binging service name statically now, but ideally need to get from previous screen
    dict[@"ServiceName"] = @"Hot Stone Massage";
    dict[@"Date"] = [dateFormatter stringFromDate:selectedDate];
    NSDate *date = _timesOfTheDay[SelectedTimeIndex];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat: @"hh:mm a"];
    
    dict[@"Time"] = [timeFormatter stringFromDate:date];
    dict[@"PartySize"] = _btnPartySize.titleLabel.text;
    dict[@"Duration"] = @"30M";
    dict[@"Description"] = @"Get the upper hand with our chip-resistant, mirror-finish get polish that requires no drying time and last up to two weeks.";
    
    //Get array from NSUserDefaults and instantiate if nil
    NSMutableArray *arrData = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"MyReservations"]];
    
    if(!arrData)
    {
        arrData = [NSMutableArray array];
    }
    
    [arrData addObject:dict];
    
    //Ad array to NSUserDefaults an synchronize
    [[NSUserDefaults standardUserDefaults] setObject:arrData forKey:@"MyReservations"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
