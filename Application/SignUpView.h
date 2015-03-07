//
//  SignUpView.h
//  Daily Expense Manager
//
//  Created by Jyoti Kumar on 09/07/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermAndconditionViewController.h"
@interface SignUpView : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    BOOL isPrivacyPolicySelected;
}

@property (strong, nonatomic) TermAndconditionViewController *controller;

@property (strong, nonatomic) IBOutlet UILabel *lblProfile;
- (IBAction)btnTermandCondition:(id)sender;

- (IBAction)backbtnClick:(id)sender;

- (IBAction)profilebtnClick:(id)sender;


@end
