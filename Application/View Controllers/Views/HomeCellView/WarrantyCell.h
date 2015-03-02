//
//  WarrantyCell.h
//  Daily Expense Manager
//
//  Created by Appbulous on 04/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarrantyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblWarranntyDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgCatagery;
@property (strong, nonatomic) IBOutlet UILabel *lblCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UILabel *lbltDate;
@property (strong, nonatomic) IBOutlet UIProgressView *progrssView;

@end
