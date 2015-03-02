//
//  ChangeProfileViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 23/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeProfileViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (IBAction)btnProfileImageClick:(id)sender;
- (IBAction)btnSubmitClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *textEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtRePassword;

@property (strong, nonatomic) IBOutlet UIImageView *imgViewProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@end
