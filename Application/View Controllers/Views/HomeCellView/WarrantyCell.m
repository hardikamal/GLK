//
//  WarrantyCell.m
//  Daily Expense Manager
//
//  Created by Appbulous on 04/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "WarrantyCell.h"

@implementation WarrantyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
  
    [self.lblCategery setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblDiscription setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lbltDate setFont:[UIFont fontWithName:Ebrima_Bold size:12.0f]];
    [self.lblAmount setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    [self.lblUserName setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblWarranntyDate setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    
    // Configure the view for the selected state
}



@end
