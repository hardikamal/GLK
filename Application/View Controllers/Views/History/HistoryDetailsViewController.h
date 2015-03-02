//
//  HistoryDetailsViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 29/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoderView.h"

@interface HistoryDetailsViewController : UIViewController
- (IBAction)btnPriviousClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *incomeView;
@property (strong, nonatomic) IBOutlet UIView *expenseView;
@property (strong, nonatomic) IBOutlet UIView *balanceView;
@property (strong, nonatomic) IBOutlet UILabel *lblIncome;
@property (strong, nonatomic) IBOutlet UILabel *lblExpense;
@property (strong, nonatomic) IBOutlet UILabel *lblBalance;
@property (strong, nonatomic) IBOutlet UILabel *lblScheduleTime;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray  *transcationItems;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *custumView;
@property (strong, nonatomic) IBOutlet UILabel *lblSummery;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleIncome;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleExpense;
@property (strong, nonatomic) IBOutlet UILabel *lblTitileBalnce;
@property (strong, nonatomic) IBOutlet BoderView *summaryView;
@property (strong, nonatomic)  NSString *userName;
@property (strong, nonatomic)  NSString *recurringString;
@property (assign, nonatomic) NSInteger diffrence;
@property (strong, nonatomic) NSString *selectedViewBy;
@property (strong, nonatomic) NSString *SelectedOrderby;
@property (strong, nonatomic) NSString  *strTo;
@property (strong, nonatomic) NSString  *strFrom;
@property (strong, nonatomic) NSMutableArray *categeryList;
@property (strong, nonatomic) NSMutableArray *paymentList;

@end
