//
//  HelpViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 06/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
// #define DATEFORMATTER @"yyyy-MM-dd HH:mm:ss"

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"

@interface HelpViewController : UIViewController

- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) NSString *xlsPath;
@end

