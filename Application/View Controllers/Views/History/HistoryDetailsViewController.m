//
//  HistoryDetailsViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 29/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "HistoryDetailsViewController.h"
#import "TransactionHandler.h"
#import "HomeViewCell.h"
#import "CategoryListHandler.h"
#import "UserInfoHandler.h"
#import "TransactionDetailsViewController.h"
#import "UserInfo.h"
//#import "MBProgressHUD.h"
#import "TransferHandler.h"
#import "Transfer.h"



@interface HistoryDetailsViewController ()
{
    NSDate *startDate;
    NSDate *endDate ;
}

@end

@implementation HistoryDetailsViewController

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
     [self profressView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"History" object:nil];
     [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
     [self.lblBalance setFont:[UIFont fontWithName:Embrima size:16.0f]];
     [self.lblExpense setFont:[UIFont fontWithName:Embrima size:16.0f]];
     [self.lblIncome setFont:[UIFont fontWithName:Embrima size:16.0f]];
     [self.lblScheduleTime setFont:[UIFont fontWithName:Embrima size:16.0f]];
     [self.lblSummery setFont:[UIFont fontWithName:Embrima size:16.0f]];
     [self.lblTitileBalnce setFont:[UIFont fontWithName:Embrima size:16.0f]];
     [self.lblTitleExpense setFont:[UIFont fontWithName:Embrima size:16.0f]];
     [self.lblTitleIncome setFont:[UIFont fontWithName:Embrima size:16.0f]];
    
    double totalamountIncome = 0.0, totalamountExpense = 0.0, totalamountBalance = 0.0;
    
    NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
    NSString *currency= [[[Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]] componentsSeparatedByString:@"-"] objectAtIndex:1];
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    NSString *amountIncome = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountIncome]];
    NSString *amountExpense = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountExpense]];
    NSString *amountBalance = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountBalance]];
    
    [self.lblIncome setText:[NSString stringWithFormat:@"%@ %@",currency,amountIncome]];
    [self.lblExpense setText:[NSString stringWithFormat:@"%@ %@",currency,amountExpense]];
    [self.lblBalance setText:[NSString stringWithFormat:@"%@ %@",currency,amountBalance]];
    
    self.scrollView.contentSize = CGSizeMake(310,(self.summaryView.frame.size.height+([self.transcationItems count])*82));
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    CGRect frame = self.tableView.frame;
    frame.size.height =+[self.transcationItems count]*82;
    self.tableView.frame = frame;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)receivedNotification:(NSNotification*) notification
{
    
      [self profressView];
}


