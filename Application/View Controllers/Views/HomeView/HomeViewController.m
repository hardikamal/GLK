

//
//  HomeViewController.m
//  Daily Expense Manager
//
//  Created by Jyoti Kumar on 21/07/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//


#import "HomeViewController.h"
#import "AddTransactionViewController.h"
#import "TransactionHandler.h"
#import "HomeViewCell.h"
#import "CategoryListHandler.h"
#import "UserInfoHandler.h"
#import "Transactions.h"
#import "UserInfo.h"
#import "UIPopoverListView.h"
#import "AddAccountViewController.h"
#import "Budget.h"
#import "BudgetHandler.h"
#import "BudgetCell.h"
#import "PaymentmodeHandler.h"
#import "WarrantyViewController.h"
#import "WarrantyCell.h"
#import "UIUnderlinedButton.h"
#import "AFNetworkReachabilityManager.h"
#import "LoginCallbacksViewController.h"
#import "HomeHelper.h"
#import "TransactionDetailsViewController.h"
#import "AFNetworking.h"
#import "SAAPIClient.h"
#import "CurrencyPopUpViewController.h"
#import "TransferHandler.h"
#import "LeftMenuViewController.h"
#import "UIColor+HexColor.h"
#import "VBPieChart.h"
#import "BROptionsButton.h"
#import "TransactionCell.h"
@interface UILabel (Colorify)
- (void)colorSubstring:(NSString *)substring;
- (void)colorRange:(NSRange)range;
@end
@implementation UILabel (Colorify)
- (void)colorRange:(NSRange)range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    else {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{ NSForegroundColorAttributeName:GREEN_COLOR } range:range];
    self.attributedText = attributedText;
}

- (void)colorSubstring:(NSString *)substring
{
    NSRange range = [self.text rangeOfString:substring];
    [self colorRange:range];
}

@end

@interface HomeViewController ()
{
    int  currentUserPosition;
    UIUnderlinedButton *fromLabel ;
    NSNumberFormatter *fmt ;
    double totalamountIncome , totalamountExpense , totalamountBalance ;
    int percentExpense;
    NSString *userAccountName;
    NSMutableArray *finalArray;
   
}
@property (nonatomic, strong) BROptionsButton *brOptionsButton;

@property (nonatomic, retain) VBPieChart *chart;

@property (nonatomic, retain) NSArray *chartValues;
@property BOOL number_of_accounts_more_than_two;


@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)drawChart
{
    if (!_chart)
    {
        _chart = [[VBPieChart alloc] init];
        [self.view addSubview:_chart];
    }
    [_chart setFrame:CGRectMake(165, 64, 150, 150)];
    [_chart setEnableStrokeColor:YES];
    [_chart setHoleRadiusPrecent:0.7];
    [_chart.layer setShadowOffset:CGSizeMake(2, 2)];
    [_chart.layer setShadowRadius:3];
    [_chart.layer setShadowColor:[UIColor blackColor].CGColor];
    [_chart.layer setShadowOpacity:0.7];
    
    [_chart setHoleRadiusPrecent:0.3];
    [_chart setShowLabels:YES];
   
    self.chartValues = @[
                         @{ @"name":@"first", @"value":[NSNumber numberWithDouble:totalamountExpense], @"color":[UIColor redColor] },
                         @{ @"name":@"second", @"value":[NSNumber numberWithDouble:totalamountIncome], @"color":GREEN_COLOR }
                         ];
    
    if (totalamountIncome+totalamountExpense > 0) {
        [_chart setChartValues:_chartValues animation:YES options:VBPieChartAnimationFanAll];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userAccountName=@"Saurabh";
    percentExpense=0;
    
    fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"HomeViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSelectViewListNotification:) name:@"LoginCallbacksViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSelectViewCurrencyPopUpViewController:) name:@"CurrencyPopUpViewController" object:nil];
    
    fromLabel = [[UIUnderlinedButton alloc] init];
    [fromLabel setTitle:NSLocalizedString(@"To View All Transactions,Tap Here.", nil) forState:UIControlStateNormal];
    
    
    [fromLabel addTarget:self action:@selector(showHistryView) forControlEvents:UIControlEventTouchUpInside];
    [fromLabel setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [self.scrollview addSubview:fromLabel];
    
}



