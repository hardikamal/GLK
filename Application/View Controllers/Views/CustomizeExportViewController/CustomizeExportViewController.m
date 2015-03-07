//
//  CustomizeExportViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 21/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

#import "CustomizeExportViewController.h"
#import "CategoryListHandler.h"
#import "PaymentmodeHandler.h"
#import "ExportViewController.h"
#import "Transactions.h"
#import "TransactionHandler.h"
#import "Transfer.h"
#import "TransferHandler.h"
#import "ReminderHandler.h"
#import "Reminder.h"
#import "Budget.h"
#import "BudgetHandler.h"
#import "CategoryList.h"
#import "CategoryList.h"
#import "Paymentmode.h"
#import "PaymentmodeHandler.h"
#import "UserInfoHandler.h"
#import "UserInfo.h"
#import "CustomizeExportViewController.h"
//#import "MBProgressHUD.h"
#import "EmailViewController.h"


// Constants used for OAuth 2.0 authorization.
//static NSString *const kKeychainItemName = @"iOSDriveSample: Google Drive";

static NSString *const kKeychainItemName = @"PdfReaderRes";//@"PdfReaderRes";
static NSString *const kClientId =@"1009544359695-vfq6m7hltvudgj5ek5l5grcvt62hatoo.apps.googleusercontent.com";//@"102673127935-4c68qg4u5vbldb9vjs46ongsgkslcmk2.apps.googleusercontent.com";*/
static NSString *const kClientSecret =@"UTj3KeexhlkJD58AwwdLX0kQ";//@"CAOBkGq9lFmFKxT_tvDCj4sg";



@interface CustomizeExportViewController ()
{
    BOOL isSelected;
    NSMutableDictionary *dict;
    NSMutableArray *currentRow;
    NSMutableArray *fieldNames;
    NSMutableArray  *transactionItems;
  //  MBProgressHUD *  progressHUD;
    NSString *currentFilePath;
}
@end

@implementation CustomizeExportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentFilePath=[[NSString alloc] init];
    self.dobView.frame=CGRectMake(0, self.view.frame.size.height, self.dobView.frame.size.width, self.dobView.frame.size.height);
    [self.view addSubview:self.dobView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSelectViewListNotification:) name:@"SelectedViewController" object:nil];
    _selectedViewBy=NSLocalizedString(@"both", nil);
    _SelectedOrderby=NSLocalizedString(@"Recent Transactions", nil);

    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalederUnit fromDate:currentDate];
    NSString *combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];
    [self.lblFromDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
    [self.lblFromMonthYear setText:combined];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
    components = [calendar components:NSCalederUnit fromDate:newDate];
    combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];
    [self.lblToDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
    [self.lblToMonthYear setText:combined];
    
      fieldNames=[[NSMutableArray alloc] initWithObjects:@"type",@"token_id",@"transaction_type",@"transaction_id",@"pic", @"user_token_id",@"category",@"sub_category", @"amount",@"updation_date",@"server_updation_date", @"date",@"location", @"discription", @"paymentMode",@"with_person",@"show_on_homescreen",@"warranty",@"transaction_reference_id",@"reminder_heading",@"reminder_when_to_alert",@"reminder_time_period",@"reminder_sub_alarm",@"reminder_recurring_type",@"reminder_alarm",@"reminder_alert",@"fromaccount",@"toaccount",@"income_transaction_id",@"expense_transaction_id",@"email_id",@"address",@"password",@"hide_status",@"user_dob",@"user_name",@"fromdate",@"todate",@"transaction_inserted_from",@"class_type", nil];
    // Do any additional setup after loading the view.
}

-(void) parserDidBeginDocument:(CHCSVParser *)parser
{
    currentRow = [[NSMutableArray alloc] init];
}

-(void) parserDidEndDocument:(CHCSVParser *)parser
{
    for(int i=0;i<[currentRow count];i++)
    {
        NSLog(@"%@          %@          %@",[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]],[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"1"]],[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"2"]]);
    }
}


- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    NSLog(@"Parser failed with error: %@ %@", [error localizedDescription], [error userInfo]);
}

-(void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    dict=[[NSMutableDictionary alloc]init];
}

