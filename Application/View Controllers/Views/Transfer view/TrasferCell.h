//
//  TrasferCell.h
//  Daily Expense Manager
//
//  Created by Appbulous on 16/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrasferCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblCatgery;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTransactionDetails;

@end
