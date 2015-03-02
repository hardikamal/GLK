//
//  TrasferCell.m
//  Daily Expense Manager
//
//  Created by Appbulous on 16/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "TrasferCell.h"

@implementation TrasferCell

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
    [self.lblCatgery setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblTransactionDetails setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblDiscription setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblAmount setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblDate setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    
    // Configure the view for the selected state
}

@end