-(void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    [dict setObject:field forKey:[NSString stringWithFormat:@"%ld",(long)fieldIndex]];
}


- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber
{
    [currentRow addObject:dict];
    dict=nil;
}


-(void)receivedSelectViewListNotification:(NSNotification*) notification
{
    [self.objCustomPopUpViewController.view removeFromSuperview];
    NSDictionary * info =notification.userInfo;
    if ([[info objectForKey:@"chek"]isEqualToString:@"YES"])
    {
        [self.categryList removeAllObjects];
         self.categryList=[info objectForKey:@"object"];
         NSArray *categeryArray=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
        if ([categeryArray count]==[[info objectForKey:@"object"] count])
        {

            [self.btnCategery setTitle:NSLocalizedString(@"all", nil) forState:UIControlStateNormal];
            [self.imgCategery setImage:[UIImage imageNamed:@"All_icon.png"]];
        }else
        {
           
            NSArray *categeryIcon=[[CategoryListHandler sharedCoreDataController]  getsearchCategeryWithAttributeName:@"category_icon" andSearchText:  [self.categryList objectAtIndex:0]];
            if ([categeryIcon count]!=0)
            {
                [self.btnCategery setTitle:[NSString stringWithFormat:@"%@ (%lu)",[[categeryIcon objectAtIndex:0] objectForKey:@"category"],(unsigned long)[self.categryList count]] forState:UIControlStateNormal];
                [self.imgCategery setImage:[UIImage imageNamed:@"Miscellaneous_icon.png"]];
               
            }
        }
    }else
    {
        [self.paymentModeList removeAllObjects];
        self.paymentModeList=[info objectForKey:@"object"];
        NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getPaymentModeList];
        if ([paymentModeArray count]==[[info objectForKey:@"object"] count])
        {
            [self.btnPaymentMode setTitle:NSLocalizedString(@"all", nil) forState:UIControlStateNormal];
            [self.imagePaymentMode setImage:[UIImage imageNamed:@"All_icon.png"]];
        }else
        {
            self.paymentModeList=[info objectForKey:@"object"];
            NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getsearchPaymentWithAttributeName:[self.paymentModeList objectAtIndex:0]];
            NSDictionary * paymentInfo =[paymentModeArray objectAtIndex:0];
            [self.btnPaymentMode setTitle:[NSString stringWithFormat:@"%@ (%lu)",[paymentInfo objectForKey:@"paymentMode"],(unsigned long)[self.paymentModeList count]] forState:UIControlStateNormal];
            [self.imagePaymentMode setImage:[UIImage imageNamed:@"paymentmode_icon.png"]];
        }
    }
  
    
}


- (void)didReceiveMemoryWarning
{
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

- (IBAction)btnBackClick:(id)sender
{
   NSString * noticationName =@"CustomizeExportViewController";
  [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:nil];
    
}


- (IBAction)btnPaymentModeClick:(id)sender
{
    self.paymentModeList=[[NSMutableArray alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
    self.objCustomPopUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"SelectedViewController"];
    NSArray *paymentModeArray=[[PaymentmodeHandler sharedCoreDataController] getPaymentModeList];
    for ( Paymentmode *mode in paymentModeArray)
    {
        [self.paymentModeList addObject:mode.paymentMode];
    }
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (NSString *string in self.paymentModeList)
    {
        NSMutableDictionary *dictonary=[[NSMutableDictionary alloc] init];
        [dictonary setObject:string forKey:@"text"];
        [dictonary setObject:@"YES" forKey:@"checked"];
        [array addObject:dictonary];
    }
    [self.objCustomPopUpViewController setItem:array];
    [self.view addSubview:self.objCustomPopUpViewController.view];
}


- (IBAction)btnCategeryClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
    self.objCustomPopUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"SelectedViewController"];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    self.categryList=[[CategoryListHandler sharedCoreDataController] getAllCategoryList];
    for (NSString *string in self.categryList)
    {
        NSMutableDictionary *dictonary=[[NSMutableDictionary alloc] init];
        [dictonary setObject:string forKey:@"text"];
        [dictonary setObject:@"YES" forKey:@"checked"];
        [array addObject:dictonary];
    }
    [self.objCustomPopUpViewController setItem:array];
    [self.objCustomPopUpViewController setChekPaymentorCategery:YES];
    [self.view addSubview:self.objCustomPopUpViewController.view];
}



