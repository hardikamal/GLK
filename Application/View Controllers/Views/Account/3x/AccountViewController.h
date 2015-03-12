//
//  AccountViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 14/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"
@interface AccountViewController : UIViewController

- (IBAction)btnPopUpClick:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnPopUp;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) NSArray  *transcationItems;
@end
