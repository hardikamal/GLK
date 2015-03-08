//
//  SignUpView.m
//  Daily Expense Manager
//
//  Created by Jyoti Kumar on 09/07/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//


#import "SignUpView.h"
#import "UIAlertView+Block.h"
#import "AFNetworking.h"
#import "SAAPIClient.h"
#import "Utility.h"
#import "TermAndconditionViewController.h"
//#import "MBProgressHUD.h"
#import "UserInfo.h"
#import "UserInfoHandler.h"
#import "TransactionHandler.h"
#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "BudgetHandler.h"
#import "UserInfoHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "HomeViewController.h"
#import "HomeHelper.h"


@interface SignUpView ()
{
    UIDatePicker *datePicker;
    // MBProgressHUD *progressHUD;
    BOOL isCompare;
}

@property (strong, nonatomic) IBOutlet UIButton *imgPhoto;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailId;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtconfirmPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrllView;
@property (strong, nonatomic) IBOutlet UIButton *login;

- (IBAction)submitBtnclick:(id)sender;
- (IBAction)checkPrivacyPolicyandTermsBtnClick:(id)sender;

@end
@implementation SignUpView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrllView.contentSize = CGSizeMake(320, 514);
    isPrivacyPolicySelected = YES;
    UIButton *btnSubmit = (UIButton *)[self.view viewWithTag:5];
    btnSubmit.enabled = YES;
    isCompare = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
    [_login setBackgroundColor:[UIColor colorWithRed:0.173 green:0.580 blue:0.518 alpha:1.000] forState:UIControlStateNormal];
    [_login setBackgroundColor:[UIColor colorWithRed:0.147 green:0.500 blue:0.447 alpha:1.000] forState:UIControlStateHighlighted];

}

- (void)showLeft {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



#pragma mark - IBAction Methods

- (BOOL)specialCharactersOccurence:(NSString *)aString {
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 "] invertedSet];
    if ([aString rangeOfCharacterFromSet:set].location != NSNotFound) {
        [Utility showAlertWithMassager:self.navigationController.view:NSLocalizedString(@"specialCharactersNotAllowed", nil)];
        return NO;
    }
    return YES;
}

- (IBAction)submitBtnclick:(id)sender {
    if ([self canContinueForSignUp]) {
        NSArray *array = [[UserInfoHandler sharedCoreDataController] getAllUserDetails];
        for (UserInfo *info in array) {
            if ([info.user_name caseInsensitiveCompare:[[_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]] == NSOrderedSame) {
                if ([info.hide_status intValue]) {
                    [Utility showAlertWithMassager:self.navigationController.view:NSLocalizedString(@"accountNameExitsHidden", nil)];
                }
                else {
                    [Utility showAlertWithMassager:self.navigationController.view:NSLocalizedString(@"accountNameExitsHidden", nil)];
                }
                return;
            }
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        UIImage *secondImage = [UIImage imageNamed:@"account.png"];
        NSData *imgData1 = UIImagePNGRepresentation(self.imgPhoto.imageView.image);
        NSData *imgData2 = UIImagePNGRepresentation(secondImage);
        isCompare =  [imgData1 isEqual:imgData2];
        if (!isCompare) {
            NSData *imageData = UIImageJPEGRepresentation(self.imgPhoto.imageView.image, 1.0f);
            NSString *imageString = [imageData base64EncodedStringWithOptions:0];
            NSLog(@"%lu", (unsigned long)[imageString length]);
            [dic setObject:imageString forKey:USER_PIC];
        }
        else
            [dic setObject:@"" forKey:USER_PIC];
        
        NSTimeZone *localTime = [NSTimeZone systemTimeZone];
        NSString *mainToken = [Utility userDefaultsForKey:MAIN_TOKEN_ID];
        NSString *currencyName = [Utility userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@", CURRENT_CURRENCY, mainToken]];
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        [dic setObject:[_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:NAME];
        [dic setObject:[_txtEmailId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:EMAIL_ADDRESS];
        [dic setObject:[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:PASSWORD];
        [dic setObject:language forKey:@"Accept-Language"];
        [dic setObject:currencyName forKey:CURRENCY];
        [dic setObject:[Utility machineName] forKey:DEVICE_NAME];
        [dic setObject:[Utility uniqueIDForDevice] forKey:DEVICE_ID];
        [dic setObject:[localTime name] forKey:TIMEZONE];
        [dic setObject:@"YYYY-MM-DD" forKey:@"date_format"];
        [dic setObject:REGISTER forKey:@"cn"];
        [dic setObject:@"1.1" forKey:@"app_version"];
        [self registerWithServer:dic];
    }
}

- (void)registerWithServer:(NSDictionary *)dic {
    SAAPIClient *manager = [SAAPIClient sharedClient];
    [[manager responseSerializer]setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager postPath:@"" parameters:dic success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             if ([[responseObject objectForKey:@"status"] boolValue]) {
                 if (!isCompare) {
                     [[NSUserDefaults standardUserDefaults] setObject:UIImageJPEGRepresentation(self.imgPhoto.imageView.image, 1.0f) forKey:@"key_for_your_image"];
                 }
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CURRENT_CURRENCY_TIMESTAMP];
                 [[HomeHelper sharedCoreDataController] SignUpwithServer:responseObject];
                 
                 UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Success" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
                 [loginAlrt setTag:10];
                 [loginAlrt show];
             }
             else if (![[responseObject objectForKey:@"status"] boolValue]) {
                 UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
                 [loginAlrt show];
             }
         }
         else {
             SHOW_SERVER_NOT_RESPONDING_MESSAGE
         }
     }         failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         SHOW_SERVER_NOT_RESPONDING_MESSAGE
     }];
}

- (IBAction)checkPrivacyPolicyandTermsBtnClick:(id)sender {
    if (isPrivacyPolicySelected) {
        UIButton *btnPrivacy = (UIButton *)[self.view viewWithTag:4];
        [btnPrivacy setImage:[UIImage imageNamed:@"rememberme_box.png"] forState:UIControlStateNormal];
        isPrivacyPolicySelected = NO;
    }
    else {
        UIButton *btnPrivacy = (UIButton *)[self.view viewWithTag:4];
        [btnPrivacy setImage:[UIImage imageNamed:@"remember_box_check.png"] forState:UIControlStateNormal];
        isPrivacyPolicySelected = YES;
    }
}

- (BOOL)canContinueForSignUp {
    BOOL canContinue = YES;
    if (canContinue) {
        canContinue = [CommonFunctions validateNameWithString:_txtName.text WithIdentifier:@"Name"];
    }
    if (canContinue) {
        canContinue = [CommonFunctions validateEmailWithString:_txtEmailId.text WithIdentifier:@"Email"];
    }
    if (canContinue) {
        canContinue = [CommonFunctions validatePasswordWithString:_txtPassword.text WithIdentifier:@"Password"];
    }
    if (canContinue) {
        canContinue = [CommonFunctions validatePasswordWithString:_txtconfirmPassword.text WithIdentifier:@"Confirm Password"];
    }
    if (canContinue) {
        canContinue = [_txtPassword.text isEqualToString:_txtconfirmPassword.text];
        if (!canContinue) {
            [CommonFunctions showToastMessageWithMessage:@"Password do not matches!"];
        }
    }
    if (canContinue) {
        canContinue = isPrivacyPolicySelected;
        if (!canContinue) {
            [CommonFunctions showToastMessageWithMessage:@"Please accept Gullak's Privacy policies and Terms and Conditions"];
        }
    }
    if (canContinue) {
        canContinue = [CommonFunctions getStatusForNetworkConnectionAndShowUnavailabilityMessage:YES];
    }
    return canContinue;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _txtEmailId) {
        if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@" "]) {
            return NO;
        }
        return (([textField.text length] + [string length] - range.length) > MAXIMUM_LENGTH_LIMIT_EMAIL) ? NO : YES;
    }
    else if (textField == _txtPassword || textField == _txtconfirmPassword) {
        if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@" "]) {
            return NO;
        }
        return (([textField.text length] + [string length] - range.length) > MAXIMUM_LENGTH_LIMIT_PASSWORD) ? NO : YES;
    }
    else if (textField == _txtName) {
        return (([textField.text length] + [string length] - range.length) > MAXIMUM_LENGTH_LIMIT_FIRST_NAME + MAXIMUM_LENGTH_LIMIT_LAST_NAME) ? NO : YES;
    }
    return YES;
}

