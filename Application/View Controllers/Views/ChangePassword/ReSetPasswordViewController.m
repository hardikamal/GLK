
//
//  ReSetPasswordViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 30/08/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "ReSetPasswordViewController.h"
#import "UIUnderlinedButton.h"
#import "NavigationLeftButton.h"
//#import "MBProgressHUD.h"
#import "SAAPIClient.h"
#import "NumberPadDoneBtn.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "FirstViewController.h"
#import "HomeHelper.h"

@interface ReSetPasswordViewController ()
{
    //MBProgressHUD *progressHUD;
}
@end

@implementation ReSetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)backViewController
{
    for (UIViewController * viewController in [self.navigationController viewControllers])
    {
        if ([viewController isKindOfClass:[SettingViewController class]])
        {
            return  YES;
        }
        
    }
    return NO;
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
     [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
     [self.navigationController  setNavigationBarHidden:YES];
     [self.txtEmail setDelegate:self];
     [self.txtReNewPassword setDelegate:self];
     [self.txtReNewPassword setDelegate:self];
      if (![self backViewController])
      {
        [self.lblTitle setText:NSLocalizedString(@"newPassword", nil)];
        [self.btnOk setTitle:NSLocalizedString(@"updatePass", nil) forState:UIControlStateNormal];
        [self.viewEmail setHidden:YES];
        [self.txtEmail setHidden:YES];
          if ([self.emailId length]==0)
          {
              [_txtNewPassword setKeyboardType:UIKeyboardTypeNumberPad];
              [_txtReNewPassword setKeyboardType:UIKeyboardTypeNumberPad];
              NumberPadDoneBtn *btnNew=[[NumberPadDoneBtn alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
              _txtNewPassword.inputAccessoryView=btnNew;
              NumberPadDoneBtn *btnRe=[[NumberPadDoneBtn alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
              _txtReNewPassword.inputAccessoryView=btnRe;
          }
     }else
     {        [_txtNewPassword setKeyboardType:UIKeyboardTypeNumberPad];
              [_txtReNewPassword setKeyboardType:UIKeyboardTypeNumberPad];
              NumberPadDoneBtn *btnNew=[[NumberPadDoneBtn alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
               _txtNewPassword.inputAccessoryView=btnNew;
              NumberPadDoneBtn *btnRe=[[NumberPadDoneBtn alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
             _txtReNewPassword.inputAccessoryView=btnRe;
     }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)backButtonClick:(id)sender
{
    if ([self backViewController])
    {
         [self.navigationController popViewControllerAnimated:YES];
    }else
        [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)btnSaveClick:(id)sender
{
    if([[_txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [[_txtReNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Invalid information please review and try again!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    } else if(([[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]!=0  && ![Utility isValidEmail:[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] Strict:YES]))
    {
        UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please Enter Valid Email ID" delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
        [loginAlrt show];
    }else if(![[_txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[_txtReNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@ "Password does't match"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else
    {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[_txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:PASSWORD];
        [_txtNewPassword resignFirstResponder];
        [_txtReNewPassword resignFirstResponder];
        if ([self.btnOk.titleLabel.text isEqualToString:NSLocalizedString(@"updatePass", nil)])
        {
            if ([self.emailId length]==0)
            {
               if([TRIM(_txtNewPassword.text ) length] < 4 &&  [TRIM(_txtNewPassword.text) length] > 6)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Please Enter at least 4 to 6 character password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Password Changed Successfully." delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
                [loginAlrt setTag:12];
                [loginAlrt show];
            }else
            {
                if([Utility isPasswordValid:_txtNewPassword])
                {
//                    progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    progressHUD.labelText=@"Please wait...";
                    [dic setObject:self.emailId forKey:EMAIL_ADDRESS];
                    [dic setObject:@"UpdatePass" forKey:@"cn"];
                    [dic setObject:[Utility uniqueIDForDevice] forKey:DEVICE_ID];
                    [self login:dic];
                    
                }
               
            }
        }else
        {
            if([[_txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 4 &&  [_txtReNewPassword.text length] < 4)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Please Enter at least 4 to 6 character password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
//            progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            progressHUD.labelText=@"Please wait...";
            [_txtEmail resignFirstResponder];
            [dic setObject:[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:EMAIL_ADDRESS];
            [dic setObject:@"ApplockRegister" forKey:@"cn"];
            [dic setObject:[Utility uniqueIDForDevice] forKey:@"imei_id"];
            [self login:dic];
        }
    }
}




-(void)login:(NSDictionary*)dic
{
//    SAAPIClient *manager = [SAAPIClient sharedClient];
//    [[manager responseSerializer]setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [manager postPath:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         if([[responseObject objectForKey:@"status"] boolValue])
//         {
//             NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Success" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//             //  self.emailId=[responseObject objectForKey:@"email"];
//             if ([[responseObject objectForKey:@"cn"] isEqualToString:@"UpdatePass"])
//             {
//                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CURRENT_CURRENCY_TIMESTAMP];
//                  [[HomeHelper sharedCoreDataController] loginResponceWithServer:responseObject];
//                [loginAlrt setTag:10];
//             }else
//             {
//                 [loginAlrt setTag:11];
//             }
//             [loginAlrt show];
//         }
//         else if(![[responseObject objectForKey:@"status"] boolValue])
//         {
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             progressHUD=nil;
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//             [loginAlrt setTag:10];
//             [loginAlrt show];
//         }
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         progressHUD=nil;
//         UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//         [loginAlrt show];
//         
//     }];
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField==self.txtNewPassword || (textField == self.txtReNewPassword))
    {
        if ([self.emailId length]==0)
        {
            NSString *updatedText = [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingCharactersInRange:range withString:string];
            if (updatedText.length > 6) // 4 was chosen for SSN verification
            {
                return NO;
            }
        }
    }
    return YES;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==11)
    {
        [[NSUserDefaults standardUserDefaults] setObject:_txtNewPassword.text forKey:LOCK_SCREEN_PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (alertView.tag==10)
    {
        NSString * noticationName =@"LeftMenuViewController";
        [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:nil];
        HomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (alertView.tag==12)
    {
        [[NSUserDefaults standardUserDefaults] setObject:_txtNewPassword.text forKey:LOCK_SCREEN_PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        for (UIViewController * viewController in [self.navigationController viewControllers])
        {
            if ([viewController isKindOfClass:[FirstViewController class]])
            {
                FirstViewController *vc=(FirstViewController*)viewController;
               // [vc setLocked:NO];
                break;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
