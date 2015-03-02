//
//  HistoryViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 11/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
#import "CustomPopUpViewController.h"
#import "UIPopoverListView.h"
@interface HistoryViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;

@property (nonatomic, assign) BOOL slideOutAnimationEnabled;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *summaryView;
@property (strong, nonatomic) IBOutlet UIView *custumView;
@property (strong, nonatomic) IBOutlet UIButton *btnRecurring;
@property (strong, nonatomic) IBOutlet UIButton *btnShowHistroy;
@property (strong, nonatomic) IBOutlet UIButton *btnProfileName;
@property (strong, nonatomic) IBOutlet UIButton *btnTo;
@property (strong, nonatomic) IBOutlet UIView *dobView;
@property (strong, nonatomic) IBOutlet UIButton *btnFrom;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic)  CustomPopUpViewController *objCustomPopUpViewController;
@property (strong, nonatomic) IBOutlet UIDatePicker *dobPicker;
@property (strong, nonatomic) UIPageViewController *pageViewController;


@property (strong, nonatomic)  UIPopoverListView *poplistview;
@property (strong, nonatomic) NSMutableArray  *transcationItems;
@property (assign, nonatomic) NSInteger diffrence;


- (IBAction)btnProfileName:(id)sender;
- (IBAction)btnToClick:(id)sender;
- (IBAction)btnFromClick:(id)sender;
- (IBAction)btnRecurringClick:(id)sender;
- (IBAction)btnClassClick:(id)sender;
- (IBAction)btnOrderClick:(id)sender;
- (IBAction)btnViewClic:(id)sender;
- (IBAction)btnFilterClick:(id)sender;
- (IBAction)backbtnClick:(id)sender;
- (IBAction)cancelDobPickerClick:(id)sender;
- (IBAction)doneDobPickerClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnView;
@property (strong, nonatomic) IBOutlet UIButton *btnFilter;
@property (strong, nonatomic) IBOutlet UIButton *btnOrder;


@end
