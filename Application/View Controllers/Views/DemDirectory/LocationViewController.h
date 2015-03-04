//
//  LocationViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 20/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"
@interface LocationViewController : UIViewController

@property (strong, nonatomic) NSMutableArray  *transcationItems;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)btnBackClick:(id)sender;

@end
