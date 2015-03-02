//
//  CurrencyPopUpViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 16/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyPopUpViewController : UIViewController

@property(nonatomic) CGFloat  alpha;
@property(nonatomic) CGAffineTransform transform;

@property (strong, nonatomic) IBOutlet UIView *tapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *popUpView;

- (void)dismiss;
- (void)show;
@end
