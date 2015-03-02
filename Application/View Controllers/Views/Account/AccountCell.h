//
//  AccountCell.h
//  Daily Expense Manager
//
//  Created by Appbulous on 15/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnAccount;
@property (strong, nonatomic) IBOutlet UIImageView *imag;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleIncome;
@property (strong, nonatomic) IBOutlet UILabel *lblTitileExpense;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleBalance;
@property (strong, nonatomic) IBOutlet UILabel *lblProfileName;
@property (strong, nonatomic) IBOutlet UILabel *lblAccount;
@property (strong, nonatomic) IBOutlet UILabel *lblIncome;
@property (strong, nonatomic) IBOutlet UILabel *lblExpense;
@property (strong, nonatomic) IBOutlet UILabel *lblBalance;
@property (strong, nonatomic) IBOutlet UILabel *lblLine;


@end
