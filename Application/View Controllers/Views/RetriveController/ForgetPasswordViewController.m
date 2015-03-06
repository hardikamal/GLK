//
//  ForgetPasswordViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 25/08/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//
//#import "MBProgressHUD.h"
#import "ForgetPasswordViewController.h"
#import "UIUnderlinedButton.h"
#import "SAAPIClient.h"
#import "RetrieveViewController.h"
@interface ForgetPasswordViewController ()
{
   // MBProgressHUD *progressHUD;
}

@end

@implementation ForgetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changePasswordclick:(id)sender
{
    if ([[_txtEmailId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"enterEmail", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        
    }else if(![Utility isValidEmail:[_txtEmailId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] Strict:YES])
    {
        // user entered invalid email address
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"enterValidEmail", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
    else
    {
//        progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHUD.labelText=@"Please wait...";
        [_txtEmailId resignFirstResponder];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[_txtEmailId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:EMAIL_ADDRESS];
        if ([self.btnResSetPassword.titleLabel.text isEqualToString:NSLocalizedString(@"forcefulllReset", nil)])
        {
            [dic setObject:@"ForgotPassForcefull" forKey:@"cn"];
            [dic setObject:[Utility uniqueIDForDevice] forKey:DEVICE_ID];
        }else if (self.locked)
        {
            [dic setObject:@"ApplockSecurityCode" forKey:@"cn"];
            [dic setObject:[Utility uniqueIDForDevice] forKey:@"imei_id"];
        }else
        {
            [dic setObject:@"ForgotPass" forKey:@"cn"];
            [dic setObject:[Utility uniqueIDForDevice] forKey:DEVICE_ID];
        }
        [self login:dic];
    }
}


-(void)login:(NSDictionary*)dic
{
    //   NSData *imageData;
//    SAAPIClient *manager = [SAAPIClient sharedClient];
//    [[manager responseSerializer]setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [manager postPath:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         if([[responseObject objectForKey:@"status"] boolValue])
//         {
////             [MBProgressHUD hideHUDForView:self.view animated:YES];
////             progressHUD=nil;
//             self.resetToken=[responseObject objectForKey:@"reset_token"];
//             NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Success" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//             [loginAlrt setTag:11];
//             [loginAlrt show];
//             
//         }
//         else if(![[responseObject objectForKey:@"status"] boolValue])
//         {
//             if ([[responseObject objectForKey:@"force_login"] boolValue])
//             {
//                [self.btnResSetPassword setTitle:NSLocalizedString(@"forcefulllReset", nil) forState:UIControlStateNormal];
//             }
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             progressHUD=nil;
//             NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==11)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:START_END_TIME];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        RetrieveViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"RetrieveViewController"];
        [catageryController setResetToken:self.resetToken];
        [self.navigationController pushViewController:catageryController animated:YES];
    }
}



- (IBAction)backbtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
