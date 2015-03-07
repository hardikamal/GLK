//
//  LogInViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 29/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "LogInViewController.h"


#import "UserInfoHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "TransactionHandler.h"
#import "UIAlertView+Block.h"
#import "AFNetworking.h"
#import "SAAPIClient.h"
//#import "MBProgressHUD.h"
#import "serviceClass.h"
#import "THPinViewController.h"
#import "ForgetPasswordViewController.h"
#import "HomeViewController.h"
#import "HomeHelper.h"
#import "GTMOAuth2ViewControllerTouch.h"
@interface LogInViewController ()
{
     // MBProgressHUD *  progressHUD;
}
@property (strong,nonatomic) NSString *isAuth;
@end

@implementation LogInViewController

static NSString *const kKeychainItemName = @"PdfReaderRes";
static NSString *const kClientId =@"1009544359695-vfq6m7hltvudgj5ek5l5grcvt62hatoo.apps.googleusercontent.com";
static NSString *const kClientSecret =@"UTj3KeexhlkJD58AwwdLX0kQ";


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
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    self.btnforgotPassword.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnNewUser.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnLog.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    self.btnGoogleSignIn.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    self.btnGoogleSignIn.titleLabel.font =[UIFont fontWithName:Embrima size:16.0f];
	// Do any additional setup after loading the view.
}

-(void)resignResponder
{
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btbBackClick:(id)sender
{
     //[[SlideNavigationController sharedInstance]toggleLeftMenu];
}

- (IBAction)signInBtnClick:(id)sender
{
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    if([TRIM(_txtEmail.text) isEqual:@""] && [TRIM(_txtPassword.text) isEqual:@""])
    {
        [Utility showAlertWithMassager:self.navigationController.view :@"Please Enter Login Details"];
        [self.view endEditing:YES];
        return;
    }
    else if(![Utility isValidEmail:TRIM(_txtEmail.text) Strict:YES])
    {
        [Utility showAlertWithMassager:self.navigationController.view :@"Please Enter Valid Email ID"];
        [self.view endEditing:YES];
        return;
        
    }else if (![Utility isInternetAvailable])
    {
        [Utility showAlertWithMassager:self.navigationController.view :   @"No Internet Connection!"];
        [self.view endEditing:YES];
        return;
    }else
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:TRIM(self.txtEmail.text) forKey:EMAIL_ADDRESS];
        [dic setObject:TRIM(self.txtPassword.text) forKey:PASSWORD];
        [dic setObject:[Utility uniqueIDForDevice] forKey:DEVICE_ID];
        if ([self.btnLog.titleLabel.text isEqualToString:NSLocalizedString(@"forcefulllogin", nil)])
        {
            [dic setObject:FORCE_LOGIN forKey:@"cn"];
        }else
        {
            [dic setObject:LOGIN forKey:@"cn"];
        }
//        progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHUD.labelText=@"Please wait...";
        [self login:dic];
    }
}


-(void)login:(NSDictionary*)dic
{
//    SAAPIClient *manager = [SAAPIClient sharedClient];
//    [[manager responseSerializer]setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [manager postPath:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         progressHUD=nil;
//         if([[responseObject objectForKey:@"status"] boolValue])
//         {
//             if ([[responseObject objectForKey:@"cn"] isEqualToString:GMAIL_LOGIN])
//             {
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CURRENT_CURRENCY_TIMESTAMP];
//                 if ([[responseObject objectForKey:@"login_type"] boolValue])
//                 {
//                     [[HomeHelper sharedCoreDataController] loginResponceWithServer:responseObject];
//                     [[HomeHelper sharedCoreDataController] clearAllDataInDataDase];
//                     
//                 }else
//                 {
//                     [[HomeHelper sharedCoreDataController] SignUpwithServer:responseObject];
//                 }
//             }else if ([[responseObject objectForKey:@"cn"] isEqualToString:LOGIN])
//             {
//                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CURRENT_CURRENCY_TIMESTAMP];
//                 [[HomeHelper sharedCoreDataController] loginResponceWithServer:responseObject];
//                 
//             }else if ( [[responseObject objectForKey:@"cn"] isEqualToString:FORCE_LOGIN])
//             {
//                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CURRENT_CURRENCY_TIMESTAMP];
//                 [[HomeHelper sharedCoreDataController] loginResponceWithServer:responseObject];
//                 [[HomeHelper sharedCoreDataController] clearAllDataInDataDase];
//             }
//             NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Success" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//             [loginAlrt setTag:10];
//             [loginAlrt show];
//         }
//         else if(![[responseObject objectForKey:@"status"] boolValue])
//         {
//             if ([[responseObject objectForKey:@"cn"] isEqualToString:LOGIN])
//             {
//                 if ([[responseObject objectForKey:@"force_login"] boolValue])
//                 {
//                     [self.btnLog setTitle:NSLocalizedString(@"forcefulllogin", nil) forState:UIControlStateNormal];
//                 }
//             }
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//             [loginAlrt show];
//         }
//         NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//         
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         progressHUD=nil;
//         UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//         [loginAlrt show];
//         NSLog(@"Success: %@ ***** %@", operation.responseString, @"jhello");
//     }];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10)
    {
         NSString * noticationName =@"LeftMenuViewController";
        [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:nil];
        HomeViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
       // [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtEmail)
    {
        [self.txtPassword becomeFirstResponder];
    }
    else
    {
        [self.txtPassword resignFirstResponder];
    }
    return YES;
}



