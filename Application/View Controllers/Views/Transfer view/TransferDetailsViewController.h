//
//  TransferDetailsViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 16/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transfer.h"
@interface TransferDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
- (IBAction)btnDeleteClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
- (IBAction)btnEditClick:(id)sender;

- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblUserFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblUserTo;
@property (strong, nonatomic) IBOutlet UILabel *lblCategery;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIImageView *imgPaymentMode;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMode;

@property (strong, nonatomic)  Transfer *transaction;

@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
- (IBAction)BackbtnClick:(id)sender;

@end
