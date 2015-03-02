
//
//  AccountCell.m
//  Daily Expense Manager
//
//  Created by Appbulous on 15/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "AccountCell.h"

@implementation AccountCell

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
    [self.lblAccount setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblBalance setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblExpense setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblIncome setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblProfileName setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblTitileExpense setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblTitleBalance setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblTitleIncome setFont:[UIFont fontWithName:Embrima size:16.0f]];
    
    // Configure the view for the selected state
}


@end
