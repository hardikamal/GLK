//
//  CustomPopUpViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 23/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SelectedViewController.h"
@interface CustomPopUpViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIView *tapView;
@property (strong, nonatomic) IBOutlet UILabel *lblCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMode;
@property (nonatomic, strong) UIControl *controlForDismiss;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitile;

- (IBAction)btnCategory:(id)sender;
- (IBAction)btnPaymentModeClick:(id)sender;
- (IBAction)btnApplayFilterClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;

- (IBAction)tapGestureClick:(id)sender;

@property (strong, nonatomic)  SelectedViewController *objCustomPopUpViewController;
@property (strong, nonatomic) NSMutableArray *categryList;
@property (strong, nonatomic) NSMutableArray *paymentModeList;

@property(nonatomic) CGFloat  alpha;
@property(nonatomic) CGAffineTransform transform;
- (void)show;
- (void)dismiss;

@end
