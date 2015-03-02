//
//  AddAccountViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 14/10/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "AddAccountViewController.h"
#import "UIAlertView+Block.h"
#import "UserInfoHandler.h"
#import "UserInfo.h"
@interface AddAccountViewController ()
{
    BOOL locationStatus;
    BOOL hideStatus;
    
}
@end

@implementation AddAccountViewController

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
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    locationStatus=NO;
    hideStatus=NO;
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
    [self.lblHidestaus setFont:[UIFont fontWithName:Embrima size:16.0f]];
    [self.lblMyLocation setFont:[UIFont fontWithName:Embrima size:16.0f]];
 
    if (self.info.managedObjectContext != nil)
    {
        [self.btnProfileImage setImage:[UIImage imageWithData:[self.info user_img]]  forState:UIControlStateNormal];
        [self setTitle:NSLocalizedString(@"editAccount", nil)];
        [self.txtCategory setText:self.info.user_name];
        if ([self.info.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]] )
        {
            self.hideStatusView.hidden=YES;
        }else
            self.hideStatusView.hidden=NO;
        if (self.info.user_img != nil)
         {
             [self.btnProfileImage setImage:[UIImage imageWithData:self.info.user_img] forState:UIControlStateNormal];
             self.btnProfileImage.layer.cornerRadius = self.btnProfileImage.frame.size.width / 2;
             self.btnProfileImage.clipsToBounds = YES;
             self.btnProfileImage.layer.borderWidth = 2.0f;
             self.btnProfileImage.layer.borderColor = [UIColor blackColor].CGColor;
         }else
         {
              [self.btnProfileImage setImage:[UIImage imageNamed:@"camera_profile_button.png"] forState:UIControlStateNormal];
         }
        
        if ([self.info.hide_status intValue])
        {
              [self.btnHidestatus setOn:YES animated:YES];
               hideStatus=YES;
        }
        if ([self.info.location intValue])
        {
              [self.btnLocation setOn:YES animated:YES];
              locationStatus=YES;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)swithLocationClick:(id)sender
{
    if ([sender isOn])
    {
        locationStatus=YES;
        
    } else
    {
        locationStatus=NO;
    }
}



- (IBAction)swithStatusClick:(id)sender
{
    if ([sender isOn])
    {
        hideStatus=YES;
        [UIAlertView alertViewWithTitle:@"Alert" message:NSLocalizedString(@"hidingAccount", nil)];
    } else
    {
        hideStatus=NO;
    }
}



- (IBAction)addAccountToDB:(id)sender
{
    if ([self CheckTransactionValidity])
    {
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        NSString *mainToke=[Utility userDefaultsForKey:MAIN_TOKEN_ID];
        [dictionary setObject:[NSString stringWithFormat:@"%@_%@",mainToke,_txtCategory.text] forKey:@"user_token_id"];
        [dictionary setObject:TRIM(self.txtCategory.text) forKey:@"user_name"];
        [dictionary setObject:hideStatus ?[NSNumber numberWithInt:1] :[NSNumber numberWithInt:0] forKey:@"hide_status"];
        [dictionary setObject:locationStatus ?[NSNumber numberWithInt:1] :[NSNumber numberWithInt:0] forKey:@"location"];
        UIImage *secondImage = [UIImage imageNamed:@"camera_profile_button.png"];
        NSData *imgData1 = UIImagePNGRepresentation(self.btnProfileImage.imageView.image);
        NSData *imgData2 = UIImagePNGRepresentation(secondImage);
        BOOL isCompare =  [imgData1 isEqual:imgData2];
        if(!isCompare)
        {
        [dictionary setObject:self.btnProfileImage.imageView.image forKey:@"pic"];
        }
        if (self.info.managedObjectContext == nil)
        {
             [[UserInfoHandler sharedCoreDataController] addUserToUserRegisterTable:dictionary];
             [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountSuccessfullyAdded", nil)];
        }else
        {
            if ([self.info.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
            {
                 NSString * noticationName =@"LeftMenuViewController";
                [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:nil];
            }
            [[UserInfoHandler sharedCoreDataController] updateUserToUserRegisterTable:dictionary :self.info];
            [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountSuccessfullyUpdated", nil)];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(BOOL)CheckTransactionValidity
{
    if ([TRIM(self.txtCategory.text) isEqual:@""])
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountNameNull", nil)];
        return NO;
    }
    if (![self specialCharactersOccurence:TRIM(self.txtCategory.text)])
    {
        return NO;
    }
    
    if( [_txtCategory.text caseInsensitiveCompare:NSLocalizedString(@"guest", nil)] == NSOrderedSame &&
       ![self.info.user_token_id isEqualToString:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]])
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"guestusernamenotaloowed", nil)];
        return NO;
    }
    
    NSArray *array =[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
    for (UserInfo *info in array)
    {
        if ([info.user_name  caseInsensitiveCompare:[TRIM(self.txtCategory.text) uppercaseString]]==NSOrderedSame && [TRIM(self.txtCategory.text) caseInsensitiveCompare:self.info.user_name] != NSOrderedSame)
        {
            if ([info.hide_status intValue])
            {
                [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountNameExitsHidden", nil)];

            }else
            {
                [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountNameExits", nil)];
            }
            return NO;
        }
    }
    return YES;
}



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
{
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
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



#pragma mark - ActionSheetDelegate

- (void) actionSheet : (UIActionSheet * ) actionSheet didDismissWithButtonIndex : ( NSInteger ) buttonIndex
{
	if (buttonIndex==0)
    {
        [self CameraFile];
        
    }
    else if(buttonIndex==1)
    {
        [self CameraRollFile];
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
        self.btnProfileImage.layer.cornerRadius = self.btnProfileImage.frame.size.width / 2;
        self.btnProfileImage.clipsToBounds = YES;
        [self.btnProfileImage setImage:image forState:UIControlStateNormal];
        
	}
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btnProfileImageClick:(id)sender
{
    UIActionSheet *actionSheet=[[ UIActionSheet alloc] initWithTitle : @"" delegate : self cancelButtonTitle :@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Photo From Gallery",nil];
	[actionSheet showInView :self.view];
    
}

@end
