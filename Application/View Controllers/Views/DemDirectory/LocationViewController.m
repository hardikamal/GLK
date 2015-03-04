//
//  LocationViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 20/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "LocationViewController.h"
#import "DBManager.h"
@interface LocationViewController ()
@property (nonatomic, strong) DBManager *dbManager;
@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"demservices.sqlite"];
    NSString*   query = @" SELECT DISTINCT location from dem_food";
    NSArray *array= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    self.transcationItems=[[NSMutableArray alloc] init];
    for (int i=0; i<[array count]; i++)
    {
        [self.transcationItems addObject:[[array objectAtIndex:i] objectAtIndex:0]];
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transcationItems count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell.textLabel setText:[self.transcationItems objectAtIndex:[indexPath row]]];
    [cell.imageView setImage:[UIImage imageNamed:@"radial_button_active@3x.png"]];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.imageView.image=[UIImage imageNamed:@"radial_button_active.png"];
    [Utility saveToUserDefaults:[self.transcationItems objectAtIndex:indexPath.row] withKey:CURRENT_CITY];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)popover:(UITapGestureRecognizer*)sender
{
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;
    UIImageView *imageView = (UIImageView *)recognizer.view;
    imageView.image=[UIImage imageNamed:@"radial_button_active.png"];
    [Utility saveToUserDefaults:[self.transcationItems objectAtIndex:imageView.tag] withKey:CURRENT_CITY];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnBackClick:(id)sender
{
    if ([[Utility userDefaultsForKey:CURRENT_CITY] length]==0)
    {
        [Utility saveToUserDefaults:[self.transcationItems objectAtIndex:0] withKey:CURRENT_CITY];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end