- (IBAction)btnSingInwithGoogle:(id)sender;
{
    
    if (![Utility isInternetAvailable])
    {
        [Utility showInternetNotAvailabelAlert];
        return;
    }else
    {
//        progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHUD.labelText=@"Please wait...";
        self.isAuth=[[NSUserDefaults standardUserDefaults] objectForKey:@"Google+Auths"];
        if(self.isAuth.length>0)
        {
            GTMOAuth2Authentication *auth =[GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName   clientID:kClientId   clientSecret:kClientSecret];
            if ([auth canAuthorize])
            {
                [self isAuthorizedWithAuthentication:auth];
            }
        }else
        {
            SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
            GTMOAuth2ViewControllerTouch *authViewController =
            [[GTMOAuth2ViewControllerTouch alloc] initWithScope:@"https://www.googleapis.com/auth/plus.login" clientID:kClientId clientSecret:kClientSecret keychainItemName:kKeychainItemName  delegate:self  finishedSelector:finishedSelector];
            [self presentViewController:authViewController animated:YES completion:nil];
        }
    }
}



- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController  finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (error == nil)
    {
        [self isAuthorizedWithAuthentication:auth];
    }else
    {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        progressHUD=nil;

    }
}




-(void)showAlertView
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    progressHUD=nil;
    UIAlertView *informationalert =[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please Try Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    informationalert.tag=21;
    [informationalert show];
    
}


- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth
{
    NSURL *url = [NSURL URLWithString:@"https://www.googleapis.com/plus/v1/people/me"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [auth authorizeRequest:request completionHandler:^(NSError *error)
     {
         NSString *output = nil;
         if (error)
         {
             output = [error description];
             [self showAlertView];
             
         } else
         {
             NSURLResponse *response = nil;
             NSData *data = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response  error:&error];
             if (data)
             {
                 output = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding] ;
                 NSError* error;
                 NSDictionary* json = [NSJSONSerialization  JSONObjectWithData:data  options:kNilOptions  error:&error];
                 if ([json count] != 0)
                 {
                     NSLog(@"displayName:%@",[json objectForKey:@"displayName"]);
                     NSLog(@"emails:%@",[[[json objectForKey:@"emails"] objectAtIndex:0]objectForKey:@"value"]);
                     NSTimeZone *localTime = [NSTimeZone systemTimeZone];
                     NSString *mainToken= [Utility userDefaultsForKey:MAIN_TOKEN_ID];
                     NSString *currencyName=[Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
                     _isAuth=@"101";
                     NSURL *url = [NSURL URLWithString:[[json objectForKey:@"image"] objectForKey:@"url"]];
                     NSData *data = [NSData dataWithContentsOfURL:url];
                     [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"key_for_your_image"];
                     [[NSUserDefaults standardUserDefaults]setObject:_isAuth forKey:@"Google+Auths"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                     NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                     [dic setObject:[json objectForKey:@"displayName"] forKey:NAME];
                     [dic setObject:[[[json objectForKey:@"emails"] objectAtIndex:0]objectForKey:@"value"] forKey:EMAIL_ADDRESS];
                     [dic setObject:@"" forKey:PASSWORD];
                     [dic setObject:language forKey:@"language"];
                     [dic setObject:@"iphone" forKey:@"User-Agent"];
                     [dic setObject:currencyName forKey:CURRENCY];
                     [dic setObject:[Utility machineName] forKey:DEVICE_NAME];
                     [dic setObject:[Utility uniqueIDForDevice] forKey:DEVICE_ID];
                     [dic setObject:[localTime name] forKey:TIMEZONE];
                     NSLog(@"age:%@",[[json objectForKey:@"ageRange"] objectForKey:@"min"]);
                     [dic setObject:[json objectForKey:@"url"] forKeyedSubscript:@"google_plus_profile"];
                     [dic setObject:[[json objectForKey:@"ageRange"] objectForKey:@"min"] forKeyedSubscript:@"min_age"];
                     [dic setObject:[[json objectForKey:@"ageRange"] objectForKey:@"min"] forKeyedSubscript:@"max_age"];
                     [dic setObject:@"" forKey:@"relationship"];
                     [dic setObject:@"YYYY-MM-DD" forKey:@"date_format"];
                     [dic setObject:@"GmailLogin" forKey:@"cn"];
                     [dic setObject:@"1.1" forKey:@"app_version"];
                     [self login:dic];
                 }
             } else
             {
                 // fetch failed
                 output = [error description];
                 [self showAlertView];
             }
         }
     }];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain   target:nil  action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}



@end
