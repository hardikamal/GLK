//
//  BudgestViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"

@interface BudgetViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblBudget;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnUserName;
@property (strong, nonatomic) IBOutlet UIView *addBudgetView;
@property (strong, nonatomic) IBOutlet UIView *custumeView;
@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) NSArray  *budgetItems;
;

- (IBAction)backbtnClick:(id)sender;
- (IBAction)btnUserNameClick:(id)sender;

@end
