//
//  HomeViewController.h
//  Daily Expense Manager
//
//  Created by Jyoti Kumar on 21/07/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MarqueeLabel.h"
#import "NavigationLeftButton.h"
#import "LoginCallbacksViewController.h"
#import "CurrencyPopUpViewController.h"
#import "SWTableViewCell.h"

@interface HomeViewController : UIViewController<UIAlertViewDelegate,SWTableViewCellDelegate>


@property (strong, nonatomic) IBOutlet UILabel *lblNoTap;
@property (strong, nonatomic) IBOutlet UILabel *lblNoAddTransaction;
@property (strong, nonatomic) IBOutlet UILabel *lblNoTransaction;
@property (strong, nonatomic) LoginCallbacksViewController *loginViewController;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleIncom;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleExpense;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleBalance;

@property (strong, nonatomic) IBOutlet UIView *viewEmpty;
@property (strong, nonatomic) IBOutlet MarqueeLabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UILabel *lblIncome;
@property (strong, nonatomic) IBOutlet UILabel *lblExpense;
@property (strong, nonatomic) IBOutlet UILabel *lblBalance;
@property (strong, nonatomic) IBOutlet UIView *viewHorizontalIncom;
@property (strong, nonatomic) IBOutlet UIView *viewHorizontalExpense;
@property (strong, nonatomic) IBOutlet UIView *viewHorizontalBalance;
@property (strong, nonatomic) IBOutlet UITableView *tblviewTransaction;
@property (strong, nonatomic) IBOutlet UILabel *lblTransaction;
@property (strong, nonatomic) IBOutlet UITableView *tblviewBudget;
@property (strong, nonatomic) IBOutlet UILabel *lblBudget;
@property (strong, nonatomic) IBOutlet UITableView *tblviewWarranty;
@property (strong, nonatomic) IBOutlet UILabel *lblWarranty;
@property (strong, nonatomic) IBOutlet UIView *viewEmptyPiChart;

@property (strong, nonatomic) CurrencyPopUpViewController *viewController;

-(void)logOutUserFromServer;

@property (strong, nonatomic) NSArray  *transcationItems;
@property (strong, nonatomic) NSArray  *warrantyItems;
@property (strong, nonatomic) NSArray  *budgetItems;


@end
