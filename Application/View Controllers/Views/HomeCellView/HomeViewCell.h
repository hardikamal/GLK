//
//  HomeViewCell.h
//  Daily Expense Manager
//
//  Created by Appbulous on 30/08/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface HomeViewCell : SWTableViewCell<SWTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgCatagery;
@property (strong, nonatomic) IBOutlet UILabel *lblCatagory;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrrentUser;
@property (strong, nonatomic) IBOutlet UILabel *lblDob;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UILabel *lblExtra;



@end