-(void)addDiscription
{
    NSString *string=[[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:0];
   
}


-(void)profressView
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSString *userToken=@"";
         NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]];
            if ([UserInfoarrray count]!=0 )
            {
                UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                userToken=userInfo.user_token_id;
            }else
            {
                userToken=@"";
            }
        
        self.warrantyItems=[[TransactionHandler sharedCoreDataController] getAllWarranrtyOnHomeScreen:[NSString stringWithFormat:@"%d",TYPE_WARRANTY] :userToken];
        
        self.budgetItems=[[BudgetHandler sharedCoreDataController] getAllBudgetOnHomeScereeen:userToken];
       
        self.transcationItems=[[TransactionHandler sharedCoreDataController] getAllTransactionsForID:userToken];
        
        totalamountIncome=[[TransactionHandler sharedCoreDataController] getTotalIncomeForAllAccounts:userToken];
        totalamountExpense=[[TransactionHandler sharedCoreDataController] getTotalExpenseForAllAccounts:userToken];
        totalamountBalance=totalamountIncome-totalamountExpense;
        double expense=totalamountExpense/(totalamountIncome+totalamountExpense)*100;
        if (!(totalamountIncome==0.0 && totalamountExpense==0.0 && totalamountBalance==0.0))
        {
            if (expense>0 && expense<1)
            {
                percentExpense=1;
            }else
            {
                percentExpense = expense;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
          //  [MBProgressHUD hideHUDForView:self.viewEmpty animated:YES];
            finalArray = [[NSMutableArray alloc]init];
             [self updateBudjetTabeview:self.budgetItems];
            [self updateTrasationTabeview:self.transcationItems];
           
         
            [self showAllTransactionDetailOnHomeScreen];
            [self.tblviewTransaction reloadData];
            
        });
    });
}


-(void)updateBudjetTabeview:(NSMutableArray*)array
{
    for (Budget *transaction in array)
    {
        [finalArray addObject:transaction];
    }
}



-(void)updateTrasationTabeview:(NSMutableArray*)array
{
      for (Transactions *transaction in array)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([[transaction.date stringValue] doubleValue] / 1000)];
        NSLog(@"days ago %d",date.daysAgo);
        NSDate *dateToCompare = nil;
        Transactions* lastObj = [finalArray lastObject];
        if ([lastObj isKindOfClass:[Transactions class]])
        {
            dateToCompare = [NSDate dateWithTimeIntervalSince1970:([[lastObj.date stringValue] doubleValue] / 1000)];
        }else if ([lastObj isKindOfClass:[Budget class]])
        {
            
        }else
        {
            dateToCompare = lastObj;
        }
        
        if ((dateToCompare!=nil)&&(dateToCompare.daysAgo == date.daysAgo))
        {
            NSLog(@"here");
        }else
        {
            if (dateToCompare)
            {
                [finalArray addObject:date];
            }else
            {
                [finalArray addObject:date];
            }
        }
        [finalArray addObject:transaction];
    }
}



-(void)addAccountName:(NSArray *)userInfoarrray
{
    UserInfo *userInfo =[userInfoarrray objectAtIndex:0];
    if ([NSLocalizedString(@"allAccount", nil) isEqualToString:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]])
    {
        userAccountName=NSLocalizedString(@"allAccount", nil);
    }else
    {
        userAccountName=userInfo.user_name;
    }
}


-(void)updateAccout
{
 //   [MBProgressHUD showHUDAddedTo:self.viewEmpty animated:YES];
    NSArray *userInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]];
    if ([userInfoarrray count]!=0)
    {
        [self addAccountName:userInfoarrray];
    }else
    {
        NSArray *userInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
        [self addAccountName:userInfoarrray];
    }
    self.warrantyItems=[[NSMutableArray alloc] init];
    self.budgetItems=[[NSMutableArray alloc] init];
    self.transcationItems=[[NSMutableArray alloc] init];
   // [self showAllTransactionDetailOnHomeScreen];
}



-(void)viewWillAppear:(BOOL)animated
{
    [[UINavigationBar appearance] setBarTintColor:GREEN_COLOR];
    self.navigationController.navigationBarHidden=0;
   // [self updateAccout];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CURRENT_CURRENCY_TIMESTAMP])
    {

        [[AppCommonFunctions sharedInstance] presentVCOfClass:[CurrencyPopUpViewController class] fromVC:self animated:YES modifyVC:nil];
    }else
    {
        [self loginCalBacksViewController];
    }

}

-(void)receivedSelectViewListNotification:(NSNotification*) notification
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME] && [Utility isInternetAvailable])
    {
        [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
    }
    //[self updateAccout];
     [self profressView];
}



