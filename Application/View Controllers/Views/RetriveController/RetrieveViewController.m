//
//  RetrieveViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 30/08/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "RetrieveViewController.h"
#import "UIUnderlinedButton.h"
//#import "MBProgressHUD.h"
#import "SAAPIClient.h"
#import "ReSetPasswordViewController.h"
#import "AppDelegate.h"
#import "NumberPadDoneBtn.h"
#import "SettingViewController.h"

@interface RetrieveViewController ()
{
    //MBProgressHUD *progressHUD;
    
}
@end

@implementation RetrieveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
      [super viewDidLoad];
      NumberPadDoneBtn *btn=[[NumberPadDoneBtn alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
     _txtSecurity.inputAccessoryView=btn;
      [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
      [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
      [self.lblDiscription setFont:[UIFont fontWithName:Embrima size:14.0f]];
      [APP_DELEGATE setRetriveController:self];
      [self.navigationController setNavigationBarHidden:NO];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRetiveClick:(id)sender
{
    if ([[_txtSecurity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter the Security code" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else
    {
//        progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHUD.labelText=@"Please wait...";
        [_txtSecurity resignFirstResponder];
         NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[_txtSecurity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"security_code"];
        if ([self.resetToken length]==0)
        {
            [dic setObject:[Utility uniqueIDForDevice] forKey:@"imei_id"];
            [dic setObject:@"ApplockResetSecurityCode" forKey:@"cn"];
            
        }else
        {
            [dic setObject:self.resetToken forKey:@"reset_token"];
            [dic setObject:@"RetrieveCode" forKey:@"cn"];
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
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             progressHUD=nil;
//             self.emailId=[responseObject objectForKey:@"email"];
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Success" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//             [loginAlrt setTag:11];
//             [loginAlrt show];
//         }
//         else if(![[responseObject objectForKey:@"status"] boolValue])
//         {
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
        APP_DELEGATE.retriveController=nil;
        ReSetPasswordViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"ReSetPasswordViewController"];
        [catageryController setEmailId:self.emailId];
        [self.navigationController pushViewController:catageryController animated:YES];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        NSString *string=[[NSUserDefaults standardUserDefaults] objectForKey:START_END_TIME];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[dateFormatter  dateFromString:string]];
        if (interval>300)
        {
            APP_DELEGATE.retriveController=nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [super viewWillDisappear:animated];
}


- (IBAction)backButtonClick:(id)sender
{
   
}

@end
