//
//  SettingViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 21/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleteDemDataViewController.h"
#import "ExportViewController.h"
#import "ImportViewController.h"
@interface SettingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;


- (IBAction)btnExportClick:(id)sender;
- (IBAction)btnImportClick:(id)sender;
- (IBAction)btnChangeCurrency:(id)sender;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnViewReports;
- (IBAction)btnViewReportClick:(id)sender;

@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnChangeCurrency;

- (IBAction)btnUnChekClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnDeleteClick:(id)sender;
@property (strong, nonatomic)  DeleteDemDataViewController *objCustomPopUpViewController;
@property (strong, nonatomic)  ExportViewController *exportViewController;
@property (strong, nonatomic)  ImportViewController *importPopUpViewController;

@property (strong, nonatomic) IBOutlet UILabel *lblDispaly;
@property (strong, nonatomic) IBOutlet UILabel *lblDatabase;
@property (strong, nonatomic) IBOutlet UIButton *btnExport;
@property (strong, nonatomic) IBOutlet UIButton *btnImport;
@property (strong, nonatomic) IBOutlet UIButton *btnViewReport;
@property (strong, nonatomic) IBOutlet UILabel *lblSecurity;
@property (strong, nonatomic) IBOutlet UIButton *btnPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblExtra;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeLog;
@property (strong, nonatomic) IBOutlet UIButton *btnContactDem;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteDem;
@property (strong, nonatomic) IBOutlet UIView *securityView;
@property (strong, nonatomic) IBOutlet UILabel *lblProfile;
- (IBAction)btnContactDemSupportClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrency;
@property (strong, nonatomic) IBOutlet UIButton *btnCategery;
@property (strong, nonatomic) IBOutlet UIButton *btnPaymentMode;



@end
