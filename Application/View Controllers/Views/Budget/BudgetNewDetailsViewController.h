//
//  BudgetNewDetailsViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 29/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Budget.h"

@interface BudgetNewDetailsViewController : UIViewController
@property (nonatomic, strong)  NSString *hello;
@property (nonatomic, strong)  Budget *tran;


@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UILabel *lblTransaction;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *scrollViewSubview;


@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAccount;
@property (strong, nonatomic) IBOutlet UILabel *lblCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategery;
@property (strong, nonatomic) IBOutlet UILabel *lbldiscription;
@property (strong, nonatomic) IBOutlet UILabel *lblFromDate;
@property (strong, nonatomic) IBOutlet UILabel *lblToDate;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMode;
@property (strong, nonatomic) IBOutlet UIImageView *imgPaymentMode;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) NSMutableArray  *transcationItems;

- (IBAction)btnEditClick:(id)sender;
- (IBAction)btnDeleteClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;



@end
