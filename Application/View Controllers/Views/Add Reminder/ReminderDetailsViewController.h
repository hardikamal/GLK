//
//  ReminderDetailsViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 03/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"
@interface ReminderDetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleate;
- (IBAction)btnEditClick:(id)sender;
- (IBAction)btnDeleteClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *lblAcccount;
@property (strong, nonatomic) IBOutlet UILabel *lblCategery;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;
@property (strong, nonatomic) IBOutlet UILabel *lblRecurring;
@property (strong, nonatomic) IBOutlet UILabel *lblAlert;

@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIImageView *imgPaymentMode;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMode;

@property (strong, nonatomic)  Reminder *transaction;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *scrollViewSubview;

- (IBAction)BackbtnClick:(id)sender;

@end
