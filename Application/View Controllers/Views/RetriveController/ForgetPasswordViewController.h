//
//  ForgetPasswordViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 25/08/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblDiscribe;
@property (strong, nonatomic) IBOutlet UIButton *btnResSetPassword;
@property (strong, nonatomic) NSString *resetToken;
@property BOOL locked;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailId;

- (IBAction)changePasswordclick:(id)sender;

@end
