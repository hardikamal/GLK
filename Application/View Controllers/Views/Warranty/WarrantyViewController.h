//
//  WarrantyViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 09/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"

@interface WarrantyViewController : UIViewController

@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnUserName;
@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;
@property (strong, nonatomic) IBOutlet UITableView *tablview;
@property (strong, nonatomic) IBOutlet UIView *customeView;
@property (strong, nonatomic) IBOutlet UIView *addWarrantyView;
@property (strong, nonatomic) IBOutlet UIView *emptyWarrantyView;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *buttonUnhideCategery;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSArray  *warrantyItems;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnUserClick:(id)sender;

@end
