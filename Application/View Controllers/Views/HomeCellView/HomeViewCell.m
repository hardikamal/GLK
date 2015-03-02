//
//  HomeViewCell.m
//  Daily Expense Manager
//
//  Created by Appbulous on 30/08/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "HomeViewCell.h"

@implementation HomeViewCell

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
    [self.lblCatagory setFont:[UIFont fontWithName:Embrima size:14.0f]];
    [self.lblCurrrentUser setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblExtra setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblDiscription setFont:[UIFont fontWithName:Embrima size:12.0f]];
    [self.lblAmount setFont:[UIFont fontWithName:Ebrima_Bold size:14.0f]];
    [self.lblDob setFont:[UIFont fontWithName:Ebrima_Bold size:14.0f]];

}

@end
