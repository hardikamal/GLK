//
//  CustomizeExportViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 21/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"
#import "SelectedViewController.h"
#import "CHCSVParser.h"
#import "VSGGoogleServiceDrive.h"

@interface CustomizeExportViewController : UIViewController<CHCSVParserDelegate,UIAlertViewDelegate>


@property (weak, readonly) VSGGoogleServiceDrive *driveService;
@property (retain) NSMutableArray *driveFiles;
@property BOOL isAuthorized;
@property (strong,nonatomic) NSString *isAuth;

@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnCategery;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnPaymentMode;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategery;
@property (strong, nonatomic) IBOutlet UIImageView *imagePaymentMode;
@property (strong, nonatomic) NSString *selectedViewBy;
@property (strong, nonatomic) NSString *SelectedOrderby;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnCategeryClick:(id)sender;
- (IBAction)btnPaymentModeClick:(id)sender;
- (IBAction)btnFromClick:(id)sender;
- (IBAction)btnToClick:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnExpese;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnIncome;

- (IBAction)btnExpenseClick:(id)sender;
- (IBAction)btnIncomeClick:(id)sender;

- (IBAction)btnExportDataClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *dobView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dobPicker;

- (IBAction)btnCancleClick:(id)sender;
- (IBAction)btnDoneClick:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblFromDay;
@property (strong, nonatomic) IBOutlet UILabel *lblFromMonthYear;
@property (strong, nonatomic) IBOutlet UILabel *lblToDay;
@property (strong, nonatomic) IBOutlet UILabel *lblToMonthYear;

@property (strong, nonatomic)  SelectedViewController *objCustomPopUpViewController;
@property (strong, nonatomic) NSMutableArray *categryList;
@property (strong, nonatomic) NSMutableArray *paymentModeList;

@end
