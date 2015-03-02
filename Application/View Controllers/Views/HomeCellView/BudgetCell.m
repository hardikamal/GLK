//
//  BudgetCell.m
//  Daily Expense Manager
//
//  Created by Appbulous on 07/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "BudgetCell.h"

@implementation BudgetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self.lblBudget setFont:[UIFont fontWithName:Embrima size:14.0f]];
    [self.lblCategery setFont:[UIFont fontWithName:Embrima size:14.0f]];
    [self.lblDiscription setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblLeft setFont:[UIFont fontWithName:Ebrima_Bold size:14.0f]];
    [self.lblPaymentMode setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblSpent setFont:[UIFont fontWithName:Embrima size:14.0f]];
    [self.lbltDate setFont:[UIFont fontWithName:Embrima size:14.0f]];
    [self.lblTitileSpent setFont:[UIFont fontWithName:Embrima size:14.0f]];
    [self.lblTitleBudget setFont:[UIFont fontWithName:Embrima size:14.0f]];
    [self.lblTitleLeft setFont:[UIFont fontWithName:Ebrima_Bold size:14.0f]];
    [self.lblUserName setFont:[UIFont fontWithName:Embrima size:14.0f]];
    // Configure the view for the selected state
}

@end
