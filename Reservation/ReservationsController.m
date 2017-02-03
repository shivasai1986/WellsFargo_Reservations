//
//  ReservationsController.m
//  Reservation
//
//  Created by Shiva Sai Rudra on 31/01/17.
//  Copyright © 2017 Shiva. All rights reserved.
//

#import "ReservationsController.h"
#import "ReservationCell.h"

@interface ReservationsController ()

@end

@implementation ReservationsController

NSMutableArray *arrData;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Fetch array of Reservations made from NSUserDefaults and reload the Reservations table
    arrData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyReservations"];
    _tblReservations.dataSource = self;
    _tblReservations.delegate = self;
    [_tblReservations reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrData.count;    //count number of row from counting array hear cataGorry is An Array
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 240;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *MyIdentifier = @"MyIdentifier";
    
    ReservationCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[ReservationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    //Get dictionary from Reservations array and buil cell data
    NSDictionary *dict = arrData[indexPath.row];
    
    cell.lblDate.text = dict[@"Date"];
    cell.lblTime.text = dict[@"Time"];
    cell.lblServiceName.text = dict[@"ServiceName"];
    cell.lblPartySize.text = dict[@"PartySize"];
    cell.lblDuration.text = dict[@"Duration"];
    cell.lblDescription.text = dict[@"Description"];
    
    return cell;
}


@end
