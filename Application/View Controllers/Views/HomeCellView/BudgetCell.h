//
//  BudgetCell.h
//  Daily Expense Manager
//
//  Created by Appbulous on 07/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BudgetCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgCatagery;
@property (strong, nonatomic) IBOutlet UIImageView *imgPaymentMode;
@property (strong, nonatomic) IBOutlet UILabel *lblCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMode;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UILabel *lblBudget;
@property (strong, nonatomic) IBOutlet UILabel *lblSpent;
@property (strong, nonatomic) IBOutlet UILabel *lblLeft;
@property (strong, nonatomic) IBOutlet UILabel *lbltDate;
@property (strong, nonatomic) IBOutlet UIProgressView *progrssView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleBudget;
@property (strong, nonatomic) IBOutlet UILabel *lblTitileSpent;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleLeft;


@end
