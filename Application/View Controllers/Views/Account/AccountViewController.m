//
//  AccountViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 14/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountCell.h"

#import "UserInfoHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "UserInfo.h"
#import "TransactionHandler.h"
#import "DemoTableController.h"
#import "FPPopoverController.h"
#import "AddAccountViewController.h"
#import "UIAlertView+Block.h"
#import "HomeHelper.h"

@interface AccountViewController ()
{
    FPPopoverController *popover ;
    NSNumber *positon;
}


@end
@implementation AccountViewController

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
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedDemoListNotification:) name:@"DemoListner" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME])
    {
        [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
    }
    self.transcationItems=[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
       return 224;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transcationItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"Account";
    AccountCell *cell = (AccountCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AccountCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    UserInfo *userInfo =[self.transcationItems objectAtIndex:[indexPath row]];
    
    double totalamountIncome = 0, totalamountExpense = 0, totalamountBalance = 0;
    
    if ([userInfo.hide_status intValue])
    {
        [cell.lblProfileName setTextColor:[UIColor lightGrayColor]];
    }else
    {
        [cell.lblProfileName setTextColor:[UIColor darkGrayColor]];
    }
    
    totalamountIncome=[[TransactionHandler sharedCoreDataController] getTotalIncomeForAllAccounts:userInfo.user_token_id];
    totalamountExpense=[[TransactionHandler sharedCoreDataController] getTotalExpenseForAllAccounts:userInfo.user_token_id];
    totalamountBalance=totalamountIncome-totalamountExpense;
    
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [[[Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]] componentsSeparatedByString:@"-"] objectAtIndex:1];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    NSString *amountIncome = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountIncome]];
    NSString *amountExpense = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountExpense]];
    NSString *amountBalance = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountBalance]];
    
    
    [cell.lblIncome setText:[NSString stringWithFormat:@"%@ %@",currency,amountIncome]];
    [cell.lblExpense setText:[NSString stringWithFormat:@"%@ %@",currency,amountExpense]];
    [cell.lblBalance setText:[NSString stringWithFormat:@"%@ %@",currency,amountBalance]];
    
    if (userInfo.user_img != nil)
     {
      cell.imag.layer.cornerRadius =  cell.imag.frame.size.width / 2;
      cell.imag.clipsToBounds = YES;
      cell.imag.image=[UIImage imageWithData:userInfo.user_img];
     }

    [cell.lblProfileName setText:userInfo.user_name];
    [cell.btnAccount setTag:[indexPath row]];
    if([indexPath row]!=0)
    {
    [cell.lblLine setHidden:NO];
    [cell.lblAccount setText:NSLocalizedString(@"Sub Account", nil)];
    }else
         [cell.lblLine setHidden:YES];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPopUpClick:(UIButton*)sender
{
    DemoTableController *controller = [[DemoTableController alloc] init];
    [controller setPosition:sender.tag];
    NSMutableArray *listArray=[[NSMutableArray alloc] init];
    NSMutableArray *categeryName;
    NSMutableArray *imageName;
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.arrowDirection = FPPopoverNoArrow;
    popover.border = NO;
    
    if (sender.tag==0)
    {
        categeryName=[[NSMutableArray alloc]initWithObjects:@"Edit",nil];
        imageName=[[NSMutableArray alloc]initWithObjects:@"edit_icon.png",nil];
        popover.contentSize = CGSizeMake(130, 46);
    }else
    {
        categeryName=[[NSMutableArray alloc]initWithObjects:@"Edit",@"Delete",nil];
        imageName=[[NSMutableArray alloc]initWithObjects:@"edit_icon.png",@"delete_icon.png",nil];
        popover.contentSize = CGSizeMake(130, 86);
    }
    for (int i=0; i<[imageName count]; i++)
    {
        NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
        [bookListing setObject:[categeryName objectAtIndex:i] forKey:@"name"];
        [bookListing setObject:[imageName objectAtIndex:i] forKey:@"image"];
        [listArray addObject:bookListing];
    }
    [controller setListArray:listArray];
    [popover presentPopoverFromView:sender];
    [self.view addSubview:popover.view];
}



- (IBAction)btnBackClick:(id)sender
{
   //  [[SlideNavigationController sharedInstance]toggleLeftMenu];
}

-(void) receivedDemoListNotification:(NSNotification*) notification
{
    [popover dismissPopoverAnimated:YES];
    NSDictionary * info =notification.userInfo;
    NSString *number=[info objectForKey:@"index"];
     positon=[info objectForKey:@"position"];
    if ([number intValue]==0)
    {
        AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
        [catageryController setInfo:[ self.transcationItems objectAtIndex:[positon intValue]]];
        [self.navigationController pushViewController:catageryController animated:YES];
    }else if ([number intValue]==1)
    {
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"deletingaccountwilldeletedata", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
        [alert addButtonWithTitle:@"Cancel"];
        [alert show];
        
    }

}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[UserInfoHandler sharedCoreDataController] deleteUserInfo:[self.transcationItems objectAtIndex:[positon intValue]] chekServerUpdation:NO];
        self.transcationItems=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
        [self.tableView reloadData];
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountdeletedSuccessfully", nil)];
    }
}

@end