-(void)loginCalBacksViewController
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:LOGIN_DONE] && [Utility isInternetAvailable] && ![[Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",LOGIN_DONE,[Utility userDefaultsForKey:MAIN_TOKEN_ID]]] isEqualToString:[Utility userDefaultsForKey:MAIN_TOKEN_ID]])
    {
        _loginViewController = [self.storyboard  instantiateViewControllerWithIdentifier:@"LoginCallbacksViewController"];
        [self.view addSubview:_loginViewController.view];
    }else
    {
       // [self updateAccout];
        [self profressView];
        if([[NSUserDefaults standardUserDefaults] boolForKey:UPDATION_ON_SERVER_TIME] && [Utility isInternetAvailable])
        {
            [[HomeHelper sharedCoreDataController] upgradeBackendDataOnServer];
        }
    }
}


-(void)receivedSelectViewCurrencyPopUpViewController:(NSNotification*) notification
{
    [self loginCalBacksViewController];
}


-(void)warrantyAction:(UIButton*)sender
{
    [[TransactionHandler sharedCoreDataController] updateTransaction:[self.warrantyItems objectAtIndex:sender.tag]];
    [self updateAccout];
    [self profressView];
}


-(void)budjetAction:(UIButton*)sender
{
    [[BudgetHandler sharedCoreDataController] updateBudget:[self.budgetItems objectAtIndex:sender.tag]];
    [self updateAccout];
    [self profressView];
}


-(void)showAllTransactionDetailOnHomeScreen
{
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [[[Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]] componentsSeparatedByString:@"-"] objectAtIndex:1];
    NSString *amountIncome = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountIncome]];
    NSString *amountExpense = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountExpense]];
    NSString *amountBalance = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountBalance]];
    if ([finalArray count]==0) {
        [self.tblviewTransaction setHidden:YES];
//        self.viewEmpty.frame=CGRectMake(0, self.tblviewTransaction.frame.origin.y, self.viewEmpty.frame.size.width, self.viewEmpty.frame.size.height);
        self.viewEmpty.center = CGPointMake(self.view.center.x, self.view.center.y+100);
        [self.view addSubview:self.viewEmpty];
        self.lblNoTransaction.text=@"You have not started using Gullak, start by adding a transaction";
        [self.lblNoTransaction colorSubstring:@"Gullak"];
    }
    [fromLabel setFrame:CGRectMake(10, self.scrollview.contentSize.height-30, 290, 30)];
//    [self.scrollview addSubview:fromLabel];
    [self drawChart];
    [self.lblIncome setText:[NSString stringWithFormat:@"%@ %@",currency,amountIncome]];
    [self.lblExpense setText:[NSString stringWithFormat:@"%@ %@",currency,amountExpense]];
    [self.lblBalance setText:[NSString stringWithFormat:@"%@ %@",currency,amountBalance]];
    
}

