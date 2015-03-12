//
//  BudgestViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//
#import "FPPopoverController.h"
#import "DemoTableController.h"
#import "BudgetViewController.h"
#import "HomeViewController.h"

#import "BudgetCell.h"
#import "BudgetHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"
#import "Budget.h"
#import "TransactionHandler.h"
#import "UserInfo.h"
#import "UIPopoverListView.h"
//#import "AddAccountViewController.h"
#import "HomeHelper.h"
//#import "MBProgressHUD.h"
#import "BudgetNewDetailsViewController.h"
@interface BudgetViewController ()

@end

@implementation BudgetViewController

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
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"BudgetViewController" object:nil];
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self updateAccout];
    if([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME])
    {
        [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
    }
  
}

-(void)profressView
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *userToken;
        if ([self.btnUserName.titleLabel.text isEqualToString:NSLocalizedString(@"allAccount", nil)])
        {
            userToken=@"";
        }else
        {
            NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.btnUserName.titleLabel.text];
            if ([UserInfoarrray count]!=0 )
            {
                UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                userToken=userInfo.user_token_id;
            }else
            {
                userToken=@"";
            }
        }
        self.budgetItems=[[BudgetHandler sharedCoreDataController] getAllBudget:userToken];
        dispatch_async(dispatch_get_main_queue(), ^{
              //[MBProgressHUD hideHUDForView:self.emptyView animated:YES];
            if ([self.budgetItems count]==0)
            {
                [self.emptyView setFrame:CGRectMake(0, 2, self.custumeView.frame.size.width, self.custumeView.frame.size.height)];
                [self.addBudgetView setHidden:YES];
                [self.emptyView setHidden:NO];
                [self.custumeView addSubview:self.emptyView];
            }else
            {
                [self.addBudgetView setFrame:CGRectMake(0, 2, self.custumeView.frame.size.width, self.custumeView.frame.size.height)];
                [self.custumeView addSubview:self.addBudgetView];
                [self.addBudgetView setHidden:NO];
                [self.emptyView setHidden:YES];
            }
           [self.tableView reloadData];
        });
    });
}


-(void)viewDidAppear:(BOOL)animated
{
    [self profressView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.budgetItems count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 205;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"Budget";
    BudgetCell *cell = (BudgetCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BudgetCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Budget *transaction =(Budget*)[self.budgetItems objectAtIndex:[indexPath row]];
    if ([transaction.category isEqualToString:NSLocalizedString(@"all", nil)])
    {
        [cell.lblCategery setText:NSLocalizedString(@"all", nil)];
        [cell.imgCatagery setImage:[UIImage imageNamed:@"All_icon.png"]];
    }else
    {
        NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
        if ([categeryArray count]!=0)
        {
            [cell.lblCategery setText:transaction.category];
            cell.imgCatagery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
        }
    }

    if ([transaction.paymentMode isEqualToString:NSLocalizedString(@"all", nil)])
    {
        [cell.lblPaymentMode setText:NSLocalizedString(@"all", nil)];
        [cell.imgPaymentMode setImage:[UIImage imageNamed:@"All_icon.png"]];
    }else
    {
        NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getsearchPaymentWithAttributeName:transaction.paymentMode];
        if([paymentModeArray count]!=0)
        {
            NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
            [cell.lblPaymentMode setText:[paymentInfo objectForKey:@"paymentMode"]];
            [cell.imgPaymentMode setImage:[UIImage imageWithData:[paymentInfo objectForKey:@"paymentmode_icon"]]];
        }
    }

    
    
    if (![transaction.discription isEqualToString:@""])
    {
        [cell.lblDiscription setText:transaction.discription];
    }else
        [cell.lblDiscription setText:@"No Description"];
    
    NSDate *fromdate = [NSDate dateWithTimeIntervalSince1970:([[transaction.fromdate stringValue] doubleValue] / 1000)];
    NSDate *todate = [NSDate dateWithTimeIntervalSince1970:([[transaction.todate stringValue] doubleValue] / 1000)];
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    [df setDateFormat:@"dd LLLL yyyy"];
    
    [cell.lbltDate setText:[NSString stringWithFormat:@"%@ to %@",[df stringFromDate:fromdate],[df stringFromDate:todate]]];
    double value=0.0;
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.user_token_id];
    if ([UserInfoarrray count]!=0)
    {
        UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
        [cell.lblUserName setText:userInfo.user_name];
        NSLog(@"%@",userInfo.user_name);
        value=[[TransactionHandler sharedCoreDataController] getTotalExpenseForAllAccountswithCategryAndPaymentMode:transaction.category :transaction.paymentMode :userInfo.user_token_id :transaction.sub_category :transaction.fromdate :transaction.todate];
    }
    
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];

    cell.progrssView.progress=[self progress:[transaction.amount doubleValue] :value];
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    [cell.lblLeft setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:([transaction.amount doubleValue]- value)]]]];
    
    [cell.lblBudget setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:[transaction.amount doubleValue]]]]];
    
    [cell.lblSpent setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:value]]]];
    
    
    if ([transaction.amount doubleValue]- value >= 0)
    {
        [cell.lblTitleLeft setText:NSLocalizedString(@"Left", nil)];
    }
    else
    {
        [cell.lblTitleLeft setText:NSLocalizedString(@"amountExceeded", nil)];
    }
    cell.backgroundColor=[UIColor clearColor];
        return cell;
}



