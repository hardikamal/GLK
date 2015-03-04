//
//  DemCell.h
//  Daily Expense Manager
//
//  Created by Appbulous on 16/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"

@interface DemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *lblLine;
@property (strong, nonatomic) IBOutlet UIImageView *imgName;
@property (strong, nonatomic) IBOutlet UILabel *lbluserName;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNo;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnCall;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnGetApp;

@end
