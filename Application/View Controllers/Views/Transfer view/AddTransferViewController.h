//
//  AddTransferViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 10/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"
#import "Transfer.h"
#import "DoneCancelNumberPadToolbar.h"
@interface AddTransferViewController : UIViewController<DoneCancelNumberPadToolbarDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgeFromProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imageToProfile;

@property (strong, nonatomic) IBOutlet NavigationLeftButton *buttonUnhideCategery;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblMonthYear;
@property (strong, nonatomic) IBOutlet UILabel *lbltime;
@property (strong, nonatomic) IBOutlet UILabel *lblPmorAm;
@property (strong, nonatomic) IBOutlet UIView *dobView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dobPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblSabCatagery;
@property (strong, nonatomic) IBOutlet UILabel *lblCarrancy;
@property (strong,nonatomic) Transfer *transaction;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (strong, nonatomic) IBOutlet UILabel *lblToday;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnCategory;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnPaymentMode;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnUserFrom;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnUserTo;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategery;
@property (strong, nonatomic) IBOutlet UIImageView *imgPaymentmode;

- (IBAction)btnUserFromClick:(id)sender;
- (IBAction)backbtnClick:(id)sender;
- (IBAction)btnDoneClick:(id)sender;
- (IBAction)btnUserToClick:(id)sender;
- (IBAction)datePickerbtnClick:(id)sender;
- (IBAction)timePickerbtnClick:(id)sender;
- (IBAction)cancelDobPickerClick:(id)sender;
- (IBAction)doneDobPickerClick:(id)sender;
- (IBAction)backButtonClick:(id)sender;


@end