- (IBAction)btnFromClick:(id)sender
{
    self.dobPicker.datePickerMode = UIDatePickerModeDate;
    float height=self.dobView.frame.size.height;
    [self animateView:self.dobView xCoordinate:0 yCoordinate:-height];
    isSelected=YES;

}

- (IBAction)btnToClick:(id)sender
{
    self.dobPicker.datePickerMode = UIDatePickerModeDate;
    float height=self.dobView.frame.size.height;
    [self animateView:self.dobView xCoordinate:0 yCoordinate:-height];
    isSelected=NO;
}




- (IBAction)btnCancleClick:(id)sender
{
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
}



- (IBAction)btnDoneClick:(id)sender
{
    [self animateView:self.dobView xCoordinate:0 yCoordinate:0];
    if (isSelected)
    {
        NSDate *currentDate =  self.dobPicker.date;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalederUnit fromDate:currentDate];
        [self.lblFromDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
        NSString *combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];
        [self.lblFromMonthYear setText:combined];
    }else
    {
        NSDate *currentDate = self.dobPicker.date;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalederUnit fromDate:currentDate];
        [self.lblToDay setText:[NSString stringWithFormat:@"%li",(long)[components day]]];
        NSString *combined = [NSString stringWithFormat:@"%li %li",(long)[components month] ,(long)[components year] ];
        [self.lblToMonthYear setText:combined];
    }
}



- (IBAction)btnExpenseClick:(UIButton*)sender
{
    _selectedViewBy=NSLocalizedString(@"expense", nil);
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [sender setImage:[UIImage   imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage   imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
    }
}


- (IBAction)btnIncomeClick:(UIButton*)sender
{
    _selectedViewBy= NSLocalizedString(@"income", nil);
    UIImage *secondImage = [UIImage imageNamed:@"check_box_actives.png"];
    NSData *imgData1 = UIImagePNGRepresentation(sender.imageView.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        [sender setImage:[UIImage   imageNamed:@"check_boxs.png"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage   imageNamed:@"check_box_actives.png"] forState:UIControlStateNormal];
    }
}



- (IBAction)btnIncome:(id)sender
{
    
    
}


-(BOOL)chekValidity
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSArray *fromDatearrry =[_lblFromMonthYear.text componentsSeparatedByString:@" "];
    NSDate *startDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ ",[NSString stringWithFormat:@"%@/%@/%@",_lblFromDay.text,[fromDatearrry objectAtIndex:0],[fromDatearrry objectAtIndex:1]]]];
    NSArray *toDatearrry =[_lblToMonthYear.text componentsSeparatedByString:@" "];
    NSDate *endDate=[dateFormat dateFromString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@/%@/%@",_lblToDay.text,[toDatearrry objectAtIndex:0],[toDatearrry objectAtIndex:1]]]];
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    if (interval<=0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"latergreater", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    }
    if ([self.paymentModeList count]==0 && [self.categryList count]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"select_atleast_one_category_and_one_payment_mode", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (IBAction)btnExportDataClick:(id)sender
{
    
    if ([self chekValidity])
    {
        NSArray *UserInfoarrray=[[UserInfoHandler sharedCoreDataController] getUserDetailsWithUserName:[Utility userDefaultsForKey:CURRENT_USER__TOKEN_ID]];
        NSString *userToken;
        if ([UserInfoarrray count]!=0)
        {
            UserInfo *userInfo =[UserInfoarrray objectAtIndex:0];
            userToken=userInfo.user_token_id;
        }
        else
        {
            userToken=@"";
        }

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSArray *fromDatearrry =[_lblFromMonthYear.text componentsSeparatedByString:@" "];
        NSArray *toDatearrry =[_lblToMonthYear.text componentsSeparatedByString:@" "];
    
        NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@/%@/%@",_lblFromDay.text,[fromDatearrry objectAtIndex:0],[fromDatearrry objectAtIndex:1]],[NSString stringWithFormat:@"%@:%@:%@",@"00",@"00",@"00"]]];
        
        NSDate *endDate=[formatter dateFromString:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@/%@/%@",_lblToDay.text,[toDatearrry objectAtIndex:0],[toDatearrry objectAtIndex:1]],[NSString stringWithFormat:@"%@:%@:%@",@"23",@"59",@"59"]]];
        
         transactionItems=[[NSMutableArray alloc] initWithArray:[[TransactionHandler sharedCoreDataController] getAllTransactionsForID:userToken :startDate :endDate :_selectedViewBy :_SelectedOrderby :self.categryList :self.paymentModeList]];
        
        if ([transactionItems count]!=0)
        {
            [self showAlertViewforRightCsv:0];
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"nothing_available_to_export_in_", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}


-(void)showAlertViewforRightCsv:(int)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"enter_file_name", nil)  message:@"-"  delegate:self cancelButtonTitle:@"Export" otherButtonTitles:NSLocalizedString(@"cancel", nil), nil];
    [alertView setTag:tag];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString *strubg= [[NSNumber numberWithUnsignedLongLong:milliseconds] stringValue];
    [alertView textFieldAtIndex:0].text =[NSString stringWithFormat:@"%@%@",@"MyTransacations",strubg];
    [alertView textFieldAtIndex:0].textColor =[UIColor darkGrayColor];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Export"])
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
//        progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHUD.labelText=NSLocalizedString(@"exporting_database", nil);
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:)
                                       userInfo:[NSString stringWithFormat:@"%@.csv",textField.text] repeats:NO];
    }  if([title isEqualToString:@"Now"])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil      message:nil     delegate:self     cancelButtonTitle: @"Cancel"  otherButtonTitles:@"Export via Google Drive", @"Export via Email", nil];
        [message show];
    }
    
    if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Button 1 was selected.");
    }
    else if([title isEqualToString:@"Export via Google Drive"])
    {
       // [self PermisonGogleDrive];
    }
    else if([title isEqualToString:@"Export via Email"])
    {
        [self composeMail];
    }

}

