//
//  AddTransactionViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 01/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"
#import "Transactions.h"
#import "NavigationLeftButton.h"
#import "DoneCancelNumberPadToolbar.h"
#import "AutocompletionTableView.h"


@interface AddTransactionViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,DoneCancelNumberPadToolbarDelegate,AutocompletionTableViewDelegate>

//---I reused
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *primeTimeLabel;
//------------------------

@property (strong, nonatomic) IBOutlet UILabel *lblToday;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *buttonUnhideCategery;

@property (strong, nonatomic) IBOutlet UILabel *lblNewTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (strong, nonatomic) IBOutlet UILabel *lblCarrency;
@property (strong, nonatomic) IBOutlet UIButton *btnCategery;
@property (strong, nonatomic) IBOutlet UIButton *btnUserName;
@property (strong, nonatomic) IBOutlet UIButton *btnPaymentMode;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *moreDetailsView;
@property (strong, nonatomic) IBOutlet UIButton *btnAddmoreDetails;

@property (strong, nonatomic) IBOutlet UIView *imgView;



@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBtn;
@property (strong, nonatomic) IBOutlet UITextField *txtAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtDescription;
@property (strong, nonatomic) IBOutlet UITextField *txtEnterLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblSubCategory;
@property (strong, nonatomic) IBOutlet UITextField *txtTagaPerson;
@property (strong, nonatomic) IBOutlet UITextField *txtwarranty;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblMonthYear;
@property (strong, nonatomic) IBOutlet UILabel *lblPmorAm;
@property (strong, nonatomic) IBOutlet UIView *dobView;
@property (weak, nonatomic)   IBOutlet UIDatePicker *dobPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblExpiryDate;
@property (strong, nonatomic) IBOutlet UILabel *lblSabCatagery;

@property (strong, nonatomic) IBOutlet UIButton *btnWarranty;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategery;
@property (strong, nonatomic) IBOutlet UIImageView *imgPaymentmode;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;

@property (strong, nonatomic)  Transactions *transaction;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarBtn;
@property (nonatomic, readwrite) BOOL isIncomeSelected;

- (IBAction)btnUserNameClick:(id)sender;
- (IBAction)backbtnClick:(id)sender;
- (IBAction)addingTransactionToDBbtnClick:(id)sender;
- (IBAction)addMoreDetailsClick:(id)sender;
- (IBAction)datePickerbtnClick:(id)sender;
- (IBAction)timePickerbtnClick:(id)sender;
- (IBAction)cancelDobPickerClick:(id)sender;
- (IBAction)doneDobPickerClick:(id)sender;
- (IBAction)incomebtnClick:(id)sender;
- (IBAction)warrantybtnClick:(id)sender;
- (IBAction)expensebtnClick:(id)sender;
- (IBAction)galarybtnClick:(id)sender;
- (IBAction)camrabtnClick:(id)sender;

@end