-(IBAction)addTransactionActionSheetShow:(UIButton*)sender
{
    [UIActionSheet showInView:self.viewEmpty withTitle:@"Add transaction" cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@[@"Income",@"Expense"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
    {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Income"])
        {
            [[AppCommonFunctions sharedInstance] pushVCOfClass:[AddTransactionViewController class] fromNC:self.navigationController animated:YES popFirstToVCOfClass:nil modifyVC:^(AddTransactionViewController* info)
            {
                info.isIncomeSelected=1;
            }];
        }
        else if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Expense"])
        {
           
                [[AppCommonFunctions sharedInstance] pushVCOfClass:[AddTransactionViewController class] fromNC:self.navigationController animated:YES popFirstToVCOfClass:nil modifyVC:^(AddTransactionViewController* info)
                 {
                     info.isIncomeSelected=0;
                 }];
            
        }
    }];
}
-(void)showHistryView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *	vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"HistoryViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView tag]==3)
    {
        return [finalArray count];
    }
    if ([tableView tag]==2)
    {
        return [self.budgetItems count];
        
    }if ([tableView tag]==1)
    {
        return [self.warrantyItems count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView tag]==3)
    {
        Transactions *transaction =[finalArray objectAtIndex:[indexPath row]];
        if ([transaction isKindOfClass:[NSDate class]])
        {
            return 30;
        }else if ([transaction isKindOfClass:[Budget class]])
        {
            return 200;
        }else
        {
            return 70;
        }
    }
    if ([tableView tag]==2)
    {
        return 200;
    }
    if ([tableView tag]==1)
    {
        return 130;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView tag]==1)
    {
        NSString *simpleTableIdentifier = @"Warranty";
        
        WarrantyCell *cell = (WarrantyCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WarrantyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        Transactions *transaction =(Transactions*)[self.warrantyItems objectAtIndex:[indexPath row]];
        NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
        if ([categeryArray count]!=0)
        {
            cell.imgCatagery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
        }
        [cell.lblCategery setText:transaction.category];
        
        if (![transaction.transaction_type intValue]==TYPE_INCOME)
            [cell.lblAmount setTextColor:[UIColor colorWithRed:232/255.0f green:76/255.0f blue:61/255.0f alpha:100.0f]];
        else
            [cell.lblAmount setTextColor:[UIColor colorWithRed:53/255.0 green:152/255.0 blue:219/255.0 alpha:100.0]];
        
        NSString *nDate=[transaction.date stringValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
        NSString *warranty=[transaction.warranty stringValue];
        NSDate *warrantydate = [NSDate dateWithTimeIntervalSince1970:([warranty doubleValue] / 1000)];
        cell.progrssView.progress=[self progress:date :warrantydate];
        NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
        [df setDateFormat:@"dd LLLL yyyy"];
        [cell.lblWarranntyDate setText:[df stringFromDate:date]];
        [cell.lbltDate setText:[NSString stringWithFormat:@"%@ to %@",[df stringFromDate:date],[df stringFromDate:warrantydate]]];
        
        if ([transaction.discription length]!=0)
        {
            [cell.lblDiscription setText:transaction.discription];
        }else
        {
            [cell.lblDiscription setText:@"No Description"];
        }
        NSString *mainToken= [Utility userDefaultsForKey:MAIN_TOKEN_ID];
        NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
        [cell.lblAmount setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:[transaction.amount doubleValue]]]]];
        
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.user_token_id ];
        if ([UserInfoarrray count]!=0)
        {
            UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
            [cell.lblUserName setText:userInfo.user_name];
        }
        
        
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(285, 0, 25, 25);
        [imageButton setTag:[indexPath row]];
        [imageButton setImage:[UIImage imageNamed:@"cancel_button_budget.png"] forState:UIControlStateNormal];
        imageButton.adjustsImageWhenHighlighted = NO;
        [imageButton addTarget:self action:@selector(warrantyAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:imageButton];
        return cell;
    }
    
    if ([tableView tag]==2)
    {
     
    }
    if ([tableView tag]==3)
    {
        NSString *simpleTableIdentifier = @"HomeViewCell";
        Transactions *transaction =[finalArray objectAtIndex:[indexPath row]];
        if ([transaction isKindOfClass:[NSDate class]])
        {
            simpleTableIdentifier=@"TransactionCell";
            NSDate *date = [finalArray objectAtIndex:[indexPath row]];
            NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
             [df setDateFormat:@"dd LLLL yyyy"];
            TransactionCell *cell = (TransactionCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell.lblDob setText:[df stringFromDate:date]];
            return cell;
        }else if ([transaction isKindOfClass:[Budget class]])
        {
            NSString *simpleTableIdentifier = @"Budget";
            BudgetCell *cell = (BudgetCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BudgetCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            Budget *transaction =(Budget*)[finalArray objectAtIndex:[indexPath row]];
            if ([transaction.category isEqualToString:NSLocalizedString(@"all", nil)])
            {
                [cell.lblCategery setText:NSLocalizedString(@"all", nil)];
                [cell.imgCatagery setImage:[UIImage imageNamed:@"All_icon.png"]];
            }else
            {
                NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
                if ([categeryArray count]!=0)
                {
                    cell.imgCatagery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
                }else
                    cell.imageView. image=[UIImage imageNamed:@"All_icon.png"];
                
                [cell.lblCategery setText:transaction.category];
            }
            
            if ([transaction.paymentMode isEqualToString:NSLocalizedString(@"all", nil)])
            {
                [cell.lblPaymentMode setText:NSLocalizedString(@"all", nil)];
                [cell.imgPaymentMode setImage:[UIImage imageNamed:@"All_icon.png"]];
            }else
            {
                NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getsearchPaymentWithAttributeName:transaction.paymentMode];
                if ([paymentModeArray count]!=0)
                {
                    NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
                    [cell.lblPaymentMode setText:[paymentInfo objectForKey:@"paymentMode"]];
                    [cell.imgPaymentMode setImage:[UIImage imageWithData:[paymentInfo objectForKey:@"paymentmode_icon"]]];
                }
                
            }
            
            if ([transaction.discription length]!=0)
            {
                [cell.lblDiscription setText:transaction.discription];
            }else
            {
                [cell.lblDiscription setText:@"No Description"];
            }
            
            NSDate *fromdate = [NSDate dateWithTimeIntervalSince1970:([[transaction.fromdate stringValue] doubleValue] / 1000)];
            NSDate *todate = [NSDate dateWithTimeIntervalSince1970:([[transaction.todate stringValue] doubleValue] / 1000)];
            NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
            [df setDateFormat:@"dd LLLL yyyy"];
            [cell.lbltDate setText:[NSString stringWithFormat:@"%@ to %@",[df stringFromDate:fromdate],[df stringFromDate:todate]]];
            NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.user_token_id];
            double value=0;
            if ([UserInfoarrray count]!=0)
            {
                UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                [cell.lblUserName setText:userInfo.user_name];
                value=[[TransactionHandler sharedCoreDataController] getTotalExpenseForAllAccountswithCategryAndPaymentMode:transaction.category :transaction.paymentMode :userInfo.user_token_id :transaction.sub_category :transaction.fromdate :transaction.todate];
            }
            
            NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
            NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
            cell.progrssView.progress=[self progressdiffrende:[transaction.amount doubleValue] :value];
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
            
            CGFloat borderWidth = .3f;
            cell.frame = CGRectInset(cell.frame, -borderWidth, -borderWidth);
            cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.layer.borderWidth = borderWidth;
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = CGRectMake(285, 0, 25, 25);
            [imageButton setTag:[indexPath row]];
            [imageButton setImage:[UIImage imageNamed:@"cancel_button_budget.png"] forState:UIControlStateNormal];
            imageButton.adjustsImageWhenHighlighted = NO;
            [imageButton addTarget:self action:@selector(budjetAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:imageButton];
            return cell;
            
            
        }else
        {
            HomeViewCell *cell = (HomeViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                cell.leftUtilityButtons = [self leftButtons];
                cell.rightUtilityButtons = [self rightButtons];
                cell.delegate = self;
            }
            NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getsearchCategeryWithAttributeName:@"category_icon" andSearchText:transaction.category];
            if ([categeryArray count]!=0)
            {
                cell.imgCatagery.image=[UIImage imageWithData:[[categeryArray objectAtIndex:0] objectForKey:@"category_icon"]];
            }
            [cell.lblCatagory setText:transaction.category];
          
            if ([transaction.discription length]!=0)
            {
                [cell.lblDiscription setText:transaction.discription];
            }else
            {
                [cell.lblDiscription setText:@"No Description"];
            }
            
            if ([transaction.transaction_type intValue]==TYPE_INCOME)
            {
                [(UILabel*)[cell.contentView viewWithTag:99] setText:@"Income"];
                [cell.lblColor setBackgroundColor:[UIColor colorWithRed:53/255.0 green:152/255.0 blue:219/255.0 alpha:100.0]];

            }else
            {
                [(UILabel*)[cell.contentView viewWithTag:99] setText:@"Expense"];
                [cell.lblColor setBackgroundColor:[UIColor colorWithRed:232/255.0f green:76/255.0f blue:61/255.0f alpha:100.0f]];

            }
            
            
            if ([transaction.transaction_inserted_from integerValue]==TYPE_REMINDER || [transaction.transaction_inserted_from integerValue]==TYPE_TRANSFER )
                
            {
                if ([transaction.transaction_inserted_from integerValue]==TYPE_REMINDER)
                {
                    [cell.lblExtra setText:NSLocalizedString(@"addtoreminder", nil)];
                }else
                {
                    NSArray *array = [[TransferHandler sharedCoreDataController] getTranferWithTransactionId:transaction.transaction_reference_id];
                    Transfer *transfer=[array objectAtIndex:0];
                    if ([transaction.transaction_type intValue]==TYPE_INCOME)
                    {
                        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transfer.fromaccount];
                        if ([UserInfoarrray count]!=0)
                        {
                            UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                            [cell.lblExtra setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"fromTransfer", nil) ,userInfo.user_name] ];
                        }
                    }else
                    {
                        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transfer.toaccount];
                        if ([UserInfoarrray count]!=0)
                        {
                            UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                            [cell.lblExtra setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"toTransfer", nil) ,userInfo.user_name] ];
                        }
                        
                    }
                }
            }else
            {
                [cell.lblExtra setHidden:YES];
            }
            
            NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
            NSString *currency= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
            [cell.lblAmount setText:[NSString stringWithFormat:@"%@ %@",[[currency componentsSeparatedByString:@"-"] objectAtIndex:1],[fmt stringFromNumber:[NSNumber numberWithDouble:[transaction.amount doubleValue]]]]];
            NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:transaction.user_token_id];
            if ([UserInfoarrray count]!=0)
            {
                UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
                [cell.lblCurrrentUser setText:userInfo.user_name];
            }
            CGFloat borderWidth = .3f;
            cell.frame = CGRectInset(cell.frame, -borderWidth, -borderWidth);
            cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.layer.borderWidth = borderWidth;
            return cell;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:YELLOW_COLOR icon:[UIImage imageNamed:@"edit_button.png"]];
    //[rightUtilityButtons sw_addUtilityButtonWithColor:BLUE_COLOR   icon:[UIImage imageNamed:@"details_icon.png"]];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:RED_COLOR  icon:[UIImage imageNamed:@"data_delete_icon.png"]];
    return leftUtilityButtons;
}



