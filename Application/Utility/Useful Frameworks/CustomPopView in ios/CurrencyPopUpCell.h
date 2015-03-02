//
//  CurrencyPopUpCell.h
//  Daily Expense Manager
//
//  Created by Appbulous on 17/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyPopUpCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblCurrency;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
