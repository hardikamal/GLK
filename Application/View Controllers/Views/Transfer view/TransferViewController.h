//
//  TransferViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"
#import "SWTableViewCell.h"
@interface TransferViewController : UIViewController<SWTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageTransfer;

@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) NSArray  *transferItems;
@property (strong, nonatomic) IBOutlet UITableView *tablview;
@property (strong, nonatomic) IBOutlet UIView *customeView;
@property (strong, nonatomic) IBOutlet UIView *addWarrantyView;
@property (strong, nonatomic) IBOutlet UIView *emptyWarrantyView;

- (IBAction)btnUserNameClick:(id)sender;
- (IBAction)backbtnClick:(id)sender;

@end