- (IBAction)btnUserNameClick:(id)sender
{
    NSMutableArray *userInfoList=[[NSMutableArray alloc] init];
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
    if ([UserInfoarrray count]>1)
    {
        [userInfoList addObject:NSLocalizedString(@"allAccount", nil)];
        for (UserInfo *info in UserInfoarrray)
        {
            [userInfoList addObject:info.user_name];
        }
    }
    [userInfoList addObject:NSLocalizedString(@"addAccount", nil)];
    CGFloat xWidth = self.view.bounds.size.width - 120.0f;
    CGFloat yHeight = [userInfoList count]*40;
    if (yHeight>300)
    {
        yHeight=300;
    }
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    [poplistview setTag:1];
    [poplistview setNotificationName:@"HomeViewController"];
    [poplistview setListArray:userInfoList];
    if (yHeight<300)
    {
        poplistview.listView.scrollEnabled = FALSE;
    }
    [poplistview show];
}


-(void)receivedNotification:(NSNotification*) notification
{
    NSDictionary * info =notification.userInfo;
    if ([[info objectForKey:@"object"] isEqualToString:NSLocalizedString(@"addAccount", nil)])
    {
        AddAccountViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
        [self.navigationController pushViewController:catageryController animated:YES];
        
    }else
    {
        [Utility saveToUserDefaults:[info objectForKey:@"object"]  withKey:CURRENT_USER__TOKEN_ID];
        [self updateAccout];
        [self profressView];
    }
}


