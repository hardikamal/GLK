//
//  CreateBudgetsViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Budget.h"
#import "NavigationLeftButton.h"
#import "DoneCancelNumberPadToolbar.h"


@interface CreateBudgetsViewController : UIViewController<DoneCancelNumberPadToolbarDelegate>

@property (strong, nonatomic) IBOutlet NavigationLeftButton *buttonUnhideCategery;
@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblTile;
@property (strong, nonatomic)  Budget *transaction;
@property (strong, nonatomic) IBOutlet UITextField *txtAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblTitlFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblTitileTo;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrency;
@property (strong, nonatomic) IBOutlet UIImageView *imgCatagery;
@property (strong, nonatomic) IBOutlet UIButton *btnCategery;
@property (strong, nonatomic) IBOutlet UIButton *btnPaymentMode;
@property (strong, nonatomic) IBOutlet UIButton *btnProfileName;


@property (strong, nonatomic) IBOutlet UIImageView *imgpaymentmode;

@property (strong, nonatomic) IBOutlet UILabel *lblFromDay;
@property (strong, nonatomic) IBOutlet UILabel *lblFromMonthYear;
@property (strong, nonatomic) IBOutlet UILabel *lblToDay;
@property (strong, nonatomic) IBOutlet UILabel *lblToMonthYear;

@property (strong, nonatomic) IBOutlet UIView *dobView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dobPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblSabCatagery;
- (IBAction)datebtnFrombtnClick:(id)sender;
- (IBAction)datebtnToClick:(id)sender;
- (IBAction)cancelDobPickerClick:(id)sender;
- (IBAction)doneDobPickerClick:(id)sender;
- (IBAction)addBudgetintoDataBase:(id)sender;
- (IBAction)backbtnClick:(id)sender;
- (IBAction)btnProfileNameclick:(id)sender;


@end
