//
//  DeleteDemDataViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 27/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteDemDataViewController : UIViewController

- (IBAction)btnIncomClick:(id)sender;
- (IBAction)btnReminderClick:(id)sender;
- (IBAction)btnBudgetClick:(id)sender;
- (IBAction)btnTransferClick:(id)sender;
- (IBAction)btnWarrantiesClick:(id)sender;
- (IBAction)btnDeleteClick:(id)sender;
- (IBAction)btnCancleClick:(id)sender;
- (IBAction)btnExpenseClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnReminder;
@property (strong, nonatomic) IBOutlet UIButton *btnBudgets;
@property (strong, nonatomic) IBOutlet UIButton *btnWarranties;
@property (strong, nonatomic) IBOutlet UIButton *btnTransfer;
@property (strong, nonatomic) IBOutlet UIButton *btnIncom;
@property (strong, nonatomic) IBOutlet UIButton *btnExpense;
@property (strong, nonatomic) IBOutlet UIView *tapView;

@end
