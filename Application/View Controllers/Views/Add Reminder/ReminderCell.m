//
//  ReminderCell.m
//  Daily Expense Manager
//
//  Created by Appbulous on 17/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "ReminderCell.h"

@implementation ReminderCell

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
    [self.lblCategery setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblProfileName setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblAlarmChek setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblDiscription setFont:[UIFont fontWithName:Embrima size:10.0f]];
    [self.lblAmount setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblNextReminderDate setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblNextTransationDate setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    
    [self.lblTitleNext setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblTitleTransaction setFont:[UIFont fontWithName:Embrima size:12.0f]];
    
    // Configure the view for the selected state
}

@end
