//
//  ChangeProfileViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 23/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import "ChangeProfileViewController.h"
#import "UIAlertView+Block.h"
#import "UserInfoHandler.h"
#import "UserInfo.h"
@interface ChangeProfileViewController ()
{
    UserInfo *userInfo;
}
@end

@implementation ChangeProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:17.0f]];
    NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserTokenid:[Utility userDefaultsForKey:CURRENT_TOKEN_ID]];
    
    if ([UserInfoarrray count]!=0)
    {
        userInfo =[UserInfoarrray objectAtIndex:0];
        [self.textEmail setText:userInfo.email_id];
        [self.txtPassword setText:userInfo.password];
        [self.txtRePassword setText:userInfo.password];
        [self.txtName setText:userInfo.user_name];
        if (userInfo.user_img != nil)
        {
            self.imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.size.width / 2;
            self.imgViewProfile.clipsToBounds = YES;
            self.imgViewProfile.image=[UIImage imageWithData:userInfo.user_img];
        }else
            self.imgViewProfile.image=[UIImage imageNamed:@"custom_profile.png"];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnProfileImageClick:(id)sender
{
    UIActionSheet *actionSheet=[[ UIActionSheet alloc] initWithTitle : @"" delegate :self cancelButtonTitle :@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Photo From Gallery",nil];
    [actionSheet showInView :self.view];
}

- (IBAction)btnSubmitClick:(id)sender
{
    
    if([[_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[_textEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ||[[_txtRePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
  
        [Utility showAlertWithMassager:self.navigationController.view : @"Invalid information please  Enter Valid information "];
        
    }else if (![self specialCharactersOccurence:_txtName.text])
    {
        
    }else if(![Utility isValidEmail:[_textEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] Strict:YES])
    {
    
        [Utility showAlertWithMassager:self.navigationController.view :@"Please Enter Valid Email ID"];
    
    }else if(![[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >=6)
    {
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"passWordCondition", nil)];
        
    }
    else if(![[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:[_txtRePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]])
    {
          [Utility showAlertWithMassager:self.navigationController.view :@"Password does't match"];

    }else if([Utility isPasswordValid:_txtPassword])
    {
        NSArray *array =[[UserInfoHandler sharedCoreDataController] getAllUserDetails];
        for (UserInfo *info in array)
        {
            if ([info.user_name  caseInsensitiveCompare:[self.txtName.text uppercaseString]]==NSOrderedSame && [self.txtName.text caseInsensitiveCompare:info.user_name] != NSOrderedSame)
            {
                if ([info.hide_status intValue])
                {
                [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountNameExitsHidden", nil)];
                }else
                {
                [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountNameExits", nil)];
                }
                return;
            }
        }
        
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        [dictionary setObject:_txtName.text forKey:@"user_name"];
        [dictionary setObject:_txtPassword.text forKey:@"password"];
        [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"hide_status"];
        [dictionary setObject:[NSNumber numberWithInt:0] forKey:@"location"];
        UIImage *secondImage = [UIImage imageNamed:@"camera_profile_button.png"];
        NSData *imgData1 = UIImagePNGRepresentation(self.imgViewProfile.image);
        NSData *imgData2 = UIImagePNGRepresentation(secondImage);
        BOOL isCompare =  [imgData1 isEqual:imgData2];
        if(!isCompare)
        {
            [dictionary setObject:self.imgViewProfile.image forKey:@"pic"];
        }
        [[UserInfoHandler sharedCoreDataController] updateUserToUserRegisterTable:dictionary :userInfo];
        [Utility showAlertWithMassager:self.navigationController.view :NSLocalizedString(@"accountSuccessfullyUpdated", nil)];
         NSString * noticationName =@"LeftMenuViewController";
        [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:nil];
         
        [self.navigationController popViewControllerAnimated:YES];
    }
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
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



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
        self.imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.size.width / 2;
        self.imgViewProfile.clipsToBounds = YES;
        [self.imgViewProfile setImage:image];
    }
}

@end
