//
//  ReminderCell.h
//  Daily Expense Manager
//
//  Created by Appbulous on 17/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface ReminderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitleNext;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTransaction;

@property (strong, nonatomic) IBOutlet UIImageView *imgCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblProfileName;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet UILabel *lblNextReminderDate;
@property (strong, nonatomic) IBOutlet UILabel *lblNextTransationDate;
@property (strong, nonatomic) IBOutlet UILabel *lblAlarmChek;



@end
