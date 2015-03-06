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
    BOOL isCompare ;
}

@property (strong, nonatomic) IBOutlet UIButton *imgPhoto;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailId;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtconfirmPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrllView;

- (IBAction)submitBtnclick:(id)sender;
- (IBAction)checkPrivacyPolicyandTermsBtnClick:(id)sender;

@end
@implementation SignUpView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
   // self.title=@"Tap to upload pic ";
    self.scrllView.contentSize=CGSizeMake(320, 514);
    isPrivacyPolicySelected=YES;
    UIButton *btnSubmit=(UIButton *)[self.view viewWithTag:5];
    btnSubmit.enabled=YES;
    isCompare=YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self.lblProfile setFont:[UIFont fontWithName:Ebrima_Bold size:16]];
    [self.txtconfirmPassword setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.txtEmailId setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.txtName setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.txtPassword setFont:[UIFont fontWithName:Embrima size:16.0f]];
}



-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
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

-(BOOL)specialCharactersOccurence:(NSString*)aString
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 "] invertedSet];
    if ([aString rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"specialCharactersNotAllowed", nil)];
        return NO;
    }
    return YES;
}


- (IBAction)submitBtnclick:(id)sender
{
  
    if([TRIM(_txtName.text) isEqualToString:@""] || [TRIM(_txtEmailId.text) isEqualToString:@""] || [TRIM(_txtPassword.text) isEqualToString:@""] ||[TRIM(_txtconfirmPassword.text) isEqualToString:@""])
    {
        [Utility showAlertWithMassager:self.navigationController.view :@"Invalid information please  Enter Valid information "];
    }else if (![self specialCharactersOccurence:_txtName.text])
    {
        
    }else if(![Utility isValidEmail:TRIM(self.txtEmailId.text) Strict:YES])
    {
          [Utility showAlertWithMassager:self.navigationController.view :@"Please Enter Valid Email ID"];
    }else if(![[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >=6)
    {
          [Utility showAlertWithMassager:self.navigationController.view :@""];
    }
   else if(![TRIM(_txtPassword.text) isEqualToString:TRIM(_txtconfirmPassword.text)])
    {
          [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"passWordCondition", nil)];
    }
   else if (!isPrivacyPolicySelected)
    {
          [Utility showAlertWithMassager:self.navigationController.view :@"Please Accept Term and Condition" ];
        
    }else if (![Utility isInternetAvailable])
    {
        [Utility showInternetNotAvailabelAlert];
        return;
    }
    else if([Utility isPasswordValid:_txtPassword])
    {
        NSArray *array =[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
        for (UserInfo *info in array)
        {
            if ([info.user_name  caseInsensitiveCompare:[[_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]]==NSOrderedSame)
            {
                if ([info.hide_status intValue])
                {
                [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountNameExitsHidden", nil) ];
                }else
                {
                [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountNameExitsHidden", nil)];
                }
                return;
            }
        }

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHUD.labelText=@"Please wait...";
        UIImage *secondImage = [UIImage imageNamed:@"camera_profile_button.png"];
        NSData *imgData1 = UIImagePNGRepresentation(self.imgPhoto.imageView.image);
        NSData *imgData2 = UIImagePNGRepresentation(secondImage);
        isCompare =  [imgData1 isEqual:imgData2];
        if(!isCompare)
        {
            NSData *imageData = UIImageJPEGRepresentation(self.imgPhoto.imageView.image, 1.0f);
            NSString *imageString = [imageData base64EncodedStringWithOptions:0];
            NSLog(@"%lu",(unsigned long)[imageString length]);
            [dic setObject:imageString forKey:USER_PIC];
        }else
          [dic setObject:@"" forKey:USER_PIC];
        
        NSTimeZone *localTime = [NSTimeZone systemTimeZone];
        NSString *mainToken= [Utility userDefaultsForKey:MAIN_TOKEN_ID];
        NSString *currencyName= [Utility  userDefaultsForKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
      
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



-(void)registerWithServer:(NSDictionary*)dic
{
//    SAAPIClient *manager = [SAAPIClient sharedClient];
//    [[manager responseSerializer]setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [manager postPath:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         progressHUD=nil;
//         NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//         
//         if([[responseObject objectForKey:@"status"] boolValue])
//         {
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             progressHUD=nil;
//             if(!isCompare)
//             {
//                 [[NSUserDefaults standardUserDefaults] setObject:UIImageJPEGRepresentation(self.imgPhoto.imageView.image, 1.0f)forKey:@"key_for_your_image"];
//             }
//             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATION_ON_SERVER_TIME];
//             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CURRENT_CURRENCY_TIMESTAMP];
//             [[HomeHelper sharedCoreDataController] SignUpwithServer:responseObject];
//           
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Success" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//             [loginAlrt setTag:10];
//             [loginAlrt show];
//             
//         }
//         else if(![[responseObject objectForKey:@"status"] boolValue])
//         {
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             progressHUD=nil;
//             UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
//             [loginAlrt show];
//         }
//
//         
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         progressHUD=nil;
//         UIAlertView *loginAlrt = [[UIAlertView alloc]initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil, nil];
//         [loginAlrt show];
//         NSLog(@"Success: %@ ***** %@", operation.responseString, @"jhello");
//     }];
}





- (IBAction)checkPrivacyPolicyandTermsBtnClick:(id)sender
{
    
    if (isPrivacyPolicySelected)
    {
        UIButton *btnPrivacy=(UIButton *)[self.view viewWithTag:4];
        [btnPrivacy setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        
        isPrivacyPolicySelected=NO;
        
        UIButton *btnSubmit=(UIButton *)[self.view viewWithTag:5];
        btnSubmit.enabled=NO;
        [btnSubmit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else
    {
        UIButton *btnPrivacy=(UIButton *)[self.view viewWithTag:4];
        [btnPrivacy setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal];
        
        isPrivacyPolicySelected=YES;
        
        UIButton *btnSubmit=(UIButton *)[self.view viewWithTag:5];
        btnSubmit.enabled=YES;
        [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}



-(void)animateView :(UIView*)aView  xCoordinate:(CGFloat)dx  yCoordinate :(CGFloat) dy
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[aView  setTransform:CGAffineTransformMakeTranslation(dx, dy)];
	[UIView commitAnimations];
    

}

#pragma mark -TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect aRect = self.view.frame;
    aRect.size.height -= 216+54+self.scrllView.frame.origin.y;
    if (!CGRectContainsPoint(aRect, textField.frame.origin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y-216+self.scrllView.frame.origin.y);
        [self.scrllView setContentOffset:scrollPoint animated:YES];
    }
    self.scrllView.scrollEnabled=YES;
    self.scrllView.contentSize=CGSizeMake(320, 670);
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtName)
    {
        [self.txtEmailId becomeFirstResponder];
    }
    else if (textField == self.txtEmailId)
    {
        [self.txtPassword becomeFirstResponder];
    }
    else if (textField == self.txtPassword)
    {
        [self.txtconfirmPassword becomeFirstResponder];
    }
    else
    {
        self.scrllView.contentSize=CGSizeMake(320, 514);
        [self.txtconfirmPassword resignFirstResponder];
    }
    
    return YES;
}



#pragma mark -GeneralMethodForCamera

-(void)CameraFile
{

    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypeCamera;
    imgPicker.allowsEditing=YES;
    if([UIImagePickerController isSourceTypeAvailable: sourceType])
    {
        imgPicker.sourceType=sourceType;
        imgPicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imgPicker animated:YES completion:NULL];
    }
    else
    {
         [Utility showAlertWithMassager:self.navigationController.view :@"You don't have camera"];
    }
}



-(void)CameraRollFile
{    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.allowsEditing=NO;
    if([UIImagePickerController isSourceTypeAvailable: sourceType])
    {
        imgPicker.sourceType=sourceType;
        [self presentViewController:imgPicker animated:YES completion:NULL];
    }
    else
    {
       [Utility showAlertWithMassager:self.navigationController.view :@"You don't have camera"];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Take Photo"])
    {
         [self CameraFile];
        
    }else if ([title isEqualToString:@"Photo From Gallery"])
    {
         [self CameraRollFile];
    }else if (alertView.tag==10)
    {
         NSString * noticationName =@"LeftMenuViewController";
        [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:nil];
        HomeViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}




#pragma mark -ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissViewControllerAnimated:YES completion:NULL];
	UIImage* image;
	if([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"])
	{
        image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.size.width / 2;
        self.imgPhoto.clipsToBounds = YES;
        self.imgPhoto.layer.borderWidth = 2.0f;
        self.imgPhoto.layer.borderColor = [UIColor blackColor].CGColor;
        [self.imgPhoto setImage:image forState:UIControlStateNormal];
	}
}


- (IBAction)btnTermandCondition:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
    self.controller = [storyboard instantiateViewControllerWithIdentifier:@"TermAndconditionViewController"];
    [ self.controller show];
}



- (IBAction)backbtnClick:(id)sender
{
      [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)profilebtnClick:(id)sender
{
    [self.txtEmailId resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtName resignFirstResponder];
    [self.txtconfirmPassword resignFirstResponder];
    CGPoint scrollPoint = CGPointMake(0.0, 0.0);
    [self.scrllView setContentOffset:scrollPoint animated:YES];
    self.scrllView.scrollEnabled=YES;
    self.scrllView.contentSize=CGSizeMake(320, 514);
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil      message:nil     delegate:self     cancelButtonTitle: @"Cancel"  otherButtonTitles:@"Take Photo",@"Photo From Gallery",nil];
    [message show];
}

@end
