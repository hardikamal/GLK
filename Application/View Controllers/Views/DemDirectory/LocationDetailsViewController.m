//
//  LocationDetailsViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 20/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "LocationDetailsViewController.h"
#import "DBManager.h"
#import "LocationDetailsViewController.h"
#import "DemCell.h"
@interface LocationDetailsViewController ()
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation LocationDetailsViewController


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
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    self.transcationItems =[[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}




-(void)viewWillAppear:(BOOL)animated
{
   // [self.lblLocation setText:[Utility userDefaultsForKey:CURRENT_CITY]];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"demservices.sqlite"];
     NSArray *stringarray =[NSLocalizedString(@"app_manager", nil) componentsSeparatedByString:@","];
    
   
    NSArray *array;
    NSString *query;
    switch ((int)self.index)
	{
        case 0:
            query = [NSString stringWithFormat:@"select * from dem_cab where  location= '%@'",[Utility userDefaultsForKey:CURRENT_CITY]];
            //query = @"select * from dem_cab";
            array= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            break;
        case 1:
             query = [NSString stringWithFormat:@"select * from dem_travel where  location= '%@'",[Utility userDefaultsForKey:CURRENT_CITY]];
           array= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            break;
        case 2:
            query = [NSString stringWithFormat:@"select * from dem_recharge where  location=  '%@' ", [Utility userDefaultsForKey:CURRENT_CITY]];
           array= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            break;
        case 3:
              query = [NSString stringWithFormat:@"select * from dem_shopping where  location=  '%@' ", [Utility userDefaultsForKey:CURRENT_CITY]];
           array= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            break;
        case 4:
            query = [NSString stringWithFormat:@"select * from dem_food where  location=  '%@' ", [Utility userDefaultsForKey:CURRENT_CITY]];
           array= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            break;
        case 5:
             query = [NSString stringWithFormat:@"select * from dem_enter where  location=  '%@' ", [Utility userDefaultsForKey:CURRENT_CITY]];
           array = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            break;
	}
    
    if ([array count]==0)
    {
        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, self.view.frame.size.height/2, 300, 60)];
        fromLabel.text =@"No Result";
        fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        fromLabel.backgroundColor = [UIColor clearColor];
        fromLabel.textColor = [UIColor lightGrayColor];
        fromLabel.textAlignment = NSTextAlignmentLeft;
    
        [fromLabel setFont:[UIFont fontWithName:Embrima size:30.0f]];
        [self.view addSubview:fromLabel];
        [self.tblView setHidden:YES];
    }
   // NSLog(@"%@",array);
    for (int i=0; i<[array count]; i++)
    {
        NSInteger indexOfLastname;
        indexOfLastname =  [self.dbManager.arrColumnNames indexOfObject:@"phone_no"];
        NSString *string  =[[[[array objectAtIndex:i] objectAtIndex:indexOfLastname] componentsSeparatedByString:@","] objectAtIndex:0];
        indexOfLastname =  [self.dbManager.arrColumnNames indexOfObject:@"app_link"];
        NSString *applink =[[array objectAtIndex:i] objectAtIndex:indexOfLastname];
        if ([string length]==0 && [applink length]==0)
        {
            
        }else
        {
            [self.transcationItems addObject:[array objectAtIndex:i]];
        }
    }
    [self.tblView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transcationItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemCell *cell = (DemCell*)[tableView dequeueReusableCellWithIdentifier:@"Location"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"service_name"];
    
    cell.lbluserName.text=[[self.transcationItems objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname];
    NSInteger indexOfLastname;
    indexOfLastname =  [self.dbManager.arrColumnNames indexOfObject:@"phone_no"];
    NSString *string  =[[[[self.transcationItems objectAtIndex:indexPath.row] objectAtIndex:indexOfLastname] componentsSeparatedByString:@","] objectAtIndex:0];
    indexOfLastname =  [self.dbManager.arrColumnNames indexOfObject:@"app_link"];
    NSString *applink =[[self.transcationItems objectAtIndex:indexPath.row] objectAtIndex:indexOfLastname];
    [cell.btnCall setTag:indexPath.row];
    [cell.btnGetApp setTag:indexPath.row];
 
    if ([string length]==0)
    {
         cell.lblPhoneNo.text=NSLocalizedString(@"categoryUnavailable",nil);
    }else
        cell.lblPhoneNo.text=string;
    cell.imgName.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[self.transcationItems objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname]]];
       return cell;
}
-(void)popover:(UIButton*)sender
{
    [sender setImage:[UIImage imageNamed:@"radial_button_active.png"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnGetAppClick:(UIButton*)sender
{
    NSInteger   indexOfLastname =  [self.dbManager.arrColumnNames indexOfObject:@"app_link"];
    NSString *applink =[[self.transcationItems objectAtIndex:[sender tag]] objectAtIndex:indexOfLastname];
    if ([applink length]!=0)
    {
        [Utility showAlertWithMassager:self.navigationController.view :@"Application does not exist in App Store"];
    }else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:applink]];
}

- (IBAction)btnCallClick:(UIButton*)sender
{
   NSInteger  indexOfLastname =  [self.dbManager.arrColumnNames indexOfObject:@"phone_no"];
   NSString *phoneNumber = [@"tel://" stringByAppendingString:[[[[self.transcationItems objectAtIndex:[sender tag]] objectAtIndex:indexOfLastname] componentsSeparatedByString:@","] objectAtIndex:0]];
    if ([phoneNumber length]!=0)
    {
         [Utility showAlertWithMassager:self.navigationController.view :@"Mobile Number does not exist"];
    }else
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
