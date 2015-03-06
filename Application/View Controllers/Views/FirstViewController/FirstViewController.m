//
//  FirstViewController.m
//  Gullak
//
//  Created by Saurabh Singh on 25/02/15.
//  Copyright (c) 2015 Mobulous. All rights reserved.
//

#import "FirstViewController.h"
#import "TransactionHandler.h"
#import "UIAlertView+Block.h"
#import "AFNetworking.h"
#import "SAAPIClient.h"
#import "serviceClass.h"
#import "ForgetPasswordViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "HomeViewController.h"
#import "TransactionHandler.h"
#import "ReminderHandler.h"
#import "TransferHandler.h"
#import "BudgetHandler.h"
#import "UserInfoHandler.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "HomeHelper.h"
#import "LeftMenuViewController.h"


static NSString *const kKeychainItemName = @"PdfReaderRes";
static NSString *const kClientId =@"1009544359695-vfq6m7hltvudgj5ek5l5grcvt62hatoo.apps.googleusercontent.com";
static NSString *const kClientSecret =@"UTj3KeexhlkJD58AwwdLX0kQ";
static const NSUInteger THNumberOfPinEntries = 4;
@interface FirstViewController () {
    NSArray *imageArray;
    int nextPage;
}
@property (strong,nonatomic) NSString *isAuth;
@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic, strong) UIImageView *secretContentView;
@property (nonatomic, strong) UIButton *loginLogoutButton;
@property (nonatomic, copy) NSString *correctPin;
@property (nonatomic, assign) NSUInteger remainingPinEntries;

@property BOOL isAuthorized;
@end

@implementation FirstViewController
@synthesize hFlowView, hPageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locked = YES;
    [self addPageViewController];
    [self addDefaultUserAsGuest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.locked)
    {
        [self chekForPasswordProtection];
    }else
        [self pushToHomeViewController];
    HIDE_STATUS_BAR
}
- (void)addPageViewController {
    nextPage = 0;
    imageArray = [[NSArray alloc] initWithObjects:@"dem_title.png", @"multipleaccount.png", @"setreminder.png", @"transaction.png", @"transfer.png", @"viewhistory.png", @"warranty.png", nil];
    hFlowView.delegate = self;
    hFlowView.dataSource = self;
    hFlowView.pageControl = hPageControl;
    hFlowView.minimumPageAlpha = 1.0;
    hFlowView.minimumPageScale = 0.7;
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(move_pagination) userInfo:nil repeats:YES];
}

- (void)move_pagination {
    nextPage  = (int)hPageControl.currentPage + 1;
    // if page is not 10, display it
    if (nextPage != [imageArray count]) {
        hPageControl.currentPage = nextPage;
        [hFlowView scrollToPage:nextPage];
    }
    else {
        nextPage = 0;
        hPageControl.currentPage = nextPage;
        [hFlowView scrollToPage:nextPage];
    }
}

-(void)chekForPasswordProtection
{
    if ([[Utility userDefaultsForKey:LOCK_SCREEN_PASSWORD] length]!=0)
    {
        self.correctPin =[Utility userDefaultsForKey:LOCK_SCREEN_PASSWORD];
        self.secretContentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confidential"]];
        self.secretContentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.secretContentView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.secretContentView];
        self.loginLogoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.loginLogoutButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.loginLogoutButton setFrame:CGRectMake(0, 0, 320, 80)];
        self.loginLogoutButton.tintColor = [UIColor whiteColor];
        [self.view addSubview:self.loginLogoutButton];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginLogoutButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX  multiplier:1.0f constant:0.0f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginLogoutButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop
                                                             multiplier:1.0f constant:60.0f]];
        NSDictionary *views = @{ @"secretContentView" : self.secretContentView };
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[secretContentView]-(20)-|"  options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(120)-[secretContentView]-(20)-|"  options:0 metrics:nil views:views]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [self login];
    }else
    {
        [self pushToHomeViewController];
    }
}
- (void)presentSignInViewController:(UIViewController *)viewController
{
    // This is an example of how you can implement it if your app is navigation-based.
    [[self navigationController] pushViewController:viewController animated:YES];
}


