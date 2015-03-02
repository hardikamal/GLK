//
//  PaymentModeViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 03/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"

@interface PaymentModeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSMutableArray *paymentModeList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgTitle;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnBack;
@property (strong, nonatomic) IBOutlet NSString *paymentMode;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnDoneClick:(id)sender;


@end
