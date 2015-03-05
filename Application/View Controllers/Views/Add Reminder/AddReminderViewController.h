//
//  AddReminderViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 04/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NavigationLeftButton.h"

@interface AddReminderViewController : UIViewController
@property (strong, nonatomic) NSArray  *reminderItems;
@property (strong, nonatomic) IBOutlet UIView *customeView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)popUpViewbtnClick:(id)sender;
- (IBAction)backbtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnUserName;
- (IBAction)btnUserClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *addReminderView;
@property (strong, nonatomic) IBOutlet UIView *noReminderView;

@end