- (void)addDefaultUserAsGuest {
    NSArray *arrray = [[UserInfoHandler sharedCoreDataController] getUserDetailsToUserRegisterTable];
    if ([arrray count] == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CURRENT_CURRENCY_TIMESTAMP];
        [Utility saveToUserDefaults:DEFAULT_TOKEN_ID withKey:CURRENT_TOKEN_ID];
        [Utility saveToUserDefaults:[[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:1] withKey:CURRENT_USER__TOKEN_ID];
        NSString *mainToken = [[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:0];
        [Utility saveToUserDefaults:mainToken withKey:MAIN_TOKEN_ID];
        [Utility saveToUserDefaults:[[NSLocalizedString(@"items", nil) componentsSeparatedByString:@","] objectAtIndex:107] withKey:[NSString stringWithFormat:@"%@ @@@@ %@", CURRENT_CURRENCY, mainToken]];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        NSString *userToke = [Utility userDefaultsForKey:CURRENT_TOKEN_ID];
        [dictionary setObject:userToke forKey:@"user_token_id"];
        [dictionary setObject:NSLocalizedString(@"guest", nil) forKey:@"user_name"];
        [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"hide_status"];
        [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"location"];
        [[UserInfoHandler sharedCoreDataController] addUserToUserRegisterTable:dictionary];
    }
    NSArray *incomeArrray = [[CategoryListHandler sharedCoreDataController] getAllCategoryListwithHideStaus];
    if ([incomeArrray count] == 0) {
        [[CategoryListHandler sharedCoreDataController] addDefaultCategoryList:NSLocalizedString(@"expenses_items", ni):NSLocalizedString(@"income_items", nil)];
    }
    NSArray *paymentModeArray = [[PaymentmodeHandler sharedCoreDataController] getPaymentModeList];
    if ([paymentModeArray count] == 0) {
        [[PaymentmodeHandler sharedCoreDataController] addDefaultPaymentMode:NSLocalizedString(@"medium_of_transaction", ni)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginGuestClickEvent:(id)sender {
    HomeViewController *homeObj = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
}

#pragma mark -
#pragma mark PagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return [imageArray count];
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
    }
    imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:index]];
    return imageView;
}

- (IBAction)pageControlValueDidChange:(id)sender {
    UIPageControl *pageControl = sender;
    [hFlowView scrollToPage:pageControl.currentPage];
}

#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView; {
    return CGSizeMake(200, 180);
}

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index {
}

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index {
}
- (IBAction)signInBtnClick:(id)sender
{
    
    
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    if([[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""] && [[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""])
    {
        UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please Enter Login Details" delegate:nil
                                                 cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [loginAlrt show];
        return;
    }
    else if(![Utility isValidEmail:[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] Strict:YES])
    {
        UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please Enter Email ID"
                                                          delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [loginAlrt show];
        return;
    }else if (![Utility isInternetAvailable])
    {
        [Utility showInternetNotAvailabelAlert];
        return;
    }else
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:EMAIL_ADDRESS];
        [dic setObject:[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:PASSWORD];
        [dic setObject:[Utility uniqueIDForDevice] forKey:DEVICE_ID];
        if ([self.btnLogIn.titleLabel.text isEqualToString:NSLocalizedString(@"forcefulllogin", nil)])
        {
            [dic setObject:FORCE_LOGIN forKey:@"cn"];
        }else
        {
            [dic setObject:LOGIN forKey:@"cn"];
        }
//        progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHUD.labelText=@"Please wait...";
        [self signIN:dic];
    }
}


- (IBAction)btnSingInwithGoogle:(id)sender
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
-(void)signIN:(NSDictionary*)dic
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
//                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CURRENT_CURRENCY_TIMESTAMP];
//                 if ([[responseObject objectForKey:@"login_type"] boolValue])
//                 {
//                     [[HomeHelper sharedCoreDataController] loginResponceWithServer:responseObject];
//                     [[HomeHelper sharedCoreDataController] clearAllDataInDataDase];
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
//                     [self.btnLogIn setTitle:NSLocalizedString(@"forcefulllogin", nil) forState:UIControlStateNormal];
//                     [self.lblLogIn setHidden:YES];
//                 }
//             }
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
//             [loginAlrt show];
//         }
//         NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//         
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
////         [MBProgressHUD hideHUDForView:self.view animated:YES];
////         progressHUD=nil;
//         UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
//         [loginAlrt show];
//         NSLog(@"Success: %@ ***** %@", operation.responseString, @"jhello");
//     }];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField == self.txtEmail)
//    {
//        if (self.view.frame.size.height >400 )
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                [self.scrllView setContentOffset:CGPointMake(0,30) animated:YES];
//            }];
//        }
//    }
//    else
//    {
//        if (self.view.frame.size.height >400 )
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                [self.scrllView setContentOffset:CGPointMake(0,80) animated:YES];
//            }];
//        }
//    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if (textField == self.txtEmail)
//    {
//        [self.txtPassword becomeFirstResponder];
//    }
//    else
//    {
//        if (self.view.frame.size.height >400 )
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                [self.scrllView setContentOffset:CGPointMake(0,0) animated:YES];
//            }];
//        }
//        [self.txtPassword resignFirstResponder];
//    }
    
    return YES;
}


