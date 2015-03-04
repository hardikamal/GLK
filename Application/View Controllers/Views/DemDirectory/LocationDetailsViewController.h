//
//  LocationDetailsViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 20/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"

@interface LocationDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)btnGetAppClick:(id)sender;
- (IBAction)btnCallClick:(id)sender;

@property (strong, nonatomic) NSMutableArray  *transcationItems;

@property ( nonatomic) NSInteger  index;
@end