-(void)PermisonGogleDrive
{
    self.isAuth=[[NSUserDefaults standardUserDefaults] objectForKey:@"isAuth"];
    if ([[self isAuth] length]==0)
    {
        // Sign in.
        SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
        GTMOAuth2ViewControllerTouch *authViewController =[[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive clientID:kClientId clientSecret:kClientSecret keychainItemName:kKeychainItemName delegate:self finishedSelector:finishedSelector];
        [self presentViewController:authViewController animated:YES completion:nil];
    } else
    {
        [self isAuthorizedWithAuthentication:[[VSGGoogleServiceDrive sharedService] authorizer]];
    }
    
}

-(void)sendToGogleDrive
{
    NSData *fileData = [NSData dataWithContentsOfFile:currentFilePath];
    NSArray *filepart = [currentFilePath componentsSeparatedByString:@"/"];
    NSString *filename = [filepart lastObject];
    NSString *extension = [[[filepart lastObject] componentsSeparatedByString:@"."] lastObject];
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = filename;
    file.descriptionProperty = NSLocalizedString(@"Daily_Expense_Manager_Backup", nil);
    NSString *mimeType;
    if ([extension isEqualToString:@"jpg"])
    {
        mimeType = @"image/jpeg";
    } else if ([extension isEqualToString:@"xls"])
    {
        mimeType = @"application/vnd.ms-excel";;
    } else if ([extension isEqualToString:@"doc"])
    {
        mimeType = @"application/msword";
    } else if ([extension isEqualToString:@"ppt"])
    {
        mimeType = @"application/vnd.ms-powerpoint";
    } else if ([extension isEqualToString:@"csv"])
    {
        mimeType =@"text/csv";
    } else if ([extension isEqualToString:@"pdf"])
    {
        mimeType = @"application/pdf";
    }
    file.mimeType = mimeType;
    
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:fileData MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file  uploadParameters:uploadParameters];
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,   GTLDriveFile *insertedFile, NSError *error)
     {
         [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
         if (error == nil)
         {
             NSLog(@"File ID: %@", insertedFile.identifier);
             [self showAlert:@"Google Drive" message:@"File saved!"];
             [self.view removeFromSuperview];
         }
         else
         {
             NSLog(@"An error occurred: %@", error);
             [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
             [self.view removeFromSuperview];
         }
     }];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth  error:(NSError *)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (error == nil)
    {
        _isAuth=@"101";
        [[NSUserDefaults standardUserDefaults]setObject:_isAuth forKey:@"isAuth"];
        [self isAuthorizedWithAuthentication:auth];
    }else
    {
        [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
        
    }
}

- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title   message: message  delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alert show];
}



- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth
{
    [[self driveService] setAuthorizer:auth];
    self.isAuthorized = YES;
    [self sendToGogleDrive];
}



// Helper for showing a wait indicator in a popup
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title    message:@"Please wait..."   delegate:self  cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,  progressAlert.bounds.size.height - 45);
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}


- (void)handleTimer:(NSTimer*)theTimer
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    progressHUD=nil;
    [self rightCsvfromCoreData:(NSString*)[theTimer userInfo]];
    
}


-(void)composeMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            EmailViewController* picker = [[EmailViewController alloc] init];
            NSArray *toRecipents = [NSArray arrayWithObject:@"rewachandan05@gmail.com"];
            [picker setToRecipients:toRecipents];
            [picker setSubject:NSLocalizedString(@"Daily_Expense_Manager_Backup", nil)];
            NSData *fileData = [NSData dataWithContentsOfFile:currentFilePath];
            NSArray *filepart = [currentFilePath componentsSeparatedByString:@"/"];
            NSString *filename = [filepart lastObject];
            NSString *extension = [[[filepart lastObject] componentsSeparatedByString:@"."] lastObject];
            NSString *mimeType;
            if ([extension isEqualToString:@"xls"])
            {
                mimeType = @"application/vnd.ms-excel";;
            } else if ([extension isEqualToString:@"csv"])
            {
                mimeType =@"text/csv";
            }
            [picker addAttachmentData:fileData mimeType:mimeType fileName:filename];
            [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:picker  animated:YES  completion:nil];
        }
        else
        {
            UIAlertView *newAlertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Email is not configured. Go to iPad settings> mail contacts, calendars > add account." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [newAlertView show];
        }
    }
}



-(void)rightCsvfromCoreData:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:fileName];
    currentFilePath=path;
    CHCSVWriter *csvWriter=[[CHCSVWriter alloc]initForWritingToCSVFile:path];
    for (NSString *string in fieldNames)
    {
        [csvWriter writeField:string];
    }
    [csvWriter finishLine];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    
    if ([transactionItems count]!=0)
    {
        for (Transactions *transaction  in transactionItems)
        {
            NSArray *array =[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",TYPE_TRANSACTION],transaction.token_id,[transaction.transaction_type stringValue],transaction.transaction_id,@"-",transaction.user_token_id,transaction.category,transaction.sub_category,[transaction.amount stringValue],[transaction.updation_date stringValue],[transaction.server_updation_date stringValue],  [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([[transaction.date stringValue] doubleValue] / 1000)]],transaction.location,transaction.discription, transaction.paymentMode,transaction.with_person,[transaction.show_on_homescreen stringValue] , [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([[transaction.warranty stringValue] doubleValue] / 1000)]],transaction.transaction_reference_id,@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",@"-",transaction.transaction_inserted_from,@"-", nil];
            NSLog(@"Transactions:%lu",(unsigned long)[array count]);
            [csvWriter writeLineOfFields:array];
        }
        [csvWriter closeStream];
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        progressHUD=nil;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"successfully_exported_popup_text", nil) message:NSLocalizedString(@"send_mail", nil) delegate:self cancelButtonTitle:@"Now" otherButtonTitles:@"Later", nil];
        [alert setTag:10];
        [alert show];
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


- (IBAction)datebtnFrombtnClick:(id)sender
{
   
}

- (IBAction)datebtnToClick:(id)sender
{
  
}



- (IBAction)doneDobPickerClick:(id)sender
{
    
}





@end
