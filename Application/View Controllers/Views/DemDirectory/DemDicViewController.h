//
//  DemDicViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 20/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"
#import "BoderView.h"


@interface DemDicViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnLocation;

@property (strong, nonatomic) IBOutlet UILabel *lblTitel;

@property (strong, nonatomic) NSArray  *transcationItems;

@end
