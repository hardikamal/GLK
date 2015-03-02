//
//  AddAccountViewController.h
//  Daily Expense Manager
//
//  Created by Appbulous on 14/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationLeftButton.h"
#import "UserInfo.h"
@interface AddAccountViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet NavigationLeftButton *buttonUnhideCategery;

@property (strong, nonatomic) IBOutlet UILabel *lblMyLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblHidestaus;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIView *hideStatusView;
@property (strong, nonatomic) IBOutlet NavigationLeftButton *btnTitle;

@property (strong, nonatomic) IBOutlet UITextField *txtCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnProfileImage;
@property (strong, nonatomic) IBOutlet UISwitch *btnLocation;
@property (strong, nonatomic) IBOutlet UISwitch *btnHidestatus;


- (IBAction)btnBackClick:(id)sender;
- (IBAction)swithLocationClick:(id)sender;
- (IBAction)swithStatusClick:(id)sender;
- (IBAction)addAccountToDB:(id)sender;
- (IBAction)btnProfileImageClick:(id)sender
;


@property (strong, nonatomic) UserInfo *info;


@end