- (IBAction)signUpBtnClick:(id)sender
{
    [self performSegueWithIdentifier: @"signupView" sender: self];
    
}

- (IBAction)guestBtnClick:(id)sender
{
    [self performSegueWithIdentifier: @"GuestToMenu" sender: self];
}



-(void)showAlertView
{
//    [MBProgressHUD hideHUDForView:self.cusumeView animated:YES];
//    progressHUD=nil;
    UIAlertView *informationalert =[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please Try Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    informationalert.tag=21;
    [informationalert show];
    
}



- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController  finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (error == nil)
    {
        [self isAuthorizedWithAuthentication:auth];
    } else
    {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        progressHUD=nil;
        
    }
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
                     [self signIN:dic];
                 }
             } else
             {
                 
                 output = [error description];
                 [self showAlertView];
             }
         }
     }];
}






- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    
    if (! self.locked)
    {
        [self showPinViewAnimated:NO];
    }
}



#pragma mark - Properties

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    
    if (self.locked)
    {
        self.remainingPinEntries = THNumberOfPinEntries;
        [self.loginLogoutButton removeTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginLogoutButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        self.secretContentView.hidden = YES;
    } else
    {
        [self.loginLogoutButton removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.loginLogoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        self.secretContentView.hidden = NO;
    }
}



#pragma mark - UI

- (void)showPinViewAnimated:(BOOL)animated
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    // pinViewController.promptTitle = @"Enter PIN";
    UIColor *darkBlueColor = [UIColor colorWithRed:13/255.0f green:198/255.0f blue:170/255.0f alpha:1.0f];
    pinViewController.promptColor = darkBlueColor;
    pinViewController.view.tintColor = darkBlueColor;
    // for a solid background color, use this:
    pinViewController.backgroundColor = [UIColor colorWithRed:13/255.0f green:198/255.0f blue:170/255.0f alpha:1.0f];;
    // for a translucent background, use this:
    self.view.tag = THPinViewControllerContentViewTag;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    pinViewController.translucentBackground = YES;
    [pinViewController didMoveToParentViewController:self];
    // [self.view addSubview:pinViewController.view];
    [self presentViewController:pinViewController animated:NO completion:nil];
}

#pragma mark - User Interaction

- (void)login
{
    [self showPinViewAnimated:YES];
    
}

- (void)logout:(id)sender
{
    self.locked = YES;
    // [self.loginLogoutButton setTitle:@"Enter PIN" forState:UIControlStateNormal];
}

#pragma mark - THPinViewControllerDelegate

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 6;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if ([pin isEqualToString:self.correctPin])
    {
        return YES;
    } else
    {
        self.remainingPinEntries--;
        return NO;
    }
}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return YES;
}

- (void)incorrectPinEnteredInPinViewController:(THPinViewController *)pinViewController
{
    if (self.remainingPinEntries > THNumberOfPinEntries / 3)
    {
        return;
    }
}

- (void)pinViewControllerWillDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController
{
    if (self.locked)
    {
        [self pushToHomeViewController];
    }
    self.locked = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
}



-(void)pushToHomeViewController
{
    NSString *string=[[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:0];
    if (![string isEqualToString:@"0"] && string !=nil)
    {
        HomeViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController
{
    self.locked = YES;
    [self.loginLogoutButton setTitle:@"Access Denied / Enter PIN" forState:UIControlStateNormal];
}



- (void)pinViewControllerWillDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController
{
    if (! self.locked)
    {
        [self logout:self];
    }
    NSString *string=[[NSUserDefaults standardUserDefaults] objectForKey:START_END_TIME];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[dateFormatter  dateFromString:string]];
    if (interval>300 || [APP_DELEGATE retriveController]==nil)
    {
        ForgetPasswordViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
        [catageryController setLocked:YES];
        [self.navigationController pushViewController:catageryController animated:YES];
        
    }else
    {
        [self.navigationController pushViewController:[APP_DELEGATE retriveController] animated:YES];
    }
}
- (IBAction)btnForgetPasswordClick:(id)sender
{
    NSString *string=[[NSUserDefaults standardUserDefaults] objectForKey:START_END_TIME];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[dateFormatter  dateFromString:string]];
    if (interval>300 ||[APP_DELEGATE retriveController]==nil)
    {
        ForgetPasswordViewController *catageryController=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
        [self.navigationController pushViewController:catageryController animated:YES];
    }else
    {
        [self.navigationController pushViewController:[APP_DELEGATE retriveController] animated:YES];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10)
    {
        HomeViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
        // [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:YES andCompletion:nil];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self addDefaultUserAsGuest];
}

@end
