//
//  CreateReminderViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 05/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"
#import "NavigationLeftButton.h"
#import "Reminder.h"
#import "DoneCancelNumberPadToolbar.h"
@interface CreateReminderViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DoneCancelNumberPadToolbarDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *buttonUnhideCategery;
@property (strong, nonatomic) IBOutlet UITextField *txtHeading;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *txtAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtDiscription;
@property (strong, nonatomic) IBOutlet UIView *customImageView;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UIButton *btnCategery;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewDays;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewHour;
@property (strong, nonatomic) IBOutlet UIImageView *imgCatagery;
@property (strong, nonatomic) IBOutlet UIImageView *imgpaymentmode;
@property (strong, nonatomic) IBOutlet UILabel *lblSubcategery;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrency;
@property (strong, nonatomic) IBOutlet UIButton *btnRecurring;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lblMonthYear;
@property (strong, nonatomic) IBOutlet UILabel *lblPmorAm;
@property (strong, nonatomic) IBOutlet UIView *dobView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dobPicker;
@property (strong, nonatomic) IBOutlet UIImageView *imgReminder;
@property (strong, nonatomic) IBOutlet UIImageView *imgDayBefore;
@property (strong, nonatomic) IBOutlet UIImageView *imgHoutBefore;
@property (strong, nonatomic) IBOutlet UIButton *btnPaymentMode;
@property (strong, nonatomic) IBOutlet UIButton *btnProfileName;
@property (strong, nonatomic) IBOutlet UIButton *btnClass;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleRecurring;
@property (strong, nonatomic) IBOutlet UILabel *lblRemindrTime;
@property (strong, nonatomic) IBOutlet UILabel *lblDayBefore;
@property (strong, nonatomic) IBOutlet UILabel *lblAlertNotification;

@property (strong, nonatomic)  Reminder *transaction;

@property (strong, nonatomic) IBOutlet UISwitch *btnHidestatus;

@property (strong, nonatomic) IBOutlet UILabel *lblHourBefore;

- (IBAction)takeCamrabtbClick:(id)sender;
- (IBAction)gallaryImagebtnClick:(id)sender;
- (IBAction)datePickerbtnClick:(id)sender;
- (IBAction)timePickerbtnClick:(id)sender;
- (IBAction)cancelDobPickerClick:(id)sender;
- (IBAction)doneDobPickerClick:(id)sender;
- (IBAction)classbtnClick:(id)sender;
- (IBAction)recurringbtnClick:(id)sender;
- (IBAction)daybeforebtnClick:(id)sender;
- (IBAction)reminderbtnClick:(id)sender;
- (IBAction)hourbeforebtnClick:(id)sender;
- (IBAction)BackbtnClick:(id)sender;
- (IBAction)addingReminderToDB:(id)sender;
- (IBAction)btnUserNameClick:(id)sender;
- (IBAction)stateChanged:(id)sender;

@end
