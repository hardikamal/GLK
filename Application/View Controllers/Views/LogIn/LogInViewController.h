//
//  LogInViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 29/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <GoogleOpenSource/GoogleOpenSource.h>
#import "THPinViewController.h"
#import "UIUnderlinedButton.h"

@interface LogInViewController : UIViewController



@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIUnderlinedButton *btnforgotPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLog;
@property (strong, nonatomic) IBOutlet UIButton *btnNewUser;
@property (strong, nonatomic) IBOutlet UIButton *btnGoogleSignIn;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)btbBackClick:(id)sender;

- (IBAction)signInBtnClick:(id)sender;
- (IBAction)btnSingInwithGoogle:(id)sender;

@end
