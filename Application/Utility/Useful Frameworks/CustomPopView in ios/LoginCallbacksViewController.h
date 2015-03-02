//
//  LoginCallbacksViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 31/12/14.
//  Copyright (c) 2014 Chandan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginCallbacksViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *tapView;
@property (strong, nonatomic) IBOutlet UILabel *lblCategries;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMode;
@property (strong, nonatomic) IBOutlet UILabel *lblTransfer;
@property (strong, nonatomic) IBOutlet UILabel *lblBudgets;
@property (strong, nonatomic) IBOutlet UILabel *lblReminder;
@property (strong, nonatomic) IBOutlet UILabel *lblIncome;
@property (strong, nonatomic) IBOutlet UILabel *lbltitile;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorCategery;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorPaymentMode;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorTransfer;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorBudgets;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorRemider;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorTransaction;



@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property(nonatomic) CGFloat  alpha;
@property(nonatomic) CGAffineTransform transform;
- (void)show;
- (void)dismiss;

@end
