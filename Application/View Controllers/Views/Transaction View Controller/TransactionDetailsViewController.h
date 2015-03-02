//
//  TransactionDetailsViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 19/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All  reserved.
//

#import <UIKit/UIKit.h>
#import "Transactions.h"
#import "NavigationLeftButton.h"
@interface TransactionDetailsViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnBack;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblTielExtra;
@property (strong, nonatomic) IBOutlet UILabel *lblExtra;
@property (strong, nonatomic) IBOutlet UIView *viewImageView;

@property (strong, nonatomic) IBOutlet UIView *viewExtra;

@property (strong, nonatomic) IBOutlet UILabel *lblAcccount;
@property (strong, nonatomic) IBOutlet UILabel *lblCategery;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
- (IBAction)btnEditClick:(id)sender;
- (IBAction)btnDeleate:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIImageView *imgPaymentMode;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMode;
@property (strong, nonatomic) IBOutlet UILabel *lblLocatation;
@property (strong, nonatomic) IBOutlet UILabel *lblWithPerson;
@property (strong, nonatomic) IBOutlet UILabel *lblWarranty;

@property (strong, nonatomic)  Transactions *transaction;

@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)BackbtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet NSString *newtitle;

@end