#pragma mark -GeneralMethodForCamera

- (void)CameraFile {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    imgPicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        imgPicker.sourceType = sourceType;
        imgPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imgPicker animated:YES completion:NULL];
    }
    else {
        [Utility showAlertWithMassager:self.navigationController.view:@"You don't have camera"];
    }
}

- (void)CameraRollFile {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.allowsEditing = NO;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        imgPicker.sourceType = sourceType;
        [self presentViewController:imgPicker animated:YES completion:NULL];
    }
    else {
        [Utility showAlertWithMassager:self.navigationController.view:@"You don't have camera"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10) {
        NSString *noticationName = @"LeftMenuViewController";
        [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:nil];
        HomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image;
    if ([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
        image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.size.width / 2;
        self.imgPhoto.clipsToBounds = YES;
        self.imgPhoto.layer.borderWidth = 2.0f;
        self.imgPhoto.layer.borderColor = [UIColor blackColor].CGColor;
        [self.imgPhoto setImage:image forState:UIControlStateNormal];
    }
}

- (IBAction)btnTermandCondition:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
    self.controller = [storyboard instantiateViewControllerWithIdentifier:@"TermAndconditionViewController"];
    [self.controller show];
}

- (IBAction)backbtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)profilebtnClick:(id)sender {
    RESIGN_KEYBOARD
    CGPoint scrollPoint = CGPointMake(0.0, 0.0);
    [self.scrllView setContentOffset:scrollPoint animated:YES];
    self.scrllView.scrollEnabled = YES;
    self.scrllView.contentSize = CGSizeMake(320, 514);
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[NSArray arrayWithObjects:@"Take Photo", @"Photo From Gallery", nil] tapBlock: ^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"Take Photo"]) {
            [self CameraFile];
        }
        else if ([title isEqualToString:@"Photo From Gallery"]) {
            [self CameraRollFile];
        }
    }];
}

@end
