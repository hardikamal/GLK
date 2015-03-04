
//
//  DemDicViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 20/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "DemDicViewController.h"
#import "DBManager.h"
#import "LocationViewController.h"

#import "LocationDetailsViewController.h"

@interface DemDicViewController ()
@end

@implementation DemDicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)changeCity:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LocationViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"LocationViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    if ([[Utility userDefaultsForKey:CURRENT_CITY] length]==0)
    {
         UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    	 LocationViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"LocationViewController"];
         [self.navigationController pushViewController:controller animated:NO];
    }
 
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

void CFStringCapitalize
(
        CFMutableStringRef theString,
        CFLocaleRef locale
);

-(void)viewWillAppear:(BOOL)animated
{
    
    self.transcationItems=[NSLocalizedString(@"app_manager", nil) componentsSeparatedByString:@","];
    [(UIButton*)[self.view viewWithTag:1000] setTitle:[Utility userDefaultsForKey:CURRENT_CITY] forState:UIControlStateNormal];
    [self.tableView reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transcationItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Demdic" forIndexPath:indexPath];
    UILabel *titleLabel=(UILabel *)[cell.contentView viewWithTag:9];
    [titleLabel setFont:[UIFont fontWithName:Embrima size:16.0f]];
    titleLabel.textColor=[UIColor whiteColor];
	titleLabel.text=[[self.transcationItems objectAtIndex:indexPath.row] capitalizedString];
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:10];
    imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_icon.png",[self.transcationItems objectAtIndex:indexPath.row]]];
   
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	LocationDetailsViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"LocationDetailsViewController"];
    [vc setIndex:[indexPath row]];
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (IBAction)btnBackClick:(id)sender
{
   // [[SlideNavigationController sharedInstance]toggleLeftMenu];
}
@end
