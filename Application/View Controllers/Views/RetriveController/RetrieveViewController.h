//
//  RetrieveViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 30/08/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetrieveViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtSecurity;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;
@property (strong, nonatomic) IBOutlet NSString *resetToken;
@property (strong, nonatomic) IBOutlet NSString *emailId;

- (IBAction)btnRetiveClick:(id)sender;

- (IBAction)backButtonClick:(id)sender;

@end
