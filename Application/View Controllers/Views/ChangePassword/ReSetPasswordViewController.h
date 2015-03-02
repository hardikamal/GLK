//
//  ReSetPasswordViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 30/08/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReSetPasswordViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtReNewPassword;
@property (strong, nonatomic) IBOutlet UIImageView *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet NSString *emailId;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) IBOutlet UIView *viewEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

- (IBAction)backButtonClick:(id)sender;
- (IBAction)btnSaveClick:(id)sender;


@end