-(float)progress:(NSDate*)startDate :(NSDate*)endDate
{
    NSTimeInterval firstsBetween = [endDate timeIntervalSinceDate:startDate];
    float firstsnumberOfDays = firstsBetween / 86400;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] init];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:[NSDate date] options:0];
    float secondsnumberOfDays = components.day;
    float toatal= secondsnumberOfDays/firstsnumberOfDays;
    return toatal;
}



-(float)progressdiffrende:(double)amount :(double)spent
{
    NSLog(@"%f",(float)(spent/amount));
    return (float)(spent/amount);
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain   target:nil  action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}



- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Alert" message:NSLocalizedString(@"areyousuretodeletetransaction", nil) delegate:self cancelButtonTitle:@"Continue"  otherButtonTitles: nil];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setTag:index];
            [alert show];
            break;
        }
        default:
            break;
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ( [[TransactionHandler sharedCoreDataController] deleteTransaction:[self.transcationItems objectAtIndex:alertView.tag]])
        {
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"transactionsdeletedSuccessfully", nil)];
            [self profressView];
           // [MBProgressHUD hideHUDForView:self.viewEmpty animated:YES];
        }
    }
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tblviewTransaction indexPathForCell:cell];
    switch (index)
    {
        case 0:
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            AddTransactionViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddTransactionViewController"];
            [vc setTransaction:[finalArray objectAtIndex:cellIndexPath.row]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            
            break;
        }
        default:
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView tag]==3)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        TransactionDetailsViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TransactionDetailsViewController"];
        [vc setTransaction:[finalArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
        NSLog(@"cell selected at index path %ld:%ld", (long)indexPath.section, (long)indexPath.row);
        NSLog(@"selected cell index path is %@", [self.tblviewTransaction indexPathForSelectedRow]);
        if (!tableView.isEditing)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}





@end