-(float) progress:(double)amount :(double)spent
{
    NSLog(@"%f",(float)(spent/amount));
    return (float)(spent/amount);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	BudgetNewDetailsViewController  *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"BudgetNewDetailsViewController"];
    Budget *transaction =(Budget*)[self.budgetItems objectAtIndex:[indexPath row]];
    [vc setTran:transaction];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)popUpViewbtnClick:(id)sender
{
    DemoTableController *controller = [[DemoTableController alloc] init];
    NSMutableArray *listArray=[[NSMutableArray alloc] init];
    NSMutableArray *categeryName=[[NSMutableArray alloc]initWithObjects:@"Edit",@"Delete",nil];
    NSMutableArray *imageName=[[NSMutableArray alloc]initWithObjects:@"edit_icon.png",@"delete_icon.png",nil];
    for (int i=0; i<[imageName count]; i++)
    {
        NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
        [bookListing setObject:[categeryName objectAtIndex:i] forKey: @"name"];
        [bookListing setObject:[imageName objectAtIndex:i] forKey:@"image"];
        [listArray addObject:bookListing];
    }
    [controller setListArray:listArray];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.arrowDirection = FPPopoverNoArrow;
    popover.border = NO;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(300, 500);
    }
    popover.contentSize = CGSizeMake(130, 120);
    [popover presentPopoverFromView:sender];
    [self.view addSubview:popover.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backbtnClick:(id)sender
{
   // [[SlideNavigationController sharedInstance]toggleLeftMenu];
}

-(void)receivedNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
    
    if ([[info objectForKey:@"object"] isEqualToString:NSLocalizedString(@"addAccount", nil)])
    {
//        AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
//        [self.navigationController pushViewController:catageryController animated:YES];
        
    }else
    {
        [Utility saveToUserDefaults:[info objectForKey:@"object"]  withKey:CURRENT_USER__TOKEN_ID];
        [self profressView];
        [self updateAccout];
    }
    
}



-(void)updateAccout
{
    [self.lblBudget setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
   // [MBProgressHUD showHUDAddedTo:self.emptyView animated:YES];
    self.budgetItems=[[NSMutableArray alloc] init];
    [self.btnUserName setTitle:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID] forState:UIControlStateNormal];
    [self.emptyView setFrame:CGRectMake(0, 2, self.custumeView.frame.size.width, self.custumeView.frame.size.height)];
    [self.addBudgetView setHidden:YES];
    [self.emptyView setHidden:NO];
    [self.custumeView addSubview:self.emptyView];
    
    NSArray *userInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]];
    if ([userInfoarrray count]!=0)
    {
       // [self addAccountName:userInfoarrray];
    }else
    {
        NSArray *userInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
        //[self addAccountName:userInfoarrray];
    }

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain   target:nil  action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}



@end
