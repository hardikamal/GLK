//
//  FirstViewController.h
//  Gullak
//
//  Created by Saurabh Singh on 25/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"
#import "THPinViewController.h"

@interface FirstViewController : UIViewController <PagedFlowViewDelegate, PagedFlowViewDataSource,THPinViewControllerDelegate>

@property (nonatomic, strong) IBOutlet PagedFlowView *hFlowView;
@property (nonatomic, strong) IBOutlet UIPageControl *hPageControl;

- (IBAction)pageControlValueDidChange:(id)sender;
//-----------
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogIn;
@property (nonatomic, assign) BOOL locked;
@property (strong, nonatomic) IBOutlet UIButton *btnNewUser;

@property (strong, nonatomic) IBOutlet UIButton *btnGoogleSignIn;
- (IBAction)signInBtnClick:(id)sender;
- (IBAction)btnSingInwithGoogle:(id)sender;
@end
