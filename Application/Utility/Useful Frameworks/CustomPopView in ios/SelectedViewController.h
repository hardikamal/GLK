//
//  SelectedViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 24/09/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
- (IBAction)btnSelectClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (nonatomic,strong)NSArray *item;
@property (strong, nonatomic) IBOutlet UILabel *lblTitile;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tapView;
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet NSString *titleString;
@property BOOL chekPaymentorCategery;
- (IBAction)okbtnClick:(id)sender;
- (IBAction)CanclebtnClick:(id)sender;
@property(nonatomic) CGFloat  alpha;
@property(nonatomic) CGAffineTransform transform;
- (void)show;
- (void)dismiss;

@end
