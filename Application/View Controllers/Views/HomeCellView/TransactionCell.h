//
//  TransactionCell.h
//  Application
//
//  Created by Saurabh Singh on 08/03/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgCatagery;
@property (strong, nonatomic) IBOutlet UILabel *lblCatagory;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrrentUser;
@property (strong, nonatomic) IBOutlet UILabel *lblDob;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UILabel *lblExtra;
@property (weak, nonatomic) IBOutlet UIImageView *lblcloud;
@property (weak, nonatomic) IBOutlet UILabel *lblColor;

@end
