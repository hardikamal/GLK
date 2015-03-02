//
//  HomeViewController.h
//  Daily Expense Manager
//
//
//  Created by Saurabh Singh on 25/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SWTableViewCell.h"
#import "BROptionsButton.h"
#import "AddTransactionViewController.h"
@interface HomeViewController : UIViewController<UIAlertViewDelegate,SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIView *firstTimeAddView;
@property (weak, nonatomic) IBOutlet UITableView *tableTransaction;

@end