-(void)profressView
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self updatedate:self.index];
        double totalamountIncome = 0.0, totalamountExpense = 0.0, totalamountBalance = 0.0;
        for (Transactions *transaction in self.transcationItems)
        {
            if ([transaction.transaction_type intValue]==TYPE_INCOME)
            {
                totalamountIncome=totalamountIncome+[transaction.amount doubleValue];
            }
            if ([transaction.transaction_type intValue]==TYPE_EXPENSE)
            {
                totalamountExpense= totalamountExpense+[transaction.amount doubleValue];
            }
        }
        totalamountBalance=totalamountIncome-totalamountExpense;
        double expense=totalamountExpense/(totalamountIncome+totalamountExpense)*100;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           // [MBProgressHUD hideHUDForView:self.view animated:YES];
            int percentExpense=0;
            if (totalamountIncome==0.0 && totalamountExpense==0.0 && totalamountBalance==0.0)
            {
                
            }else
            {
                if (expense>0 && expense<1)
                {
                    percentExpense=1;
                }else
                {
                    percentExpense = expense;
                }
            }
        
            if (startDate==nil)
            {
                if ([NSLocalizedString(@"yearly", nil) isEqualToString:self.recurringString])
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
                    [dateFormat setDateFormat:@"yyyy"];
                    [self.lblSummery setText:[dateFormat stringFromDate:[NSDate date]]];
                    
                }else if ([NSLocalizedString(@"monthly", nil) isEqualToString:self.recurringString])
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
                    [dateFormat setDateFormat:@" LLLL yyyy"];
                    [self.lblSummery setText:[dateFormat stringFromDate:[NSDate date]]];
                }else if ([NSLocalizedString(@"daily", nil) isEqualToString:self.recurringString])
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
                    [dateFormat setDateFormat:@"dd LLLL yyyy"];
                    [self.lblSummery setText:[dateFormat stringFromDate:[NSDate date]]];
                }else if ([NSLocalizedString(@"weekly", nil) isEqualToString:self.recurringString])
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
                    [dateFormat setDateFormat:@"dd LLLL yyyy"];
                    [self.lblSummery setText:[NSString stringWithFormat:@"%@ To %@",[dateFormat stringFromDate:[[NSDate date] dateByAddingTimeInterval:-7*24*60*60]],[dateFormat stringFromDate:[NSDate date]]]];
                }else
                {
                    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                    [dateComponents setMonth:-1];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
                    [dateFormat setDateFormat:@"dd LLLL yyyy"];
                    [self.lblSummery setText:[NSString stringWithFormat:@"%@ To %@",[dateFormat stringFromDate:newDate],[dateFormat stringFromDate:[NSDate date]]]];
                }
                
            }else
            {
                if ([NSLocalizedString(@"yearly", nil) isEqualToString:self.recurringString])
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
                    [dateFormat setDateFormat:@"yyyy"];
                    [self.lblSummery setText:[dateFormat stringFromDate:startDate]];
                    
                }else if ([NSLocalizedString(@"monthly", nil) isEqualToString:self.recurringString])
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
                    [dateFormat setDateFormat:@" LLLL yyyy"];
                    [self.lblSummery setText:[dateFormat stringFromDate:startDate]];
                }else if ([NSLocalizedString(@"daily", nil) isEqualToString:self.recurringString])
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
                    [dateFormat setDateFormat:@"dd LLLL yyyy"];
                    [self.lblSummery setText:[dateFormat stringFromDate:startDate]];
                }else
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
                    [dateFormat setDateFormat:@"dd LLLL yyyy"];
                    [self.lblSummery setText:[NSString stringWithFormat:@"%@ To %@",[dateFormat stringFromDate:startDate],[dateFormat stringFromDate:endDate]]];
                }
                
            }
            
         
            
            self.scrollView.contentSize = CGSizeMake(310,(self.summaryView.frame.size.height+([self.transcationItems count])*82));
            CGRect frame = self.tableView.frame;
            frame.size.height =+[self.transcationItems count]*82;
            self.tableView.frame = frame;
            
            NSString *mainToken=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
            NSString *currency= [[[Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]] componentsSeparatedByString:@"-"] objectAtIndex:1];
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            [fmt setPositiveFormat:@"0.##"];
            NSString *amountIncome = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountIncome]];
            NSString *amountExpense = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountExpense]];
            NSString *amountBalance = [fmt stringFromNumber:[NSNumber numberWithDouble:totalamountBalance]];
           
            [self.lblIncome setText:[NSString stringWithFormat:@"%@ %@",currency,amountIncome]];
            [self.lblExpense setText:[NSString stringWithFormat:@"%@ %@",currency,amountExpense]];
            [self.lblBalance setText:[NSString stringWithFormat:@"%@ %@",currency,amountBalance]];
            [self.tableView reloadData];
        });
    });
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
    //[cell.lblDob setText:[df stringFromDate:date]];
    
    
    if ([transaction.discription length]!=0)
    {
        [cell.lblDiscription setText:transaction.discription];
    }else
    {
        [cell.lblDiscription setText:@"No Description"];
    }
    
    if (![transaction.transaction_type intValue]==TYPE_INCOME)
        [cell.lblAmount setTextColor:[UIColor colorWithRed:232/255.0f green:76/255.0f blue:61/255.0f alpha:100.0f]];
    else
        [cell.lblAmount setTextColor:[UIColor colorWithRed:53/255.0 green:152/255.0 blue:219/255.0 alpha:100.0]];
    
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
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	TransactionDetailsViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TransactionDetailsViewController"];
    [vc setTransaction:[self.transcationItems objectAtIndex:[indexPath row]]];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updatedate:(NSInteger)index
{
    NSString *userToke;
    if ([self.userName isEqualToString:NSLocalizedString(@"allAccount", nil)])
    {
        userToke=@"";
    }else
    {
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:self.userName];
        if ([UserInfoarrray count]!=0 )
        {
            UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
            userToke=userInfo.user_token_id;
        }else
        {
            userToke=@"";
        }
    }
    
    NSArray *maxarray=[[TransactionHandler sharedCoreDataController] getMaxDateFromTransactionTable:userToke];
    NSArray *minarray=[[TransactionHandler sharedCoreDataController] getMinDateFromTransactionTable:userToke];
    if ([maxarray count]!=0 && [minarray count]!=0)
    {
        Transactions *transation=(Transactions*)[maxarray objectAtIndex:0];
        NSDate *maxDate = [NSDate dateWithTimeIntervalSince1970:([[transation.date stringValue] doubleValue] / 1000)];
        
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents *componentsForReferenceDate;
        
        if ([NSLocalizedString(@"yearly", nil) isEqualToString:self.recurringString])
        {
            componentsForReferenceDate = [calendar components:NSCalendarUnitYear  fromDate:maxDate];
            [componentsForReferenceDate setYear:[componentsForReferenceDate year]-(self.diffrence -index)];
            [componentsForReferenceDate setDay:01];
            [componentsForReferenceDate setMonth:01];
            [componentsForReferenceDate setHour:0];
            [componentsForReferenceDate setMinute:0];
            [componentsForReferenceDate setSecond:0] ;
            startDate = [calendar dateFromComponents:componentsForReferenceDate];
            
            componentsForReferenceDate = [calendar components:NSCalendarUnitYear  fromDate:maxDate];
            [componentsForReferenceDate setYear:[componentsForReferenceDate year]-(_diffrence -index)];
            NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[calendar dateFromComponents:componentsForReferenceDate]];
            [componentsForReferenceDate setDay:range.length];
            [componentsForReferenceDate setMonth:12];
            [componentsForReferenceDate setHour:23];
            [componentsForReferenceDate setMinute:59];
            [componentsForReferenceDate setSecond:59];
            endDate = [calendar dateFromComponents:componentsForReferenceDate];
            
        }else if ([NSLocalizedString(@"monthly", nil) isEqualToString:self.recurringString])
        {
            componentsForReferenceDate = [calendar components:(NSDayCalendarUnit | NSCalendarUnitYear | NSMonthCalendarUnit ) fromDate:maxDate];
            [componentsForReferenceDate setMonth:[componentsForReferenceDate month]-(_diffrence-index)];
            [componentsForReferenceDate setDay:01];
            [componentsForReferenceDate setHour:0];
            [componentsForReferenceDate setMinute:0];
            [componentsForReferenceDate setSecond:0] ;
            startDate = [calendar dateFromComponents:componentsForReferenceDate];
            componentsForReferenceDate = [calendar components:(NSDayCalendarUnit | NSCalendarUnitYear | NSMonthCalendarUnit ) fromDate:maxDate];
            
            [componentsForReferenceDate setMonth:[componentsForReferenceDate month]-(_diffrence-index)];
            NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[calendar dateFromComponents:componentsForReferenceDate]];
            [componentsForReferenceDate setDay:range.length];
            [componentsForReferenceDate setHour:23];
            [componentsForReferenceDate setMinute:59];
            [componentsForReferenceDate setSecond:59] ;
            endDate = [calendar dateFromComponents:componentsForReferenceDate];
            
        }else if ([NSLocalizedString(@"weekly", nil) isEqualToString:self.recurringString])
        {
            componentsForReferenceDate = [calendar components:(NSDayCalendarUnit | NSCalendarUnitYear | NSMonthCalendarUnit ) fromDate:maxDate];
            int count=_diffrence - index;
            [componentsForReferenceDate setDay:[componentsForReferenceDate day]-7-7*count];
            [componentsForReferenceDate setHour:0];
            [componentsForReferenceDate setMinute:0];
            [componentsForReferenceDate setSecond:0];
            startDate = [calendar dateFromComponents:componentsForReferenceDate];
            componentsForReferenceDate = [calendar components:(NSDayCalendarUnit | NSCalendarUnitYear | NSMonthCalendarUnit ) fromDate:maxDate];
            [componentsForReferenceDate setDay:[componentsForReferenceDate day]-7*count];
            [componentsForReferenceDate setHour:23];
            [componentsForReferenceDate setMinute:59];
            [componentsForReferenceDate setSecond:59] ;
            endDate = [calendar dateFromComponents:componentsForReferenceDate];
            
            
        }else if ([NSLocalizedString(@"daily", nil) isEqualToString:self.recurringString])
        {
            componentsForReferenceDate = [calendar components:(NSDayCalendarUnit | NSCalendarUnitYear | NSMonthCalendarUnit|NSWeekCalendarUnit ) fromDate:maxDate];
            [componentsForReferenceDate setDay:[componentsForReferenceDate day]-(_diffrence -index)];
            [componentsForReferenceDate setHour:0];
            [componentsForReferenceDate setMinute:0];
            [componentsForReferenceDate setSecond:0] ;
            startDate = [calendar dateFromComponents:componentsForReferenceDate] ;
            componentsForReferenceDate = [calendar components:(NSDayCalendarUnit | NSCalendarUnitYear | NSMonthCalendarUnit ) fromDate:maxDate];
            [componentsForReferenceDate setDay:[componentsForReferenceDate day]-(_diffrence -index)];
            [componentsForReferenceDate setHour:23];
            [componentsForReferenceDate setMinute:59];
            [componentsForReferenceDate setSecond:59] ;
            endDate = [calendar dateFromComponents:componentsForReferenceDate];
            
        }else if ([NSLocalizedString(@"custom", nil) isEqualToString:self.recurringString])
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd-MM-yyyy"];
            startDate = [dateFormat dateFromString:self.strTo];
            componentsForReferenceDate = [calendar components:(NSDayCalendarUnit | NSCalendarUnitYear | NSMonthCalendarUnit ) fromDate:[dateFormat dateFromString:self.strFrom]];
            [componentsForReferenceDate setHour:23];
            [componentsForReferenceDate setMinute:59];
            [componentsForReferenceDate setSecond:59] ;
            endDate = [calendar dateFromComponents:componentsForReferenceDate];
            
        }
        
    
    self.transcationItems=[[NSMutableArray alloc] initWithArray:[[TransactionHandler sharedCoreDataController] getAllTransactionsForID:userToke :startDate :endDate :_selectedViewBy :_SelectedOrderby :self.categeryList :self.paymentList]];
    }else
    {
        [self.transcationItems removeAllObjects];
    }
}


@end
