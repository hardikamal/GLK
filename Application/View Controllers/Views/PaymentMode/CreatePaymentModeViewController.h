//
//  CreatePaymentModeViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Paymentmode.h"

@interface CreatePaymentModeViewController : UIViewController
@property (strong, nonatomic) Paymentmode *mode;

- (IBAction)btnBackClick:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *textPayemtnMode;
@property (strong, nonatomic) IBOutlet UISwitch *btnHideStaus;
@property (strong, nonatomic) IBOutlet UILabel *lblHideStaus;
@property (strong, nonatomic) NSString *string;
- (IBAction)btnHideStausClick:(id)sender;
- (IBAction)btnDoneClick:(id)sender;


@end
