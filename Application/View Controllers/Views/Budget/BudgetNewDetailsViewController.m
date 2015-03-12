//
//  BudgetNewDetailsViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 29/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import "BudgetNewDetailsViewController.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"
#import "UIAlertView+Block.h"
#import "BudgetHandler.h"
#import "BudgetViewController.h"
#import "UserInfo.h"
#import "Paymentmode.h"
#import "UIPopoverListView.h"
#import "CategeyListViewController.h"
#import "PaymentModeViewController.h"
#import "CreateBudgetsViewController.h"
#import "Transactions.h"
#import "HomeViewCell.h"
#import "TransactionHandler.h"
//#import "MBProgressHUD.h"
@interface BudgetNewDetailsViewController ()

@end

@implementation BudgetNewDetailsViewController

@synthesize tran;
@synthesize scrollViewSubview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UILabel appearance] setFont:[UIFont fontWithName:Embrima size:16.0]];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
    // self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat borderWidth = .3f;
    self.scrollView.frame = CGRectInset(self.scrollView.frame, -borderWidth, -borderWidth);
    self.scrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.scrollView.layer.borderWidth = borderWidth;
    
    scrollViewSubview.translatesAutoresizingMaskIntoConstraints = YES;
    scrollViewSubview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 5, 500);
    self.scrollView.contentSize = scrollViewSubview.frame.size;
    self.scrollView.contentOffset = CGPointZero;
}


-(void)viewWillAppear:(BOOL)animated
{
   // [MBProgressHUD showHUDAddedTo:self.tblView animated:YES];
    if ([self.transcationItems count]==0)
    {
        [self.lblTransaction setText:NSLocalizedString(@"notransactionfound", nil)];
    }
    if ([tran.category isEqualToString:NSLocalizedString(@"all", nil)])
    {
        [ self.lblCategery setText:NSLocalizedString(@"all", nil)];
        [self.imgCategery setImage:[UIImage imageNamed:@"All_icon.png"]];
    }else
    {
        NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:tran.category];
        if ([categeryArray count]!=0)
        {
            self.imgCategery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
        }else
            self.imgCategery. image=[UIImage imageNamed:@"All_icon.png"];
        
        if (![tran.sub_category isEqualToString:@""])
        {
            [self.lblCategery setText:[NSString stringWithFormat:@"%@ (%@)",tran.category,tran.sub_category]];
        }else
            [self.lblCategery setText:tran.category];
    }
    
    if ([tran.paymentMode isEqualToString:NSLocalizedString(@"all", nil)])
    {
        [self.lblPaymentMode setText:NSLocalizedString(@"all", nil)];
        [self.imgPaymentMode setImage:[UIImage imageNamed:@"All_icon.png"]];
    }else
    {
        NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getsearchPaymentWithAttributeName:tran.paymentMode];
        NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
        [self.lblPaymentMode setText:[paymentInfo objectForKey:@"paymentMode"]];
        [self.imgPaymentMode setImage:[UIImage imageWithData:[paymentInfo objectForKey:@"paymentmode_icon"]]];
    }
    
    NSString *mainToken= [Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [self.lblAmount setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:[tran.amount doubleValue]]]]];
    
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:tran.user_token_id];
    UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
    [self.lblAccount setText:userInfo.user_name];
    
    if (![tran.discription isEqualToString:@""])
    {
        [self.lbldiscription setText:tran.discription];
    }else
        [self.lbldiscription setText:@"No Description"];
    
    NSString *nDate=[tran.fromdate stringValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    [self.lblFromDate setText:[dateFormatter stringFromDate:date]];
    NSString *sDate=[tran.todate stringValue];
    NSDate *sdate = [NSDate dateWithTimeIntervalSince1970:([sDate doubleValue] / 1000)];
    [self.lblToDate setText:[dateFormatter stringFromDate:sdate]];
}

-(void)profressView
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        self.transcationItems=[[NSMutableArray alloc] initWithArray:[[TransactionHandler sharedCoreDataController] getAllUserwithCategaryandPaymentMode:tran.category andSearchText:tran.paymentMode :[NSString stringWithFormat:@"%i",TYPE_EXPENSE] :tran.user_token_id :tran.sub_category :tran.fromdate :tran.todate]];
//        self.scrollView.contentSize = CGSizeMake(310,340+([self.transcationItems count])*82);
        // self.scrollView.frame=self.view.frame;
        
        CGRect frame = self.tblView.frame;
        frame.size.height =+[self.transcationItems count]*82;
        self.tblView.frame = frame;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.transcationItems count]!=0)
            {
                [self.lblTransaction setText:NSLocalizedString(@"transactionTitle", nil)];
            }
            //[MBProgressHUD hideHUDForView:self.tblView animated:YES];
            [self.tblView reloadData];
        });
    });
}


-(void)viewDidAppear:(BOOL)animated
{
    [self profressView];
}




-(void)deleteItem
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"areyousuretodeletebudget", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ( [[BudgetHandler sharedCoreDataController] deleteBudget:tran])
        {
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"budgetdeletedSuccessfully", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Hello:%lu",(unsigned long)[self.transcationItems count]);
    return [self.transcationItems count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"HomeViewCell";
    Transactions *transaction =(Transactions*)[self.transcationItems objectAtIndex:[indexPath row]];
    HomeViewCell *cell = (HomeViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
    if ([categeryArray count]!=0)
    {
        cell.imgCatagery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
        
    }
    [cell.lblCatagory setText:transaction.category];
    
    NSString *nDate=[transaction.date stringValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    [df setDateFormat:@"dd LLLL yyyy"];
   // [cell.lblDob setText:[df stringFromDate:date]];
    
    if (![transaction.transaction_type intValue]==TYPE_INCOME)
        [cell.lblAmount setTextColor:[UIColor colorWithRed:232/255.0f green:76/255.0f blue:61/255.0f alpha:100.0f]];
    else
        [cell.lblAmount setTextColor:[UIColor colorWithRed:53/255.0 green:152/255.0 blue:219/255.0 alpha:100.0]];
    
    
    if ([transaction.discription length]!=0)
        [cell.lblDiscription setText:transaction.discription];
    
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    [cell.lblAmount setText:[NSString stringWithFormat:@"%@ %.02f",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[transaction.amount doubleValue]]];
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController]getUserDetailsWithUserTokenid:transaction.user_token_id];
    UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
    [cell.lblCurrrentUser setText:userInfo.user_name];
    CGFloat borderWidth = .3f;
    cell.frame = CGRectInset(cell.frame, -borderWidth, -borderWidth);
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = borderWidth;
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnEditClick:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"	 bundle: nil];
    CreateBudgetsViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CreateBudgetsViewController"];
    [vc setTransaction:tran];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnDeleteClick:(id)sender
{
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"areyousuretodeletebudget", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
}

@end
